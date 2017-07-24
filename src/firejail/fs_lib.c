/*
 * Copyright (C) 2017 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/
#include "firejail.h"
#include <elf.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifdef __LP64__
#define Elf_Ehdr Elf64_Ehdr
#define Elf_Phdr Elf64_Phdr
#define Elf_Shdr Elf64_Shdr
#define Elf_Dyn Elf64_Dyn
#else
#define Elf_Ehdr Elf32_Ehdr
#define Elf_Phdr Elf32_Phdr
#define Elf_Shdr Elf32_Shdr
#define Elf_Dyn Elf32_Dyn
#endif

static const char * const lib_paths[] = {
	"/lib",
	"/lib/x86_64-linux-gnu",
	"/lib64",
	"/usr/lib",
	"/usr/lib/x86_64-linux-gnu",
	LIBDIR,
	"/usr/local/lib",
	NULL
};

static void copy_libs_for_lib(const char *lib, const char *private_run_dir);

static void duplicate(const char *fname, const char *private_run_dir) {
	if (arg_debug)
		printf("copying %s to private %s\n", fname, private_run_dir);
	sbox_run(SBOX_ROOT| SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", fname, private_run_dir);
}

static void copy_libs_for_exe(const char *exe, const char *private_run_dir) {
	if (arg_debug)
		printf("copy libs for %s\n", exe);
	int f;
	f = open(exe, O_RDONLY);
	if (f < 0)
		return;
	struct stat s;
	char *base = NULL;
	if (fstat(f, &s) == -1)
		goto error_close;
	base = mmap(0, s.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, f, 0);
	if (base == MAP_FAILED)
		goto error_close;

	Elf_Ehdr *ebuf = (Elf_Ehdr *)base;
	if (strncmp((const char *)ebuf->e_ident, ELFMAG, SELFMAG) != 0)
		goto close;

	Elf_Phdr *pbuf = (Elf_Phdr *)(base + sizeof(*ebuf));
	while (ebuf->e_phnum-- > 0) {
		switch (pbuf->p_type) {
		case PT_INTERP:
			// dynamic loader ld-linux.so
			duplicate(base + pbuf->p_offset, private_run_dir);
			break;
		}
		pbuf++;
	}

	Elf_Shdr *sbuf = (Elf_Shdr *)(base + ebuf->e_shoff);

	// Find strings section
	char *strbase = NULL;
	int sections = ebuf->e_shnum;
	while (sections-- > 0) {
		if (sbuf->sh_type == SHT_STRTAB) {
			strbase = base + sbuf->sh_offset;
			break;
		}
		sbuf++;
	}
	if (strbase == NULL)
		goto error_close;

	// Find dynamic section
	sections = ebuf->e_shnum;
	while (sections-- > 0) {
		if (sbuf->sh_type == SHT_DYNAMIC) {
			// Find DT_NEEDED tags
			Elf_Dyn *dbuf = (Elf_Dyn *)(base + sbuf->sh_offset);
			while (sbuf->sh_size >= sizeof(*dbuf)) {
				if (dbuf->d_tag == DT_NEEDED) {
					const char *lib = strbase + dbuf->d_un.d_ptr;
					copy_libs_for_lib(lib, private_run_dir);
				}
				sbuf->sh_size -= sizeof(*dbuf);
				dbuf++;
			}
		}
		sbuf++;
	}
	goto close;

 error_close:
	perror("copy libs");
 close:
	if (base)
		munmap(base, s.st_size);
	close(f);
}

static void copy_libs_for_lib(const char *lib, const char *private_run_dir) {
	for (int i = 0; lib_paths[i]; i++) {
		char *fname;
		if (asprintf(&fname, "%s/%s", lib_paths[i], lib) == -1)
			errExit("asprintf");
		if (access(fname, R_OK) == 0) {
			char *dst;
			if (asprintf(&dst, "%s/%s", private_run_dir, lib) == -1)
				errExit("asprintf");

			if (access(dst, R_OK) != 0) {
				duplicate(fname, private_run_dir);
				// libs may need other libs
				copy_libs_for_exe(fname, private_run_dir);
			}
			free(dst);
			free(fname);
			return;
		}
		free(fname);
	}
	errExit("library not found");
}

void fs_private_lib(void) {
	char *private_list = cfg.lib_private_keep;
	assert(private_list);

	// create /run/firejail/mnt/lib directory
	mkdir_attr(RUN_LIB_DIR, 0755, 0, 0);

	// copy the libs in the new lib directory for the main exe
	if (cfg.original_program_index > 0)
		copy_libs_for_exe(cfg.original_argv[cfg.original_program_index], RUN_LIB_DIR);

	// for the shell
	if (!arg_shell_none)
		copy_libs_for_exe(cfg.shell, RUN_LIB_DIR);

	// for the listed libs
	if (*private_list != '\0') {
		if (arg_debug)
			printf("Copying extra files in the new lib directory:\n");

		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");

		char *ptr = strtok(dlist, ",");
		copy_libs_for_lib(ptr, RUN_LIB_DIR);

		while ((ptr = strtok(NULL, ",")) != NULL)
			copy_libs_for_lib(ptr, RUN_LIB_DIR);
		free(dlist);
		fs_logger_print();
	}

	if (arg_debug)
		printf("Mount-bind %s on top of /lib /lib64 /usr/lib\n", RUN_LIB_DIR);
	if (mount(RUN_LIB_DIR, "/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /lib");
	if (mount(RUN_LIB_DIR, "/lib64", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/lib64", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /lib64");
	if (mount(RUN_LIB_DIR, "/usr/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, "/usr/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger("mount /usr/lib");
}

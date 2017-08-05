/*
 * Copyright (C) 2014-2017 netblue30 (netblue30@yahoo.com)
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

#include "../include/common.h"

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

static int arg_quiet = 0;
static void copy_libs_for_lib(const char *lib);

static const char * const lib_paths[] = {
	"/lib",
	"/lib/x86_64-linux-gnu",
	"/lib64",
	"/usr/lib",
	"/usr/lib/x86_64-linux-gnu",
	LIBDIR,
	"/usr/local/lib",
	NULL
}; // Note: this array is duplicated in src/firejail/fs_lib.c


typedef struct storage_t {
	struct storage_t *next;
	const char *name;
} Storage;
static Storage *head;

// return 1 if found
static int storage_find(const char *name) {
	Storage *ptr = head;
	
	while (ptr) {
		if (strcmp(ptr->name, name) == 0)
			return 1;
		ptr = ptr->next;
	}

	return 0;
}

static void storage_add(const char *name) {
	if (storage_find(name))
		return;

	Storage *s = malloc(sizeof(Storage));
	if (!s)
		errExit("malloc");
	s->next = head;
	head = s;
	s->name = strdup(name);
	if (!s->name)
		errExit("strdup");
}


static void storage_print(int fd) {
	Storage *ptr = head;
	
	while (ptr) {
		dprintf(fd, "%s\n", ptr->name);
		ptr = ptr->next;
	}
}



static void copy_libs_for_exe(const char *exe) {
	int f;
	f = open(exe, O_RDONLY);
	if (f < 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fldd: cannot open %s, skipping...\n", exe);
		return;
	}
	
	struct stat s;
	char *base = NULL;
	if (fstat(f, &s) == -1)
		goto error_close;
	base = mmap(0, s.st_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, f, 0);
	if (base == MAP_FAILED)
		goto error_close;


	Elf_Ehdr *ebuf = (Elf_Ehdr *)base;
	if (strncmp((const char *)ebuf->e_ident, ELFMAG, SELFMAG) != 0) {
		if (!arg_quiet)
			fprintf(stderr, "Warning fldd: %s is not an ELF executable or library\n", exe);
		goto close;
	}

	Elf_Phdr *pbuf = (Elf_Phdr *)(base + sizeof(*ebuf));
	while (ebuf->e_phnum-- > 0) {
		switch (pbuf->p_type) {
		case PT_INTERP:
			// dynamic loader ld-linux.so
			storage_add(base + pbuf->p_offset);
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
// TODO: running fldd on large gui programs (fldd /usr/bin/transmission-qt)
// crash on accessing memory location sbuf->sh_type if sbuf->sh_type in the previous section was 0 (SHT_NULL)
// for now we just exit the while loop - this is probably incorrect
// printf("sbuf %p #%s#, sections %d, type %u\n", sbuf, exe, sections, sbuf->sh_type);
		if (sbuf->sh_type == SHT_NULL)
			break;
		if (sbuf->sh_type == SHT_DYNAMIC) {
			// Find DT_NEEDED tags
			Elf_Dyn *dbuf = (Elf_Dyn *)(base + sbuf->sh_offset);
			while (sbuf->sh_size >= sizeof(*dbuf)) {
				if (dbuf->d_tag == DT_NEEDED) {
					const char *lib = strbase + dbuf->d_un.d_ptr;
					copy_libs_for_lib(lib);
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

static void copy_libs_for_lib(const char *lib) {
	int i;
	for (i = 0; lib_paths[i]; i++) {
		char *fname;
		if (asprintf(&fname, "%s/%s", lib_paths[i], lib) == -1)
			errExit("asprintf");
		if (access(fname, R_OK) == 0) {
			if (!storage_find(fname)) {
				storage_add(fname);
				// libs may need other libs
				copy_libs_for_exe(fname);
			}
			free(fname);
			return;
		}
		free(fname);
	}

	// log a  warning and continue
	if (!arg_quiet)
		fprintf(stderr, "Warning fldd: cannot find %s, skipping...\n", lib);
}

static void usage(void) {
	printf("Usage: fldd program [file]\n");
	printf("print a list of libraries used by program or store it in the file.\n");
}

int main(int argc, char **argv) {
#if 0
{
//system("cat /proc/self/status");
int i;
for (i = 0; i < argc; i++)
        printf("*%s* ", argv[i]);
printf("\n");
}
#endif
	if (argc < 2) {
		fprintf(stderr, "Error fldd: invalid arguments\n");
		usage();
		exit(1);
	}


	// check program access
	if (access(argv[1], R_OK)) {
		fprintf(stderr, "Error fldd: cannot access %s\n", argv[1]);
		exit(1);
	}

	char *quiet = getenv("FIREJAIL_QUIET");
	if (quiet && strcmp(quiet, "yes") == 0)
		arg_quiet = 1;

	if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0 || strcmp(argv[1], "-?") ==0) {
		usage();
		return 0;
	}
	
	int fd = STDOUT_FILENO;
	// attempt to open the file
	if (argc == 3) {
		fd = open(argv[2], O_CREAT | O_TRUNC | O_WRONLY, 0644);
		if (!fd) {
			fprintf(stderr, "Error fldd: invalid arguments\n");
			usage();
			exit(1);
		}
	}
	
	copy_libs_for_exe(argv[1]);
	storage_print(fd);	
	if (argc == 3)
		close(fd);
		
	return 0;
}

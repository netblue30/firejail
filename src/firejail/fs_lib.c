/*
 * Copyright (C) 2014-2024 Firejail Authors
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
#include "../include/ldd_utils.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <glob.h>
#define MAXBUF 4096

extern void fslib_install_stdc(void);
extern void fslib_install_firejail(void);
extern void fslib_install_system(void);

// return 1 if symlink to firejail executable
int is_firejail_link(const char *fname) {
	EUID_ASSERT();

	if (!is_link(fname))
		return 0;

	char *rp = realpath(fname, NULL);
	if (!rp)
		return 0;

	int rv = 0;
	const char *base = gnu_basename(rp);
	if (strcmp(base, "firejail") == 0)
		rv = 1;

	free(rp);
	return rv;
}

char *find_in_path(const char *program) {
	EUID_ASSERT();
	if (arg_debug)
		printf("Searching $PATH for %s\n", program);

	const char *path = env_get("PATH");
	if (!path)
		return NULL;

	char *dup = strdup(path);
	if (!dup)
		errExit("strdup");
	char *tok = strtok(dup, ":");
	while (tok) {
		char *fname;
		if (asprintf(&fname, "%s/%s", tok, program) == -1)
			errExit("asprintf");

		if (arg_debug)
			printf("trying #%s#\n", fname);
		struct stat s;
		if (stat(fname, &s) == 0 &&
		    !is_firejail_link(fname)) { // skip links created by firecfg
			free(dup);
			return fname;
		}

		free(fname);
		tok = strtok(NULL, ":");
	}

	free(dup);
	return NULL;
}

#ifdef HAVE_PRIVATE_LIB
static int lib_cnt = 0;
static int dir_cnt = 0;

static const char *masked_lib_dirs[] = {
	"/usr/lib64",
	"/lib64",
	"/usr/lib",
	"/lib",
	"/usr/local/lib64",
	"/usr/local/lib",
	NULL,
};

// return 1 if the file is in masked_lib_dirs[]
static int valid_full_path(const char *full_path) {
	if (strstr(full_path, ".."))
		return 0;

	int i = 0;
	while (masked_lib_dirs[i]) {
		size_t len = strlen(masked_lib_dirs[i]);
		if (strncmp(full_path, masked_lib_dirs[i], len) == 0 &&
		    full_path[len] == '/')
			return 1;
		i++;
	}
	return 0;
}

static char *build_dest_dir(const char *full_path) {
	assert(full_path);
	if (strstr(full_path, "/x86_64-linux-gnu/"))
		return RUN_LIB_DIR "/x86_64-linux-gnu";
	return RUN_LIB_DIR;
}

// return name of mount target in allocated memory
static char *build_dest_name(const char *full_path) {
	assert(full_path);
	char *fname = strrchr(full_path, '/');
	assert(fname);
	fname++;
	// no trailing slash or dot
	assert(fname[0] != '\0' && (fname[0] != '.' || fname[1] != '\0'));

	char *dest;
	if (asprintf(&dest, "%s/%s", build_dest_dir(full_path), fname) == -1)
		errExit("asprintf");
	return dest;
}

static void fslib_mount_dir(const char *full_path) {
	// create new directory and mount the original on top of it
	char *dest = build_dest_name(full_path);
	if (mkdir(dest, 0755) == -1) {
		if (errno == EEXIST) { // directory has been mounted already, nothing to do
			free(dest);
			return;
		}
		errExit("mkdir");
	}

	if (arg_debug || arg_debug_private_lib)
		printf("    mounting %s on %s\n", full_path, dest);
	// if full_path is a symbolic link, mount will follow it
	if (mount(full_path, dest, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(dest);
	dir_cnt++;
}

static void fslib_mount_file(const char *full_path) {
	// create new file and mount the original on top of it
	char *dest = build_dest_name(full_path);
	int fd = open(dest, O_RDONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR | S_IWUSR);
	if (fd == -1) {
		if (errno == EEXIST) { // file has been mounted already, nothing to do
			free(dest);
			return;
		}
		errExit("open");
	}
	close(fd);

	if (arg_debug || arg_debug_private_lib)
		printf("    mounting %s on %s\n", full_path, dest);
	// if full_path is a symbolic link, mount will follow it
	if (mount(full_path, dest, NULL, MS_BIND, NULL) < 0)
		errExit("mount bind");
	free(dest);
	lib_cnt++;
}

void fslib_mount(const char *full_path) {
	assert(full_path);
	struct stat s;

	if (*full_path == '\0' ||
	    !valid_full_path(full_path) ||
	    stat_as_user(full_path, &s) != 0 ||
	    s.st_uid != 0)
		return;

	if (S_ISDIR(s.st_mode))
		fslib_mount_dir(full_path);
	else if (S_ISREG(s.st_mode) && is_lib_64(full_path))
		fslib_mount_file(full_path);
}

// requires full path for lib
// it could be a library or an executable
// lib is not copied, only libraries used by it
void fslib_mount_libs(const char *full_path, unsigned user) {
	assert(full_path);
	// if library/executable does not exist or the user does not have read access to it
	// print a warning and exit the function.
	if (access(full_path, F_OK)) {
		if (arg_debug || arg_debug_private_lib)
			printf("Cannot find %s, skipping...\n", full_path);
		return;
	}
	if (user && access(full_path, R_OK)) {
		if (arg_debug || arg_debug_private_lib)
			printf("Cannot read %s, skipping...\n", full_path);
		return;
	}

	if (arg_debug || arg_debug_private_lib)
		printf("    fslib_mount_libs %s\n", full_path);
	// create an empty RUN_LIB_FILE and allow the user to write to it
	unlink(RUN_LIB_FILE);			  // in case is there
	create_empty_file_as_root(RUN_LIB_FILE, 0644);
	if (user && chown(RUN_LIB_FILE, getuid(), getgid()))
		errExit("chown");

	// run fldd to extract the list of files
	if (arg_debug || arg_debug_private_lib)
		printf("    running fldd %s as %s\n", full_path, user ? "user" : "root");
	unsigned mask;
	if (user)
		mask = SBOX_USER;
	else
		mask = SBOX_ROOT;
	sbox_run(mask | SBOX_SECCOMP | SBOX_CAPS_NONE, 3, PATH_FLDD, full_path, RUN_LIB_FILE);

	// open the list of libraries and install them on by one
	FILE *fp = fopen(RUN_LIB_FILE, "re");
	if (!fp)
		errExit("fopen");

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		trim_trailing_slash_or_dot(buf);
		fslib_mount(buf);
	}
	fclose(fp);
	unlink(RUN_LIB_FILE);
}

// fname should be a full path at this point
static void load_library(const char *fname) {
	assert(fname);
	assert(*fname == '/');

	// existing file owned by root
	struct stat s;
	if (stat_as_user(fname, &s) == 0 && s.st_uid == 0) {
		// load directories, regular 64 bit libraries, and 64 bit executables
		if (S_ISDIR(s.st_mode))
			fslib_mount(fname);
		else if (S_ISREG(s.st_mode) && is_lib_64(fname)) {
			if (strstr(fname, ".so") ||
			    access(fname, X_OK) != 0) // don't duplicate executables, just install the libraries
				fslib_mount(fname);

			fslib_mount_libs(fname, 1); // parse as user
		}
	}
}

static void install_list_entry(const char *lib) {
	assert(lib);

	// filename check
	reject_meta_chars(lib, 1);

	if (strstr(lib, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid library\n", lib);
		exit(1);
	}

	// if this is a full path, use it as is
	if (*lib == '/')
		return load_library(lib);


	// find the library
	int i;
	for (i = 0; default_lib_paths[i]; i++) {
		char *fname = NULL;
		if (asprintf(&fname, "%s/%s", default_lib_paths[i], lib) == -1)
			errExit("asprintf");

#define DO_GLOBBING
#ifdef DO_GLOBBING
		// globbing
		EUID_USER();
		glob_t globbuf;
		int globerr = glob(fname, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
		if (globerr) {
			fprintf(stderr, "Error: failed to glob private-lib pattern %s\n", fname);
			exit(1);
		}
		EUID_ROOT();
		size_t j;
		for (j = 0; j < globbuf.gl_pathc; j++) {
			assert(globbuf.gl_pathv[j]);
//printf("glob %s\n", globbuf.gl_pathv[j]);
			// GLOB_NOCHECK - no pattern matched returns the original pattern; try to load it anyway

			// foobar/* expands to foobar/. and foobar/..
			const char *base = gnu_basename(globbuf.gl_pathv[j]);
			if (strcmp(base, ".") == 0 || strcmp(base, "..") == 0)
				continue;
			load_library(globbuf.gl_pathv[j]);
		}

		globfree(&globbuf);
#else
		load_library(fname);
#endif
		free(fname);
	}

//	fwarning("%s library not found, skipping...\n", lib);
	return;
}

void fslib_install_list(const char *lib_list) {
	assert(lib_list);
	if (arg_debug || arg_debug_private_lib)
		printf("    fslib_install_list  %s\n", lib_list);

	char *dlist = strdup(lib_list);
	if (!dlist)
		errExit("strdup");

	char *ptr = strtok(dlist, ",");
	if (!ptr) {
		fprintf(stderr, "Error: invalid private-lib argument\n");
		exit(1);
	}
	trim_trailing_slash_or_dot(ptr);
	install_list_entry(ptr);

	while ((ptr = strtok(NULL, ",")) != NULL) {
		trim_trailing_slash_or_dot(ptr);
		install_list_entry(ptr);
	}
	free(dlist);
	fs_logger_print();
}

static void mount_directories(void) {
	fs_remount(RUN_LIB_DIR, MOUNT_READONLY, 1); // should be redundant except for RUN_LIB_DIR itself

	int i = 0;
	while (masked_lib_dirs[i]) {
		if (is_dir(masked_lib_dirs[i])) {
			if (arg_debug || arg_debug_private_lib)
				printf("Mount-bind %s on top of %s\n", RUN_LIB_DIR, masked_lib_dirs[i]);
			if (mount(RUN_LIB_DIR, masked_lib_dirs[i], NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");
			fs_logger2("tmpfs", masked_lib_dirs[i]);
			fs_logger2("mount", masked_lib_dirs[i]);
		}
		i++;
	}

	// for amd64 only - we'll deal with i386 later
	if (is_dir("/lib32")) {
		if (mount(RUN_RO_DIR, "/lib32", "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
		fs_logger("blacklist-nolog /lib32");
	}
	if (is_dir("/libx32")) {
		if (mount(RUN_RO_DIR, "/libx32", "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("disable file");
		fs_logger("blacklist-nolog /libx32");
	}
}

void fs_private_lib(void) {
#ifndef __x86_64__
	fwarning("private-lib feature is currently available only on amd64 platforms\n");
	return;
#endif
	char *private_list = cfg.lib_private_keep;
	if (arg_debug || arg_debug_private_lib)
		printf("Starting private-lib processing: program %s, shell %s\n",
			(cfg.original_program_index > 0)? cfg.original_argv[cfg.original_program_index]: "none", cfg.usershell);

	// create /run/firejail/mnt/lib directory
	mkdir_attr(RUN_LIB_DIR, 0755, 0, 0);
	selinux_relabel_path(RUN_LIB_DIR, "/usr/lib");

	// install standard C libraries
	if (arg_debug || arg_debug_private_lib)
		printf("Installing standard C library\n");
	fslib_install_stdc();

	// install other libraries needed by firejail
	if (arg_debug || arg_debug_private_lib)
		printf("Installing Firejail libraries\n");
	fslib_install_firejail();

	// start timetrace
	timetrace_start();

	// copy the libs in the new lib directory for the main exe
	if (cfg.original_program_index > 0) {
		if (arg_debug || arg_debug_private_lib)
			printf("Installing sandboxed program libraries\n");

		if (strchr(cfg.original_argv[cfg.original_program_index], '/'))
			fslib_install_list(cfg.original_argv[cfg.original_program_index]);
		else { // search executable in $PATH
			EUID_USER();
			char *fname = find_in_path(cfg.original_argv[cfg.original_program_index]);
			EUID_ROOT();
			if (fname) {
				fslib_install_list(fname);
				free(fname);
			}
		}
	}

// Note: this might be used for appimages!!!
//	if (!arg_shell_none) {
//		if (arg_debug || arg_debug_private_lib)
//			printf("Installing shell libraries\n");
//
//		fslib_install_list(cfg.shell);
//		// a shell is useless without some basic commands
//		fslib_install_list("/bin/ls,/bin/cat,/bin/mv,/bin/rm");
//	}

	// for the listed libs and directories
	if (private_list && *private_list != '\0') {
		if (arg_debug || arg_debug_private_lib)
			printf("Processing private-lib files\n");
		fslib_install_list(private_list);
	}

	// for private-bin files
	if (arg_private_bin && cfg.bin_private_lib && *cfg.bin_private_lib != '\0') {
		if (arg_debug || arg_debug_private_lib)
			printf("Processing private-bin files\n");
		fslib_install_list(cfg.bin_private_lib);
	}
	fmessage("Program libraries installed in %0.2f ms\n", timetrace_end());

	// install the rest of the system libraries
	if (arg_debug || arg_debug_private_lib)
		printf("Installing system libraries\n");
	fslib_install_system();

	fmessage("Installed %d %s and %d %s\n", lib_cnt, (lib_cnt == 1)? "library": "libraries",
		dir_cnt, (dir_cnt == 1)? "directory": "directories");

	// mount lib filesystem
	mount_directories();
}
#endif
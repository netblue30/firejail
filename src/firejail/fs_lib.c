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
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define MAXBUF 4096

static const char * const lib_paths[] = {
	"/lib",
	"/lib/x86_64-linux-gnu",
	"/lib64",
	"/usr/lib",
	"/usr/lib/x86_64-linux-gnu",
	LIBDIR,
	"/usr/local/lib",
	NULL
}; // Note: this array is duplicated in src/fldd/main.c

static void duplicate(const char *fname, const char *private_run_dir) {
	if (arg_debug)
		printf("copying %s to private %s\n", fname, private_run_dir);

	// copy only root-owned files
	struct stat s;
	if (stat(fname, &s) == 0 && s.st_uid == 0)
		sbox_run(SBOX_ROOT| SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", fname, private_run_dir);
}


// requires full path for lib
static void copy_libs(const char *lib, const char *private_run_dir, const char *output_file) {
	// if library/executable does not exist or the user does not have read access to it
	// print a warning and exit the function.
	if (access(lib, R_OK)) {
		fwarning("cannot find %s for private-lib, skipping...\n", lib);
		return;
	}

	// create an empty RUN_LIB_FILE and allow the user to write to it
	unlink(output_file); // in case is there
	create_empty_file_as_root(output_file, 0644);
	if (chown(output_file, getuid(), getgid()))
		errExit("chown");
		
	// run fldd to extact the list of file
	sbox_run(SBOX_USER | SBOX_SECCOMP | SBOX_CAPS_NONE, 3, PATH_FLDD, lib, output_file);
	
	// open the list of libraries and install them on by one
	FILE *fp = fopen(output_file, "r");
	if (!fp)
		errExit("fopen");

	char buf[MAXBUF];
	while (fgets(buf, MAXBUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		duplicate(buf, private_run_dir);
	}
	fclose(fp);
}

static void copy_directory(const char *full_path, const char *dir_name, const char *private_run_dir) {
	char *dest;
	if (asprintf(&dest, "%s/%s", private_run_dir, dir_name) == -1)
		errExit("asprintf");

	// do nothing if the directory is already there
	struct stat s;
	if (stat(dest, &s) == 0) {
		free(dest);
		return;
	}

	// create new directory and mount the original on top of it
	mkdir_attr(dest, 0755, 0, 0);

	if (mount(full_path, dest, NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, dest, NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("clone", full_path);
	fs_logger2("mount", full_path);
	free(dest);
}

// return 1 if the file is valid
static char *valid_file(const char *lib) {
	// filename check
	int len = strlen(lib);
	if (strcspn(lib, "\\&!?\"'<>%^(){}[];,*") != (size_t)len ||
	    strstr(lib, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid library\n", lib);
		exit(1);
	}
	
	// find the library
	int i;
	for (i = 0; lib_paths[i]; i++) {
		char *fname;
		if (asprintf(&fname, "%s/%s", lib_paths[i], lib) == -1)
			errExit("asprintf");
		
		// existing file owned by root
		struct stat s;
		if (stat(fname, &s) == 0 && s.st_uid == 0) {
			return fname;
		}
		free(fname);
	}

	fwarning("%s library not found, skipping...\n", lib);	
	return NULL;
}


void fs_private_lib(void) {
#ifndef __x86_64__
	fwarning("private-lib feature is currently available only on amd64 platforms\n");
	return;
#endif

	char *private_list = cfg.lib_private_keep;
	if (arg_debug)
		printf("Starting private-lib processing: program %s, shell %s\n",
			(cfg.original_program_index > 0)? cfg.original_argv[cfg.original_program_index]: "none",
			(arg_shell_none)? "none": cfg.shell);

	// create /run/firejail/mnt/lib directory
	mkdir_attr(RUN_LIB_DIR, 0755, 0, 0);

	//  fix libselinux linking problem on Debian stretch; the library is
	//  linked in most  basic command utilities (ls, cp, find etc.), and it
	//  seems to have a path hardlinked under /lib/x86_64-linux-gnu directory.
	struct stat s;
	if (stat("/lib/x86_64-linux-gnu/libselinux.so.1", &s) == 0) {
		mkdir_attr(RUN_LIB_DIR "/x86_64-linux-gnu", 0755, 0, 0);
		duplicate("/lib/x86_64-linux-gnu/libselinux.so.1", RUN_LIB_DIR "/x86_64-linux-gnu");
	}

	// copy the libs in the new lib directory for the main exe
	if (cfg.original_program_index > 0)
		copy_libs(cfg.original_argv[cfg.original_program_index], RUN_LIB_DIR, RUN_LIB_FILE);

	// for the shell
	if (!arg_shell_none) {
		copy_libs(cfg.shell, RUN_LIB_DIR, RUN_LIB_FILE);
		// a shell is useless without ls command
		copy_libs("/bin/ls", RUN_LIB_DIR, RUN_LIB_FILE);
	}

	// for the listed libs
	if (private_list && *private_list != '\0') {
		if (arg_debug)
			printf("Copying extra files (%s) in the new lib directory:\n", private_list);

		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");

		char *ptr = strtok(dlist, ",");
		char *lib = valid_file(ptr);
		if (lib) {
			if (is_dir(lib))
				copy_directory(lib, ptr, RUN_LIB_DIR);
			else {
				duplicate(lib, RUN_LIB_DIR);
				copy_libs(lib, RUN_LIB_DIR, RUN_LIB_FILE);
			}
			free(lib);
		}

		while ((ptr = strtok(NULL, ",")) != NULL) {
			lib = valid_file(ptr);
			if (lib) {
				if (is_dir(lib))
					copy_directory(lib, ptr, RUN_LIB_DIR);
				else {
					duplicate(lib, RUN_LIB_DIR);
					copy_libs(lib, RUN_LIB_DIR, RUN_LIB_FILE);
				}
				free(lib);
			}
		}
		free(dlist);
		fs_logger_print();
	}

	// for private-bin files
	if (arg_private_bin) {
		FILE *fp = fopen(RUN_LIB_BIN, "r");
		if (fp) {
			char buf[MAXBUF];
			while (fgets(buf, MAXBUF, fp)) {
				// remove \n
				char *ptr = strchr(buf, '\n');
				if (ptr)
					*ptr = '\0';
				copy_libs(buf, RUN_LIB_DIR, RUN_LIB_FILE);
			}
		}
		fclose(fp);
	}

	// for our trace and tracelog libs
	if (arg_trace)
		duplicate(LIBDIR "/firejail/libtrace.so", RUN_LIB_DIR);
	else if (arg_tracelog)
		duplicate(LIBDIR "/firejail/libtracelog.so", RUN_LIB_DIR);

	if (arg_debug)
		printf("Mount-bind %s on top of /lib /lib64 /usr/lib\n", RUN_LIB_DIR);

    if (is_dir("/lib")) {
    	if (mount(RUN_LIB_DIR, "/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	        mount(NULL, "/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
            errExit("mount bind");
    	fs_logger2("tmpfs", "/lib");
	    fs_logger("mount /lib");
    }

    if (is_dir("/lib64")) {	
        if (mount(RUN_LIB_DIR, "/lib64", NULL, MS_BIND|MS_REC, NULL) < 0 ||
    	    mount(NULL, "/lib64", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
    		errExit("mount bind");
    	fs_logger2("tmpfs", "/lib64");
    	fs_logger("mount /lib64");
    }

    if (is_dir("/usr/lib")) {
    	if (mount(RUN_LIB_DIR, "/usr/lib", NULL, MS_BIND|MS_REC, NULL) < 0 ||
	        mount(NULL, "/usr/lib", NULL, MS_BIND|MS_REMOUNT|MS_NOSUID|MS_NODEV|MS_REC, NULL) < 0)
            errExit("mount bind");
       fs_logger2("tmpfs", "/usr/lib");
    	fs_logger("mount /usr/lib");
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

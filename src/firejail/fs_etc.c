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
#include <errno.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#include <glob.h>
#include "../include/etc_groups.h"

static int etc_cnt = 0;

static void etc_copy_group(char **pptr) {
	assert(pptr);

	while (*pptr != NULL) {
		etc_list[etc_cnt++] = *pptr;
		etc_list[etc_cnt] = NULL;
		pptr++;
	}
}

static void etc_add(const char *file) {
	assert(file);
	if (etc_cnt >= ETC_MAX) {
		fprintf(stderr, "Error: size of private_etc list exceeded (%d maximum)\n", ETC_MAX);
		exit(1);
	}

	// look for file in the current list
	int i;
	for (i = 0; i < etc_cnt; i++) {
		if (strcmp(file, etc_list[i]) == 0) {
			if (arg_debug)
				printf("private-etc arguments: skip %s\n", file);
			return;
		}
	}

	char *ptr = strdup(file);
	if (!ptr)
		errExit("strdup");
	etc_list[etc_cnt++] = ptr;
	etc_list[etc_cnt] = NULL;
}

// str can be NULL
char *fs_etc_build(char *str) {
	while (etc_list[etc_cnt++]);
	etc_cnt--;
	if (!arg_nonetwork)
		etc_copy_group(&etc_group_network[0]);
	if (!arg_nosound)
		etc_copy_group(&etc_group_sound[0]);

	// parsing
	if (str) {
		char* ptr = strtok(str, ",");
		while (ptr) {
			// look for standard groups
			if (strcmp(ptr, "@tls-ca") == 0)
				etc_copy_group(&etc_group_tls_ca[0]);
			if (strcmp(ptr, "@x11") == 0)
				etc_copy_group(&etc_group_x11[0]);
			if (strcmp(ptr, "@sound") == 0)
				etc_copy_group(&etc_group_sound[0]);
			if (strcmp(ptr, "@network") == 0)
				etc_copy_group(&etc_group_network[0]);
			if (strcmp(ptr, "@games") == 0)
				etc_copy_group(&etc_group_games[0]);
			else
				etc_add(ptr);
			ptr = strtok(NULL, ",");
		}
	}

	// manufacture the new string
	int len = 0;
	int i;
	for (i = 0; i < etc_cnt; i++)
		len += strlen(etc_list[i]) + 1; // plus 1 for the trailing ','
	char *rv = malloc(len + 1);
	if (!rv)
		errExit("malloc");
	char *ptr = rv;
	for (i = 0; i < etc_cnt; i++) {
		sprintf(ptr, "%s,", etc_list[i]);
		ptr += strlen(etc_list[i]) + 1;
	}

	return rv;
}

void fs_resolvconf(void) {
	if (arg_nonetwork) {
		if (arg_debug)
			printf("arg_nonetwork found (--net=none). Skip creating /etc/resolv.conf file\n");
		return;
	}
	if (arg_debug)
		printf("Creating a new /etc/resolv.conf file\n");
	FILE *fp = fopen(RUN_RESOLVCONF_FILE, "wxe");
	if (!fp) {
		fprintf(stderr, "Error: cannot create /etc/resolv.conf file\n");
		exit(1);
	}

	if (cfg.dns1) {
		if (any_dhcp())
			fwarning("network setup uses DHCP, nameservers will likely be overwritten\n");
		fprintf(fp, "nameserver %s\n", cfg.dns1);
	}
	if (cfg.dns2)
		fprintf(fp, "nameserver %s\n", cfg.dns2);
	if (cfg.dns3)
		fprintf(fp, "nameserver %s\n", cfg.dns3);
	if (cfg.dns4)
		fprintf(fp, "nameserver %s\n", cfg.dns4);

	// mode and owner
	SET_PERMS_STREAM(fp, 0, 0, 0644);

	fclose(fp);
	selinux_relabel_path(RUN_RESOLVCONF_FILE, "/etc/resolv.conf");


	if (mount(RUN_RESOLVCONF_FILE, "/etc/resolv.conf", "none", MS_BIND, "mode=644,gid=0") < 0)
		errExit("mount");

	fs_logger("create /etc/resolv.conf");
}


// spoof /etc/machine_id
void fs_machineid(void) {
	union machineid_t {
		uint8_t u8[16];
		uint32_t u32[4];
	} mid;

	// if --machine-id flag is inactive, do nothing
	if (arg_machineid == 0)
		return;
	if (arg_debug)
		printf("Generating a new machine-id\n");

	// init random number generator
	srand(time(NULL));

	// generate random id
	mid.u32[0] = rand();
	mid.u32[1] = rand();
	mid.u32[2] = rand();
	mid.u32[3] = rand();

	// UUID version 4 and DCE variant
	mid.u8[6] = (mid.u8[6] & 0x0F) | 0x40;
	mid.u8[8] = (mid.u8[8] & 0x3F) | 0x80;

	// write it in a file
	FILE *fp = fopen(RUN_MACHINEID, "we");
	if (!fp)
		errExit("fopen");
	fprintf(fp, "%08x%08x%08x%08x\n", mid.u32[0], mid.u32[1], mid.u32[2], mid.u32[3]);
	fclose(fp);
	if (set_perms(RUN_MACHINEID, 0, 0, 0444))
		errExit("set_perms");

	selinux_relabel_path(RUN_MACHINEID, "/etc/machine-id");

	struct stat s;
	if (stat("/etc/machine-id", &s) == 0) {
		if (arg_debug)
			printf("installing a new /etc/machine-id\n");

		if (mount(RUN_MACHINEID, "/etc/machine-id", "none", MS_BIND, "mode=444,gid=0"))
			errExit("mount");
	}
	if (stat("/var/lib/dbus/machine-id", &s) == 0) {
		if (mount(RUN_MACHINEID, "/var/lib/dbus/machine-id", "none", MS_BIND, "mode=444,gid=0"))
			errExit("mount");
	}
}

// Duplicate directory structure from src to dst by creating empty directories.
// The paths _must_ be identical after their respective prefixes.
// When finished, dst will point to the target directory. That is, if
// it starts out pointing to a file, it will instead be truncated so
// that it contains the parent directory instead.
static void build_dirs(char *src, char *dst, size_t src_prefix_len, size_t dst_prefix_len) {
	char *p = src + src_prefix_len + 1;
	char *q = dst + dst_prefix_len + 1;
	char *r = dst + dst_prefix_len;
	struct stat s;
	bool last = false;
	*r = '\0';
	for (; !last; p++, q++) {
		if (*p == '\0') {
			last = true;
		}
		if (*p == '\0' || (*p == '/' && *(p - 1) != '/')) {
			// We found a new component of our src path.
			// Null-terminate it temporarily here so that we can work
			// with it.
			*p = '\0';
			if (stat(src, &s) == 0 && S_ISDIR(s.st_mode)) {
				// Null-terminate the dst path and undo its previous
				// termination.
				*q = '\0';
				*r = '/';
				r = q;
				if (mkdir(dst, 0700) != 0 && errno != EEXIST)
					errExit("mkdir");
				if (chmod(dst, s.st_mode) != 0)
					errExit("chmod");
			}
			if (!last) {
				// If we're not at the final terminating null, restore
				// the slash so that we can continue our traversal.
				*p = '/';
			}
		}
	}
}

// return 0 if file not found, 1 if found
static int check_dir_or_file(const char *fname) {
	assert(fname);

	struct stat s;
	if (stat(fname, &s) == -1) {
		if (arg_debug)
			fwarning("file %s not found.\n", fname);
		return 0;
	}

	// read access
	if (access(fname, R_OK) == -1)
		goto errexit;

	// dir or regular file
	if (S_ISDIR(s.st_mode) || S_ISREG(s.st_mode) || !is_link(fname))
		return 1;	// normal exit

errexit:
	fprintf(stderr, "Error: invalid file type, %s.\n", fname);
	exit(1);
}

static void duplicate(const char *fname, const char *private_dir, const char *private_run_dir) {
	char *src;
	if (asprintf(&src,  "%s/%s", private_dir, fname) == -1)
		errExit("asprintf");

	if (check_dir_or_file(src) == 0) {
		free(src);
		return;
	}

	if (arg_debug)
		printf("Copying %s to private %s\n", src, private_dir);

	char *dst;
	if (asprintf(&dst, "%s/%s", private_run_dir, fname) == -1)
		errExit("asprintf");

	build_dirs(src, dst, strlen(private_dir), strlen(private_run_dir));

	// follow links by default, thus making a copy of the file or directory pointed by the symlink
	// this will solve problems such as NixOS #4887
	//
	// don't follow links to dynamic directories such as /proc
	if (strcmp(src, "/etc/mtab") == 0)
		sbox_run(SBOX_ROOT | SBOX_SECCOMP, 3, PATH_FCOPY, src, dst);
	else
		sbox_run(SBOX_ROOT | SBOX_SECCOMP, 4, PATH_FCOPY, "--follow-link", src, dst);

	free(dst);
	fs_logger2("clone", src);
}

static void duplicate_globbing(const char *fname, const char *private_dir, const char *private_run_dir) {
	assert(fname);

	if (*fname == '~' || *fname == '/' || strstr(fname, "..")) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", fname);
		exit(1);
	}
	invalid_filename(fname, 1); // no globbing

	char *pattern;
	if (asprintf(&pattern,  "%s/%s", private_dir, fname) == -1)
		errExit("asprintf");

	glob_t globbuf;
	int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
	if (globerr) {
		fprintf(stderr, "Error: failed to glob pattern %s\n", pattern);
		exit(1);
	}

	size_t i;
	int len = strlen(private_dir);
	for (i = 0; i < globbuf.gl_pathc; i++) {
		char *path = globbuf.gl_pathv[i];
		duplicate(path + len + 1, private_dir, private_run_dir);
	}

	globfree(&globbuf);
	free(pattern);
}

void fs_private_dir_copy(const char *private_dir, const char *private_run_dir, const char *private_list) {
	assert(private_dir);
	assert(private_run_dir);
	assert(private_list);

	// nothing to do if directory does not exist
	struct stat s;
	if (stat(private_dir, &s) == -1) {
		if (arg_debug)
			printf("Cannot find %s: %s\n", private_dir, strerror(errno));
		return;
	}

	// create /run/firejail/mnt/etc directory
	mkdir_attr(private_run_dir, 0755, 0, 0);
	selinux_relabel_path(private_run_dir, private_dir);
	fs_logger2("tmpfs", private_dir);

	fs_logger_print();	// save the current log


	// copy the list of files in the new etc directory
	// using a new child process with root privileges
	if (*private_list != '\0') {
		if (arg_debug)
			printf("Copying files in the new %s directory:\n", private_dir);

		// copy the list of files in the new home directory
		char *dlist = strdup(private_list);
		if (!dlist)
			errExit("strdup");


		char *ptr = strtok(dlist, ",");
		if (!ptr) {
			fprintf(stderr, "Error: invalid private %s argument\n", private_dir);
			exit(1);
		}
		duplicate_globbing(ptr, private_dir, private_run_dir);

		while ((ptr = strtok(NULL, ",")) != NULL)
			duplicate_globbing(ptr, private_dir, private_run_dir);
		free(dlist);
		fs_logger_print();
	}
}

void fs_private_dir_mount(const char *private_dir, const char *private_run_dir) {
	assert(private_dir);
	assert(private_run_dir);

	if (arg_debug)
		printf("Mount-bind %s on top of %s\n", private_run_dir, private_dir);

	// nothing to do if directory does not exist
	struct stat s;
	if (stat(private_dir, &s) == -1) {
		if (arg_debug)
			printf("Cannot find %s: %s\n", private_dir, strerror(errno));
		return;
	}

	if (mount(private_run_dir, private_dir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("mount", private_dir);

	// mask private_run_dir (who knows if there are writable paths, and it is mounted exec)
	if (mount("tmpfs", private_run_dir, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mounting tmpfs");
	fs_logger2("tmpfs", private_run_dir);
}

void fs_private_dir_list(const char *private_dir, const char *private_run_dir, const char *private_list) {
	timetrace_start();
	fs_private_dir_copy(private_dir, private_run_dir, private_list);
	fs_private_dir_mount(private_dir, private_run_dir);
	fmessage("Private %s installed in %0.2f ms\n", private_dir, timetrace_end());
}

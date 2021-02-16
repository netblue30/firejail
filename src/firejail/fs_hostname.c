/*
 * Copyright (C) 2014-2021 Firejail Authors
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
#include <linux/limits.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>

void fs_hostname(const char *hostname) {
	struct stat s;

	// create a new /etc/hostname
	if (stat("/etc/hostname", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hostname file\n");

		create_empty_file_as_root(RUN_HOSTNAME_FILE, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH);

		// bind-mount the file on top of /etc/hostname
		if (mount(RUN_HOSTNAME_FILE, "/etc/hostname", NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind /etc/hostname");
		fs_logger("create /etc/hostname");
	}

	// create a new /etc/hosts
	if (cfg.hosts_file == NULL && stat("/etc/hosts", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hosts file\n");
		// copy /etc/host into our new file, and modify it on the fly
		/* coverity[toctou] */
		FILE *fp1 = fopen("/etc/hosts", "r");
		if (!fp1)
			goto errexit;

		FILE *fp2 = fopen(RUN_HOSTS_FILE, "w");
		if (!fp2) {
			fclose(fp1);
			goto errexit;
		}

		char buf[4096];
		int done = 0;
		while (fgets(buf, sizeof(buf), fp1)) {
			// remove '\n'
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';

			// copy line
			if (strstr(buf, "127.0.0.1") && done == 0) {
				done = 1;
				fprintf(fp2, "%s %s\n", buf, hostname);
			}
			else
				fprintf(fp2, "%s\n", buf);
		}
		fclose(fp1);
		// mode and owner
		SET_PERMS_STREAM(fp2, 0, 0, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH);
		fclose(fp2);

		// bind-mount the file on top of /etc/hostname
		fs_mount_hosts_file();
	}
	return;

errexit:
	fprintf(stderr, "Error: cannot create hostname file\n");
	exit(1);
}

void fs_resolvconf(void) {
	if (cfg.dns1 == NULL && !any_dhcp())
		return;

	if (arg_debug)
		printf("mirroring /etc directory\n");
	if (mkdir(RUN_DNS_ETC, 0755))
		errExit("mkdir");
	selinux_relabel_path(RUN_DNS_ETC, "/etc");
	fs_logger("tmpfs /etc");

	DIR *dir = opendir("/etc");
	if (!dir)
		errExit("opendir");

	struct stat s;
	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;
		// for resolv.conf we create a brand new file
		if (strcmp(entry->d_name, "resolv.conf") == 0 ||
        strcmp(entry->d_name, "resolv.conf.dhclient-new") == 0)
			continue;
//		printf("linking %s\n", entry->d_name);

		char *src;
		if (asprintf(&src, "/etc/%s", entry->d_name) == -1)
			errExit("asprintf");
		if (stat(src, &s) != 0) {
			free(src);
			continue;
		}

		char *dest;
		if (asprintf(&dest, "%s/%s", RUN_DNS_ETC, entry->d_name) == -1)
			errExit("asprintf");

		int symlink_done = 0;
		if (is_link(src)) {
			char *rp =realpath(src, NULL);
			if (rp == NULL) {
				free(src);
				free(dest);
				continue;
			}
			if (symlink(rp, dest))
				errExit("symlink");
			else
				symlink_done = 1;
		}
		else if (S_ISDIR(s.st_mode))
			create_empty_dir_as_root(dest, s.st_mode);
		else
			create_empty_file_as_root(dest, s.st_mode);

		// bind-mount src on top of dest
		if (!symlink_done) {
			if (mount(src, dest, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind mirroring /etc");
		}
		fs_logger2("clone", src);

		free(src);
		free(dest);
	}
	closedir(dir);

	// mount bind our private etc directory on top of /etc
	if (arg_debug)
		printf("Mount-bind %s on top of /etc\n", RUN_DNS_ETC);
	if (mount(RUN_DNS_ETC, "/etc", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind mirroring /etc");
	fs_logger("mount /etc");

	if (arg_debug)
		printf("Creating a new /etc/resolv.conf file\n");
	FILE *fp = fopen("/etc/resolv.conf", "w");
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

	fs_logger("create /etc/resolv.conf");
}

char *fs_check_hosts_file(const char *fname) {
	assert(fname);
	invalid_filename(fname, 0); // no globbing
	char *rv = expand_macros(fname);

	// no a link
	if (is_link(rv))
		goto errexit;

	// the user has read access to the file
	if (access(rv, R_OK))
		goto errexit;

	return rv;
errexit:
	fprintf(stderr, "Error: invalid file %s\n", fname);
	exit(1);
}

void fs_store_hosts_file(void) {
	copy_file_from_user_to_root(cfg.hosts_file, RUN_HOSTS_FILE, 0, 0, 0644); // root needed
}

void fs_mount_hosts_file(void) {
	if (arg_debug)
		printf("Loading user hosts file\n");

	// check /etc/hosts file
	struct stat s;
	if (stat("/etc/hosts", &s) == -1)
		goto errexit;
	// not a link
	if (is_link("/etc/hosts"))
		goto errexit;
	// owned by root
	if (s.st_uid != 0)
		goto errexit;

	// bind-mount the file on top of /etc/hostname
	if (mount(RUN_HOSTS_FILE, "/etc/hosts", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind /etc/hosts");
	fs_logger("create /etc/hosts");
	return;

errexit:
	fprintf(stderr, "Error: invalid /etc/hosts file\n");
	exit(1);
}

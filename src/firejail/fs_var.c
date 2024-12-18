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
#include <sys/mount.h>
#include <sys/stat.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <pwd.h>
#include <utmp.h>
#include <time.h>

typedef struct dirdata_t{
	struct dirdata_t *next;
	char *name;
	mode_t st_mode;
	uid_t st_uid;
	gid_t st_gid;
} DirData;

static DirData *dirlist = NULL;

static void release_all(void) {
	DirData *ptr = dirlist;
	while (ptr) {
		DirData *next = ptr->next;
		free(ptr->name);
		free(ptr);
		ptr = next;
	}
	dirlist = NULL;
}

static void build_list(const char *srcdir) {
	// extract current /var/log directory data
	struct dirent *dir;
	DIR *d = opendir(srcdir);
	if (d == NULL)
		return;

	while ((dir = readdir(d))) {
		if(strcmp(dir->d_name, "." ) == 0 || strcmp(dir->d_name, ".." ) == 0)
			continue;

		if (dir->d_type == DT_DIR ) {
			// get properties
			struct stat s;
			char *name;
			if (asprintf(&name, "%s/%s", srcdir, dir->d_name) == -1)
				errExit("asprintf");
			if (stat(name, &s) == -1 ||
			    S_ISLNK(s.st_mode)) {
				free(name);
				continue;
			}

//			printf("directory %u %u:%u %s\n",
//				s.st_mode,
//				s.st_uid,
//				s.st_gid,
//				dir->d_name);

			DirData *ptr = malloc(sizeof(DirData));
			if (ptr == NULL)
				errExit("malloc");
			memset(ptr, 0, sizeof(DirData));
			ptr->name = name;
			ptr->st_mode = s.st_mode;
			ptr->st_uid = s.st_uid;
			ptr->st_gid = s.st_gid;
			ptr->next = dirlist;
			dirlist = ptr;
		}
	}
	closedir(d);
}

static void build_dirs(void) {
	// create directories under /var/log
	DirData *ptr = dirlist;
	while (ptr) {
		mkdir_attr(ptr->name, ptr->st_mode, ptr->st_uid, ptr->st_gid);
		fs_logger2("mkdir", ptr->name);
		ptr = ptr->next;
	}
}

void fs_var_log(void) {
	build_list("/var/log");

	// note: /var/log is not created here, if it does not exist, this section fails.
	// create /var/log if it doesn't exit
	if (is_dir("/var/log")) {
		// extract group id for /var/log/wtmp
		struct stat s;
		gid_t wtmp_group = 0;
		if (stat("/var/log/wtmp", &s) == 0)
			wtmp_group = s.st_gid;

		// mount a tmpfs on top of /var/log
		if (arg_debug)
			printf("Mounting tmpfs on /var/log\n");
		if (mount("tmpfs", "/var/log", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/log");
		fs_logger("tmpfs /var/log");

		build_dirs();
		release_all();

		// create an empty /var/log/wtmp file
		/* coverity[toctou] */
		FILE *fp = fopen("/var/log/wtmp", "wxe");
		if (fp) {
			SET_PERMS_STREAM(fp, 0, wtmp_group, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
			fclose(fp);
		}
		fs_logger("touch /var/log/wtmp");

		// create an empty /var/log/btmp file
		fp = fopen("/var/log/btmp", "wxe");
		if (fp) {
			SET_PERMS_STREAM(fp, 0, wtmp_group, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
			fclose(fp);
		}
		fs_logger("touch /var/log/btmp");
	}
	else
		fwarning("cannot hide /var/log directory\n");
}

void fs_var_lib(void) {
	struct stat s;

	// ISC DHCP multiserver
	if (stat("/var/lib/dhcp", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/dhcp\n");
		if (mount("tmpfs", "/var/lib/dhcp", "tmpfs", MS_NOSUID |  MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/dhcp");
		fs_logger("tmpfs /var/lib/dhcp");

		// isc dhcp server requires a /var/lib/dhcp/dhcpd.leases file
		FILE *fp = fopen("/var/lib/dhcp/dhcpd.leases", "wxe");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, 0, 0, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH);
			fclose(fp);
			fs_logger("touch /var/lib/dhcp/dhcpd.leases");
		}
	}

	// nginx multiserver
	if (stat("/var/lib/nginx", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/nginx\n");
		if (mount("tmpfs", "/var/lib/nginx", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/nginx");
		fs_logger("tmpfs /var/lib/nginx");
	}

	// net-snmp multiserver
	if (stat("/var/lib/snmp", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/snmp\n");
		if (mount("tmpfs", "/var/lib/snmp", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/snmp");
		fs_logger("tmpfs /var/lib/snmp");
	}

	// this is where sudo remembers its state
	if (stat("/var/lib/sudo", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/sudo\n");
		if (mount("tmpfs", "/var/lib/sudo", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/sudo");
		fs_logger("tmpfs /var/lib/sudo");
	}
}

void fs_var_cache(void) {
	struct stat s;

	if (stat("/var/cache/apache2", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/cache/apache2\n");
		if (mount("tmpfs", "/var/cache/apache2", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/cache/apache2");
		fs_logger("tmpfs /var/cache/apache2");
	}

	if (stat("/var/cache/lighttpd", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/cache/lighttpd\n");
		if (mount("tmpfs", "/var/cache/lighttpd", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /var/cache/lighttpd");
		fs_logger("tmpfs /var/cache/lighttpd");

		struct passwd *p = getpwnam("www-data");
		uid_t uid = 0;
		gid_t gid = 0;
		if (p) {
			uid = p->pw_uid;
			gid = p->pw_gid;
		}

		mkdir_attr("/var/cache/lighttpd/compress", 0755, uid, gid);
		selinux_relabel_path("/var/cache/lighttpd/compress", "/var/cache/lighttpd/compress");
		fs_logger("mkdir /var/cache/lighttpd/compress");

		mkdir_attr("/var/cache/lighttpd/uploads", 0755, uid, gid);
		selinux_relabel_path("/var/cache/lighttpd/uploads", "/var/cache/lighttpd/uploads");
		fs_logger("/var/cache/lighttpd/uploads");
	}
}

void fs_var_lock(void) {

	if (is_dir("/var/lock")) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lock\n");
		if (mount("tmpfs", "/var/lock", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=1777,gid=0") < 0)
			errExit("mounting /lock");
		fs_logger("tmpfs /var/lock");
	}
	else
		fwarning("/var/lock not mounted\n");
}

void fs_var_tmp(void) {
	struct stat s;
	if (stat("/var/tmp", &s) == 0) {
		if (!is_link("/var/tmp")) {
			if (arg_debug)
				printf("Mounting tmpfs on /var/tmp\n");
			if (mount("tmpfs", "/var/tmp", "tmpfs", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,  "mode=1777,gid=0") < 0)
				errExit("mounting /var/tmp");
			fs_logger("tmpfs /var/tmp");
		}
	}
	else
		fwarning("/var/tmp not mounted\n");
}

void fs_var_utmp(void) {
	struct stat s;

	// extract utmp group id
	gid_t utmp_group = 0;
	if (stat(UTMP_FILE, &s) == 0)
		utmp_group = s.st_gid;
	else {
		fwarning("cannot find %s\n", UTMP_FILE);
		return;
	}

	// create a new utmp file
	if (arg_debug)
		printf("Create the new utmp file\n");

	/* coverity[toctou] */
	FILE *fp = fopen(RUN_UTMP_FILE, "we");
	if (!fp)
		errExit("fopen");

	// read current utmp
	struct utmp *u;
	struct utmp u_boot = {0};
	setutent();
	while ((u = getutent()) != NULL) {
		if (u->ut_type == BOOT_TIME) {
			memcpy(&u_boot, u, sizeof(u_boot));
			u_boot.ut_tv.tv_sec = (unsigned) time(NULL);
		}
	}
	endutent();

	// save new utmp file
	int rv = fwrite(&u_boot, sizeof(u_boot), 1, fp);
	(void) rv;
	SET_PERMS_STREAM(fp, 0, utmp_group, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH);
	fclose(fp);

	// mount the new utmp file
	if (arg_debug)
		printf("Mount the new utmp file\n");
	if (mount(RUN_UTMP_FILE, UTMP_FILE, NULL, MS_BIND|MS_NOSUID|MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mount bind utmp");
	fs_logger2("create", UTMP_FILE);

	// blacklist RUN_UTMP_FILE
	if (mount(RUN_RO_FILE, RUN_UTMP_FILE, NULL, MS_BIND, "mode=400,gid=0") < 0)
		errExit("mount bind");
}

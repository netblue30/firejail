/*
 * Copyright (C) 2014, 2015 Firejail Authors
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
	fs_build_mnt_dir();
	
	// create a new /etc/hostname
	if (stat("/etc/hostname", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hostname file\n");
		char *fhost;
		if (asprintf(&fhost, "%s/hostname", MNT_DIR) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fhost, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot create %s\n", fhost);
			free(fhost);
			exit(1);
		}
		fprintf(fp, "%s\n", hostname);
		fclose(fp);
		
		// mode and owner
		if (chown(fhost, 0, 0) < 0)
			errExit("chown");
		if (chmod(fhost, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH ) < 0)
			errExit("chmod");
		
		// bind-mount the file on top of /etc/hostname
		if (mount(fhost, "/etc/hostname", NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind /etc/hostname");
		free(fhost);
	}
	
	// create a new /etc/hosts
	if (stat("/etc/hosts", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/hosts file\n");
		char *fhost;
		if (asprintf(&fhost, "%s/hosts", MNT_DIR) == -1)
			errExit("asprintf");
		// copy /etc/host into our new file, and modify it on the fly
		/* coverity[toctou] */
		FILE *fp1 = fopen("/etc/hosts", "r");
		if (!fp1) {
			fprintf(stderr, "Error: cannot open /etc/hosts\n");
			free(fhost);
			exit(1);
		}
		FILE *fp2 = fopen(fhost, "w");
		if (!fp2) {
			fprintf(stderr, "Error: cannot create %s\n", fhost);
			free(fhost);
			exit(1);
		}
		
		char buf[4096];
		while (fgets(buf, sizeof(buf), fp1)) {
			// remove '\n'
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
				
			// copy line
			if (strstr(buf, "127.0.0.1"))
				fprintf(fp2, "%s %s\n", buf, hostname);
			else
				fprintf(fp2, "%s\n", buf);
		}
		fclose(fp1);
		fclose(fp2);
		
		// mode and owner
		if (chown(fhost, 0, 0) < 0)
			errExit("chown");
		if (chmod(fhost, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH ) < 0)
			errExit("chmod");
		
		// bind-mount the file on top of /etc/hostname
		if (mount(fhost, "/etc/hosts", NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind /etc/hosts");
		free(fhost);
	}
}

void fs_resolvconf(void) {
	if (cfg.dns1 == 0)
		return;
		
	struct stat s;
	fs_build_mnt_dir();
	
	// create a new /etc/hostname
	if (stat("/etc/resolv.conf", &s) == 0) {
		if (arg_debug)
			printf("Creating a new /etc/resolv.conf file\n");
		char *fname;
		if (asprintf(&fname, "%s/resolv.conf", MNT_DIR) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "w");
		if (!fp) {
			fprintf(stderr, "Error: cannot create %s\n", fname);
			free(fname);
			exit(1);
		}
		
		if (cfg.dns1)
			fprintf(fp, "nameserver %d.%d.%d.%d\n", PRINT_IP(cfg.dns1));
		if (cfg.dns2)
			fprintf(fp, "nameserver %d.%d.%d.%d\n", PRINT_IP(cfg.dns2));
		if (cfg.dns3)
			fprintf(fp, "nameserver %d.%d.%d.%d\n", PRINT_IP(cfg.dns3));
		fclose(fp);
		
		// mode and owner
		if (chown(fname, 0, 0) < 0)
			errExit("chown");
		if (chmod(fname, S_IRUSR | S_IWRITE | S_IRGRP | S_IROTH ) < 0)
			errExit("chmod");
		
		// bind-mount the file on top of /etc/hostname
		if (mount(fname, "/etc/resolv.conf", NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount bind /etc/resolv.conf");
		free(fname);
	}
	else {
		fprintf(stderr, "Error: cannot set DNS servers, /etc/resolv.conf file is missing\n");
		exit(1);
	}
}

	

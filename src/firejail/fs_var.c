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
				continue;
			if (stat(name, &s) == -1)
				continue;
			if (S_ISLNK(s.st_mode)) {
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
		if (mkdir(ptr->name, ptr->st_mode))
			errExit("mkdir");
		if (chown(ptr->name, ptr->st_uid, ptr->st_gid))
			errExit("chown");
		ptr = ptr->next;
	}
}
	
void fs_var_log(void) {
	build_list("/var/log");
	
	// create /var/log if it does't exit
	if (is_dir("/var/log")) {
		// extract group id for /var/log/wtmp
		struct stat s;
		gid_t wtmp_group = 0;
		if (stat("/var/log/wtmp", &s) == 0)
			wtmp_group = s.st_gid;
		
		// mount a tmpfs on top of /var/log
		if (arg_debug)
			printf("Mounting tmpfs on /var/log\n");
		if (mount("tmpfs", "/var/log", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/log");
		
		build_dirs();
		release_all();
		
		// create an empty /var/log/wtmp file
		/* coverity[toctou] */
		FILE *fp = fopen("/var/log/wtmp", "w");
		if (fp)
			fclose(fp);
		if (chown("/var/log/wtmp", 0, wtmp_group) < 0)
			errExit("chown");
		if (chmod("/var/log/wtmp", S_IRUSR | S_IWRITE | S_IRGRP | S_IWGRP | S_IROTH ) < 0)
			errExit("chmod");
			
		// create an empty /var/log/btmp file
		fp = fopen("/var/log/btmp", "w");
		if (fp)
			fclose(fp);
		if (chown("/var/log/btmp", 0, wtmp_group) < 0)
			errExit("chown");
		if (chmod("/var/log/btmp", S_IRUSR | S_IWRITE | S_IRGRP | S_IWGRP) < 0)
			errExit("chmod");
	}
	else
		fprintf(stderr, "Warning: cannot mount tmpfs on top of /var/log\n");
}

void fs_var_lib(void) {
	struct stat s;
	
	// ISC DHCP multiserver
	if (stat("/var/lib/dhcp", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/dhcp\n");
		if (mount("tmpfs", "/var/lib/dhcp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/dhcp");
			
		// isc dhcp server requires a /var/lib/dhcp/dhcpd.leases file
		FILE *fp = fopen("/var/lib/dhcp/dhcpd.leases", "w");
		
		if (fp) {
			fprintf(fp, "\n");
			fclose(fp);
			if (chown("/var/lib/dhcp/dhcpd.leases", 0, 0) == -1)
				errExit("chown");
			if (chmod("/var/lib/dhcp/dhcpd.leases", S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH))
				errExit("chmod");
		}
	}

	// nginx multiserver
	if (stat("/var/lib/nginx", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/nginx\n");
		if (mount("tmpfs", "/var/lib/nginx", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/nginx");
	}			

	// net-snmp multiserver
	if (stat("/var/lib/snmp", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/snmp\n");
		if (mount("tmpfs", "/var/lib/snmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/snmp");
	}			

	// this is where sudo remembers its state
	if (stat("/var/lib/sudo", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lib/sudo\n");
		if (mount("tmpfs", "/var/lib/sudo", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/lib/sudo");
	}			
}

void fs_var_cache(void) {
	struct stat s;

	if (stat("/var/cache/apache2", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/cache/apache2\n");
		if (mount("tmpfs", "/var/cache/apache2", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/cahce/apache2");
	}			

	if (stat("/var/cache/lighttpd", &s) == 0) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/cache/lighttpd\n");
		if (mount("tmpfs", "/var/cache/lighttpd", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /var/cache/lighttpd");

		struct passwd *p = getpwnam("www-data");
		uid_t uid = 0;
		gid_t gid = 0;
		if (p) {
			uid = p->pw_uid;
			gid = p->pw_gid;
		}
		
		int rv = mkdir("/var/cache/lighttpd/compress", S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown("/var/cache/lighttpd/compress", uid, gid) < 0)
			errExit("chown");

		rv = mkdir("/var/cache/lighttpd/uploads", S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
		if (rv == -1)
			errExit("mkdir");
		if (chown("/var/cache/lighttpd/uploads", uid, gid) < 0)
			errExit("chown");
	}			
}

void dbg_test_dir(const char *dir) {
	if (arg_debug) {
		if (is_dir(dir))
			printf("%s is a directory\n", dir);
		if (is_link(dir)) {
			char *lnk = realpath(dir, NULL);
			if (lnk) {
				printf("%s is a symbolic link to %s\n", dir, lnk);
				free(lnk);
			}
		}
	}
}


void fs_var_lock(void) {

	if (is_dir("/var/lock")) {
		if (arg_debug)
			printf("Mounting tmpfs on /var/lock\n");
		if (mount("tmpfs", "/var/lock", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting /lock");
	}
	else {
		char *lnk = realpath("/var/lock", NULL);
		if (lnk) {
			if (!is_dir(lnk)) {
				// create directory
				if (mkdir(lnk, S_IRWXU|S_IRWXG|S_IRWXO))
					errExit("mkdir");
				if (chown(lnk, 0, 0))
					errExit("chown");
				if (chmod(lnk, S_IRWXU|S_IRWXG|S_IRWXO))
					errExit("chmod");
			}
			if (arg_debug)
				printf("Mounting tmpfs on %s on behalf of /var/lock\n", lnk);
			if (mount("tmpfs", lnk, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
				errExit("mounting /var/lock");
			free(lnk);
		}
		else {
			fprintf(stderr, "Warning: /var/lock not mounted\n");
			dbg_test_dir("/var/lock");
		}
	}
}

void fs_var_tmp(void) {
	struct stat s;
	if (stat("/var/tmp", &s) == 0) {
		if (!is_link("/var/tmp")) {
			if (arg_debug)
				printf("Mounting tmpfs on /var/tmp\n");
			if (mount("tmpfs", "/var/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
				errExit("mounting /var/tmp");
		}
	}
	else {
		fprintf(stderr, "Warning: /var/tmp not mounted\n");
		dbg_test_dir("/var/tmp");
	}
}

void fs_var_utmp(void) {
	struct stat s;

	// extract utmp group id
	gid_t utmp_group = 0;
	if (stat("/var/run/utmp", &s) == 0)
		utmp_group = s.st_gid;
	else {
		fprintf(stderr, "Warning: cannot find /var/run/utmp\n");
		return;
	}

	// create /tmp/firejail/mnt directory
	fs_build_mnt_dir();
	
	// create a new utmp file
	if (arg_debug)
		printf("Create the new utmp file\n");
	char *utmp;
	if (asprintf(&utmp, "%s/utmp", MNT_DIR) == -1)
		errExit("asprintf");
	FILE *fp = fopen(utmp, "w");
	if (!fp)
		errExit("fopen");
		
	// read current utmp
	struct utmp *u;
	struct utmp u_boot;
	setutent();
	while ((u = getutent()) != NULL) {
		if (u->ut_type == BOOT_TIME) {
			memcpy(&u_boot, u, sizeof(u_boot));
			u_boot.ut_tv.tv_sec = (unsigned) time(NULL);
		}
	}
	endutent();
			
	// save new utmp file
	fwrite(&u_boot, sizeof(u_boot), 1, fp);
	fclose(fp);
	if (chown(utmp, 0, utmp_group) < 0)
		errExit("chown");
	if (chmod(utmp, S_IRUSR | S_IWRITE | S_IRGRP | S_IWGRP | S_IROTH ) < 0)
		errExit("chmod");
	
	// mount the new utmp file
	if (arg_debug)
		printf("Mount the new utmp file\n");
	if (mount(utmp, "/var/run/utmp", NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind utmp");
}


#if 0
Testing servers:

brctl addbr br0
ifconfig br0 10.10.20.1/24

apt-get install snmpd
insserv -r snmpd
sudo firejail --net=br0 --ip=10.10.20.10 "/etc/init.d/rsyslog start; /etc/init.d/ssh start; /etc/init.d/snmpd start; sleep inf"

apt-get install apache2
insserv -r apache2
sudo firejail --net=br0 --ip=10.10.20.10 "/etc/init.d/rsyslog start; /etc/init.d/ssh start; /etc/init.d/apache2 start; sleep inf"

apt-get install nginx
insserv -r nginx
sudo firejail --net=br0 --ip=10.10.20.10 "/etc/init.d/rsyslog start; /etc/init.d/ssh start; /etc/init.d/nginx start; sleep inf"

apt-get install lighttpd
insserv -r lighttpd
sudo firejail --net=br0 --ip=10.10.20.10 "/etc/init.d/rsyslog start; /etc/init.d/ssh start; /etc/init.d/lighttpd start; sleep inf"

apt-get install isc-dhcp-server
insserv -r isc-dhcp-server
sudo firejail --net=br0 --ip=10.10.20.10 "/etc/init.d/rsyslog start; /etc/init.d/ssh start; /etc/init.d/isc-dhcp-server start; sleep inf"
#endif

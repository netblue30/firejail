/*
 * Copyright (C) 2014-2016 Firejail Authors
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
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <fcntl.h>
#include <errno.h>

static void create_empty_dir(void) {
	struct stat s;
	
	if (stat(RUN_RO_DIR, &s)) {
		/* coverity[toctou] */
		int rv = mkdir(RUN_RO_DIR, S_IRUSR | S_IXUSR);
		if (rv == -1)
			errExit("mkdir");	
		if (chown(RUN_RO_DIR, 0, 0) < 0)
			errExit("chown");
	}
}

static void create_empty_file(void) {
	struct stat s;

	if (stat(RUN_RO_FILE, &s)) {
		/* coverity[toctou] */
		FILE *fp = fopen(RUN_RO_FILE, "w");
		if (!fp)
			errExit("fopen");
		fclose(fp);
		if (chown(RUN_RO_FILE, 0, 0) < 0)
			errExit("chown");
		if (chmod(RUN_RO_FILE, S_IRUSR) < 0)
			errExit("chown");
	}
}

// build /run/firejail directory
void fs_build_firejail_dir(void) {
	struct stat s;

	if (stat(RUN_FIREJAIL_DIR, &s)) {
		if (arg_debug)
			printf("Creating %s directory\n", RUN_FIREJAIL_DIR);
		/* coverity[toctou] */
		int rv = mkdir(RUN_FIREJAIL_DIR, 0755);
		if (rv == -1)
			errExit("mkdir");
		if (chown(RUN_FIREJAIL_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(RUN_FIREJAIL_DIR, 0755) < 0)
			errExit("chmod");
	}
	else { // check /tmp/firejail directory belongs to root end exit if doesn't!
		if (s.st_uid != 0 || s.st_gid != 0) {
			fprintf(stderr, "Error: non-root %s directory, exiting...\n", RUN_FIREJAIL_DIR);
			exit(1);
		}
	}
	
	create_empty_dir();
	create_empty_file();
}


// build /tmp/firejail/mnt directory
static int tmpfs_mounted = 0;
#ifdef HAVE_CHROOT		
static void fs_build_remount_mnt_dir(void) {
	tmpfs_mounted = 0;
	fs_build_mnt_dir();
}
#endif

void fs_build_mnt_dir(void) {
	struct stat s;
	fs_build_firejail_dir();
	
	// create /run/firejail/mnt directory
	if (stat(RUN_MNT_DIR, &s)) {
		if (arg_debug)
			printf("Creating %s directory\n", RUN_MNT_DIR);
		/* coverity[toctou] */
		int rv = mkdir(RUN_MNT_DIR, 0755);
		if (rv == -1)
			errExit("mkdir");
		if (chown(RUN_MNT_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(RUN_MNT_DIR, 0755) < 0)
			errExit("chmod");
	}

	// ... and mount tmpfs on top of it
	if (!tmpfs_mounted) {
		// mount tmpfs on top of /run/firejail/mnt
		if (arg_debug)
			printf("Mounting tmpfs on %s directory\n", RUN_MNT_DIR);
		if (mount("tmpfs", RUN_MNT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /tmp/firejail/mnt");
		tmpfs_mounted = 1;
	}
}

// grab a copy of cp command
void fs_build_cp_command(void) {
	struct stat s;
	fs_build_mnt_dir();
	if (stat(RUN_CP_COMMAND, &s)) {
		char* fname = realpath("/bin/cp", NULL);
		if (fname == NULL) {
			fprintf(stderr, "Error: /bin/cp not found\n");
			exit(1);
		}
		if (stat(fname, &s)) {
			fprintf(stderr, "Error: /bin/cp not found\n");
			exit(1);
		}
		if (is_link(fname)) {
			fprintf(stderr, "Error: invalid /bin/cp file\n");
			exit(1);
		}
		int rv = copy_file(fname, RUN_CP_COMMAND);
		if (rv) {
			fprintf(stderr, "Error: cannot access /bin/cp\n");
			exit(1);
		}
		/* coverity[toctou] */
		if (chown(RUN_CP_COMMAND, 0, 0))
			errExit("chown");
		if (chmod(RUN_CP_COMMAND, 0755))
			errExit("chmod");
			
		free(fname);
	}
}

// delete the temporary cp command
void fs_delete_cp_command(void) {
	unlink(RUN_CP_COMMAND);
}

//***********************************************
// process profile file
//***********************************************
typedef enum {
	BLACKLIST_FILE,
	BLACKLIST_NOLOG,
	MOUNT_READONLY,
	MOUNT_TMPFS,
	OPERATION_MAX
} OPERATION;

typedef enum {
	UNSUCCESSFUL,
	SUCCESSFUL
} LAST_DISABLE_OPERATION;
LAST_DISABLE_OPERATION last_disable = UNSUCCESSFUL;

static void disable_file(OPERATION op, const char *filename) {
	assert(filename);
	assert(op <OPERATION_MAX);
	last_disable = UNSUCCESSFUL;
	
	// rebuild /run/firejail directory in case tmpfs was mounted on top of /run
	fs_build_firejail_dir();
	
	// Resolve all symlinks
	char* fname = realpath(filename, NULL);
	if (fname == NULL && errno != EACCES) {
		if (arg_debug)
			printf("Warning: %s is an invalid file, skipping...\n", filename);
		return;
	}
	if (fname == NULL && errno == EACCES) {
		if (arg_debug)
			printf("Debug: no access to file %s, forcing mount\n", filename);
		// realpath and stat funtions will fail on FUSE filesystems
		// they don't seem to like a uid of 0
		// force mounting
		int rv = mount(RUN_RO_DIR, filename, "none", MS_BIND, "mode=400,gid=0");
		if (rv == 0)
			last_disable = SUCCESSFUL;
		else {
			rv = mount(RUN_RO_FILE, filename, "none", MS_BIND, "mode=400,gid=0");
			if (rv == 0)
				last_disable = SUCCESSFUL;
		}
		if (last_disable == SUCCESSFUL) {
			if (arg_debug)
				printf("Disable %s\n", filename);
			if (op == BLACKLIST_FILE)
				fs_logger2("blacklist", filename);
			else
				fs_logger2("blacklist-nolog", filename);
		}
		else {
			if (arg_debug)
				printf("Warning: %s is an invalid file, skipping...\n", filename);
		}
				
		return;
	}
	
	// if the file is not present, do nothing
	struct stat s;
	if (stat(fname, &s) == -1) {
		if (arg_debug)
			printf("Warning: %s does not exist, skipping...\n", fname);
		free(fname);
		return;
	}

	// modify the file
	if (op == BLACKLIST_FILE || op == BLACKLIST_NOLOG) {
		// some distros put all executables under /usr/bin and make /bin a symbolic link
		if ((strcmp(fname, "/bin") == 0 || strcmp(fname, "/usr/bin") == 0) &&
		      is_link(filename) &&
		      S_ISDIR(s.st_mode))
			fprintf(stderr, "Warning: %s directory link was not blacklisted\n", filename);
			
		else {
			if (arg_debug)
				printf("Disable %s\n", fname);
			else if (arg_debug_blacklists) {
				printf("Disable %s", fname);
				if (op == BLACKLIST_FILE)
					printf("\n");
				else
					printf(" - no logging\n");
			}
			if (S_ISDIR(s.st_mode)) {
				if (mount(RUN_RO_DIR, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
					errExit("disable file");
			}
			else {
				if (mount(RUN_RO_FILE, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
					errExit("disable file");
			}
			last_disable = SUCCESSFUL;
			if (op == BLACKLIST_FILE)
				fs_logger2("blacklist", fname);
			else
				fs_logger2("blacklist-nolog", fname);
		}
	}
	else if (op == MOUNT_READONLY) {
		if (arg_debug)
			printf("Mounting read-only %s\n", fname);
		fs_rdonly(fname);
// todo: last_disable = SUCCESSFUL;
	}
	else if (op == MOUNT_TMPFS) {
		if (S_ISDIR(s.st_mode)) {
			if (arg_debug)
				printf("Mounting tmpfs on %s\n", fname);
			// preserve owner and mode for the directory
			if (mount("tmpfs", fname, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  0) < 0)
				errExit("mounting tmpfs");
			/* coverity[toctou] */
			if (chown(fname, s.st_uid, s.st_gid) == -1)
				errExit("mounting tmpfs chmod");
			last_disable = SUCCESSFUL;
			fs_logger2("mount tmpfs on", fname);
		}
		else
			printf("Warning: %s is not a directory; cannot mount a tmpfs on top of it.\n", fname);
	}
	else
		assert(0);

	free(fname);
}

// Treat pattern as a shell glob pattern and blacklist matching files
static void globbing(OPERATION op, const char *pattern, const char *noblacklist[], size_t noblacklist_len) {
	assert(pattern);

	glob_t globbuf;
	// Profiles contain blacklists for files that might not exist on a user's machine.
	// GLOB_NOCHECK makes that okay.
	int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT, NULL, &globbuf);
	if (globerr) {
		fprintf(stderr, "Error: failed to glob pattern %s\n", pattern);
		exit(1);
	}

	size_t i, j;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		char *path = globbuf.gl_pathv[i];
		assert(path);
		// /home/me/.* can glob to /home/me/.. which would blacklist /home/
		const char *base = gnu_basename(path);
		if (strcmp(base, ".") == 0 || strcmp(base, "..") == 0)
			continue;
		// noblacklist is expected to be short in normal cases, so stupid and correct brute force is okay
		bool okay_to_blacklist = true;
		for (j = 0; j < noblacklist_len; j++) {
			int result = fnmatch(noblacklist[j], path, FNM_PATHNAME);
			if (result == FNM_NOMATCH)
				continue;
			else if (result == 0) {
				okay_to_blacklist = false;
				break;
			}
			else {
				fprintf(stderr, "Error: failed to compare path %s with pattern %s\n", path, noblacklist[j]);
				exit(1);
			}
		}
		if (okay_to_blacklist)
			disable_file(op, path);
		else if (arg_debug)
			printf("Not blacklist %s\n", path);
	}
	globfree(&globbuf);
}


// blacklist files or directoies by mounting empty files on top of them
void fs_blacklist(void) {
	char *homedir = cfg.homedir;
	assert(homedir);
	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;
		
	size_t noblacklist_c = 0;
	size_t noblacklist_m = 32;
	char **noblacklist = calloc(noblacklist_m, sizeof(*noblacklist));

	if (noblacklist == NULL)
		errExit("failed allocating memory for noblacklist entries");

	while (entry) {
		OPERATION op = OPERATION_MAX;
		char *ptr;

		// whitelist commands handled by fs_whitelist()
		if (strncmp(entry->data, "whitelist ", 10) == 0 || *entry->data == '\0') {
			entry = entry->next;
			continue;
		}

		// process bind command
		if (strncmp(entry->data, "bind ", 5) == 0)  {
			char *dname1 = entry->data + 5;
			char *dname2 = split_comma(dname1);
			if (dname2 == NULL) {
				fprintf(stderr, "Error: second directory missing in bind command\n");
				entry = entry->next;
				continue;
			}
			struct stat s;
			if (stat(dname1, &s) == -1) {
				fprintf(stderr, "Error: cannot find directories for bind command\n");
				entry = entry->next;
				continue;
			}
			if (stat(dname2, &s) == -1) {
				fprintf(stderr, "Error: cannot find directories for bind command\n");
				entry = entry->next;
				continue;
			}
			
			// mount --bind olddir newdir
			if (arg_debug)
				printf("Mount-bind %s on top of %s\n", dname1, dname2);
			// preserve dname2 mode and ownership
			if (mount(dname1, dname2, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");
			/* coverity[toctou] */
			if (chown(dname2, s.st_uid, s.st_gid) == -1)
				errExit("mount-bind chown");
			/* coverity[toctou] */
			if (chmod(dname2, s.st_mode) == -1)
				errExit("mount-bind chmod");
				
			entry = entry->next;
			continue;
		}

		// Process noblacklist command
		if (strncmp(entry->data, "noblacklist ", 12) == 0) {
			if (noblacklist_c >= noblacklist_m) {
                                noblacklist_m *= 2;
                                noblacklist = realloc(noblacklist, sizeof(*noblacklist) * noblacklist_m);
                                if (noblacklist == NULL)
                                        errExit("failed increasing memory for noblacklist entries");
			}
			else
				noblacklist[noblacklist_c++] = expand_home(entry->data + 12, homedir);
			entry = entry->next;
			continue;
		}

		// process blacklist command
		if (strncmp(entry->data, "blacklist ", 10) == 0)  {
			ptr = entry->data + 10;
			op = BLACKLIST_FILE;
		}
		else if (strncmp(entry->data, "blacklist-nolog ", 16) == 0)  {
			ptr = entry->data + 16;
			op = BLACKLIST_NOLOG;
		}
		else if (strncmp(entry->data, "read-only ", 10) == 0) {
			ptr = entry->data + 10;
			op = MOUNT_READONLY;
		}			
		else if (strncmp(entry->data, "tmpfs ", 6) == 0) {
			ptr = entry->data + 6;
			op = MOUNT_TMPFS;
		}			
		else {
			fprintf(stderr, "Error: invalid profile line %s\n", entry->data);
			entry = entry->next;
			continue;
		}

		// replace home macro in blacklist array
		char *new_name = expand_home(ptr, homedir);
		ptr = new_name;

		// expand path macro - look for the file in /bin, /usr/bin, /sbin and  /usr/sbin directories
		if (ptr) {
			if (strncmp(ptr, "${PATH}", 7) == 0) {
				char *fname = ptr + 7;
				size_t fname_len = strlen(fname);
				char **path, *paths[] = {"/bin", "/sbin", "/usr/bin", "/usr/sbin", NULL};
				for (path = &paths[0]; *path; path++) {
					char newname[strlen(*path) + fname_len + 1];
					sprintf(newname, "%s%s", *path, fname);
					globbing(op, newname, (const char**)noblacklist, noblacklist_c);
					if  (last_disable == SUCCESSFUL)
						break;
				}
			}
			else
				globbing(op, ptr, (const char**)noblacklist, noblacklist_c);
		}

		if (new_name)
			free(new_name);
		entry = entry->next;
	}

	size_t i;
	for (i = 0; i < noblacklist_c; i++) free(noblacklist[i]);
        free(noblacklist);
}

//***********************************************
// mount namespace
//***********************************************

// remount a directory read-only
void fs_rdonly(const char *dir) {
	assert(dir);
	// check directory exists
	struct stat s;
	int rv = stat(dir, &s);
	if (rv == 0) {
		// mount --bind /bin /bin
		if (mount(dir, dir, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mount read-only");
		// mount --bind -o remount,ro /bin
		if (mount(NULL, dir, NULL, MS_BIND|MS_REMOUNT|MS_RDONLY|MS_REC, NULL) < 0)
			errExit("mount read-only");
		fs_logger2("read-only", dir);
	}
}
void fs_rdonly_noexit(const char *dir) {
	assert(dir);
	// check directory exists
	struct stat s;
	int rv = stat(dir, &s);
	if (rv == 0) {
		int merr = 0;
		// mount --bind /bin /bin
		if (mount(dir, dir, NULL, MS_BIND|MS_REC, NULL) < 0)
			merr = 1;
		// mount --bind -o remount,ro /bin
		if (mount(NULL, dir, NULL, MS_BIND|MS_REMOUNT|MS_RDONLY|MS_REC, NULL) < 0)
			merr = 1;
		if (merr)
			fprintf(stderr, "Warning: cannot mount %s read-only\n", dir); 
		else
			fs_logger2("read-only", dir);
	}
}

// mount /proc and /sys directories
void fs_proc_sys_dev_boot(void) {
	struct stat s;

	if (arg_debug)
		printf("Remounting /proc and /proc/sys filesystems\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");
	fs_logger("remount /proc");

	// remount /proc/sys readonly
	if (mount("/proc/sys", "/proc/sys", NULL, MS_BIND | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");

	if (mount(NULL, "/proc/sys", NULL, MS_BIND | MS_REMOUNT | MS_RDONLY | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");
	fs_logger("read-only /proc/sys");


	/* Mount a version of /sys that describes the network namespace */
	if (arg_debug)
		printf("Remounting /sys directory\n");
	if (umount2("/sys", MNT_DETACH) < 0) 
		fprintf(stderr, "Warning: failed to unmount /sys\n");
	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
		fprintf(stderr, "Warning: failed to mount /sys\n");
	else
		fs_logger("remount /sys");
		
	if (stat("/sys/firmware", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/sys/firmware");
	}
		
	if (stat("/sys/hypervisor", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/sys/hypervisor");
	}

	if (stat("/sys/fs", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/sys/fs");
	}

	if (stat("/sys/module", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/sys/module");
	}

	if (stat("/sys/power", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/sys/power");
	}

//	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
//		errExit("mounting /sys");

	// Disable SysRq
	// a linux box can be shut down easily using the following commands (as root):
	// # echo 1 > /proc/sys/kernel/sysrq
	// #echo b > /proc/sysrq-trigger
	// for more information see https://www.kernel.org/doc/Documentation/sysrq.txt
	if (arg_debug)
		printf("Disable /proc/sysrq-trigger\n");
	fs_rdonly_noexit("/proc/sysrq-trigger");
	
	// disable hotplug and uevent_helper
	if (arg_debug)
		printf("Disable /proc/sys/kernel/hotplug\n");
	fs_rdonly_noexit("/proc/sys/kernel/hotplug");
	if (arg_debug)
		printf("Disable /sys/kernel/uevent_helper\n");
	fs_rdonly_noexit("/sys/kernel/uevent_helper");
	
	// read-only /proc/irq and /proc/bus
	if (arg_debug)
		printf("Disable /proc/irq\n");
	fs_rdonly_noexit("/proc/irq");
	if (arg_debug)
		printf("Disable /proc/bus\n");
	fs_rdonly_noexit("/proc/bus");
	
	// disable /proc/kcore
	disable_file(BLACKLIST_FILE, "/proc/kcore");

	// disable /proc/kallsyms
	disable_file(BLACKLIST_FILE, "/proc/kallsyms");
	
	// disable /boot
	if (stat("/boot", &s) == 0) {
		if (arg_debug)
			printf("Disable /boot directory\n");
		disable_file(BLACKLIST_FILE, "/boot");
	}
	
	// disable /selinux
	if (stat("/selinux", &s) == 0) {
		if (arg_debug)
			printf("Disable /selinux directory\n");
		disable_file(BLACKLIST_FILE, "/selinux");
	}
	
	// disable /dev/port
	if (stat("/dev/port", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/dev/port");
	}
	
	if (getuid() != 0) {
		// disable /dev/kmsg
		if (stat("/dev/kmsg", &s) == 0) {
			disable_file(BLACKLIST_FILE, "/dev/kmsg");
		}
		
		// disable /proc/kmsg
		if (stat("/proc/kmsg", &s) == 0) {
			disable_file(BLACKLIST_FILE, "/proc/kmsg");
		}
	}
}

// disable firejail configuration in /etc/firejail and in ~/.config/firejail
static void disable_firejail_config(void) {
	struct stat s;
	if (stat("/etc/firejail", &s) == 0)
		disable_file(BLACKLIST_FILE, "/etc/firejail");

	char *fname;
	if (asprintf(&fname, "%s/.config/firejail", cfg.homedir) == -1)
		errExit("asprintf");
	if (stat(fname, &s) == 0)
		disable_file(BLACKLIST_FILE, fname);
	
	if (stat("/usr/local/etc/firejail", &s) == 0)
		disable_file(BLACKLIST_FILE, "/usr/local/etc/firejail");

	if (strcmp(PREFIX, "/usr/local")) {
		if (asprintf(&fname, "%s/etc/firejail", PREFIX) == -1)
			errExit("asprintf");
		if (stat(fname, &s) == 0)
			disable_file(BLACKLIST_FILE, fname);
	}

	
	
	free(fname);
}


// build a basic read-only filesystem
void fs_basic_fs(void) {
	if (arg_debug)
		printf("Mounting read-only /bin, /sbin, /lib, /lib32, /lib64, /usr, /etc, /var\n");
	fs_rdonly("/bin");
	fs_rdonly("/sbin");
	fs_rdonly("/lib");
	fs_rdonly("/lib64");
	fs_rdonly("/lib32");
	fs_rdonly("/usr");
	fs_rdonly("/etc");
	fs_rdonly("/var");

	// update /var directory in order to support multiple sandboxes running on the same root directory
	if (!arg_private_dev)
		fs_dev_shm();
	fs_var_lock();
	fs_var_tmp();
	fs_var_log();
	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();

	// don't leak user information
	restrict_users();
	
	disable_firejail_config();
}


// mount overlayfs on top of / directory
// mounting an overlay and chrooting into it:
//
// Old Ubuntu kernel
// # cd ~
// # mkdir -p overlay/root
// # mkdir -p overlay/diff
// # mount -t overlayfs -o lowerdir=/,upperdir=/root/overlay/diff overlayfs /root/overlay/root
// # chroot /root/overlay/root
// to shutdown, first exit the chroot and then  unmount the overlay
// # exit
// # umount /root/overlay/root
//
// Kernels 3.18+
// # cd ~
// # mkdir -p overlay/root
// # mkdir -p overlay/diff
// # mkdir -p overlay/work
// # mount -t overlay -o lowerdir=/,upperdir=/root/overlay/diff,workdir=/root/overlay/work overlay /root/overlay/root
// # cat /etc/mtab | grep overlay
// /root/overlay /root/overlay/root overlay rw,relatime,lowerdir=/,upperdir=/root/overlay/diff,workdir=/root/overlay/work 0 0
// # chroot /root/overlay/root
// to shutdown, first exit the chroot and then  unmount the overlay
// # exit
// # umount /root/overlay/root


// to do: fix the code below; also, it might work without /dev; impose seccomp/caps filters when not root
#include <sys/utsname.h>
void fs_overlayfs(void) {
	// check kernel version
	struct utsname u;
	int rv = uname(&u);
	if (rv != 0)
		errExit("uname");
	int major;
	int minor;
	if (2 != sscanf(u.release, "%d.%d", &major, &minor)) {
		fprintf(stderr, "Error: cannot extract Linux kernel version: %s\n", u.version);
		exit(1);
	}
	
	if (arg_debug)
		printf("Linux kernel version %d.%d\n", major, minor);
	int oldkernel = 0;
	if (major < 3) {
		fprintf(stderr, "Error: minimum kernel version required 3.x\n");
		exit(1);
	}
	if (major == 3 && minor < 18)
		oldkernel = 1;
	
	// build overlay directories
	fs_build_mnt_dir();

	char *oroot;
	if(asprintf(&oroot, "%s/oroot", RUN_MNT_DIR) == -1)
		errExit("asprintf");
	if (mkdir(oroot, 0755))
		errExit("mkdir");
	if (chown(oroot, 0, 0) < 0)
		errExit("chown");
	if (chmod(oroot, 0755) < 0)
		errExit("chmod");

	char *basedir = RUN_MNT_DIR;
	if (arg_overlay_keep) {
		// set base for working and diff directories
		basedir = cfg.overlay_dir;
		if (mkdir(basedir, 0755) != 0) {
			fprintf(stderr, "Error: cannot create overlay directory\n");
			exit(1);
		}
	}

	char *odiff;
	if(asprintf(&odiff, "%s/odiff", basedir) == -1)
		errExit("asprintf");
	if (mkdir(odiff, 0755))
		errExit("mkdir");
	if (chown(odiff, 0, 0) < 0)
		errExit("chown");
	if (chmod(odiff, 0755) < 0)
		errExit("chmod");
	
	char *owork;
	if(asprintf(&owork, "%s/owork", basedir) == -1)
		errExit("asprintf");
	if (mkdir(owork, 0755))
		errExit("mkdir");
	if (chown(owork, 0, 0) < 0)
		errExit("chown");
	if (chmod(owork, 0755) < 0)
		errExit("chmod");
	
	// mount overlayfs
	if (arg_debug)
		printf("Mounting OverlayFS\n");
	char *option;
	if (oldkernel) { // old Ubuntu/OpenSUSE kernels
		if (arg_overlay_keep) {
			fprintf(stderr, "Error: option --overlay= not available for kernels older than 3.18\n");
			exit(1);
		}
		if (asprintf(&option, "lowerdir=/,upperdir=%s", odiff) == -1)
			errExit("asprintf");
		if (mount("overlayfs", oroot, "overlayfs", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");
	}
	else { // kernel 3.18 or newer
		if (asprintf(&option, "lowerdir=/,upperdir=%s,workdir=%s", odiff, owork) == -1)
			errExit("asprintf");
//printf("option #%s#\n", option);			
		if (mount("overlay", oroot, "overlay", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");
	}
	printf("OverlayFS configured in %s directory\n", basedir);
	
	// mount-bind dev directory
	if (arg_debug)
		printf("Mounting /dev\n");
	char *dev;
	if (asprintf(&dev, "%s/dev", oroot) == -1)
		errExit("asprintf");
	if (mount("/dev", dev, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");

	// chroot in the new filesystem
	if (chroot(oroot) == -1)
		errExit("chroot");
	// update /var directory in order to support multiple sandboxes running on the same root directory
	if (!arg_private_dev)
		fs_dev_shm();
	fs_var_lock();
	fs_var_tmp();
	fs_var_log();
	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();

	// don't leak user information
	restrict_users();

	disable_firejail_config();

	// cleanup and exit
	free(option);
	free(oroot);
	free(odiff);
}



#ifdef HAVE_CHROOT		
// return 1 if error
int fs_check_chroot_dir(const char *rootdir) {
	assert(rootdir);
	struct stat s;
	char *name;

	// check /dev
	if (asprintf(&name, "%s/dev", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == -1) {
		fprintf(stderr, "Error: cannot find /dev in chroot directory\n");
		return 1;
	}
	free(name);

	// check /var/tmp
	if (asprintf(&name, "%s/var/tmp", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == -1) {
		fprintf(stderr, "Error: cannot find /var/tmp in chroot directory\n");
		return 1;
	}
	free(name);
	
	// check /proc
	if (asprintf(&name, "%s/proc", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == -1) {
		fprintf(stderr, "Error: cannot find /proc in chroot directory\n");
		return 1;
	}
	free(name);
	
	// check /proc
	if (asprintf(&name, "%s/tmp", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == -1) {
		fprintf(stderr, "Error: cannot find /tmp in chroot directory\n");
		return 1;
	}
	free(name);
	
	// check /bin/bash
	if (asprintf(&name, "%s/bin/bash", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == -1) {
		fprintf(stderr, "Error: cannot find /bin/bash in chroot directory\n");
		return 1;
	}
	free(name);

	return 0;	
}

// chroot into an existing directory; mount exiting /dev and update /etc/resolv.conf
void fs_chroot(const char *rootdir) {
	assert(rootdir);
	
	//***********************************
	// mount-bind a /dev in rootdir
	//***********************************
	// mount /dev
	char *newdev;
	if (asprintf(&newdev, "%s/dev", rootdir) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("Mounting /dev on %s\n", newdev);
	if (mount("/dev", newdev, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	
	// some older distros don't have a /run directory
	// create one by default
	// no exit on error, let the user deal with any problems
	char *rundir;
	if (asprintf(&rundir, "%s/run", rootdir) == -1)
		errExit("asprintf");
	if (!is_dir(rundir)) {
		int rv = mkdir(rundir, 0755);
		(void) rv;
		rv = chown(rundir, 0, 0);
		(void) rv;
	}
	
	// copy /etc/resolv.conf in chroot directory
	// if resolv.conf in chroot is a symbolic link, this will fail
	// no exit on error, let the user deal with the problem
	char *fname;
	if (asprintf(&fname, "%s/etc/resolv.conf", rootdir) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("Updating /etc/resolv.conf in %s\n", fname);
	if (is_link(fname)) {
		fprintf(stderr, "Error: invalid %s file\n", fname);
		exit(1);
	}
	if (copy_file("/etc/resolv.conf", fname) == -1)
		fprintf(stderr, "Warning: /etc/resolv.conf not initialized\n");
		
	// chroot into the new directory
	if (arg_debug)
		printf("Chrooting into %s\n", rootdir);
	if (chroot(rootdir) < 0)
		errExit("chroot");
	// mount a new tmpfs in /run/firejail/mnt - the old one was lost in chroot
	fs_build_remount_mnt_dir();
		
	// update /var directory in order to support multiple sandboxes running on the same root directory
	if (!arg_private_dev)
		fs_dev_shm();
	fs_var_lock();
	fs_var_tmp();
	fs_var_log();
	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();

	// don't leak user information
	restrict_users();

	disable_firejail_config();
}
#endif

void fs_private_tmp(void) {
	// mount tmpfs on top of /run/firejail/mnt
	if (arg_debug)
		printf("Mounting tmpfs on /tmp directory\n");
	if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=1777,gid=0") < 0)
		errExit("mounting /tmp/firejail/mnt");
}


/*
 * Copyright (C) 2014, 2015 netblue30 (netblue30@yahoo.com)
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
#include <errno.h>

// build /tmp/firejail directory
void fs_build_firejail_dir(void) {
	struct stat s;

	if (stat(FIREJAIL_DIR, &s)) {
		if (arg_debug)
			printf("Creating %s directory\n", FIREJAIL_DIR);
		/* coverity[toctou] */
		int rv = mkdir(FIREJAIL_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(FIREJAIL_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(FIREJAIL_DIR, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
			errExit("chmod");
	}
	else { // check /tmp/firejail directory belongs to root end exit if doesn't!
		if (s.st_uid != 0 || s.st_gid != 0) {
			fprintf(stderr, "Error: non-root %s directory, exiting...\n", FIREJAIL_DIR);
			exit(1);
		}
	}
}


// build /tmp/firejail/mnt directory
static int tmpfs_mounted = 0;
void fs_build_mnt_dir(void) {
	struct stat s;
	fs_build_firejail_dir();
	
	// create /tmp/firejail directory
	if (stat(MNT_DIR, &s)) {
		if (arg_debug)
			printf("Creating %s directory\n", MNT_DIR);
		/* coverity[toctou] */
		int rv = mkdir(MNT_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");
		if (chown(MNT_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(MNT_DIR, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
			errExit("chmod");
	}

	// ... and mount tmpfs on top of it
	if (!tmpfs_mounted) {
		// mount tmpfs on top of /tmp/firejail/mnt
		if (arg_debug)
			printf("Mounting tmpfs on %s directory\n", MNT_DIR);
		if (mount("tmpfs", MNT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=755,gid=0") < 0)
			errExit("mounting /tmp/firejail/mnt");
		tmpfs_mounted = 1;
	}
}

// build /tmp/firejail/overlay directory
void fs_build_overlay_dir(void) {
	struct stat s;
	fs_build_firejail_dir();
	
	// create /tmp/firejail directory
	if (stat(OVERLAY_DIR, &s)) {
		if (arg_debug)
			printf("Creating %s directory\n", MNT_DIR);
		/* coverity[toctou] */
		int rv = mkdir(OVERLAY_DIR, S_IRWXU | S_IRWXG | S_IRWXO);
		if (rv == -1)
			errExit("mkdir");	
		if (chown(OVERLAY_DIR, 0, 0) < 0)
			errExit("chown");
		if (chmod(OVERLAY_DIR, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
			errExit("chmod");
	}
}





//***********************************************
// process profile file
//***********************************************
typedef enum {
	BLACKLIST_FILE,
	MOUNT_READONLY,
	MOUNT_TMPFS,
	OPERATION_MAX
} OPERATION;


static char *create_empty_dir(void) {
	struct stat s;
	fs_build_firejail_dir();
	
	if (stat(RO_DIR, &s)) {
		/* coverity[toctou] */
		int rv = mkdir(RO_DIR, S_IRUSR | S_IXUSR);
		if (rv == -1)
			errExit("mkdir");	
		if (chown(RO_DIR, 0, 0) < 0)
			errExit("chown");
	}
	
	return RO_DIR;
}

static char *create_empty_file(void) {
	struct stat s;
	fs_build_firejail_dir();

	if (stat(RO_FILE, &s)) {
		/* coverity[toctou] */
		FILE *fp = fopen(RO_FILE, "w");
		if (!fp)
			errExit("fopen");
		fclose(fp);
		if (chown(RO_FILE, 0, 0) < 0)
			errExit("chown");
		if (chmod(RO_FILE, S_IRUSR) < 0)
			errExit("chown");
	}
	
	return RO_FILE;
}

static void disable_file(OPERATION op, const char *fname, const char *emptydir, const char *emptyfile) {
	assert(fname);
	assert(emptydir);
	assert(emptyfile);
	assert(op <OPERATION_MAX);

	// if the file is a link, follow the link
	char *lnk = NULL;
	if (is_link(fname)) {
		lnk = get_link(fname);
		if (lnk)
			fname = lnk;
		else
			fprintf(stderr, "Warning: cannot follow link %s, skipping...\n", fname);
	}
	
	// if the file is not present, do nothing
	struct stat s;
	if (stat(fname, &s) == -1) {
		if (lnk)
			free(lnk);
		return;
	}

	// modify the file
	if (op == BLACKLIST_FILE) {
		if (arg_debug)
			printf("Disable %s\n", fname);
		if (S_ISDIR(s.st_mode)) {
			if (mount(emptydir, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
				errExit("disable file");
		}
		else {
			if (mount(emptyfile, fname, "none", MS_BIND, "mode=400,gid=0") < 0)
				errExit("disable file");
		}
	}
	else if (op == MOUNT_READONLY) {
		if (arg_debug)
			printf("Mounting read-only %s\n", fname);
		fs_rdonly(fname);
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
		}
		else
			printf("Warning: %s is not a directory; cannot mount a tmpfs on top of it.\n", fname);
	}
	else
		assert(0);

	if (lnk)
		free(lnk);
}

static void globbing(OPERATION op, const char *fname, const char *emptydir, const char *emptyfile) {
	assert(fname);
	assert(emptydir);
	assert(emptyfile);

	// filename globbing: expand * macro and continue processing for every single file
	if (strchr(fname, '*')) {
		glob_t globbuf;
		globbuf.gl_offs = 0;
		glob(fname, GLOB_DOOFFS, NULL, &globbuf);
		int i;
		for (i = 0; i < globbuf.gl_pathc; i++) {
			assert(globbuf.gl_pathv[i]);
			disable_file(op, globbuf.gl_pathv[i], emptydir, emptyfile);
		}
	}
	else
		disable_file(op, fname, emptydir, emptyfile);
}

static void expand_path(OPERATION op, const char *path, const char *fname, const char *emptydir, const char *emptyfile) {
	assert(path);
	assert(fname);
	assert(emptydir);
	assert(emptyfile);
	char newname[strlen(path) + strlen(fname) + 1];
	sprintf(newname, "%s%s", path, fname);

	globbing(op, newname, emptydir, emptyfile);
}

// blacklist files or directoies by mounting empty files on top of them
void fs_blacklist(const char *homedir) {
	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;
		
	char *emptydir = create_empty_dir();
	char *emptyfile = create_empty_file();

	while (entry) {
		OPERATION op = OPERATION_MAX;
		char *ptr;

		// process blacklist command
		if (strncmp(entry->data, "bind", 4) == 0)  {
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

		// process blacklist command
		if (strncmp(entry->data, "blacklist", 9) == 0)  {
			ptr = entry->data + 10;
			op = BLACKLIST_FILE;
		}
		else if (strncmp(entry->data, "read-only", 9) == 0) {
			ptr = entry->data + 10;
			op = MOUNT_READONLY;
		}			
		else if (strncmp(entry->data, "tmpfs", 5) == 0) {
			ptr = entry->data + 6;
			op = MOUNT_TMPFS;
		}			
		else {
			fprintf(stderr, "Error: invalid profile line %s\n", entry->data);
			entry = entry->next;
			continue;
		}

		// replace home macro in blacklist array
		char *new_name = NULL;
		if (strncmp(ptr, "${HOME}", 7) == 0) {
			if (asprintf(&new_name, "%s%s", homedir, ptr + 7) == -1)
				errExit("asprintf");
			ptr = new_name;
		}

		// expand path macro - look for the file in /bin, /usr/bin, /sbin and  /usr/sbin directories
		if (strncmp(ptr, "${PATH}", 7) == 0) {
			expand_path(op, "/bin", ptr + 7, emptydir, emptyfile);
			expand_path(op, "/sbin", ptr + 7, emptydir, emptyfile);
			expand_path(op, "/usr/bin", ptr + 7, emptydir, emptyfile);
			expand_path(op, "/usr/sbin", ptr + 7, emptydir, emptyfile);
		}
		else
			globbing(op, ptr, emptydir, emptyfile);

		if (new_name)
			free(new_name);
		entry = entry->next;
	}
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
	}
}

// mount /proc and /sys directories
void fs_proc_sys_dev_boot(void) {
	struct stat s;

	if (arg_debug)
		printf("Remounting /proc and /proc/sys filesystems\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");

	// remount /proc/sys readonly
	if (mount("/proc/sys", "/proc/sys", NULL, MS_BIND | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");

	if (mount(NULL, "/proc/sys", NULL, MS_BIND | MS_REMOUNT | MS_RDONLY | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");


	/* Mount a version of /sys that describes the network namespace */
	if (arg_debug)
		printf("Remounting /sys directory\n");
	if (umount2("/sys", MNT_DETACH) < 0) 
		fprintf(stderr, "Warning: failed to unmount /sys\n");
	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
		fprintf(stderr, "Warning: failed to mount /sys\n");

//	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
//		errExit("mounting /sys");


	// mounting firejail kernel module files
	if (stat("/proc/firejail-uptime", &s) == 0) {
		errno = 0;
		FILE *fp = fopen("/proc/firejail", "w");
		int cnt = 0;
		while (errno == EBUSY && cnt < 10) {
			if (!fp) {
				int s = random();
				s /= 200000;
				usleep(s);
				fp = fopen("/proc/firejail", "w");
			}
			else
				break;
		}
		if (!fp) {
			fprintf(stderr, "Error: cannot register sandbox with firejail-lkm\n");
			exit(1);
		}	
		if (fp) {
			// registration
			fprintf(fp, "register\n");
			fflush(0);
			// filtering x11 connect calls
			if (arg_nox11) {
				fprintf(fp, "no connect unix /tmp/.X11\n");
				fflush(0);
				printf("X11 access disabled\n");
			}
			if (arg_nodbus) {
				fprintf(fp, "no connect unix /var/run/dbus/system_bus_socket\n");
				fflush(0);
				fprintf(fp, "no connect unix /tmp/dbus\n");
				fflush(0);
				printf("D-Bus access disabled\n");
			}
			fclose(fp);
			if (mount("/proc/firejail-uptime", "/proc/uptime", NULL, MS_BIND|MS_REC, NULL) < 0)
				fprintf(stderr, "Warning: cannot mount /proc/firejail-uptime\n");
		}
	}

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
	disable_file(BLACKLIST_FILE, "/proc/kcore", "not used", "/dev/null");

	// disable /proc/kallsyms
	disable_file(BLACKLIST_FILE, "/proc/kallsyms", "not used", "/dev/null");
	
	// disable /boot
	if (stat("/boot", &s) == 0) {
		if (arg_debug)
			printf("Mounting a new /boot directory\n");
		if (mount("tmpfs", "/boot", "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC,  "mode=777,gid=0") < 0)
			errExit("mounting /boot directory");
	}
	
	// disable /dev/port
	if (stat("/dev/port", &s) == 0) {
		disable_file(BLACKLIST_FILE, "/dev/port", "not used", "/dev/null");
	}
}

static void sanitize_home(void) {
	// extract current /home directory data
	struct dirent *dir;
	DIR *d = opendir("/home");
	if (d == NULL)
		return;

	char *emptydir = create_empty_dir();
	while ((dir = readdir(d))) {
		if(strcmp(dir->d_name, "." ) == 0 || strcmp(dir->d_name, ".." ) == 0)
			continue;

		if (dir->d_type == DT_DIR ) {
			// get properties
			struct stat s;
			char *name;
			if (asprintf(&name, "/home/%s", dir->d_name) == -1)
				continue;
			if (stat(name, &s) == -1)
				continue;
			if (S_ISLNK(s.st_mode)) {
				free(name);
				continue;
			}
			
			if (strcmp(name, cfg.homedir) == 0)
				continue;

//			printf("directory %u %u:%u #%s#\n",
//				s.st_mode,
//				s.st_uid,
//				s.st_gid,
//				name);
			
			// disable directory
			disable_file(BLACKLIST_FILE, name, emptydir, "not used");
			free(name);
		}			
	}
	closedir(d);
}






// build a basic read-only filesystem
void fs_basic_fs(void) {
	if (arg_debug)
		printf("Mounting read-only /bin, /sbin, /lib, /lib64, /usr, /etc, /var\n");
	fs_rdonly("/bin");
	fs_rdonly("/sbin");
	fs_rdonly("/lib");
	fs_rdonly("/lib64");
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

	// only in user mode
	if (getuid())
		sanitize_home();
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
	if(asprintf(&oroot, "%s/oroot", MNT_DIR) == -1)
		errExit("asprintf");
	if (mkdir(oroot, S_IRWXU | S_IRWXG | S_IRWXO))
		errExit("mkdir");
	if (chown(oroot, 0, 0) < 0)
		errExit("chown");
	if (chmod(oroot, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
		errExit("chmod");

	char *odiff;
	if(asprintf(&odiff, "%s/odiff", MNT_DIR) == -1)
		errExit("asprintf");
	if (mkdir(odiff, S_IRWXU | S_IRWXG | S_IRWXO))
		errExit("mkdir");
	if (chown(odiff, 0, 0) < 0)
		errExit("chown");
	if (chmod(odiff, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
		errExit("chmod");

	char *owork;
	if(asprintf(&owork, "%s/owork", MNT_DIR) == -1)
		errExit("asprintf");
	if (mkdir(owork, S_IRWXU | S_IRWXG | S_IRWXO))
		errExit("mkdir");
	if (chown(owork, 0, 0) < 0)
		errExit("chown");
	if (chmod(owork, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
		errExit("chmod");

	// mount overlayfs
	if (arg_debug)
		printf("Mounting OverlayFS\n");
	char *option;
	if (oldkernel) { // old Ubuntu/OpenSUSE kernels
		if (asprintf(&option, "lowerdir=/,upperdir=%s", odiff) == -1)
			errExit("asprintf");
		if (mount("overlayfs", oroot, "overlayfs", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");
	}
	else { // kernel 3.18 or newer
		if (asprintf(&option, "lowerdir=/,upperdir=%s,workdir=%s", odiff, owork) == -1)
			errExit("asprintf");
		if (mount("overlay", oroot, "overlay", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");
	}

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

	// only in user mode
	if (getuid())
		sanitize_home();

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
		int rv = mkdir(rundir, S_IRWXU | S_IRWXG | S_IRWXO);
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
	if (copy_file("/etc/resolv.conf", fname) == -1)
		fprintf(stderr, "Warning: /etc/resolv.conf not initialized\n");
		
	// chroot into the new directory
	if (arg_debug)
		printf("Chrooting into %s\n", rootdir);
	if (chroot(rootdir) < 0)
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

	// only in user mode
	if (getuid())
		sanitize_home();
	
}
#endif



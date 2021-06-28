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
#include "../include/gcov_wrapper.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/wait.h>
#include <linux/limits.h>
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#define MAX_BUF 4096
#define EMPTY_STRING ("")
// check noblacklist statements not matched by a proper blacklist in disable-*.inc files
//#define TEST_NO_BLACKLIST_MATCHING


//***********************************************
// process profile file
//***********************************************
static void fs_remount_rec(const char *dir, OPERATION op);

static char *opstr[] = {
	[BLACKLIST_FILE] = "blacklist",
	[BLACKLIST_NOLOG] = "blacklist-nolog",
	[MOUNT_READONLY] = "read-only",
	[MOUNT_TMPFS] = "tmpfs",
	[MOUNT_NOEXEC] = "noexec",
	[MOUNT_RDWR] = "read-write",
	[MOUNT_RDWR_NOCHECK] = "read-write",
};

static void disable_file(OPERATION op, const char *filename) {
	assert(filename);
	assert(op <OPERATION_MAX);
	EUID_ASSERT();

	// Resolve all symlinks
	char* fname = realpath(filename, NULL);
	if (fname == NULL && errno != EACCES) {
		return;
	}
	if (fname == NULL && errno == EACCES) {
		// realpath and stat functions will fail on FUSE filesystems
		// they don't seem to like a uid of 0
		// force mounting
		int fd = open(filename, O_PATH|O_CLOEXEC);
		if (fd < 0) {
			if (arg_debug)
				printf("Warning (blacklisting): cannot open %s: %s\n", filename, strerror(errno));
			return;
		}

		EUID_ROOT();
		int err = bind_mount_path_to_fd(RUN_RO_DIR, fd);
		if (err != 0)
			err = bind_mount_path_to_fd(RUN_RO_FILE, fd);
		EUID_USER();
		close(fd);

		if (err == 0) {
			if (arg_debug)
				printf("Disable %s\n", filename);
			if (op == BLACKLIST_FILE)
				fs_logger2("blacklist", filename);
			else
				fs_logger2("blacklist-nolog", filename);
		}
		else if (arg_debug)
			printf("Warning (blacklisting): cannot mount on %s\n", filename);

		return;
	}

	// if the file is not present, do nothing
	assert(fname);
	struct stat s;
	if (stat(fname, &s) < 0) {
		if (arg_debug)
			printf("Warning (blacklisting): cannot access %s: %s\n", fname, strerror(errno));
		free(fname);
		return;
	}

	// check for firejail executable
	// we migth have a file found in ${PATH} pointing to /usr/bin/firejail
	// blacklisting it here will end up breaking situations like user clicks on a link in Thunderbird
	//     and expects Firefox to open in the same sandbox
	if (strcmp(BINDIR "/firejail", fname) == 0) {
		free(fname);
		return;
	}

	// modify the file
	if (op == BLACKLIST_FILE || op == BLACKLIST_NOLOG) {
		// some distros put all executables under /usr/bin and make /bin a symbolic link
		if ((strcmp(fname, "/bin") == 0 || strcmp(fname, "/usr/bin") == 0) &&
		      is_link(filename) &&
		      S_ISDIR(s.st_mode)) {
			fwarning("%s directory link was not blacklisted\n", filename);
		}
		else {
			if (arg_debug) {
				if (strcmp(filename, fname))
					printf("Disable %s (requested %s)\n", fname, filename);
				else
					printf("Disable %s\n", fname);
			}
			else if (arg_debug_blacklists) {
				printf("Disable %s", fname);
				if (op == BLACKLIST_FILE)
					printf("\n");
				else
					printf(" - no logging\n");
			}

			int fd = open(fname, O_PATH|O_CLOEXEC);
			if (fd < 0) {
				if (arg_debug)
					printf("Warning (blacklisting): cannot open %s: %s\n", fname, strerror(errno));
				free(fname);
				return;
			}
			EUID_ROOT();
			if (S_ISDIR(s.st_mode)) {
				if (bind_mount_path_to_fd(RUN_RO_DIR, fd) < 0)
					errExit("disable file");
			}
			else {
				if (bind_mount_path_to_fd(RUN_RO_FILE, fd) < 0)
					errExit("disable file");
			}
			EUID_USER();
			close(fd);

			if (op == BLACKLIST_FILE)
				fs_logger2("blacklist", fname);
			else
				fs_logger2("blacklist-nolog", fname);
		}
	}
	else if (op == MOUNT_READONLY || op == MOUNT_RDWR || op == MOUNT_NOEXEC) {
		fs_remount_rec(fname, op);
	}
	else if (op == MOUNT_TMPFS) {
		if (!S_ISDIR(s.st_mode)) {
			fwarning("%s is not a directory; cannot mount a tmpfs on top of it.\n", fname);
			free(fname);
			return;
		}

		uid_t uid = getuid();
		if (uid != 0) {
			// only user owned directories in user home
			if (s.st_uid != uid ||
			    strncmp(cfg.homedir, fname, strlen(cfg.homedir)) != 0 ||
			    fname[strlen(cfg.homedir)] != '/') {
				fwarning("you are not allowed to mount a tmpfs on %s\n", fname);
				free(fname);
				return;
			}
		}

		fs_tmpfs(fname, uid);
		EUID_USER(); // fs_tmpfs returns with EUID 0

		selinux_relabel_path(fname, fname);
	}
	else
		assert(0);

	free(fname);
}

#ifdef TEST_NO_BLACKLIST_MATCHING
static int nbcheck_start = 0;
static size_t nbcheck_size = 0;
static int *nbcheck = NULL;
#endif

// Treat pattern as a shell glob pattern and blacklist matching files
static void globbing(OPERATION op, const char *pattern, const char *noblacklist[], size_t noblacklist_len) {
	assert(pattern);
	EUID_ASSERT();

#ifdef TEST_NO_BLACKLIST_MATCHING
	if (nbcheck_start == 0) {
		nbcheck_start = 1;
		nbcheck_size = noblacklist_len;
		nbcheck = malloc(sizeof(int) * noblacklist_len);
		if (nbcheck == NULL)
			errExit("malloc");
		memset(nbcheck, 0, sizeof(int) * noblacklist_len);
	}
#endif

	glob_t globbuf;
	// Profiles contain blacklists for files that might not exist on a user's machine.
	// GLOB_NOCHECK makes that okay.
	int globerr = glob(pattern, GLOB_NOCHECK | GLOB_NOSORT | GLOB_PERIOD, NULL, &globbuf);
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
		if (op == BLACKLIST_FILE || op == BLACKLIST_NOLOG) {
			for (j = 0; j < noblacklist_len; j++) {
				int result = fnmatch(noblacklist[j], path, FNM_PATHNAME);
				if (result == FNM_NOMATCH)
					continue;
				else if (result == 0) {
					okay_to_blacklist = false;
#ifdef TEST_NO_BLACKLIST_MATCHING
					if (j < nbcheck_size)	// noblacklist checking
						nbcheck[j] = 1;
#endif
					break;
				}
				else {
					fprintf(stderr, "Error: failed to compare path %s with pattern %s\n", path, noblacklist[j]);
					exit(1);
				}
			}
		}

		if (okay_to_blacklist)
			disable_file(op, path);
		else if (arg_debug)
			printf("Not blacklist %s\n", path);
	}
	globfree(&globbuf);
}


// blacklist files or directories by mounting empty files on top of them
void fs_blacklist(void) {
	ProfileEntry *entry = cfg.profile;
	if (!entry)
		return;

	size_t noblacklist_c = 0;
	size_t noblacklist_m = 32;
	char **noblacklist = calloc(noblacklist_m, sizeof(*noblacklist));

	if (noblacklist == NULL)
		errExit("failed allocating memory for noblacklist entries");

	EUID_USER();
	while (entry) {
		OPERATION op = OPERATION_MAX;
		char *ptr;

		// whitelist commands handled by fs_whitelist()
		if (strncmp(entry->data, "whitelist ", 10) == 0 ||
		    strncmp(entry->data, "nowhitelist ", 12) == 0 ||
		    strncmp(entry->data, "dbus-", 5) == 0 ||
		   *entry->data == '\0') {
			entry = entry->next;
			continue;
		}

		// process bind command
		if (strncmp(entry->data, "bind ", 5) == 0)  {
			struct stat s;
			char *dname1 = entry->data + 5;
			char *dname2 = split_comma(dname1);
			if (dname2 == NULL ||
			    stat(dname1, &s) == -1 ||
			    stat(dname2, &s) == -1) {
				fprintf(stderr, "Error: invalid bind command, directory missing\n");
				entry = entry->next;
				continue;
			}

			// mount --bind olddir newdir
			if (arg_debug)
				printf("Mount-bind %s on top of %s\n", dname1, dname2);
			// preserve dname2 mode and ownership
			// EUID_ROOT(); - option not accessible to non-root users
			if (mount(dname1, dname2, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");
			/* coverity[toctou] */
			if (set_perms(dname2,  s.st_uid, s.st_gid,s.st_mode))
				errExit("set_perms");
			// EUID_USER();

			entry = entry->next;
			continue;
		}

		// Process noblacklist command
		if (strncmp(entry->data, "noblacklist ", 12) == 0) {
			char **enames;
			int i;

			if (strncmp(entry->data + 12, "${PATH}", 7) == 0) {
				// expand ${PATH} macro
				char **paths = build_paths();
				unsigned int npaths = count_paths();
				enames = calloc(npaths, sizeof(char *));
				if (!enames)
					errExit("calloc");

				for (i = 0; paths[i]; i++) {
					if (asprintf(&enames[i], "%s%s", paths[i],
						entry->data + 19) == -1)
						errExit("asprintf");
				}
				assert(enames[npaths-1] == 0);

			}
			else {
				// expand ${HOME} macro if found or pass as is
				enames = calloc(2, sizeof(char *));
				if (!enames)
					errExit("calloc");
				enames[0] = expand_macros(entry->data + 12);
				assert(enames[1] == 0);
			}

			for (i = 0; enames[i]; i++) {
				if (noblacklist_c >= noblacklist_m) {
					noblacklist_m *= 2;
					noblacklist = realloc(noblacklist, sizeof(*noblacklist) * noblacklist_m);
					if (noblacklist == NULL)
						errExit("failed increasing memory for noblacklist entries");
				}
				noblacklist[noblacklist_c++] = enames[i];
			}

			free(enames);

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
		else if (strncmp(entry->data, "read-write ", 11) == 0) {
			ptr = entry->data + 11;
			op = MOUNT_RDWR;
		}
		else if (strncmp(entry->data, "noexec ", 7) == 0) {
			ptr = entry->data + 7;
			op = MOUNT_NOEXEC;
		}
		else if (strncmp(entry->data, "tmpfs ", 6) == 0) {
			ptr = entry->data + 6;
			op = MOUNT_TMPFS;
		}
		else if (strncmp(entry->data, "mkdir ", 6) == 0) {
			fs_mkdir(entry->data + 6);
			entry = entry->next;
			continue;
		}
		else if (strncmp(entry->data, "mkfile ", 7) == 0) {
			fs_mkfile(entry->data + 7);
			entry = entry->next;
			continue;
		}
		else {
			fprintf(stderr, "Error: invalid profile line %s\n", entry->data);
			entry = entry->next;
			continue;
		}

		// replace home macro in blacklist array
		char *new_name = expand_macros(ptr);
		ptr = new_name;

		// expand path macro - look for the file in /usr/local/bin,  /usr/local/sbin, /bin, /usr/bin, /sbin and  /usr/sbin directories
		if (ptr) {
			if (strncmp(ptr, "${PATH}", 7) == 0) {
				char *fname = ptr + 7;
				size_t fname_len = strlen(fname);
				char **paths = build_paths(); //{"/usr/local/bin", "/usr/local/sbin", "/bin", "/usr/bin/", "/sbin", "/usr/sbin", NULL};
				int i = 0;
				while (paths[i] != NULL) {
					char *path = paths[i];
					i++;
					char newname[strlen(path) + fname_len + 1];
					sprintf(newname, "%s%s", path, fname);
					globbing(op, newname, (const char**)noblacklist, noblacklist_c);
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
#ifdef TEST_NO_BLACKLIST_MATCHING
	// noblacklist checking
	for (i = 0; i < nbcheck_size; i++)
		if (!arg_quiet && !nbcheck[i])
			printf("TESTING warning: noblacklist %s not matched by a proper blacklist command in disable*.inc\n",
				 noblacklist[i]);

	// free memory
	if (nbcheck) {
		free(nbcheck);
		nbcheck = NULL;
		nbcheck_size = 0;
	}
#endif
	for (i = 0; i < noblacklist_c; i++)
		free(noblacklist[i]);
	free(noblacklist);

	EUID_ROOT();
}

//***********************************************
// mount namespace
//***********************************************

// mount a writable tmpfs on directory; requires a resolved path
void fs_tmpfs(const char *dir, unsigned check_owner) {
	EUID_USER();
	assert(dir);
	if (arg_debug)
		printf("Mounting tmpfs on %s, check owner: %s\n", dir, (check_owner)? "yes": "no");
	// get a file descriptor for dir, fails if there is any symlink
	int fd = safer_openat(-1, dir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("while opening directory");
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (check_owner && s.st_uid != getuid()) {
		fprintf(stderr, "Error: cannot mount tmpfs on %s: not owned by the current user\n", dir);
		exit(1);
	}
	// preserve ownership, mode
	char *options;
	if (asprintf(&options, "mode=%o,uid=%u,gid=%u", s.st_mode & 07777, s.st_uid, s.st_gid) == -1)
		errExit("asprintf");
	// preserve mount flags, but remove read-only flag
	struct statvfs buf;
	if (fstatvfs(fd, &buf) == -1)
		errExit("fstatvfs");
	unsigned long flags = buf.f_flag & ~(MS_RDONLY|MS_BIND);
	// mount via the symbolic link in /proc/self/fd
	EUID_ROOT();
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount("tmpfs", proc, "tmpfs", flags|MS_NOSUID|MS_NODEV, options) < 0)
		errExit("mounting tmpfs");
	// check the last mount operation
	MountData *mdata = get_last_mount();
	if (strcmp(mdata->fstype, "tmpfs") != 0 || strcmp(mdata->dir, dir) != 0)
		errLogExit("invalid tmpfs mount");
	fs_logger2("tmpfs", dir);
	free(options);
	free(proc);
	close(fd);
}

// remount path, preserving other mount flags; requires a resolved path
static void fs_remount_simple(const char *path, OPERATION op) {
	EUID_ASSERT();
	assert(path);

	// open path without following symbolic links
	int fd = safer_openat(-1, path, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (fd < 0)
		goto out;

	struct stat s;
	if (fstat(fd, &s) < 0) {
		// fstat can fail with EACCES if path is a FUSE mount,
		// mounted without 'allow_root' or 'allow_other'
		if (errno != EACCES)
			errExit("fstat");
		close(fd);
		goto out;
	}
	// get mount flags
	struct statvfs buf;
	if (fstatvfs(fd, &buf) < 0) {
		close(fd);
		goto out;
	}
	unsigned long flags = buf.f_flag;

	// read-write option
	if (op == MOUNT_RDWR || op == MOUNT_RDWR_NOCHECK) {
		// nothing to do if there is no read-only flag
		if ((flags & MS_RDONLY) == 0) {
			close(fd);
			return;
		}
		// allow only user owned directories, except the user is root
		if (op != MOUNT_RDWR_NOCHECK && getuid() != 0 && s.st_uid != getuid()) {
			fwarning("you are not allowed to change %s to read-write\n", path);
			close(fd);
			return;
		}
		flags &= ~MS_RDONLY;
	}
	// noexec option
	else if (op == MOUNT_NOEXEC) {
		// nothing to do if path is mounted noexec already
		if ((flags & (MS_NOEXEC|MS_NODEV|MS_NOSUID)) == (MS_NOEXEC|MS_NODEV|MS_NOSUID)) {
			close(fd);
			return;
		}
		flags |= MS_NOEXEC|MS_NODEV|MS_NOSUID;
	}
	// read-only option
	else if (op == MOUNT_READONLY) {
		// nothing to do if path is mounted read-only already
		if ((flags & MS_RDONLY) == MS_RDONLY) {
			close(fd);
			return;
		}
		flags |= MS_RDONLY;
	}
	else
		assert(0);

	if (arg_debug)
		printf("Mounting %s %s\n", opstr[op], path);

	// make path a mount point:
	// mount --bind path path
	EUID_ROOT();
	int err = bind_mount_by_fd(fd, fd);
	EUID_USER();
	if (err) {
		close(fd);
		goto out;
	}

	// remount the mount point
	// need to open path again
	int fd2 = safer_openat(-1, path, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	close(fd); // earliest timepoint to close fd
	if (fd2 < 0)
		goto out;

	// device and inode number should be the same
	struct stat s2;
	if (fstat(fd2, &s2) < 0)
		errExit("fstat");
	if (s.st_dev != s2.st_dev || s.st_ino != s2.st_ino)
		errLogExit("invalid %s mount", opstr[op]);

	EUID_ROOT();
	err = remount_by_fd(fd2, flags);
	EUID_USER();
	close(fd2);
	if (err)
		goto out;

	// run a sanity check on /proc/self/mountinfo and confirm that target of the last
	// mount operation was path; if there are other mount points contained inside path,
	// one of those will show up as target of the last mount operation instead
	MountData *mptr = get_last_mount();
	size_t len = strlen(path);
	if ((strncmp(mptr->dir, path, len) != 0 ||
	   (*(mptr->dir + len) != '\0' && *(mptr->dir + len) != '/'))
	   && strcmp(path, "/") != 0) // support read-only=/
		errLogExit("invalid %s mount", opstr[op]);

	fs_logger2(opstr[op], path);
	return;

out:
	fwarning("not remounting %s\n", path);
}

// remount recursively; requires a resolved path
static void fs_remount_rec(const char *dir, OPERATION op) {
	EUID_ASSERT();
	assert(dir);

	struct stat s;
	if (stat(dir, &s) != 0)
		return;
	if (!S_ISDIR(s.st_mode)) {
		// no need to search in /proc/self/mountinfo for submounts if not a directory
		fs_remount_simple(dir, op);
		return;
	}
	// get mount point of the directory
	int mountid = get_mount_id(dir);
	if (mountid == -1)
		return;
	if (mountid == -2) {
		// falling back to a simple remount on old kernels
		static int mount_warning = 0;
		if (!mount_warning) {
			fwarning("read-only, read-write and noexec options are not applied recursively\n");
			mount_warning = 1;
		}
		fs_remount_simple(dir, op);
		return;
	}
	// build array with all mount points that need to get remounted
	char **arr = build_mount_array(mountid, dir);
	assert(arr);
	// remount
	char **tmp = arr;
	while (*tmp) {
		fs_remount_simple(*tmp, op);
		free(*tmp++);
	}
	free(arr);
}

// resolve a path and remount it
void fs_remount(const char *path, OPERATION op, int rec) {
	assert(path);

	int called_as_root = 0;
	if (geteuid() == 0)
		called_as_root = 1;

	if (called_as_root)
		EUID_USER();

	char *rpath = realpath(path, NULL);
	if (rpath) {
		if (rec)
			fs_remount_rec(rpath, op);
		else
			fs_remount_simple(rpath, op);
		free(rpath);
	}

	if (called_as_root)
		EUID_ROOT();
}

// Disable /mnt, /media, /run/mount and /run/media access
void fs_mnt(const int enforce) {
	EUID_USER();
	if (enforce) {
		// disable-mnt set in firejail.config
		// overriding with noblacklist is not possible in this case
		disable_file(BLACKLIST_FILE, "/mnt");
		disable_file(BLACKLIST_FILE, "/media");
		disable_file(BLACKLIST_FILE, "/run/mount");
		disable_file(BLACKLIST_FILE, "/run/media");
	}
	else {
		profile_add("blacklist /mnt");
		profile_add("blacklist /media");
		profile_add("blacklist /run/mount");
		profile_add("blacklist /run/media");
	}
	EUID_ROOT();
}


// mount /proc and /sys directories
void fs_proc_sys_dev_boot(void) {

	// remount /proc/sys readonly
	if (arg_debug)
		printf("Mounting read-only /proc/sys\n");
	if (mount("/proc/sys", "/proc/sys", NULL, MS_BIND | MS_REC, NULL) < 0 ||
	    mount(NULL, "/proc/sys", NULL, MS_BIND | MS_REMOUNT | MS_RDONLY | MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");
	fs_logger("read-only /proc/sys");

	/* Mount a version of /sys that describes the network namespace */
	if (arg_debug)
		printf("Remounting /sys directory\n");
	// sysfs not yet mounted in overlays, so don't try to unmount it
	// expect that unmounting /sys fails in a chroot, no need to print a warning in that case
	if (!arg_overlay) {
		if (umount2("/sys", MNT_DETACH) < 0 && !cfg.chrootdir)
			fwarning("failed to unmount /sys\n");
	}
	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
		fwarning("failed to mount /sys\n");
	else
		fs_logger("remount /sys");

	EUID_USER();

	disable_file(BLACKLIST_FILE, "/sys/firmware");
	disable_file(BLACKLIST_FILE, "/sys/hypervisor");
	{ // allow user access to some directories in /sys/ by specifying 'noblacklist' option
		profile_add("blacklist /sys/fs");
		profile_add("blacklist /sys/module");
	}
	disable_file(BLACKLIST_FILE, "/sys/power");
	disable_file(BLACKLIST_FILE, "/sys/kernel/debug");
	disable_file(BLACKLIST_FILE, "/sys/kernel/vmcoreinfo");
	disable_file(BLACKLIST_FILE, "/sys/kernel/uevent_helper");

	// various /proc/sys files
	disable_file(BLACKLIST_FILE, "/proc/sys/security");
	disable_file(BLACKLIST_FILE, "/proc/sys/efi/vars");
	disable_file(BLACKLIST_FILE, "/proc/sys/fs/binfmt_misc");
	disable_file(BLACKLIST_FILE, "/proc/sys/kernel/core_pattern");
	disable_file(BLACKLIST_FILE, "/proc/sys/kernel/modprobe");
	disable_file(BLACKLIST_FILE, "/proc/sysrq-trigger");
	disable_file(BLACKLIST_FILE, "/proc/sys/kernel/hotplug");
	disable_file(BLACKLIST_FILE, "/proc/sys/vm/panic_on_oom");

	// various /proc files
	disable_file(BLACKLIST_FILE, "/proc/irq");
	disable_file(BLACKLIST_FILE, "/proc/bus");
	// move /proc/config.gz to disable-common.inc
	//disable_file(BLACKLIST_FILE, "/proc/config.gz");
	disable_file(BLACKLIST_FILE, "/proc/sched_debug");
	disable_file(BLACKLIST_FILE, "/proc/timer_list");
	disable_file(BLACKLIST_FILE, "/proc/timer_stats");
	disable_file(BLACKLIST_FILE, "/proc/kcore");
	disable_file(BLACKLIST_FILE, "/proc/kallsyms");
	disable_file(BLACKLIST_FILE, "/proc/mem");
	disable_file(BLACKLIST_FILE, "/proc/kmem");

	// remove kernel symbol information
	if (!arg_allow_debuggers) {
		disable_file(BLACKLIST_FILE, "/usr/src/linux");
		disable_file(BLACKLIST_FILE, "/lib/modules");
		disable_file(BLACKLIST_FILE, "/usr/lib/debug");
		disable_file(BLACKLIST_FILE, "/boot");
	}

	// disable /selinux
	disable_file(BLACKLIST_FILE, "/selinux");

	// disable /dev/port
	disable_file(BLACKLIST_FILE, "/dev/port");

	// disable various ipc sockets in /run/user
	if (!arg_writable_run_user) {
		char *fname;
		if (asprintf(&fname, "/run/user/%d", getuid()) == -1)
			errExit("asprintf");
		if (is_dir(fname)) { // older distros don't have this directory
			// disable /run/user/{uid}/gnupg
			char *fnamegpg;
			if (asprintf(&fnamegpg, "/run/user/%d/gnupg", getuid()) == -1)
				errExit("asprintf");
			if (create_empty_dir_as_user(fnamegpg, 0700))
				fs_logger2("create", fnamegpg);
			disable_file(BLACKLIST_FILE, fnamegpg);
			free(fnamegpg);

			// disable /run/user/{uid}/systemd
			char *fnamesysd;
			if (asprintf(&fnamesysd, "/run/user/%d/systemd", getuid()) == -1)
				errExit("asprintf");
			if (create_empty_dir_as_user(fnamesysd, 0755))
				fs_logger2("create", fnamesysd);
			disable_file(BLACKLIST_FILE, fnamesysd);
			free(fnamesysd);
		}
		free(fname);
	}

	if (getuid() != 0) {
		// disable /dev/kmsg and /proc/kmsg
		disable_file(BLACKLIST_FILE, "/dev/kmsg");
		disable_file(BLACKLIST_FILE, "/proc/kmsg");
	}

	EUID_ROOT();
}

// disable firejail configuration in ~/.config/firejail
void disable_config(void) {
	EUID_USER();
	char *fname;
	if (asprintf(&fname, "%s/.config/firejail", cfg.homedir) == -1)
		errExit("asprintf");
	disable_file(BLACKLIST_FILE, fname);
	free(fname);

	// disable run time information
	disable_file(BLACKLIST_FILE, RUN_FIREJAIL_NETWORK_DIR);
	disable_file(BLACKLIST_FILE, RUN_FIREJAIL_BANDWIDTH_DIR);
	disable_file(BLACKLIST_FILE, RUN_FIREJAIL_NAME_DIR);
	disable_file(BLACKLIST_FILE, RUN_FIREJAIL_PROFILE_DIR);
	disable_file(BLACKLIST_FILE, RUN_FIREJAIL_X11_DIR);
	EUID_ROOT();
}


// build a basic read-only filesystem
void fs_basic_fs(void) {
	uid_t uid = getuid();

	// mount a new proc filesystem
	if (arg_debug)
		printf("Mounting /proc filesystem representing the PID namespace\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");

	EUID_USER();
	if (arg_debug)
		printf("Basic read-only filesystem:\n");
	if (!arg_writable_etc) {
		fs_remount("/etc", MOUNT_READONLY, 1);
		if (uid)
			fs_remount("/etc", MOUNT_NOEXEC, 1);
	}
	if (!arg_writable_var) {
		fs_remount("/var", MOUNT_READONLY, 1);
		if (uid)
			fs_remount("/var", MOUNT_NOEXEC, 1);
	}
	fs_remount("/usr", MOUNT_READONLY, 1);
	fs_remount("/bin", MOUNT_READONLY, 1);
	fs_remount("/sbin", MOUNT_READONLY, 1);
	fs_remount("/lib", MOUNT_READONLY, 1);
	fs_remount("/lib64", MOUNT_READONLY, 1);
	fs_remount("/lib32", MOUNT_READONLY, 1);
	fs_remount("/libx32", MOUNT_READONLY, 1);
	EUID_ROOT();

	// update /var directory in order to support multiple sandboxes running on the same root directory
	fs_var_lock();
	if (!arg_keep_var_tmp)
	  fs_var_tmp();
	if (!arg_writable_var_log)
		fs_var_log();
	else
		fs_remount("/var/log", MOUNT_RDWR_NOCHECK, 0);

	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();
	fs_machineid();

	// don't leak user information
	restrict_users();

	// when starting as root, firejail config is not disabled;
	if (uid)
		disable_config();
}



#ifdef HAVE_OVERLAYFS
char *fs_check_overlay_dir(const char *subdirname, int allow_reuse) {
	assert(subdirname);
	EUID_ASSERT();
	struct stat s;
	char *dirname;

	if (asprintf(&dirname, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");
	// check if ~/.firejail already exists
	if (lstat(dirname, &s) == 0) {
		if (!S_ISDIR(s.st_mode)) {
			if (S_ISLNK(s.st_mode))
				fprintf(stderr, "Error: %s is a symbolic link\n", dirname);
			else
				fprintf(stderr, "Error: %s is not a directory\n", dirname);
			exit(1);
		}
		if (s.st_uid != getuid()) {
			fprintf(stderr, "Error: %s is not owned by the current user\n", dirname);
			exit(1);
		}
	}
	else {
		// create ~/.firejail directory
		create_empty_dir_as_user(dirname, 0700);
		if (stat(dirname, &s) == -1) {
			fprintf(stderr, "Error: cannot create directory %s\n", dirname);
			exit(1);
		}
	}
	free(dirname);

	// check overlay directory
	if (asprintf(&dirname, "%s/.firejail/%s", cfg.homedir, subdirname) == -1)
		errExit("asprintf");
	if (lstat(dirname, &s) == 0) {
		if (!S_ISDIR(s.st_mode)) {
			if (S_ISLNK(s.st_mode))
				fprintf(stderr, "Error: %s is a symbolic link\n", dirname);
			else
				fprintf(stderr, "Error: %s is not a directory\n", dirname);
			exit(1);
		}
		if (s.st_uid != 0) {
			fprintf(stderr, "Error: overlay directory %s is not owned by the root user\n", dirname);
			exit(1);
		}
		if (allow_reuse == 0) {
			fprintf(stderr, "Error: overlay directory exists, but reuse is not allowed\n");
			exit(1);
		}
	}

	return dirname;
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


// to do: fix the code below; also, it might work without /dev, but consider keeping /dev/shm; add locking mechanism for overlay-clean
#include <sys/utsname.h>
void fs_overlayfs(void) {
	struct stat s;

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

	// mounting an overlayfs on top of / seems to be broken for kernels > 4.19
	// we disable overlayfs for now, pending fixing
	if (major >= 4 &&minor >= 19) {
		fprintf(stderr, "Error: OverlayFS disabled for Linux kernels 4.19 and newer, pending fixing.\n");
		exit(1);
	}

	char *oroot = RUN_OVERLAY_ROOT;
	mkdir_attr(oroot, 0755, 0, 0);

	// set base for working and diff directories
	char *basedir = RUN_MNT_DIR;
	int basefd = -1;

	if (arg_overlay_keep) {
		basedir = cfg.overlay_dir;
		assert(basedir);
		// get a file descriptor for ~/.firejail, fails if there is any symlink
		char *firejail;
		if (asprintf(&firejail, "%s/.firejail", cfg.homedir) == -1)
			errExit("asprintf");
		int fd = safer_openat(-1, firejail, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1)
			errExit("safer_openat");
		free(firejail);
		// create basedir if it doesn't exist
		// the new directory will be owned by root
		const char *dirname = gnu_basename(basedir);
		if (mkdirat(fd, dirname, 0755) == -1 && errno != EEXIST) {
			perror("mkdir");
			fprintf(stderr, "Error: cannot create overlay directory %s\n", basedir);
			exit(1);
		}
		// open basedir
		basefd = openat(fd, dirname, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		close(fd);
	}
	else {
		basefd = open(basedir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	}
	if (basefd == -1) {
		perror("open");
		fprintf(stderr, "Error: cannot open overlay directory %s\n", basedir);
		exit(1);
	}

	// confirm once more base is owned by root
	if (fstat(basefd, &s) == -1)
		errExit("fstat");
	if (s.st_uid != 0) {
		fprintf(stderr, "Error: overlay directory %s is not owned by the root user\n", basedir);
		exit(1);
	}
	// confirm permissions of base are 0755
	if (((S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH) & s.st_mode) != (S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH)) {
		fprintf(stderr, "Error: invalid permissions on overlay directory %s\n", basedir);
		exit(1);
	}

	// create diff and work directories inside base
	// no need to check arg_overlay_reuse
	char *odiff;
	if (asprintf(&odiff, "%s/odiff", basedir) == -1)
		errExit("asprintf");
	// the new directory will be owned by root
	if (mkdirat(basefd, "odiff", 0755) == -1 && errno != EEXIST) {
		perror("mkdir");
		fprintf(stderr, "Error: cannot create overlay directory %s\n", odiff);
		exit(1);
	}
	ASSERT_PERMS(odiff, 0, 0, 0755);

	char *owork;
	if (asprintf(&owork, "%s/owork", basedir) == -1)
		errExit("asprintf");
	// the new directory will be owned by root
	if (mkdirat(basefd, "owork", 0755) == -1 && errno != EEXIST) {
		perror("mkdir");
		fprintf(stderr, "Error: cannot create overlay directory %s\n", owork);
		exit(1);
	}
	ASSERT_PERMS(owork, 0, 0, 0755);

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
		if (mount("overlay", oroot, "overlay", MS_MGC_VAL, option) < 0) {
			fprintf(stderr, "Debug: running on kernel version %d.%d\n", major, minor);
			errExit("mounting overlayfs");
		}

		//***************************
		// issue #263 start code
		// My setup has a separate mount point for /home. When the overlay is mounted,
		// the overlay does not contain the original /home contents.
		// I added code to create a second overlay for /home if the overlay home dir is empty and this seems to work
		// @dshmgh, Jan 2016
		{
			char *overlayhome;
			struct stat s;
			char *hroot;
			char *hdiff;
			char *hwork;

			// dons add debug
			if (arg_debug) printf ("DEBUG: chroot dirs are oroot %s  odiff %s  owork %s\n",oroot,odiff,owork);

			// BEFORE NEXT, WE NEED TO TEST IF /home has any contents or do we need to mount it?
			// must create var for oroot/cfg.homedir
			if (asprintf(&overlayhome, "%s%s", oroot, cfg.homedir) == -1)
				errExit("asprintf");
			if (arg_debug) printf ("DEBUG: overlayhome var holds ##%s##\n", overlayhome);

			// if no homedir in overlay -- create another overlay for /home
			if (stat(cfg.homedir, &s) == 0 && stat(overlayhome, &s) == -1) {

				// no need to check arg_overlay_reuse
				if (asprintf(&hdiff, "%s/hdiff", basedir) == -1)
					errExit("asprintf");
				// the new directory will be owned by root
				if (mkdirat(basefd, "hdiff", 0755) == -1 && errno != EEXIST) {
					perror("mkdir");
					fprintf(stderr, "Error: cannot create overlay directory %s\n", hdiff);
					exit(1);
				}
				ASSERT_PERMS(hdiff, 0, 0, 0755);

				// no need to check arg_overlay_reuse
				if (asprintf(&hwork, "%s/hwork", basedir) == -1)
					errExit("asprintf");
				// the new directory will be owned by root
				if (mkdirat(basefd, "hwork", 0755) == -1 && errno != EEXIST) {
					perror("mkdir");
					fprintf(stderr, "Error: cannot create overlay directory %s\n", hwork);
					exit(1);
				}
				ASSERT_PERMS(hwork, 0, 0, 0755);

				// no homedir in overlay so now mount another overlay for /home
				if (asprintf(&hroot, "%s/home", oroot) == -1)
					errExit("asprintf");
				if (asprintf(&option, "lowerdir=/home,upperdir=%s,workdir=%s", hdiff, hwork) == -1)
					errExit("asprintf");
				if (mount("overlay", hroot, "overlay", MS_MGC_VAL, option) < 0)
					errExit("mounting overlayfs for mounted home directory");

				printf("OverlayFS for /home configured in %s directory\n", basedir);
				free(hroot);
				free(hdiff);
				free(hwork);

			} // stat(overlayhome)
			free(overlayhome);
		}
		// issue #263 end code
		//***************************
	}
	fmessage("OverlayFS configured in %s directory\n", basedir);
	close(basefd);

	// /dev, /run and /tmp are not covered by the overlay
	// mount-bind dev directory
	if (arg_debug)
		printf("Mounting /dev\n");
	char *dev;
	if (asprintf(&dev, "%s/dev", oroot) == -1)
		errExit("asprintf");
	if (mount("/dev", dev, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	fs_logger("whitelist /dev");

	// mount-bind run directory
	if (arg_debug)
		printf("Mounting /run\n");
	char *run;
	if (asprintf(&run, "%s/run", oroot) == -1)
		errExit("asprintf");
	if (mount("/run", run, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /run");
	fs_logger("whitelist /run");

	// mount-bind tmp directory
	if (arg_debug)
		printf("Mounting /tmp\n");
	char *tmp;
	if (asprintf(&tmp, "%s/tmp", oroot) == -1)
		errExit("asprintf");
	if (mount("/tmp", tmp, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /tmp");
	fs_logger("whitelist /tmp");

	// chroot in the new filesystem
	__gcov_flush();

	if (chroot(oroot) == -1)
		errExit("chroot");

	// mount a new proc filesystem
	if (arg_debug)
		printf("Mounting /proc filesystem representing the PID namespace\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");

	// update /var directory in order to support multiple sandboxes running on the same root directory
//	if (!arg_private_dev)
//		fs_dev_shm();
	fs_var_lock();
	if (!arg_keep_var_tmp)
		fs_var_tmp();
	if (!arg_writable_var_log)
		fs_var_log();
	fs_var_lib();
	fs_var_cache();
	fs_var_utmp();
	fs_machineid();

	// don't leak user information
	restrict_users();

	// when starting as root, firejail config is not disabled;
	if (getuid() != 0)
		disable_config();

	// cleanup and exit
	free(option);
	free(odiff);
	free(owork);
	free(dev);
	free(run);
	free(tmp);
}
#endif

// this function is called from sandbox.c before blacklist/whitelist functions
void fs_private_tmp(void) {
	EUID_ASSERT();
	if (arg_debug)
		printf("Generate private-tmp whitelist commands\n");

	// check XAUTHORITY file, KDE keeps it under /tmp
	const char *xauth = env_get("XAUTHORITY");
	if (xauth) {
		char *rp = realpath(xauth, NULL);
		if (rp && strncmp(rp, "/tmp/", 5) == 0) {
			char *cmd;
			if (asprintf(&cmd, "whitelist %s", rp) == -1)
				errExit("asprintf");
			profile_check_line(cmd, 0, NULL);
			profile_add(cmd); // profile_add does not duplicate the string
		}
		if (rp)
			free(rp);
	}

	// whitelist x11 directory
	profile_add("whitelist /tmp/.X11-unix");
	// read-only x11 directory
	profile_add("read-only /tmp/.X11-unix");

	// whitelist any pulse* file in /tmp directory
	// some distros use PulseAudio sockets under /tmp instead of the socket in /urn/user
	DIR *dir;
	if (!(dir = opendir("/tmp"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/tmp"))) {
			return;
		}
	}

	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strncmp(entry->d_name, "pulse-", 6) == 0) {
			char *cmd;
			if (asprintf(&cmd, "whitelist /tmp/%s", entry->d_name) == -1)
				errExit("asprintf");
			profile_check_line(cmd, 0, NULL);
			profile_add(cmd); // profile_add does not duplicate the string
		}
	}
	closedir(dir);
}

/*
 * Copyright (C) 2014-2018 Firejail Authors
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
#include <sys/statvfs.h>
#include <sys/wait.h>
#include <linux/limits.h>
#include <fnmatch.h>
#include <glob.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>

// check noblacklist statements not matched by a proper blacklist in disable-*.inc files
//#define TEST_NO_BLACKLIST_MATCHING



static void fs_rdwr(const char *dir);



//***********************************************
// process profile file
//***********************************************
typedef enum {
	BLACKLIST_FILE,
	BLACKLIST_NOLOG,
	MOUNT_READONLY,
	MOUNT_TMPFS,
	MOUNT_NOEXEC,
	MOUNT_RDWR,
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

	// Resolve all symlinks
	char* fname = realpath(filename, NULL);
	if (fname == NULL && errno != EACCES) {
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
				printf("Warning (blacklisting): %s is an invalid file, skipping...\n", filename);
		}

		return;
	}

	// if the file is not present, do nothing
	struct stat s;
	if (fname == NULL)
		return;
	if (stat(fname, &s) == -1) {
		if (arg_debug)
			fwarning("%s does not exist, skipping...\n", fname);
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
	else if (op == MOUNT_RDWR) {
		if (arg_debug)
			printf("Mounting read-only %s\n", fname);
		fs_rdwr(fname);
// todo: last_disable = SUCCESSFUL;
	}
	else if (op == MOUNT_NOEXEC) {
		if (arg_debug)
			printf("Mounting noexec %s\n", fname);
		fs_noexec(fname);
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
				errExit("mounting tmpfs chown");
			if (chmod(fname, s.st_mode) == -1)
				errExit("mounting tmpfs chmod");
			last_disable = SUCCESSFUL;
			fs_logger2("tmpfs", fname);
		}
		else
			fwarning("%s is not a directory; cannot mount a tmpfs on top of it.\n", fname);
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

		if (okay_to_blacklist)
			disable_file(op, path);
		else if (arg_debug)
			printf("Not blacklist %s\n", path);
	}
	globfree(&globbuf);
}


// blacklist files or directories by mounting empty files on top of them
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
		if (strncmp(entry->data, "whitelist ", 10) == 0 ||
		    strncmp(entry->data, "nowhitelist ", 12) == 0 ||
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
			if (mount(dname1, dname2, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mount bind");
			/* coverity[toctou] */
			if (set_perms(dname2,  s.st_uid, s.st_gid,s.st_mode))
				errExit("set_perms");

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
				enames[0] = expand_home(entry->data + 12, homedir);
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
			EUID_USER();
			fs_mkdir(entry->data + 6);
			EUID_ROOT();
			entry = entry->next;
			continue;
		}
		else if (strncmp(entry->data, "mkfile ", 7) == 0) {
			EUID_USER();
			fs_mkfile(entry->data + 7);
			EUID_ROOT();
			entry = entry->next;
			continue;
		}
		else {
			fprintf(stderr, "Error: invalid profile line %s\n", entry->data);
			entry = entry->next;
			continue;
		}

		// replace home macro in blacklist array
		char *new_name = expand_home(ptr, homedir);
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
}

static int get_mount_flags(const char *path, unsigned long *flags) {
	struct statvfs buf;

	if (statvfs(path, &buf) < 0)
		return -errno;
	*flags = buf.f_flag;
	return 0;
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
		unsigned long flags = 0;
		get_mount_flags(dir, &flags);
		if ((flags & MS_RDONLY) == MS_RDONLY)
			return;
		flags |= MS_RDONLY;
		// mount --bind /bin /bin
		// mount --bind -o remount,ro /bin
		if (mount(dir, dir, NULL, MS_BIND|MS_REC, NULL) < 0 ||
		    mount(NULL, dir, NULL, flags|MS_BIND|MS_REMOUNT|MS_REC, NULL) < 0)
			errExit("mount read-only");
		fs_logger2("read-only", dir);
	}
}

static void fs_rdwr(const char *dir) {
	assert(dir);
	// check directory exists and ensure we have a resolved path
	// the resolved path allows to run a sanity check after the mount
	char *path = realpath(dir, NULL);
	if (path == NULL)
		return;
	// allow only user owned directories, except the user is root
	uid_t u = getuid();
	struct stat s;
	int rv = stat(path, &s);
	if (rv) {
		free(path);
		return;
	}
	if (u != 0 && s.st_uid != u) {
		fwarning("you are not allowed to change %s to read-write\n", path);
		free(path);
		return;
	}
	// mount --bind /bin /bin
	// mount --bind -o remount,rw /bin
	unsigned long flags = 0;
	get_mount_flags(path, &flags);
	if ((flags & MS_RDONLY) == 0) {
		free(path);
		return;
	}
	flags &= ~MS_RDONLY;
	if (mount(path, path, NULL, MS_BIND|MS_REC, NULL) < 0 ||
	    mount(NULL, path, NULL, flags|MS_BIND|MS_REMOUNT|MS_REC, NULL) < 0)
		errExit("mount read-write");
	fs_logger2("read-write", path);

	// run a check on /proc/self/mountinfo to validate the mount
	MountData *mptr = get_last_mount();
	if (strncmp(mptr->dir, path, strlen(path)) != 0)
		errLogExit("invalid read-write mount");

	free(path);
}

void fs_noexec(const char *dir) {
	assert(dir);
	// check directory exists
	struct stat s;
	int rv = stat(dir, &s);
	if (rv == 0) {
		// mount --bind /bin /bin
		// mount --bind -o remount,ro /bin
		unsigned long flags = 0;
		get_mount_flags(dir, &flags);
		if ((flags & (MS_NOEXEC|MS_NODEV|MS_NOSUID)) == (MS_NOEXEC|MS_NODEV|MS_NOSUID))
			return;
		flags |= MS_NOEXEC|MS_NODEV|MS_NOSUID;
		if (mount(dir, dir, NULL, MS_BIND|MS_REC, NULL) < 0 ||
		    mount(NULL, dir, NULL, flags|MS_BIND|MS_REMOUNT|MS_REC, NULL) < 0)
			errExit("mount noexec");
		fs_logger2("noexec", dir);
	}
}

// Disable /mnt, /media, /run/mount and /run/media access
void fs_mnt(void) {
	disable_file(BLACKLIST_FILE, "/mnt");
	disable_file(BLACKLIST_FILE, "/media");
	disable_file(BLACKLIST_FILE, "/run/mount");
	disable_file(BLACKLIST_FILE, "//run/media");
}


// mount /proc and /sys directories
void fs_proc_sys_dev_boot(void) {

	if (arg_debug)
		printf("Remounting /proc and /proc/sys filesystems\n");
	if (mount("proc", "/proc", "proc", MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc");
	fs_logger("remount /proc");

	// remount /proc/sys readonly
	if (mount("/proc/sys", "/proc/sys", NULL, MS_BIND | MS_REC, NULL) < 0 ||
	    mount(NULL, "/proc/sys", NULL, MS_BIND | MS_REMOUNT | MS_RDONLY | MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_REC, NULL) < 0)
		errExit("mounting /proc/sys");
	fs_logger("read-only /proc/sys");


	/* Mount a version of /sys that describes the network namespace */
	if (arg_debug)
		printf("Remounting /sys directory\n");
	// if this is an overlay, don't try to unmount, just mount a new sysfs
	if (!arg_overlay) {
		if (umount2("/sys", MNT_DETACH) < 0 && !cfg.chrootdir)
			fwarning("failed to unmount /sys\n");
	}
	if (mount("sysfs", "/sys", "sysfs", MS_RDONLY|MS_NOSUID|MS_NOEXEC|MS_NODEV|MS_REC, NULL) < 0)
		fwarning("failed to mount /sys\n");
	else
		fs_logger("remount /sys");

	disable_file(BLACKLIST_FILE, "/sys/firmware");
	disable_file(BLACKLIST_FILE, "/sys/hypervisor");
	{ // allow user access to some directories in /sys/ by specifying 'noblacklist' option
		EUID_USER();
		profile_add("blacklist /sys/fs");
		profile_add("blacklist /sys/module");
		EUID_ROOT();
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
	disable_file(BLACKLIST_FILE, "/proc/config.gz");
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
		struct stat s;

		char *fname;
		if (asprintf(&fname, "/run/user/%d", getuid()) == -1)
			errExit("asprintf");
		if (is_dir(fname)) { // older distros don't have this directory
			// disable /run/user/{uid}/gnupg
			char *fnamegpg;
			if (asprintf(&fnamegpg, "/run/user/%d/gnupg", getuid()) == -1)
				errExit("asprintf");
			if (stat(fnamegpg, &s) == -1) {
				pid_t child = fork();
				if (child < 0)
					errExit("fork");
				if (child == 0) {
					// drop privileges
					drop_privs(0);
					if (mkdir(fnamegpg, 0700) == 0) {
						if (chmod(fnamegpg, 0700) == -1)
							{;} // do nothing
					}
#ifdef HAVE_GCOV
					__gcov_flush();
#endif
					_exit(0);
				}
				// wait for the child to finish
				waitpid(child, NULL, 0);
				fs_logger2("create", fnamegpg);
			}
			if (stat(fnamegpg, &s) == 0)
				disable_file(BLACKLIST_FILE, fnamegpg);
			free(fnamegpg);

			// disable /run/user/{uid}/systemd
			char *fnamesysd;
			if (asprintf(&fnamesysd, "/run/user/%d/systemd", getuid()) == -1)
				errExit("asprintf");
			if (stat(fnamesysd, &s) == -1) {
				pid_t child = fork();
				if (child < 0)
					errExit("fork");
				if (child == 0) {
					// drop privileges
					drop_privs(0);
					if (mkdir(fnamesysd, 0755) == 0) {
						if (chmod(fnamesysd, 0755) == -1)
							{;} // do nothing
					}
#ifdef HAVE_GCOV
					__gcov_flush();
#endif
					_exit(0);
				}
				// wait for the child to finish
				waitpid(child, NULL, 0);
				fs_logger2("create", fnamesysd);
			}
			if (stat(fnamesysd, &s) == 0)
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
}

// disable firejail configuration in /etc/firejail and in ~/.config/firejail
static void disable_config(void) {
	struct stat s;

	char *fname;
	if (asprintf(&fname, "%s/.config/firejail", cfg.homedir) == -1)
		errExit("asprintf");
	if (stat(fname, &s) == 0)
		disable_file(BLACKLIST_FILE, fname);
	free(fname);

	// disable run time information
	if (stat(RUN_FIREJAIL_NETWORK_DIR, &s) == 0)
		disable_file(BLACKLIST_FILE, RUN_FIREJAIL_NETWORK_DIR);
	if (stat(RUN_FIREJAIL_BANDWIDTH_DIR, &s) == 0)
		disable_file(BLACKLIST_FILE, RUN_FIREJAIL_BANDWIDTH_DIR);
	if (stat(RUN_FIREJAIL_NAME_DIR, &s) == 0)
		disable_file(BLACKLIST_FILE, RUN_FIREJAIL_NAME_DIR);
	if (stat(RUN_FIREJAIL_X11_DIR, &s) == 0)
		disable_file(BLACKLIST_FILE, RUN_FIREJAIL_X11_DIR);
}


// build a basic read-only filesystem
void fs_basic_fs(void) {
	uid_t uid = getuid();

	if (arg_debug)
		printf("Mounting read-only /bin, /sbin, /lib, /lib32, /lib64, /usr");
	if (!arg_writable_etc) {
		fs_rdonly("/etc");
		if (uid)
			fs_noexec("/etc");
		if (arg_debug) printf(", /etc");
	}
	if (!arg_writable_var) {
		fs_rdonly("/var");
		if (uid)
			fs_noexec("/var");
		if (arg_debug) printf(", /var");
	}
	if (arg_debug) printf("\n");
	fs_rdonly("/bin");
	fs_rdonly("/sbin");
	fs_rdonly("/lib");
	fs_rdonly("/lib64");
	fs_rdonly("/lib32");
	fs_rdonly("/libx32");
	fs_rdonly("/usr");

	// update /var directory in order to support multiple sandboxes running on the same root directory
	fs_var_lock();
	if (!arg_keep_var_tmp)
	  fs_var_tmp();
	if (!arg_writable_var_log)
		fs_var_log();
	else
		fs_rdwr("/var/log");

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
		pid_t child = fork();
		if (child < 0)
			errExit("fork");
		if (child == 0) {
			// drop privileges
			drop_privs(0);

			// create directory
			if (mkdir(dirname, 0700))
				errExit("mkdir");
			if (chmod(dirname, 0700) == -1)
				errExit("chmod");
			ASSERT_PERMS(dirname, getuid(), getgid(), 0700);
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}
		// wait for the child to finish
		waitpid(child, NULL, 0);
		if (stat(dirname, &s) == -1) {
			fprintf(stderr, "Error: cannot create ~/.firejail directory\n");
			exit(1);
		}
		fs_logger2("create", dirname);
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
		int fd = safe_fd(firejail, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
		if (fd == -1)
			errExit("safe_fd");
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
		if (mount("overlay", oroot, "overlay", MS_MGC_VAL, option) < 0)
			errExit("mounting overlayfs");

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
#ifdef HAVE_GCOV
	__gcov_flush();
#endif
	if (chroot(oroot) == -1)
		errExit("chroot");

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


#ifdef HAVE_CHROOT
// exit if error
void fs_check_chroot_dir(const char *rootdir) {
	EUID_ASSERT();
	assert(rootdir);
	struct stat s;
	int fd = -1;
	int parentfd = -1;

	char *overlay;
	if (asprintf(&overlay, "%s/.firejail", cfg.homedir) == -1)
		errExit("asprintf");
	if (strncmp(rootdir, overlay, strlen(overlay)) == 0) {
		fprintf(stderr, "Error: invalid chroot directory: no directories in %s are allowed\n", overlay);
		exit(1);
	}
	free(overlay);

	// fails if there is any symlink or if rootdir is not a directory
	parentfd = safe_fd(rootdir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (parentfd == -1) {
		fprintf(stderr, "Error: invalid chroot directory %s\n", rootdir);
		exit(1);
	}
	// rootdir has to be owned by root and is not allowed to be generally writable,
	// this also excludes /tmp, /var/tmp and such
	if (fstat(parentfd, &s) == -1)
		errExit("fstat");
	if (s.st_uid != 0) {
		fprintf(stderr, "Error: chroot directory should be owned by root\n");
		exit(1);
	}
	if (((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
		fprintf(stderr, "Error: only root user should be given write permission on chroot directory\n");
		exit(1);
	}

	// check /dev
	fd = openat(parentfd, "dev", O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open /dev in chroot directory\n");
		exit(1);
	}
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /dev should be a directory owned by root\n");
		exit(1);
	}
	close(fd);

	// check /var/tmp
	fd = openat(parentfd, "var/tmp", O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open /var/tmp in chroot directory\n");
		exit(1);
	}
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /var/tmp should be a directory owned by root\n");
		exit(1);
	}
	close(fd);

	// check /proc
	fd = openat(parentfd, "proc", O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open /proc in chroot directory\n");
		exit(1);
	}
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /proc should be a directory owned by root\n");
		exit(1);
	}
	close(fd);

	// check /tmp
	fd = openat(parentfd, "tmp", O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open /tmp in chroot directory\n");
		exit(1);
	}
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /tmp should be a directory owned by root\n");
		exit(1);
	}
	close(fd);

	// check /etc
	fd = openat(parentfd, "etc", O_PATH|O_CLOEXEC);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open /etc in chroot directory\n");
		exit(1);
	}
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
		fprintf(stderr, "Error: chroot /etc should be a directory owned by root\n");
		exit(1);
	}
	if (((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
		fprintf(stderr, "Error: only root user should be given write permission on chroot /etc\n");
		exit(1);
	}
	close(fd);

	// there should be no checking on <chrootdir>/etc/resolv.conf
	// the file is replaced with the real /etc/resolv.conf anyway
#if 0
	if (asprintf(&name, "%s/etc/resolv.conf", rootdir) == -1)
		errExit("asprintf");
	if (stat(name, &s) == 0) {
		if (s.st_uid != 0) {
			fprintf(stderr, "Error: chroot /etc/resolv.conf should be owned by root\n");
			exit(1);
		}
	}
	else {
		fprintf(stderr, "Error: chroot /etc/resolv.conf not found\n");
		exit(1);
	}
	// on Arch /etc/resolv.conf could be a symlink to /run/systemd/resolve/resolv.conf
	// on Ubuntu 17.04 /etc/resolv.conf could be a symlink to /run/resolveconf/resolv.conf
	if (is_link(name)) {
		// check the link points in chroot
		char *rname = realpath(name, NULL);
		if (!rname || strncmp(rname, rootdir, strlen(rootdir)) != 0) {
			fprintf(stderr, "Error: chroot /etc/resolv.conf is pointing outside chroot\n");
			exit(1);
		}
	}
	free(name);
#endif

	// check x11 socket directory
	if (getenv("FIREJAIL_X11")) {
		fd = openat(parentfd, "tmp/.X11-unix", O_PATH|O_CLOEXEC);
		if (fd == -1) {
			fprintf(stderr, "Error: cannot open /tmp/.X11-unix in chroot directory\n");
			exit(1);
		}
		if (fstat(fd, &s) == -1)
			errExit("fstat");
		if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
			fprintf(stderr, "Error: chroot /tmp/.X11-unix should be a directory owned by root\n");
			exit(1);
		}
		close(fd);
	}

	close(parentfd);
}

// chroot into an existing directory; mount exiting /dev and update /etc/resolv.conf
void fs_chroot(const char *rootdir) {
	assert(rootdir);

	// mount-bind a /dev in rootdir
	char *newdev;
	if (asprintf(&newdev, "%s/dev", rootdir) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("Mounting /dev on %s\n", newdev);
	if (mount("/dev", newdev, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");
	free(newdev);

	// x11
	if (getenv("FIREJAIL_X11")) {
		char *newx11;
		if (asprintf(&newx11, "%s/tmp/.X11-unix", rootdir) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("Mounting /tmp/.X11-unix on %s\n", newx11);
		if (mount("/tmp/.X11-unix", newx11, NULL, MS_BIND|MS_REC, NULL) < 0)
			errExit("mounting /tmp/.X11-unix");
		free(newx11);
	}

	// some older distros don't have a /run directory
	// create one by default
	char *rundir;
	if (asprintf(&rundir, "%s/run", rootdir) == -1)
		errExit("asprintf");
	struct stat s;
	if (lstat(rundir, &s) == 0) {
		if (S_ISLNK(s.st_mode)) {
			fprintf(stderr, "Error: chroot /run is a symbolic link\n");
			exit(1);
		}
		if (!S_ISDIR(s.st_mode) || s.st_uid != 0) {
			fprintf(stderr, "Error: chroot /run should be a directory owned by root\n");
			exit(1);
		}
		if (((S_IWGRP|S_IWOTH) & s.st_mode) != 0) {
			fprintf(stderr, "Error: only root user should be given write permission on chroot /run\n");
			exit(1);
		}
	}
	else {
		// several sandboxes could race to create /run
		if (mkdir(rundir, 0755) == -1 && errno != EEXIST)
			errExit("mkdir");
		ASSERT_PERMS(rundir, 0, 0, 0755);
	}
	free(rundir);

	// create /run/firejail directory in chroot
	if (asprintf(&rundir, "%s/run/firejail", rootdir) == -1)
		errExit("asprintf");
	if (mkdir(rundir, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	ASSERT_PERMS(rundir, 0, 0, 0755);
	free(rundir);

	// create /run/firejail/mnt directory in chroot and mount the current one
	if (asprintf(&rundir, "%s%s", rootdir, RUN_MNT_DIR) == -1)
		errExit("asprintf");
	if (mkdir(rundir, 0755) == -1 && errno != EEXIST)
		errExit("mkdir");
	ASSERT_PERMS(rundir, 0, 0, 0755);
	if (mount(RUN_MNT_DIR, rundir, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	free(rundir);

	// copy /etc/resolv.conf in chroot directory
	char *fname;
	if (asprintf(&fname, "%s/etc/resolv.conf", rootdir) == -1)
		errExit("asprintf");
	if (arg_debug)
		printf("Updating /etc/resolv.conf in %s\n", fname);
	unlink(fname);
	if (copy_file("/etc/resolv.conf", fname, 0, 0, 0644) == -1) // root needed
		fwarning("/etc/resolv.conf not initialized\n");
	free(fname);

	// chroot into the new directory
#ifdef HAVE_GCOV
	__gcov_flush();
#endif
	// mount the chroot dir on top of /run/firejail/mnt/oroot in order to reuse the apparmor rules for overlay
	// and chroot into this new directory
	if (arg_debug)
		printf("Chrooting into %s\n", rootdir);
	char *oroot = RUN_OVERLAY_ROOT;
	if (mkdir(oroot, 0755) == -1)
		errExit("mkdir");
	if (mount(rootdir, oroot, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting rootdir oroot");
	if (chroot(oroot) < 0)
		errExit("chroot");

	// create all other /run/firejail files and directories
	preproc_build_firejail_dir();

	// update /var directory in order to support multiple sandboxes running on the same root directory
//		if (!arg_private_dev)
//			fs_dev_shm();
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
}
#endif

// this function is called from sandbox.c before blacklist/whitelist functions
void fs_private_tmp(void) {
	// check XAUTHORITY file, KDE keeps it under /tmp
	char *xauth = getenv("XAUTHORITY");
	if (xauth) {
		char *rp = realpath(xauth, NULL);
		if (rp && strncmp(rp, "/tmp/", 5) == 0) {
			char *cmd;
			if (asprintf(&cmd, "whitelist %s", rp) == -1)
				errExit("asprintf");
			profile_add(cmd); // profile_add does not duplicate the string
		}
		if (rp)
			free(rp);
	}

	// whitelist x11 directory
	profile_add("whitelist /tmp/.X11-unix");

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
			profile_add(cmd); // profile_add does not duplicate the string
		}
	}
	closedir(dir);


}

// this function is called from sandbox.c before blacklist/whitelist functions
void fs_private_cache(void) {
	char *cache;
	if (asprintf(&cache, "%s/.cache", cfg.homedir) == -1)
		errExit("asprintf");
	// check if ~/.cache is a valid destination
	struct stat s;
	if (is_link(cache)) {
		fwarning("user .cache is a symbolic link, tmpfs not mounted\n");
		free(cache);
		return;
	}
	if (stat(cache, &s) == -1 || !S_ISDIR(s.st_mode)) {
		fwarning("no user .cache directory found, tmpfs not mounted\n");
		free(cache);
		return;
	}
	if (s.st_uid != getuid()) {
		fwarning("user .cache is not owned by current user, tmpfs not mounted\n");
		free(cache);
		return;
	}

	if (arg_debug)
		printf("Mounting tmpfs on %s\n", cache);
	// get a file descriptor for ~/.cache, fails if there is any symlink
	int fd = safe_fd(cache, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("safe_fd");
	// confirm that actual mount destination is owned by the user
	if (fstat(fd, &s) == -1 || s.st_uid != getuid())
		errExit("fstat");

	// mount a tmpfs on ~/.cache via the symbolic link in /proc/self/fd
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount("tmpfs", proc, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME | MS_REC, 0) < 0)
		errExit("mounting tmpfs");
	fs_logger2("tmpfs", cache);
	free(proc);
	close(fd);
	// check the last mount operation
	MountData *mdata = get_last_mount();
	assert(mdata);
	if (strcmp(mdata->fstype, "tmpfs") != 0 || strcmp(mdata->dir, cache) != 0)
		errLogExit("invalid .cache mount");

	// get a new file descriptor for ~/.cache, the old directory is masked by the tmpfs
	fd = safe_fd(cache, O_RDONLY|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("safe_fd");
	free(cache);
	// restore permissions
	SET_PERMS_FD(fd, s.st_uid, s.st_gid, s.st_mode);
	close(fd);
}

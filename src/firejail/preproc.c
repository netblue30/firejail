/*
 * Copyright (C) 2014-2025 Firejail Authors
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
#include <sys/file.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>

static const useconds_t    LOCK_INITIAL_SLEEP_USEC =  500U;
static const useconds_t    LOCK_MAX_SLEEP_USEC =   500000U;
static const unsigned long LOCK_TIMEOUT_USEC =    5000000U;

static int tmpfs_mounted = 0;
static volatile sig_atomic_t caught_tstp = 0;
static struct sigaction backup_tstp_directory_action;
static struct sigaction backup_tstp_network_action;

// We need to ignore SIGTSTP while we hold flock(s), otherwise that signal
// could stop this process before the locks are released, causing future
// firejail processes to be stuck during startup (see #6729).
static void handle_sigtstp(int signo) {
	(void) signo;

	if (arg_debug) {
		long pid = (long)getpid();
		printf("pid=%ld: caught SIGTSTP while holding a lock\n", pid);
	}
	caught_tstp++;
}

static void install_ignore_tstp_signal_handler(struct sigaction* backup_action) {
	struct sigaction sa_ignore;
	sa_ignore.sa_handler = handle_sigtstp;
	sa_ignore.sa_flags = 0;
	sigemptyset(&sa_ignore.sa_mask);

	if (sigaction(SIGTSTP, &sa_ignore, backup_action) == -1)
		errExit("sigaction");
}

static void uninstall_ignore_tstp_signal_handler(struct sigaction* backup_action) {
	if (sigaction(SIGTSTP, backup_action, NULL) == -1)
		errExit("sigaction");
	if (caught_tstp > 0) {
		if (arg_debug) {
			long pid = (long)getpid();
			printf("pid=%ld: resending caught SIGTSTP\n", pid);
		}

		// We can do this even in the case of nested locks, as in that
		// case caught_tstp will just be incremented and eventually the
		// outermost unlock will restore the original handler before
		// resending SIGTSTP.
		caught_tstp = 0;
		raise(SIGTSTP);
	}
}

static void preproc_lock_file(const char *path, int *lockfd_ptr) {
	assert(path);
	assert(lockfd_ptr);

	long pid = (long)getpid();
	if (arg_debug)
		printf("pid=%ld: locking %s ...\n", pid, path);

	if (*lockfd_ptr != -1) {
		if (arg_debug)
			printf("pid=%ld: already locked %s\n", pid, path);
		return;
	}

	int lockfd = open(path, O_WRONLY | O_CREAT | O_CLOEXEC, S_IRUSR | S_IWUSR);
	if (lockfd == -1) {
		fprintf(stderr, "Error: cannot create a lockfile at %s\n", path);
		errExit("open");
	}

	if (fchown(lockfd, 0, 0) == -1) {
		fprintf(stderr, "Error: cannot chown root:root %s\n", path);
		errExit("fchown");
	}

	unsigned long sleep_usec = LOCK_INITIAL_SLEEP_USEC;
	unsigned long wait_total = 0U;

	while (flock(lockfd, LOCK_EX | LOCK_NB) == -1) {
		if (errno == EWOULDBLOCK) {
			if (wait_total >= LOCK_TIMEOUT_USEC) {
				fprintf(stderr, "Error: timeout occurred while trying to lock %s\n", path);
				errExit("flock");
			}

			if (arg_debug) {
				printf("pid=%ld: sleeping %luus while trying to lock %s\n",
				       pid, sleep_usec, path);
			}

			usleep(sleep_usec);
			wait_total += sleep_usec;

			sleep_usec *= 2U;
			if (sleep_usec > LOCK_MAX_SLEEP_USEC)
				sleep_usec = LOCK_MAX_SLEEP_USEC;
		} else {
			fprintf(stderr, "Error: cannot lock %s\n", path);
			errExit("flock");
		}
	}

	*lockfd_ptr = lockfd;
	if (arg_debug)
		printf("pid=%ld: locked %s\n", pid, path);
}

static void preproc_unlock_file(const char *path, int *lockfd_ptr) {
	assert(path);
	assert(lockfd_ptr);

	long pid = (long)getpid();
	if (arg_debug)
		printf("pid=%ld: unlocking %s ...\n", pid, path);

	int lockfd = *lockfd_ptr;
	if (lockfd == -1) {
		if (arg_debug)
			printf("pid=%ld: already unlocked %s\n", pid, path);
		return;
	}

	if (flock(lockfd, LOCK_UN) == -1) {
		fprintf(stderr, "Error: cannot unlock %s\n", path);
		errExit("flock");
	}

	if (close(lockfd) == -1) {
		fprintf(stderr, "Error: cannot close %s\n", path);
		errExit("close");
	}

	*lockfd_ptr = -1;
	if (arg_debug)
		printf("pid=%ld: unlocked %s\n", pid, path);
}

void preproc_lock_firejail_dir(void) {
	install_ignore_tstp_signal_handler(&backup_tstp_directory_action);
	preproc_lock_file(RUN_DIRECTORY_LOCK_FILE, &lockfd_directory);
}

void preproc_unlock_firejail_dir(void) {
	preproc_unlock_file(RUN_DIRECTORY_LOCK_FILE, &lockfd_directory);
	uninstall_ignore_tstp_signal_handler(&backup_tstp_directory_action);
}

void preproc_lock_firejail_network_dir(void) {
	install_ignore_tstp_signal_handler(&backup_tstp_network_action);
	preproc_lock_file(RUN_NETWORK_LOCK_FILE, &lockfd_network);
}

void preproc_unlock_firejail_network_dir(void) {
	preproc_unlock_file(RUN_NETWORK_LOCK_FILE, &lockfd_network);
	uninstall_ignore_tstp_signal_handler(&backup_tstp_network_action);
}

// build /run/firejail directory
//
// Note: This creates the base directory of the rundir lockfile;
// it should be called before preproc_lock_firejail_dir().
void preproc_build_firejail_dir_unlocked(void) {
	struct stat s;

	// CentOS 6 doesn't have /run directory
	if (stat(RUN_FIREJAIL_BASEDIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_BASEDIR, 0755);
	}

	create_empty_dir_as_root(RUN_FIREJAIL_DIR, 0755);
}

// build directory hierarchy under /run/firejail
//
// Note: Remounts have timing hazards. This function should
// only be called after acquiring the directory lock via
// preproc_lock_firejail_dir().
void preproc_build_firejail_dir_locked(void) {
	create_empty_dir_as_root(RUN_FIREJAIL_NETWORK_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_BANDWIDTH_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_NAME_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_PROFILE_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_X11_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_APPIMAGE_DIR, 0755);
	create_empty_dir_as_root(RUN_FIREJAIL_LIB_DIR, 0755);
	create_empty_dir_as_root(RUN_MNT_DIR, 0755);

	// restricted search permission
	// only root should be able to lock files in this directory
	create_empty_dir_as_root(RUN_FIREJAIL_SANDBOX_DIR, 0700);

#ifdef HAVE_DBUSPROXY
	create_empty_dir_as_root(RUN_FIREJAIL_DBUS_DIR, 0755);
	fs_remount(RUN_FIREJAIL_DBUS_DIR, MOUNT_NOEXEC, 0);
#endif

	create_empty_dir_as_root(RUN_RO_DIR, S_IRUSR);
	fs_remount(RUN_RO_DIR, MOUNT_READONLY, 0);

	create_empty_file_as_root(RUN_RO_FILE, S_IRUSR);
	fs_remount(RUN_RO_FILE, MOUNT_READONLY, 0);
}

// build /run/firejail/mnt directory
void preproc_mount_mnt_dir(void) {
	// mount tmpfs on top of /run/firejail/mnt
	if (!tmpfs_mounted) {
		if (arg_debug)
			printf("Mounting tmpfs on %s directory\n", RUN_MNT_DIR);
		if (mount("tmpfs", RUN_MNT_DIR, "tmpfs", MS_NOSUID | MS_STRICTATIME,  "mode=755,gid=0") < 0)
			errExit("mounting /run/firejail/mnt");
		tmpfs_mounted = 1;
		fs_logger2("tmpfs", RUN_MNT_DIR);

		// open and mount trace file while there are no user-writable files in RUN_MNT_DIR
		if (arg_tracefile)
			fs_tracefile();

		create_empty_dir_as_root(RUN_SECCOMP_DIR, 0755);

		if (arg_seccomp_block_secondary)
			copy_file(PATH_SECCOMP_BLOCK_SECONDARY, RUN_SECCOMP_BLOCK_SECONDARY, getuid(), getgid(), 0644); // root needed
		else {
			//copy default seccomp files
			copy_file(PATH_SECCOMP_32, RUN_SECCOMP_32, getuid(), getgid(), 0644); // root needed
		}
		if (arg_allow_debuggers) {
			copy_file(PATH_SECCOMP_DEFAULT_DEBUG, RUN_SECCOMP_CFG, getuid(), getgid(), 0644); // root needed
			copy_file(PATH_SECCOMP_DEBUG_32, RUN_SECCOMP_32, getuid(), getgid(), 0644); // root needed
		} else
			copy_file(PATH_SECCOMP_DEFAULT, RUN_SECCOMP_CFG, getuid(), getgid(), 0644); // root needed

		if (arg_memory_deny_write_execute) {
			copy_file(PATH_SECCOMP_MDWX, RUN_SECCOMP_MDWX, getuid(), getgid(), 0644); // root needed
			copy_file(PATH_SECCOMP_MDWX_32, RUN_SECCOMP_MDWX_32, getuid(), getgid(), 0644); // root needed
		}
		// as root, create empty RUN_SECCOMP_PROTOCOL, RUN_SECCOMP_NS and RUN_SECCOMP_POSTEXEC files
		create_empty_file_as_root(RUN_SECCOMP_PROTOCOL, 0644);
		if (set_perms(RUN_SECCOMP_PROTOCOL, getuid(), getgid(), 0644))
			errExit("set_perms");
		if (cfg.restrict_namespaces) {
			copy_file(PATH_SECCOMP_NAMESPACES, RUN_SECCOMP_NS, getuid(), getgid(), 0644); // root needed
			copy_file(PATH_SECCOMP_NAMESPACES_32, RUN_SECCOMP_NS_32, getuid(), getgid(), 0644); // root needed
#if 0
			create_empty_file_as_root(RUN_SECCOMP_NS, 0644);
			if (set_perms(RUN_SECCOMP_NS, getuid(), getgid(), 0644))
				errExit("set_perms");
			create_empty_file_as_root(RUN_SECCOMP_NS_32, 0644);
			if (set_perms(RUN_SECCOMP_NS_32, getuid(), getgid(), 0644))
				errExit("set_perms");
#endif
		}
		create_empty_file_as_root(RUN_SECCOMP_POSTEXEC, 0644);
		if (set_perms(RUN_SECCOMP_POSTEXEC, getuid(), getgid(), 0644))
			errExit("set_perms");
		create_empty_file_as_root(RUN_SECCOMP_POSTEXEC_32, 0644);
		if (set_perms(RUN_SECCOMP_POSTEXEC_32, getuid(), getgid(), 0644))
			errExit("set_perms");
	}
}

static void clean_dir(const char *name, int *pidarr, int start_pid, int max_pids) {
	DIR *dir;
	if (!(dir = opendir(name))) {
		fwarning("cannot clean %s directory\n", name);
		return; // we live to fight another day!
	}

	// clean leftover files
	struct dirent *entry;
	char *end;
	while ((entry = readdir(dir)) != NULL) {
		pid_t pid = strtol(entry->d_name, &end, 10);
		pid %= max_pids;
		if (end == entry->d_name || *end)
			continue;

		if (pid < start_pid)
			continue;
		if (pidarr[pid] == 0)
			delete_run_files(pid);
	}
	closedir(dir);
}


// clean run directory
void preproc_clean_run(void) {
	int max_pids=32769;
	int start_pid = 100;
	// extract real max_pids
	FILE *fp = fopen("/proc/sys/kernel/pid_max", "re");
	if (fp) {
		int val;
		if (fscanf(fp, "%d", &val) == 1) {
			if (val > 4194304)	// this is the max value supported on 64 bit Linux kernels
				val = 4194304;
			if (val >= max_pids)
				max_pids = val + 1;
		}
		fclose(fp);
	}
	int *pidarr = malloc(max_pids * sizeof(int));
	if (!pidarr)
		errExit("malloc");

	memset(pidarr, 0, max_pids * sizeof(int));

	// open /proc directory
	DIR *dir;
	if (!(dir = opendir("/proc"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/proc"))) {
			fprintf(stderr, "Error: cannot open /proc directory\n");
			exit(1);
		}
	}

	// read /proc and populate pidarr with all active processes
	struct dirent *entry;
	char *end;
	while ((entry = readdir(dir)) != NULL) {
		pid_t pid = strtol(entry->d_name, &end, 10);
		pid %= max_pids;
		if (end == entry->d_name || *end)
			continue;

		if (pid < start_pid)
			continue;
		pidarr[pid] = 1;
	}
	closedir(dir);

	// clean profile and name directories
	clean_dir(RUN_FIREJAIL_PROFILE_DIR, pidarr, start_pid, max_pids);
	clean_dir(RUN_FIREJAIL_NAME_DIR, pidarr, start_pid, max_pids);

	free(pidarr);
}

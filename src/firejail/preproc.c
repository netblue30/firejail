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
#include <sys/types.h>
#include <dirent.h>

static int tmpfs_mounted = 0;

// build /run/firejail directory
void preproc_build_firejail_dir(void) {
	struct stat s;

	// CentOS 6 doesn't have /run directory
	if (stat(RUN_FIREJAIL_BASEDIR, &s)) {
		create_empty_dir_as_root(RUN_FIREJAIL_BASEDIR, 0755);
	}

	create_empty_dir_as_root(RUN_FIREJAIL_DIR, 0755);
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

	create_empty_dir_as_root(RUN_FIREJAIL_DBUS_DIR, 0755);
	fs_remount(RUN_FIREJAIL_DBUS_DIR, MOUNT_NOEXEC, 0);

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

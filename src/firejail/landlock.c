/*
 * Copyright (C) 2014-2023 Firejail Authors
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

#ifdef HAVE_LANDLOCK
#include "firejail.h"
#include <linux/landlock.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>

static int ll_ruleset_fd = -1;

int ll_get_fd(void) {
	return ll_ruleset_fd;
}

#ifndef landlock_create_ruleset
static inline int
landlock_create_ruleset(const struct landlock_ruleset_attr *const attr,
                        const size_t size, const __u32 flags) {
	return syscall(__NR_landlock_create_ruleset, attr, size, flags);
}
#endif

#ifndef landlock_add_rule
static inline int
landlock_add_rule(const int ruleset_fd,
                  const enum landlock_rule_type rule_type,
                  const void *const rule_attr,
                  const __u32 flags) {
	return syscall(__NR_landlock_add_rule, ruleset_fd, rule_type,
	               rule_attr, flags);
}
#endif

#ifndef landlock_restrict_self
static inline int
landlock_restrict_self(const int ruleset_fd, const __u32 flags) {
	return syscall(__NR_landlock_restrict_self, ruleset_fd, flags);
}
#endif

static int ll_create_full_ruleset() {
	struct landlock_ruleset_attr attr;
	attr.handled_access_fs =
		LANDLOCK_ACCESS_FS_EXECUTE |
		LANDLOCK_ACCESS_FS_MAKE_BLOCK |
		LANDLOCK_ACCESS_FS_MAKE_CHAR |
		LANDLOCK_ACCESS_FS_MAKE_DIR |
		LANDLOCK_ACCESS_FS_MAKE_FIFO |
		LANDLOCK_ACCESS_FS_MAKE_REG |
		LANDLOCK_ACCESS_FS_MAKE_SOCK |
		LANDLOCK_ACCESS_FS_MAKE_SYM |
		LANDLOCK_ACCESS_FS_READ_DIR |
		LANDLOCK_ACCESS_FS_READ_FILE |
		LANDLOCK_ACCESS_FS_REMOVE_DIR |
		LANDLOCK_ACCESS_FS_REMOVE_FILE |
		LANDLOCK_ACCESS_FS_WRITE_FILE;

	ll_ruleset_fd = landlock_create_ruleset(&attr, sizeof(attr), 0);
	if (ll_ruleset_fd < 0) {
		fprintf(stderr, "Error: failed to create a Landlock ruleset: %s\n",
		        strerror(errno));
	}
	return ll_ruleset_fd;
}

int ll_read(const char *allowed_path) {
	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	int error;
	int allowed_fd = open(allowed_path, O_PATH | O_CLOEXEC);
	if (allowed_fd < 0) {
		if (arg_debug) {
			fprintf(stderr, "%s: failed to open %s: %s\n",
			        __func__, allowed_path, strerror(errno));
		}
		return 0;
	}
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access =
		LANDLOCK_ACCESS_FS_READ_DIR |
		LANDLOCK_ACCESS_FS_READ_FILE;

	error = landlock_add_rule(ll_ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
	                          &target, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to add Landlock rule for %s: %s\n",
		        __func__, allowed_path, strerror(errno));
	}
	close(allowed_fd);
	return error;
}

int ll_write(const char *allowed_path) {
	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	int error;
	int allowed_fd = open(allowed_path, O_PATH | O_CLOEXEC);
	if (allowed_fd < 0) {
		if (arg_debug) {
			fprintf(stderr, "%s: failed to open %s: %s\n",
			        __func__, allowed_path, strerror(errno));
		}
		return 0;
	}
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access =
		LANDLOCK_ACCESS_FS_MAKE_DIR |
		LANDLOCK_ACCESS_FS_MAKE_REG |
		LANDLOCK_ACCESS_FS_MAKE_SYM |
		LANDLOCK_ACCESS_FS_REMOVE_DIR |
		LANDLOCK_ACCESS_FS_REMOVE_FILE |
		LANDLOCK_ACCESS_FS_WRITE_FILE;

	error = landlock_add_rule(ll_ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
	                          &target, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to add Landlock rule for %s: %s\n",
		        __func__, allowed_path, strerror(errno));
	}
	close(allowed_fd);
	return error;
}

int ll_special(const char *allowed_path) {
	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	int error;
	int allowed_fd = open(allowed_path, O_PATH | O_CLOEXEC);
	if (allowed_fd < 0) {
		if (arg_debug) {
			fprintf(stderr, "%s: failed to open %s: %s\n",
			        __func__, allowed_path, strerror(errno));
		}
		return 0;
	}
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access =
		LANDLOCK_ACCESS_FS_MAKE_BLOCK |
		LANDLOCK_ACCESS_FS_MAKE_CHAR |
		LANDLOCK_ACCESS_FS_MAKE_FIFO |
		LANDLOCK_ACCESS_FS_MAKE_SOCK;

	error = landlock_add_rule(ll_ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
	                          &target, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to add Landlock rule for %s: %s\n",
		        __func__, allowed_path, strerror(errno));
	}
	close(allowed_fd);
	return error;
}

int ll_exec(const char *allowed_path) {
	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	int error;
	int allowed_fd = open(allowed_path, O_PATH | O_CLOEXEC);
	if (allowed_fd < 0) {
		if (arg_debug) {
			fprintf(stderr, "%s: failed to open %s: %s\n",
			        __func__, allowed_path, strerror(errno));
		}
		return 0;
	}
	struct landlock_path_beneath_attr target;
	target.parent_fd = allowed_fd;
	target.allowed_access =
		LANDLOCK_ACCESS_FS_EXECUTE;

	error = landlock_add_rule(ll_ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
	                          &target, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to add Landlock rule for %s: %s\n",
		        __func__, allowed_path, strerror(errno));
	}
	close(allowed_fd);
	return error;
}

int ll_basic_system(void) {
	assert(cfg.homedir);

	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	int error =
		ll_read("/bin/") ||
		ll_read("/dev/") ||
		ll_read("/etc/") ||
		ll_read("/lib/") ||
		ll_read("/opt/") ||
		ll_read("/usr/") ||
		ll_read("/var/") ||
		ll_read(cfg.homedir) ||

		ll_write("/dev/") ||
		ll_write(cfg.homedir) ||

		ll_exec("/bin/") ||
		ll_exec("/lib/") ||
		ll_exec("/opt/") ||
		ll_exec("/usr/");

	if (error) {
		fprintf(stderr, "Error: %s: failed to set --landlock rules\n",
		        __func__);
	}
	return error;
}

int ll_restrict(__u32 flags) {
	if (ll_ruleset_fd == -1)
		return 0;

	int error;
	error = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to restrict privileges: %s\n",
		        __func__, strerror(errno));
		goto out;
	}
	error = landlock_restrict_self(ll_ruleset_fd, flags);
	if (error) {
		fprintf(stderr, "Error: %s: failed to enforce Landlock: %s\n",
		        __func__, strerror(errno));
		goto out;
	}
	if (arg_debug)
		printf("%s: Enforcing Landlock\n", __func__);
out:
	close(ll_ruleset_fd);
	return error;
}

#endif /* HAVE_LANDLOCK */

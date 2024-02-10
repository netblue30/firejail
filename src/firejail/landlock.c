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

#ifdef HAVE_LANDLOCK
#include "firejail.h"
#include <linux/landlock.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>

static int ll_ruleset_fd = -1;
static int ll_abi = -1;

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

static int ll_is_supported(void) {
	if (ll_abi != -1)
		goto out;

	ll_abi = landlock_create_ruleset(NULL, 0,
	                                 LANDLOCK_CREATE_RULESET_VERSION);
	if (ll_abi < 1) {
		ll_abi = 0;
		fprintf(stderr, "Warning: %s: Landlock is disabled or not supported: %s, "
		                "ignoring landlock commands\n",
		        __func__, strerror(errno));
		goto out;
	}

	if (arg_debug) {
		fprintf(stderr, "%s: Detected Landlock ABI version %d\n",
		        __func__, ll_abi);
	}
out:
	return ll_abi;
}

static int ll_create_full_ruleset(void) {
	struct landlock_ruleset_attr attr = {0};
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

	if (arg_debug) {
		fprintf(stderr, "%s: Creating Landlock ruleset (abi=%d fs=%llx)\n",
		        __func__, ll_abi, attr.handled_access_fs);
	}

	int ruleset_fd = landlock_create_ruleset(&attr, sizeof(attr), 0);
	if (ruleset_fd < 0) {
		fprintf(stderr, "Error: %s: failed to create Landlock ruleset "
		                "(abi=%d fs=%llx): %s\n",
		        __func__, ll_abi, attr.handled_access_fs,
		        strerror(errno));
	}
	return ruleset_fd;
}

static void _ll_fs(const char *allowed_path, const __u64 allowed_access,
                   const char *caller) {
	if (ll_ruleset_fd == -1)
		ll_ruleset_fd = ll_create_full_ruleset();

	if (arg_debug) {
		fprintf(stderr, "%s: Adding Landlock rule (abi=%d fs=%llx) for %s\n",
		        caller, ll_abi, allowed_access, allowed_path);
	}

	int allowed_fd = open(allowed_path, O_PATH | O_CLOEXEC);
	if (allowed_fd < 0) {
		if (arg_debug) {
			fprintf(stderr, "%s: failed to open %s: %s\n",
			        caller, allowed_path, strerror(errno));
		}
		return;
	}

	struct landlock_path_beneath_attr target = {0};
	target.parent_fd = allowed_fd;
	target.allowed_access = allowed_access;
	int error = landlock_add_rule(ll_ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
	                          &target, 0);
	if (error) {
		fprintf(stderr, "Error: %s: failed to add Landlock rule "
		                "(abi=%d fs=%llx) for %s: %s\n",
		        caller, ll_abi, allowed_access, allowed_path,
		        strerror(errno));
	}
	close(allowed_fd);
}

static void ll_fs(const char *allowed_path, const __u64 allowed_access,
                  const char *caller) {
	char *expanded_path;

	// ${PATH} macro is not included by default in expand_macros()
	if (strncmp(allowed_path, "${PATH}", 7) == 0) {
		char **paths = build_paths();
		int i = 0;
		while (paths[i] != NULL) {
			if (asprintf(&expanded_path, "%s%s", paths[i], allowed_path + 7) == -1)
				errExit("asprintf");
			if (arg_debug)
				fprintf(stderr, "landlock expand path %s\n", expanded_path);

			_ll_fs(expanded_path, allowed_access, caller);
			free(expanded_path);
			i++;
		}
		return;
	}


	expanded_path = expand_macros(allowed_path);
	_ll_fs(expanded_path, allowed_access, caller);
	free(expanded_path);
}

static void ll_fs_read(const char *allowed_path) {
	__u64 allowed_access =
		LANDLOCK_ACCESS_FS_READ_DIR |
		LANDLOCK_ACCESS_FS_READ_FILE;

	ll_fs(allowed_path, allowed_access, __func__);
}

static void ll_fs_write(const char *allowed_path) {
	__u64 allowed_access =
		LANDLOCK_ACCESS_FS_MAKE_DIR |
		LANDLOCK_ACCESS_FS_MAKE_REG |
		LANDLOCK_ACCESS_FS_MAKE_SYM |
		LANDLOCK_ACCESS_FS_REMOVE_DIR |
		LANDLOCK_ACCESS_FS_REMOVE_FILE |
		LANDLOCK_ACCESS_FS_WRITE_FILE;

	ll_fs(allowed_path, allowed_access, __func__);
}

static void ll_fs_makeipc(const char *allowed_path) {
	__u64 allowed_access =
		LANDLOCK_ACCESS_FS_MAKE_FIFO |
		LANDLOCK_ACCESS_FS_MAKE_SOCK;

	ll_fs(allowed_path, allowed_access, __func__);
}

static void ll_fs_makedev(const char *allowed_path) {
	__u64 allowed_access =
		LANDLOCK_ACCESS_FS_MAKE_BLOCK |
		LANDLOCK_ACCESS_FS_MAKE_CHAR;

	ll_fs(allowed_path, allowed_access, __func__);
}

static void ll_fs_exec(const char *allowed_path) {
	__u64 allowed_access =
		LANDLOCK_ACCESS_FS_EXECUTE;

	ll_fs(allowed_path, allowed_access, __func__);
}

int ll_restrict(uint32_t flags) {
	if (!ll_is_supported())
		return 0;

	timetrace_start();

	if (arg_debug)
		fprintf(stderr, "%s: Starting Landlock restrict\n", __func__);

	void (*fnc[])(const char *) = {
		ll_fs_read,
		ll_fs_write,
		ll_fs_makeipc,
		ll_fs_makedev,
		ll_fs_exec,
		NULL
	};

	LandlockEntry *ptr = cfg.lprofile;
	int rules = 0;
	while (ptr) {
		rules++;
		fnc[ptr->type](ptr->data);
		ptr = ptr->next;
	}

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
	fmessage("%d Landlock rules initialized in %0.2f ms\n", rules, timetrace_end());

out:
	close(ll_ruleset_fd);
	return error;
}

void ll_add_profile(int type, const char *data) {
	assert(type >= 0);
	assert(type < LL_MAX);
	assert(data);

	while (*data == ' ' || *data == '\t')
		data++;

	LandlockEntry *entry = malloc(sizeof(LandlockEntry));
	if (!entry)
		errExit("malloc");
	memset(entry, 0, sizeof(LandlockEntry));
	entry->type = type;
	entry->data = strdup(data);
	if (!entry->data)
		errExit("strdup");

	// add entry to the list
	if (cfg.lprofile == NULL) {
		cfg.lprofile = entry;
		return;
	}
	LandlockEntry *ptr = cfg.lprofile;
	while (ptr->next != NULL)
		ptr = ptr->next;
	ptr->next = entry;
}

#endif /* HAVE_LANDLOCK */

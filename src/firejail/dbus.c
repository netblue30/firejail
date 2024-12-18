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
#ifdef HAVE_DBUSPROXY
#include "firejail.h"
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#ifndef O_PATH
#define O_PATH 010000000
#endif

#define DBUS_SOCKET_PATH_PREFIX "unix:path="
#define DBUS_USER_SOCKET_FORMAT "/run/user/%d/bus"
#define DBUS_USER_SOCKET_FORMAT2 "/run/user/%d/dbus/user_bus_socket"
#define DBUS_SYSTEM_SOCKET "/run/dbus/system_bus_socket"
#define DBUS_SESSION_BUS_ADDRESS_ENV "DBUS_SESSION_BUS_ADDRESS"
#define DBUS_SYSTEM_BUS_ADDRESS_ENV "DBUS_SYSTEM_BUS_ADDRESS"
#define DBUS_USER_DIR_FORMAT RUN_FIREJAIL_DBUS_DIR "/%d"
#define DBUS_USER_PROXY_SOCKET_FORMAT DBUS_USER_DIR_FORMAT "/%d-user"
#define DBUS_SYSTEM_PROXY_SOCKET_FORMAT DBUS_USER_DIR_FORMAT "/%d-system"
#define DBUS_MAX_NAME_LENGTH 255
// moved to include/common.h - #define XDG_DBUS_PROXY_PATH "/usr/bin/xdg-dbus-proxy"

static pid_t dbus_proxy_pid = 0;
static int dbus_proxy_status_fd = -1;
static char *dbus_user_proxy_socket = NULL;
static char *dbus_system_proxy_socket = NULL;

static int check_bus_or_interface_name(const char *name, int hyphens_allowed) {
	unsigned long length = strlen(name);
	if (length == 0 || length > DBUS_MAX_NAME_LENGTH)
		return 0;
	const char *p = name;
	int segments = 1;
	int in_segment = 0;
	while (*p) {
		int alpha = (*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z');
		int digit = *p >= '0' && *p <= '9';
		if (in_segment) {
			if (*p == '.') {
				++segments;
				in_segment = 0;
			} else if (!alpha && !digit && *p != '_' && (!hyphens_allowed || *p != '-')) {
				return 0;
			}
		}
		else {
			if (*p == '*') {
				return *(p + 1) == '\0';
			} else if (!alpha && *p != '_' && (!hyphens_allowed || *p != '-')) {
				return 0;
			}
			in_segment = 1;
		}
		++p;
	}
	return in_segment && segments >= 2;
}

static int check_object_path(const char *path) {
	unsigned long length = strlen(path);
	if (length == 0 || path[0] != '/')
		return 0;
	// The root path "/" is the only path allowed to have a trailing slash.
	if (length == 1)
		return 1;
	const char *p = path + 1;
	int segments = 1;
	int in_segment = 0;
	while (*p) {
		int alpha = (*p >= 'a' && *p <= 'z') || (*p >= 'A' && *p <= 'Z');
		int digit = *p >= '0' && *p <= '9';
		if (in_segment) {
			if (*p == '/') {
				++segments;
				in_segment = 0;
			} else if (!alpha && !digit && *p != '_') {
				return 0;
			}
		}
		else {
			if (*p == '*') {
				return *(p + 1) == '\0';
			} else if (!alpha && *p != '_') {
				return 0;
			}
			in_segment = 1;
		}
		++p;
	}
	return in_segment && segments >= 1;
}

int dbus_check_name(const char *name) {
	return check_bus_or_interface_name(name, 1);
}

int dbus_check_call_rule(const char *rule) {
	char buf[DBUS_MAX_NAME_LENGTH + 1];
	char *name_end = strchr(rule, '=');
	if (name_end == NULL)
		return 0;
	size_t name_length = (size_t) (name_end - rule);
	if (name_length > DBUS_MAX_NAME_LENGTH)
		return 0;
	strncpy(buf, rule, (size_t) name_length);
	buf[name_length] = '\0';
	if (!dbus_check_name(buf))
		return 0;
	++name_end;
	char *interface_end = strchr(name_end, '@');
	if (interface_end == NULL)
		return check_bus_or_interface_name(name_end, 0);
	size_t interface_length = (size_t) (interface_end - name_end);
	if (interface_length > DBUS_MAX_NAME_LENGTH)
		return 0;
	if (interface_length > 0) {
		strncpy(buf, name_end, interface_length);
		buf[interface_length] = '\0';
		if (!check_bus_or_interface_name(buf, 0))
			return 0;
	}
	return check_object_path(interface_end + 1);
}

static void dbus_check_bus_profile(char const *prefix, DbusPolicy *policy) {
	if (*policy == DBUS_POLICY_FILTER) {
		struct stat s;
		if (stat(XDG_DBUS_PROXY_PATH, &s) == -1) {
			if (errno == ENOENT) {
				fprintf(stderr,
						"Warning: " XDG_DBUS_PROXY_PATH
						" was not found, downgrading %s policy to allow.\n"
						"To enable DBus filtering, install the xdg-dbus-proxy "
						"program.\n", prefix);
				*policy = DBUS_POLICY_ALLOW;
			} else {
				errExit("stat");
			}
		} else {
			// No need to warn on profile entries.
			return;
		}
	}

	size_t prefix_length = strlen(prefix);
	ProfileEntry *it = cfg.profile;
	int num_matches = 0;
	const char *first_match = NULL;
	while (it) {
		char *data = it->data;
		it = it->next;
		if (strncmp(prefix, data, prefix_length) == 0) {
			++num_matches;
			if (first_match == NULL)
				first_match = data;
		}
	}

	if (num_matches > 0 && !arg_quiet) {
		assert(first_match != NULL);
		if (num_matches == 1) {
			fprintf(stderr, "Ignoring \"%s\".\n", first_match);
		} else if (num_matches == 2) {
			fprintf(stderr, "Ignoring \"%s\" and 1 other %s filter rule.\n",
					first_match, prefix);
		} else {
			fprintf(stderr, "Ignoring \"%s\" and %d other %s filter rules.\n",
					first_match, num_matches - 1, prefix);
		}
	}
}

void dbus_check_profile(void) {
	dbus_check_bus_profile("dbus-user", &arg_dbus_user);
	dbus_check_bus_profile("dbus-system", &arg_dbus_system);
}

static void write_arg(int fd, char const *format, ...) {
	va_list ap;
	va_start(ap, format);
	char *arg;
	int length = vasprintf(&arg, format, ap);
	va_end(ap);
	if (length == -1)
		errExit("vasprintf");
	length++;
	if (arg_debug)
		printf("xdg-dbus-proxy arg: %s\n", arg);
	if (write(fd, arg, (size_t) length) != (ssize_t) length)
		errExit("write");
	free(arg);
}

static void write_profile(int fd, char const *prefix) {
	size_t prefix_length = strlen(prefix);
	ProfileEntry *it = cfg.profile;
	while (it) {
		char *data = it->data;
		it = it->next;
		if (strncmp(prefix, data, prefix_length) != 0)
			continue;
		data += prefix_length;
		int arg_length = 0;
		while (data[arg_length] != '\0' && data[arg_length] != ' ')
			arg_length++;
		if (data[arg_length] != ' ')
			continue;
		write_arg(fd, "--%.*s=%s", arg_length, data, &data[arg_length + 1]);
	}
}

static void dbus_create_user_dir(void) {
	char *path;
	if (asprintf(&path, DBUS_USER_DIR_FORMAT, (int) getuid()) == -1)
		errExit("asprintf");
	struct stat s;
	mode_t mode = 0700;
	uid_t uid = getuid();
	gid_t gid = getgid();
	if (stat(path, &s)) {
		if (arg_debug)
			printf("Creating %s directory for DBus proxy sockets\n", path);
		if (mkdir(path, mode) == -1 && errno != EEXIST)
			errExit("mkdir");
		if (set_perms(path, uid, gid, mode))
			errExit("set_perms");
		ASSERT_PERMS(path, uid, gid, mode);
	}
	free(path);
}

static char *find_user_socket_by_format(char *format) {
	char *dbus_user_socket;
	if (asprintf(&dbus_user_socket, format, (int) getuid()) == -1)
		errExit("asprintf");
	struct stat s;
	if (lstat(dbus_user_socket, &s) == -1)
		goto fail;
	if (!S_ISSOCK(s.st_mode))
		goto fail;
	return dbus_user_socket;
fail:
	free(dbus_user_socket);
	return NULL;
}

static char *find_user_socket(void) {
	char *socket1 = find_user_socket_by_format(DBUS_USER_SOCKET_FORMAT);
	if (socket1 != NULL)
		return socket1;
	char *socket2 = find_user_socket_by_format(DBUS_USER_SOCKET_FORMAT2);
	if (socket2 != NULL)
		return socket2;
	fprintf(stderr, "DBus user socket was not found.\n");
	exit(1);
}

void dbus_proxy_start(void) {
	dbus_create_user_dir();

	EUID_USER();

	int status_pipe[2];
	if (pipe(status_pipe) == -1)
		errExit("pipe");
	dbus_proxy_status_fd = status_pipe[0];

	int args_pipe[2];
	if (pipe(args_pipe) == -1)
		errExit("pipe");

	dbus_proxy_pid = fork();
	if (dbus_proxy_pid == -1)
		errExit("fork");
	if (dbus_proxy_pid == 0) {
		// close open files
		int keep[2];
		keep[0] = status_pipe[1];
		keep[1] = args_pipe[0];
		close_all(keep, ARRAY_SIZE(keep));

		if (arg_dbus_log_file != NULL) {
			int output_fd = creat(arg_dbus_log_file, 0666);
			if (output_fd < 0)
				errExit("creat");
			if (output_fd != STDOUT_FILENO) {
				if (dup2(output_fd, STDOUT_FILENO) != STDOUT_FILENO)
					errExit("dup2");
				close(output_fd);
			}
		}
		close(STDIN_FILENO);
		char *args[4] = {XDG_DBUS_PROXY_PATH, NULL, NULL, NULL};
		if (asprintf(&args[1], "--fd=%d", status_pipe[1]) == -1
			|| asprintf(&args[2], "--args=%d", args_pipe[0]) == -1)
			errExit("asprintf");
		if (arg_debug)
			printf("starting xdg-dbus-proxy\n");
		sbox_exec_v(SBOX_USER | SBOX_SECCOMP | SBOX_CAPS_NONE | SBOX_KEEP_FDS, args);
	} else {
		if (close(status_pipe[1]) == -1 || close(args_pipe[0]) == -1)
			errExit("close");

		if (arg_dbus_user == DBUS_POLICY_FILTER) {
			const char *user_env = env_get(DBUS_SESSION_BUS_ADDRESS_ENV);
			if (user_env == NULL) {
				char *dbus_user_socket = find_user_socket();
				write_arg(args_pipe[1], DBUS_SOCKET_PATH_PREFIX "%s",
						  dbus_user_socket);
				free(dbus_user_socket);
			} else {
				write_arg(args_pipe[1], "%s", user_env);
			}
			if (asprintf(&dbus_user_proxy_socket, DBUS_USER_PROXY_SOCKET_FORMAT,
						 (int) getuid(), (int) getpid()) == -1)
				errExit("asprintf");
			write_arg(args_pipe[1], "%s", dbus_user_proxy_socket);
			if (arg_dbus_log_user) {
				write_arg(args_pipe[1], "--log");
			}
			write_arg(args_pipe[1], "--filter");
			write_profile(args_pipe[1], "dbus-user.");
		}

		if (arg_dbus_system == DBUS_POLICY_FILTER) {
			const char *system_env = env_get(DBUS_SYSTEM_BUS_ADDRESS_ENV);
			if (system_env == NULL) {
				write_arg(args_pipe[1],
						  DBUS_SOCKET_PATH_PREFIX DBUS_SYSTEM_SOCKET);
			} else {
				write_arg(args_pipe[1], "%s", system_env);
			}
			if (asprintf(&dbus_system_proxy_socket, DBUS_SYSTEM_PROXY_SOCKET_FORMAT,
						 (int) getuid(), (int) getpid()) == -1)
				errExit("asprintf");
			write_arg(args_pipe[1], "%s", dbus_system_proxy_socket);
			if (arg_dbus_log_system) {
				write_arg(args_pipe[1], "--log");
			}
			write_arg(args_pipe[1], "--filter");
			write_profile(args_pipe[1], "dbus-system.");
		}

		if (close(args_pipe[1]) == -1)
			errExit("close");
		char buf[1];
		ssize_t read_bytes = read(status_pipe[0], buf, 1);
		switch (read_bytes) {
		case -1:
			errExit("read");
			break;
		case 0:
			fprintf(stderr, "xdg-dbus-proxy closed pipe unexpectedly\n");
			// Wait for the subordinate process to write any errors to stderr and exit.
			waitpid(dbus_proxy_pid, NULL, 0);
			exit(-1);
			break;
		case 1:
			if (arg_debug)
				printf("xdg-dbus-proxy initialized\n");
			break;
		default:
			assert(0);
		}
	}
}

void dbus_proxy_stop(void) {
	if (dbus_proxy_pid == 0)
		return;
	assert(dbus_proxy_status_fd >= 0);
	if (close(dbus_proxy_status_fd) == -1)
		errExit("close");
	int status;
	if (waitpid(dbus_proxy_pid, &status, 0) == -1)
		errExit("waitpid");
	if (WIFEXITED(status) && WEXITSTATUS(status) != 0)
		fwarning("xdg-dbus-proxy returned %s\n", WEXITSTATUS(status));
	dbus_proxy_pid = 0;
	dbus_proxy_status_fd = -1;
	if (dbus_user_proxy_socket != NULL) {
		free(dbus_user_proxy_socket);
		dbus_user_proxy_socket = NULL;
	}
	if (dbus_system_proxy_socket != NULL) {
		free(dbus_system_proxy_socket);
		dbus_system_proxy_socket = NULL;
	}
}

static void socket_overlay(char *socket_path, char *proxy_path) {
	int fd = safer_openat(-1, proxy_path, O_PATH | O_NOFOLLOW | O_CLOEXEC);
	if (fd == -1)
		errExit("opening DBus proxy socket");
	struct stat s;
	if (fstat(fd, &s) == -1)
		errExit("fstat");
	if (!S_ISSOCK(s.st_mode)) {
		errno = ENOTSOCK;
		errExit("mounting DBus proxy socket");
	}
	if (bind_mount_fd_to_path(fd, socket_path))
		errExit("mount bind");
	close(fd);
}

static const char *get_socket_env(const char *name) {
	const char *value = env_get(name);
	if (value == NULL)
		return NULL;
	if (strncmp(value, DBUS_SOCKET_PATH_PREFIX,
				strlen(DBUS_SOCKET_PATH_PREFIX)) == 0)
		return value + strlen(DBUS_SOCKET_PATH_PREFIX);
	return NULL;
}

void dbus_set_session_bus_env(void) {
	env_store_name_val(DBUS_SESSION_BUS_ADDRESS_ENV,
			   DBUS_SOCKET_PATH_PREFIX RUN_DBUS_USER_SOCKET, SETENV);
}

void dbus_set_system_bus_env(void) {
	env_store_name_val(DBUS_SYSTEM_BUS_ADDRESS_ENV,
			   DBUS_SOCKET_PATH_PREFIX RUN_DBUS_SYSTEM_SOCKET, SETENV);
}

static void disable_socket_dir(void) {
	struct stat s;
	if (stat(RUN_FIREJAIL_DBUS_DIR, &s) == 0)
		disable_file_or_dir(RUN_FIREJAIL_DBUS_DIR);
}

void dbus_apply_policy(void) {
	EUID_ROOT();

	if (arg_dbus_user == DBUS_POLICY_ALLOW && arg_dbus_system == DBUS_POLICY_ALLOW) {
		disable_socket_dir();
		return;
	}

	if (!checkcfg(CFG_DBUS)) {
		disable_socket_dir();
		fwarning("D-Bus handling is disabled in Firejail configuration file\n");
		return;
	}

	create_empty_dir_as_root(RUN_DBUS_DIR, 0755);

	if (arg_dbus_user != DBUS_POLICY_ALLOW) {
		create_empty_file_as_root(RUN_DBUS_USER_SOCKET, 0600);

		if (arg_dbus_user == DBUS_POLICY_FILTER) {
			assert(dbus_user_proxy_socket != NULL);
			socket_overlay(RUN_DBUS_USER_SOCKET, dbus_user_proxy_socket);
			free(dbus_user_proxy_socket);
		}

		char *dbus_user_socket;
		if (asprintf(&dbus_user_socket, DBUS_USER_SOCKET_FORMAT,
					 (int) getuid()) == -1)
			errExit("asprintf");
		disable_file_or_dir(dbus_user_socket);

		char *dbus_user_socket2;
		if (asprintf(&dbus_user_socket2, DBUS_USER_SOCKET_FORMAT2,
					 (int) getuid()) == -1)
			errExit("asprintf");
		disable_file_or_dir(dbus_user_socket2);

		const char *user_env = get_socket_env(DBUS_SESSION_BUS_ADDRESS_ENV);
		if (user_env != NULL && strcmp(user_env, dbus_user_socket) != 0 &&
			strcmp(user_env, dbus_user_socket2) != 0)
			disable_file_or_dir(user_env);

		free(dbus_user_socket);
		free(dbus_user_socket2);

		dbus_set_session_bus_env();

		// blacklist the dbus-launch user directory
		char *path;
		if (asprintf(&path, "%s/.dbus", cfg.homedir) == -1)
			errExit("asprintf");
		disable_file_or_dir(path);
		free(path);
	}

	if (arg_dbus_system != DBUS_POLICY_ALLOW) {
		create_empty_file_as_root(RUN_DBUS_SYSTEM_SOCKET, 0600);

		if (arg_dbus_system == DBUS_POLICY_FILTER) {
			assert(dbus_system_proxy_socket != NULL);
			socket_overlay(RUN_DBUS_SYSTEM_SOCKET, dbus_system_proxy_socket);
			free(dbus_system_proxy_socket);
		}

		disable_file_or_dir(DBUS_SYSTEM_SOCKET);

		const char *system_env = get_socket_env(DBUS_SYSTEM_BUS_ADDRESS_ENV);
		if (system_env != NULL && strcmp(system_env, DBUS_SYSTEM_SOCKET) != 0)
			disable_file_or_dir(system_env);

		dbus_set_system_bus_env();
	}

	// Only disable access to /run/firejail/dbus here, when the sockets have been bind-mounted.
	disable_socket_dir();

	// look for a possible abstract unix socket

	// --net=none
	if (arg_nonetwork)
		return;

	// --net=eth0
	if (any_bridge_configured())
		return;

	// --protocol=unix
	if (cfg.protocol && !strstr(cfg.protocol, "unix"))
		return;

	fwarning("An abstract unix socket for session D-BUS might still be available. Use --net or remove unix from --protocol set.\n");
}
#endif // HAVE_DBUSPROXY

/*
 * Copyright (C) 2014-2020 Firejail Authors
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
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>

#define DBUS_SOCKET_PATH_PREFIX "unix:path="
#define DBUS_USER_SOCKET_FORMAT "/run/user/%d/bus"
#define DBUS_USER_SOCKET_PATH_FORMAT DBUS_SOCKET_PATH_PREFIX DBUS_USER_SOCKET_FORMAT
#define DBUS_SYSTEM_SOCKET "/run/dbus/system_bus_socket"
#define DBUS_SYSTEM_SOCKET_PATH DBUS_SOCKET_PATH_PREFIX DBUS_SYSTEM_SOCKET
#define DBUS_SESSION_BUS_ADDRESS_ENV "DBUS_SESSION_BUS_ADDRESS"
#define DBUS_USER_PROXY_SOCKET_FORMAT RUN_FIREJAIL_DBUS_DIR "/%d-user"
#define DBUS_SYSTEM_PROXY_SOCKET_FORMAT RUN_FIREJAIL_DBUS_DIR "/%d-system"

static pid_t dbus_proxy_pid = 0;
static int dbus_proxy_status_fd = -1;
static char *dbus_user_proxy_socket = NULL;
static char *dbus_system_proxy_socket = NULL;

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

void dbus_proxy_start(void) {
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
		int i;
		for (i = 3; i < FIREJAIL_MAX_FD; i++) {
			if (i != status_pipe[1] && i != args_pipe[0])
				close(i); // close open files
		}
		char *args[4] = {"/usr/bin/xdg-dbus-proxy", NULL, NULL, NULL};
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
			char *dbus_user_path_env = getenv(DBUS_SESSION_BUS_ADDRESS_ENV);
			if (dbus_user_path_env == NULL) {
				write_arg(args_pipe[1], DBUS_USER_SOCKET_PATH_FORMAT, getuid());
			} else {
				write_arg(args_pipe[1], dbus_user_path_env);
			}
			if (asprintf(&dbus_user_proxy_socket, DBUS_USER_PROXY_SOCKET_FORMAT, (int) getpid()) == -1)
				errExit("asprintf");
			write_arg(args_pipe[1], dbus_user_proxy_socket);
			write_arg(args_pipe[1], "--filter");
			// TODO Write filter rules to pipe
		}

		if (arg_dbus_system == DBUS_POLICY_FILTER) {
			write_arg(args_pipe[1], DBUS_SYSTEM_SOCKET_PATH);
			if (asprintf(&dbus_system_proxy_socket, DBUS_SYSTEM_PROXY_SOCKET_FORMAT, (int) getpid()) == -1)
				errExit("asprintf");
			write_arg(args_pipe[1], dbus_system_proxy_socket);
			write_arg(args_pipe[1], "--filter");
			// TODO Write filter rules to pipe
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
	if (mount(proxy_path, socket_path, NULL, MS_BIND, NULL) == -1)
		errExit("mount");
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

	char *dbus_new_user_socket_path;
	if (asprintf(&dbus_new_user_socket_path, DBUS_USER_SOCKET_PATH_FORMAT, getuid()) == -1)
		errExit("asprintf");
	char *dbus_new_user_socket = dbus_new_user_socket_path + strlen(DBUS_SOCKET_PATH_PREFIX);
	char *dbus_user_path_env = getenv(DBUS_SESSION_BUS_ADDRESS_ENV);
	char *dbus_orig_user_socket_path;
	if (dbus_user_path_env != NULL
		&& strncmp(DBUS_SOCKET_PATH_PREFIX, dbus_user_path_env, strlen(DBUS_SOCKET_PATH_PREFIX)) == 0) {
		dbus_orig_user_socket_path = dbus_user_path_env;
	} else {
		dbus_orig_user_socket_path = dbus_new_user_socket_path;
	}
	char *dbus_orig_user_socket = dbus_user_path_env + strlen(DBUS_SOCKET_PATH_PREFIX);

	if (arg_dbus_user != DBUS_POLICY_ALLOW) {
		if (arg_dbus_user == DBUS_POLICY_FILTER) {
			assert(dbus_user_proxy_socket != NULL);
			socket_overlay(dbus_new_user_socket, dbus_user_proxy_socket);
			free(dbus_user_proxy_socket);
		} else { // arg_dbus_user == DBUS_POLICY_BLOCK
			disable_file_or_dir(dbus_new_user_socket);
		}

		if (strcmp(dbus_orig_user_socket, dbus_new_user_socket) != 0)
			disable_file_or_dir(dbus_orig_user_socket);

		// set a new environment variable:
		// DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/<UID>/bus
		if (setenv(DBUS_SESSION_BUS_ADDRESS_ENV, dbus_new_user_socket_path, 1) == -1) {
			fprintf(stderr, "Error: cannot modify " DBUS_SESSION_BUS_ADDRESS_ENV " required by --dbus-user\n");
			exit(1);
		}

		// blacklist the dbus-launch user directory
		char *path;
		if (asprintf(&path, "%s/.dbus", cfg.homedir) == -1)
			errExit("asprintf");
		disable_file_or_dir(path);
		free(path);
	}

	free(dbus_new_user_socket_path);

	if (arg_dbus_system == DBUS_POLICY_FILTER) {
		assert(dbus_system_proxy_socket != NULL);
		socket_overlay(DBUS_SYSTEM_SOCKET, dbus_system_proxy_socket);
		free(dbus_system_proxy_socket);
	} else if (arg_dbus_system == DBUS_POLICY_BLOCK) {
		disable_file_or_dir(DBUS_SYSTEM_SOCKET);
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
#ifdef HAVE_SECCOMP
	if (cfg.protocol && !strstr(cfg.protocol, "unix"))
		return;
#endif

	fwarning("An abstract unix socket for session D-BUS might still be available. Use --net or remove unix from --protocol set.\n");
}

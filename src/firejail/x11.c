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
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/statvfs.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/mount.h>
#include <sys/wait.h>
#include <errno.h>
#include <limits.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif


// Parse the DISPLAY environment variable and return a display number.
// Returns -1 if DISPLAY is not set, or is set to anything other than :ddd.
int x11_display(void) {
	const char *display_str = env_get("DISPLAY");
	char *endp;
	unsigned long display;

	if (!display_str) {
		if (arg_debug)
			fputs("DISPLAY is not set\n", stderr);
		return -1;
	}

	if (display_str[0] != ':' || display_str[1] < '0' || display_str[1] > '9') {
		if (arg_debug)
			fprintf(stderr, "unsupported DISPLAY form '%s'\n", display_str);
		return -1;
	}

	errno = 0;
	display = strtoul(display_str+1, &endp, 10);
	// handling DISPLAY=:0 and also :0.0
	if (endp == display_str+1 || (*endp != '\0' && *endp != '.')) {
		if (arg_debug)
			fprintf(stderr, "unsupported DISPLAY form '%s'\n", display_str);
		return -1;
	}
	if (errno || display > (unsigned long)INT_MAX) {
		if (arg_debug)
			fprintf(stderr, "display number %s is outside the valid range\n",
				display_str+1);
		return -1;
	}

	if (arg_debug)
		fprintf(stderr, "DISPLAY=%s parsed as %lu\n", display_str, display);

	return (int)display;
}


#ifdef HAVE_X11
// check for X11 abstract sockets
static int x11_abstract_sockets_present(void) {

	EUID_ROOT();				  // grsecurity fix
	FILE *fp = fopen("/proc/net/unix", "re");
	if (!fp)
		errExit("fopen");
	EUID_USER();

	char *linebuf = 0;
	size_t bufsz = 0;
	int found = 0;
	errno = 0;

	for (;;) {
		if (getline(&linebuf, &bufsz, fp) == -1) {
			if (errno)
				errExit("getline");
			break;
		}
		// The last space-separated field in 'linebuf' is the
		// pathname of the socket.  Abstract sockets' pathnames
		// all begin with '@/', normal ones begin with '/'.
		char *p = strrchr(linebuf, ' ');
		if (!p) {
			fputs("error parsing /proc/net/unix\n", stderr);
			exit(1);
		}
		if (strncmp(p+1, "@/tmp/.X11-unix/", 16) == 0) {
			found = 1;
			break;
		}
	}

	free(linebuf);
	fclose(fp);
	return found;
}


// Choose a random, unallocated display number.  This has an inherent
// and unavoidable TOCTOU race, since we cannot create either the
// socket or a lockfile ourselves.
static int random_display_number(void) {
	int display;
	int found = 0;
	int i;

	struct sockaddr_un sa;
	// The -1 here is because we need space to inject a
	// leading nul byte.
	int sun_pathmax = (int)(sizeof sa.sun_path - 1);
	assert((size_t)sun_pathmax == sizeof sa.sun_path - 1);
	int sun_pathlen;

	int sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
	if (sockfd == -1)
		errExit("socket");

	for (i = 0; i < 100; i++) {
		display = rand() % (X11_DISPLAY_END - X11_DISPLAY_START) + X11_DISPLAY_START;

		// The display number might be claimed by a server listening
		// in _either_ the normal or the abstract namespace; they
		// don't necessarily do both.  The easiest way to check is
		// to try to connect, both ways.
		memset(&sa, 0, sizeof sa);
		sa.sun_family = AF_UNIX;
		sun_pathlen = snprintf(sa.sun_path, sun_pathmax,
			"/tmp/.X11-unix/X%d", display);
		if (sun_pathlen >= sun_pathmax) {
			fprintf(stderr, "sun_path too small for display :%d"
				" (only %d bytes usable)\n", display, sun_pathmax);
			exit(1);
		}

		if (connect(sockfd, (struct sockaddr *)&sa,
		offsetof(struct sockaddr_un, sun_path) + sun_pathlen + 1) == 0) {
			close(sockfd);
			sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
			if (sockfd == -1)
				errExit("socket");
			continue;
		}
		if (errno != ECONNREFUSED && errno != ENOENT)
			errExit("connect");

		// Name not claimed in the normal namespace; now try it
		// in the abstract namespace.  Note that abstract-namespace
		// names are NOT nul-terminated; they extend to the length
		// specified as the third argument to 'connect'.
		memmove(sa.sun_path + 1, sa.sun_path, sun_pathlen + 1);
		sa.sun_path[0] = '\0';
		if (connect(sockfd, (struct sockaddr *)&sa,
		offsetof(struct sockaddr_un, sun_path) + 1 + sun_pathlen) == 0) {
			close(sockfd);
			sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
			if (sockfd == -1)
				errExit("socket");
			continue;
		}
		if (errno != ECONNREFUSED && errno != ENOENT)
			errExit("connect");

		// This display number is unclaimed.  Of course, it could
		// be claimed before we get around to doing it...
		found = 1;
		break;
	}
	close(sockfd);

	if (!found) {
		fputs("Error: cannot find an unallocated X11 display number, "
			"exiting...\n", stderr);
		exit(1);
	}
	return display;
}
#endif

#ifdef HAVE_X11
void x11_start_xvfb(int argc, char **argv) {
	EUID_ASSERT();
	int i;
	pid_t jail = 0;
	pid_t server = 0;

	env_store_name_val("FIREJAIL_X11", "yes", SETENV);

	// never try to run X servers as root!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}
	drop_privs(0);

	// check xvfb
	if (!program_in_path("Xvfb")) {
		fprintf(stderr, "\nError: Xvfb program was not found in /usr/bin directory, please install it:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xvfb\n");
		fprintf(stderr, "   Arch: sudo pacman -S xorg-server-xvfb\n");
		fprintf(stderr, "   Fedora: sudo dnf install xorg-x11-server-Xvfb\n");
		exit(0);
	}

	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	assert(xvfb_screen);

	char *server_argv[256] = {		  // rest initialized to NULL
		"Xvfb", display_str, "-screen", "0", xvfb_screen
	};
	unsigned pos = 0;
	while (server_argv[pos] != NULL) pos++;
	assert(xvfb_extra_params);		  // should be "" if empty

	// parse xvfb_extra_params
	// very basic quoting support
	char *temp = strdup(xvfb_extra_params);
	if (*xvfb_extra_params != '\0') {
		if (!temp)
			errExit("strdup");
		bool dquote = false;
		bool squote = false;
		for (i = 0; i < (int) strlen(xvfb_extra_params); i++) {
			if (temp[i] == '\"') {
				dquote = !dquote;
						  // replace closing quote by \0
				if (dquote) temp[i] = '\0';
			}
			if (temp[i] == '\'') {
				squote = !squote;
						  // replace closing quote by \0
				if (squote) temp[i] = '\0';
			}
			if (!dquote && !squote && temp[i] == ' ') temp[i] = '\0';
			if (dquote && squote) {
				fprintf(stderr, "Error: mixed quoting found while parsing xvfb_extra_params\n");
				exit(1);
			}
		}
		if (dquote) {
			fprintf(stderr, "Error: unclosed quote found while parsing xvfb_extra_params\n");
			exit(1);
		}

		server_argv[pos++] = temp;
		for (i = 0; i < (int) strlen(xvfb_extra_params)-1; i++) {
			if (pos >= (sizeof(server_argv)/sizeof(*server_argv)) - 2) {
				fprintf(stderr, "Error: arg count limit exceeded while parsing xvfb_extra_params\n");
				exit(1);
			}
			if (temp[i] == '\0' && (temp[i+1] == '\"' || temp[i+1] == '\'')) server_argv[pos++] = temp + i + 2;
			else if (temp[i] == '\0' && temp[i+1] != '\0') server_argv[pos++] = temp + i + 1;
		}
	}

	server_argv[pos++] = NULL;

	assert(pos < (sizeof(server_argv)/sizeof(*server_argv))); // no overrun
	assert(server_argv[pos-1] == NULL);	  // last element is null

	if (arg_debug) {
		size_t i = 0;
		printf("\n*** Starting xvfb server:");
		while (server_argv[i]!=NULL) {
			printf(" \"%s\"", server_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	// remove --x11 arg
	char *jail_argv[argc+2];
	int j = 0;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--x11", 5) == 0)
			continue;
		jail_argv[j] = argv[i];
		j++;
	}
	jail_argv[j] = NULL;

	assert(j < argc+2);			  // no overrun

	if (arg_debug) {
		size_t i = 0;
		printf("\n*** Starting xvfb client:");
		while (jail_argv[i]!=NULL) {
			printf(" \"%s\"", jail_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	server = fork();
	if (server < 0)
		errExit("fork");
	if (server == 0) {
		if (arg_debug)
			printf("Starting xvfb...\n");

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(server_argv[0], server_argv);
		perror("execvp");
		_exit(1);
	}

	if (arg_debug)
		printf("xvfb server pid %d\n", server);

	// check X11 socket
	char *fname;
	if (asprintf(&fname, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	int n = 0;
	// wait for x11 server to start
	while (++n < 10) {
		sleep(1);
		if (access(fname, F_OK) == 0)
			break;
	};

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xvfb\n");
		exit(1);
	}
	free(fname);

	assert(display_str);
	env_store_name_val("DISPLAY", display_str, SETENV);
	// run attach command
	jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		fmessage("\n*** Attaching to Xvfb display %d ***\n\n", display);

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(jail_argv[0], jail_argv);
		perror("execvp");
		_exit(1);
	}

	// cleanup
	free(display_str);
	free(temp);

	// wait for either server or jail termination
	pid_t pid = wait(NULL);

	// see which process terminated and kill other
	if (pid == server) {
		kill(jail, SIGTERM);
	}
	else if (pid == jail) {
		kill(server, SIGTERM);
	}

	// without this closing Xephyr window may mess your terminal:
	// "monitoring" process will release terminal before
	// jail process ends and releases terminal
	wait(NULL);				  // fulneral

	exit(0);
}


static char *extract_setting(int argc, char **argv, const char *argument) {
	int i;
	int len = strlen(argument);

	for (i = 1; i < argc; i++) {
		if (strncmp(argv[i], argument, len) == 0) {
			return argv[i] + len;
		}

		// detect end of firejail params
		if (strcmp(argv[i], "--") == 0)
			break;
		if (strncmp(argv[i], "--", 2) != 0)
			break;
	}

	return NULL;
}


//$ Xephyr -ac -br -noreset -screen 800x600 :22 &
//$ DISPLAY=:22 firejail --net=eth0 --blacklist=/tmp/.X11-unix/x0 firefox
void x11_start_xephyr(int argc, char **argv) {
	EUID_ASSERT();
	int i;
	pid_t jail = 0;
	pid_t server = 0;

	// default xephyr screen can be overwritten by a --xephyr-screen= command line option
	char *newscreen = extract_setting(argc, argv, "--xephyr-screen=");
	if (newscreen)
		xephyr_screen = newscreen;

	env_store_name_val("FIREJAIL_X11", "yes", SETENV);

	// unfortunately, xephyr does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}
	drop_privs(0);

	// check xephyr
	if (!program_in_path("Xephyr")) {
		fprintf(stderr, "\nError: Xephyr program was not found in /usr/bin directory, please install it:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xserver-xephyr\n");
		fprintf(stderr, "   Arch: sudo pacman -S xorg-server-xephyr\n");
		fprintf(stderr, "   Fedora: sudo dnf install xorg-x11-server-Xephyr\n");
		exit(0);
	}

	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	assert(xephyr_screen);
	char *server_argv[256] = {		  // rest initialized to NULL
		"Xephyr", "-ac", "-br", "-noreset", "-screen", xephyr_screen
	};
	unsigned pos = 0;
	while (server_argv[pos] != NULL) pos++;
	if (checkcfg(CFG_XEPHYR_WINDOW_TITLE)) {
		server_argv[pos++] = "-title";
		server_argv[pos++] = "firejail x11 sandbox";
	}

	assert(xephyr_extra_params);		  // should be "" if empty

	// parse xephyr_extra_params
	// very basic quoting support
	char *temp = strdup(xephyr_extra_params);
	if (*xephyr_extra_params != '\0') {
		if (!temp)
			errExit("strdup");
		bool dquote = false;
		bool squote = false;
		for (i = 0; i < (int) strlen(xephyr_extra_params); i++) {
			if (temp[i] == '\"') {
				dquote = !dquote;
						  // replace closing quote by \0
				if (dquote) temp[i] = '\0';
			}
			if (temp[i] == '\'') {
				squote = !squote;
						  // replace closing quote by \0
				if (squote) temp[i] = '\0';
			}
			if (!dquote && !squote && temp[i] == ' ') temp[i] = '\0';
			if (dquote && squote) {
				fprintf(stderr, "Error: mixed quoting found while parsing xephyr_extra_params\n");
				exit(1);
			}
		}
		if (dquote) {
			fprintf(stderr, "Error: unclosed quote found while parsing xephyr_extra_params\n");
			exit(1);
		}

		server_argv[pos++] = temp;
		for (i = 0; i < (int) strlen(xephyr_extra_params)-1; i++) {
			if (pos >= (sizeof(server_argv)/sizeof(*server_argv)) - 2) {
				fprintf(stderr, "Error: arg count limit exceeded while parsing xephyr_extra_params\n");
				exit(1);
			}
			if (temp[i] == '\0' && (temp[i+1] == '\"' || temp[i+1] == '\'')) {
				server_argv[pos++] = temp + i + 2;
			}
			else if (temp[i] == '\0' && temp[i+1] != '\0') {
				server_argv[pos++] = temp + i + 1;
			}
		}
	}

	server_argv[pos++] = display_str;
	server_argv[pos++] = NULL;

						  // no overrun
	assert(pos < (sizeof(server_argv)/sizeof(*server_argv)));
	assert(server_argv[pos-1] == NULL);	  // last element is null

	{
		size_t i = 0;
		printf("\n*** Starting xephyr server:");
		while (server_argv[i]!=NULL) {
			printf(" \"%s\"", server_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	// remove --x11 arg
	char *jail_argv[argc+2];
	int j = 0;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--x11", 5) == 0)
			continue;
		jail_argv[j] = argv[i];
		j++;
	}
	jail_argv[j] = NULL;

	assert(j < argc+2);			  // no overrun

	if (arg_debug) {
		size_t i = 0;
		printf("*** Starting xephyr client:");
		while (jail_argv[i]!=NULL) {
			printf(" \"%s\"", jail_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	server = fork();
	if (server < 0)
		errExit("fork");
	if (server == 0) {
		if (arg_debug)
			printf("Starting xephyr...\n");

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(server_argv[0], server_argv);
		perror("execvp");
		_exit(1);
	}

	if (arg_debug)
		printf("xephyr server pid %d\n", server);

	// check X11 socket
	char *fname;
	if (asprintf(&fname, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	int n = 0;
	// wait for x11 server to start
	while (++n < 10) {
		sleep(1);
		if (access(fname, F_OK) == 0)
			break;
	};

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xephyr\n");
		exit(1);
	}
	free(fname);

	assert(display_str);
	env_store_name_val("DISPLAY", display_str, SETENV);
	// run attach command
	jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		if (!arg_quiet)
			printf("\n*** Attaching to Xephyr display %d ***\n\n", display);

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);
		assert(env_get("LD_PRELOAD") == NULL);
		execvp(jail_argv[0], jail_argv);
		perror("execvp");
		_exit(1);
	}

	// cleanup
	free(display_str);
	free(temp);

	// wait for either server or jail termination
	pid_t pid = wait(NULL);

	// see which process terminated and kill other
	if (pid == server) {
		kill(jail, SIGTERM);
	}
	else if (pid == jail) {
		kill(server, SIGTERM);
	}

	// without this closing Xephyr window may mess your terminal:
	// "monitoring" process will release terminal before
	// jail process ends and releases terminal
	wait(NULL);				  // fulneral

	exit(0);
}


// this function returns the string that will appear in the window title when xpra is being used
// this string may include one of these items:
// *  the "--name" argument, if specified
// *  the basename portion of the "--private" directory, if specified
// note: the malloc() is leaking, but this is a small string allocated one time only during startup, so don't care
static char * get_title_arg_str() {

	char * title_arg_str = NULL;

	const char * title_start = "--title=firejail x11 sandbox";
	const char * title_sep = " ";

	// use the "--name" argument if it was explicitly specified
	if ((cfg.name != NULL) && (strlen(cfg.name) > 0)) {

		title_arg_str = malloc(strlen(title_start) + strlen(title_sep) + strlen(cfg.name) + 1);
		if (title_arg_str == NULL) {
			fprintf(stderr, "Error: malloc() failed to allocate memory\n");
			exit(1);
		}

		strcpy(title_arg_str, title_start);
		strcat(title_arg_str, title_sep);
		strcat(title_arg_str, cfg.name);
	}

	// use the "--private" argument if it was explicitly specified
	else if ((cfg.home_private != NULL) && (strlen(cfg.home_private) > 0)) {

		const char * base_out = gnu_basename(cfg.home_private);

		title_arg_str = malloc(strlen(title_start) + strlen(title_sep) + strlen(base_out) + 1);
		if (title_arg_str == NULL) {
			fprintf(stderr, "Error: malloc() failed to allocate memory\n");
			exit(1);
		}

		strcpy(title_arg_str, title_start);
		strcat(title_arg_str, title_sep);
		strcat(title_arg_str, base_out);
	}

	// default
	else {
		title_arg_str = malloc(strlen(title_start) + 1);
		if (title_arg_str == NULL) {
			fprintf(stderr, "Error: malloc() failed to allocate memory\n");
			exit(1);
		}

		strcpy(title_arg_str, title_start);
	}

	return title_arg_str;
}


static void __attribute__((noreturn)) x11_start_xpra_old(int argc, char **argv, int display, char *display_str) {
	EUID_ASSERT();
	int i;
	pid_t client = 0;
	pid_t server = 0;

	// build the start command
	char *server_argv[256] = {		  // rest initialized to NULL
		"xpra", "start", display_str, "--no-daemon",
	};
	unsigned pos = 0;
	while (server_argv[pos] != NULL) pos++;

	assert(xpra_extra_params);		  // should be "" if empty

	// parse xephyr_extra_params
	// very basic quoting support
	char *temp = strdup(xpra_extra_params);
	if (*xpra_extra_params != '\0') {
		if (!temp)
			errExit("strdup");
		bool dquote = false;
		bool squote = false;
		for (i = 0; i < (int) strlen(xpra_extra_params); i++) {
			if (temp[i] == '\"') {
				dquote = !dquote;
						  // replace closing quote by \0
				if (dquote) temp[i] = '\0';
			}
			if (temp[i] == '\'') {
				squote = !squote;
						  // replace closing quote by \0
				if (squote) temp[i] = '\0';
			}
			if (!dquote && !squote && temp[i] == ' ') temp[i] = '\0';
			if (dquote && squote) {
				fprintf(stderr, "Error: mixed quoting found while parsing xpra_extra_params\n");
				exit(1);
			}
		}
		if (dquote) {
			fprintf(stderr, "Error: unclosed quote found while parsing xpra_extra_params\n");
			exit(1);
		}

		server_argv[pos++] = temp;
		for (i = 0; i < (int) strlen(xpra_extra_params)-1; i++) {
			if (pos >= (sizeof(server_argv)/sizeof(*server_argv)) - 2) {
				fprintf(stderr, "Error: arg count limit exceeded while parsing xpra_extra_params\n");
				exit(1);
			}
			if (temp[i] == '\0' && (temp[i+1] == '\"' || temp[i+1] == '\'')) {
				server_argv[pos++] = temp + i + 2;
			}
			else if (temp[i] == '\0' && temp[i+1] != '\0') {
				server_argv[pos++] = temp + i + 1;
			}
		}
	}

	server_argv[pos++] = NULL;

						  // no overrun
	assert(pos < (sizeof(server_argv)/sizeof(*server_argv)));
	assert(server_argv[pos-1] == NULL);	  // last element is null

	if (arg_debug) {
		size_t i = 0;
		printf("\n*** Starting xpra server: ");
		while (server_argv[i]!=NULL) {
			printf(" \"%s\"", server_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	int fd_null = -1;
	if (arg_quiet) {
		fd_null = open("/dev/null", O_RDWR);
		if (fd_null == -1)
			errExit("open");
	}

	// start
	server = fork();
	if (server < 0)
		errExit("fork");
	if (server == 0) {
		if (arg_debug)
			printf("Starting xpra...\n");

		if (arg_quiet && fd_null != -1) {
			dup2(fd_null,0);
			dup2(fd_null,1);
			dup2(fd_null,2);
		}

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);
		assert(env_get("LD_PRELOAD") == NULL);
		execvp(server_argv[0], server_argv);
		perror("execvp");
		_exit(1);
	}

	// add a small delay, on some systems it takes some time for the server to start
	sleep(5);

	// check X11 socket
	char *fname;
	if (asprintf(&fname, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	int n = 0;
	// wait for x11 server to start
	while (++n < 10) {
		sleep(1);
		if (access(fname, F_OK) == 0)
			break;
	}

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xpra\n");
		exit(1);
	}
	free(fname);

	// build attach command

	char * title_arg_str = get_title_arg_str();

	char *attach_argv[] = { "xpra", title_arg_str, "attach", display_str, NULL };

	// run attach command
	client = fork();
	if (client < 0)
		errExit("fork");
	if (client == 0) {
		if (arg_quiet && fd_null != -1) {
			dup2(fd_null,0);
			dup2(fd_null,1);
			dup2(fd_null,2);
		}

		fmessage("\n*** Attaching to xpra display %d ***\n\n", display);

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(attach_argv[0], attach_argv);
		perror("execvp");
		_exit(1);
	}

	assert(display_str);
	env_store_name_val("DISPLAY", display_str, SETENV);

	// build jail command
	char *firejail_argv[argc+2];
	pos = 0;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--x11", 5) == 0)
			continue;
		firejail_argv[pos] = argv[i];
		pos++;
	}
	firejail_argv[pos] = NULL;

	assert((int) pos < (argc+2));
	assert(!firejail_argv[pos]);

	// start jail
	pid_t jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);

		// restore original environment variables
		env_apply_all();

		if (firejail_argv[0])		  // shut up llvm scan-build
			execvp(firejail_argv[0], firejail_argv);
		perror("execvp");
		exit(1);
	}

	fmessage("Xpra server pid %d, xpra client pid %d, jail %d\n", server, client, jail);

	sleep(1);				  // adding a delay in order to let the server start

	// wait for jail or server to end
	while (1) {
		pid_t pid = wait(NULL);

		if (pid == jail) {
			char *stop_argv[] = { "xpra", "stop", display_str, NULL };
			pid_t stop = fork();
			if (stop < 0)
				errExit("fork");
			if (stop == 0) {
				if (arg_quiet && fd_null != -1) {
					dup2(fd_null,0);
					dup2(fd_null,1);
					dup2(fd_null,2);
				}

				// restore original environment variables
				env_apply_all();

				// running without privileges - see drop_privs call above
				assert(env_get("LD_PRELOAD") == NULL);
				assert(getenv("LD_PRELOAD") == NULL);
				execvp(stop_argv[0], stop_argv);
				perror("execvp");
				_exit(1);
			}

			// wait for xpra server to stop, 10 seconds limit
			while (++n < 10) {
				sleep(1);
				pid = waitpid(server, NULL, WNOHANG);
				if (pid == server)
					break;
			}

			if (arg_debug) {
				if (n == 10)
					printf("failed to stop xpra server gracefully\n");
				else
					printf("xpra server successfully stopped in %d secs\n", n);
			}

			// kill xpra server and xpra client
			kill(client, SIGTERM);
			kill(server, SIGTERM);
			exit(0);
		}
		else if (pid == server) {
			// kill firejail process
			kill(jail, SIGTERM);
			// kill xpra client (should die with server, but...)
			kill(client, SIGTERM);
			exit(0);
		}
	}
}


static void __attribute__((noreturn)) x11_start_xpra_new(int argc, char **argv, char *display_str) {
	EUID_ASSERT();
	int i;
	pid_t server = 0;

	// build the start command
	char *server_argv[256] = {		  // rest initialized to NULL
		"xpra", "start", display_str, "--daemon=no", "--attach=yes", "--exit-with-children=yes"
	};
	unsigned spos = 0;
	unsigned fpos = 0;
	while (server_argv[spos] != NULL) spos++;

	// build jail command
	char *firejail_argv[argc+2];
	size_t total_length = 0;
	for (i = 0; i < argc; i++) {
		if (strncmp(argv[i], "--x11", 5) == 0)
			continue;
		firejail_argv[fpos] = argv[i];
		fpos++;
		total_length += strlen(argv[i]);
	}

	char *start_child_prefix = "--start-child=";
	char *start_child;
	start_child = malloc(total_length + strlen(start_child_prefix) + fpos + 2);
	if (start_child == NULL) {
		fprintf(stderr, "Error: unable to allocate start_child to assemble command\n");
		exit(1);
	}

	strcpy(start_child,start_child_prefix);
	for(i = 0; (unsigned) i < fpos; i++) {
		strcat(start_child,firejail_argv[i]);
		if((unsigned) i != fpos - 1)
			strcat(start_child," ");
	}

	server_argv[spos++] = start_child;

	server_argv[spos++] = NULL;
	firejail_argv[fpos] = NULL;

	assert(xpra_extra_params);		  // should be "" if empty

	// parse xephyr_extra_params
	// very basic quoting support
	char *temp = strdup(xpra_extra_params);
	if (*xpra_extra_params != '\0') {
		if (!temp)
			errExit("strdup");
		bool dquote = false;
		bool squote = false;
		for (i = 0; i < (int) strlen(xpra_extra_params); i++) {
			if (temp[i] == '\"') {
				dquote = !dquote;
						  // replace closing quote by \0
				if (dquote) temp[i] = '\0';
			}
			if (temp[i] == '\'') {
				squote = !squote;
						  // replace closing quote by \0
				if (squote) temp[i] = '\0';
			}
			if (!dquote && !squote && temp[i] == ' ') temp[i] = '\0';
			if (dquote && squote) {
				fprintf(stderr, "Error: mixed quoting found while parsing xpra_extra_params\n");
				exit(1);
			}
		}
		if (dquote) {
			fprintf(stderr, "Error: unclosed quote found while parsing xpra_extra_params\n");
			exit(1);
		}

		server_argv[spos++] = temp;
		for (i = 0; i < (int) strlen(xpra_extra_params)-1; i++) {
			if (spos >= (sizeof(server_argv)/sizeof(*server_argv)) - 2) {
				fprintf(stderr, "Error: arg count limit exceeded while parsing xpra_extra_params\n");
				exit(1);
			}
			if (temp[i] == '\0' && (temp[i+1] == '\"' || temp[i+1] == '\'')) {
				server_argv[spos++] = temp + i + 2;
			}
			else if (temp[i] == '\0' && temp[i+1] != '\0') {
				server_argv[spos++] = temp + i + 1;
			}
		}
	}

	server_argv[spos++] = NULL;

	assert((int) fpos < (argc+2));
	assert(!firejail_argv[fpos]);
						  // no overrun
	assert(spos < (sizeof(server_argv)/sizeof(*server_argv)));
	assert(server_argv[spos-1] == NULL);	  // last element is null

	if (arg_debug) {
		size_t i = 0;
		printf("\n*** Starting xpra server: ");
		while (server_argv[i]!=NULL) {
			printf(" \"%s\"", server_argv[i]);
			i++;
		}
		printf(" ***\n\n");
	}

	int fd_null = -1;
	if (arg_quiet) {
		fd_null = open("/dev/null", O_RDWR);
		if (fd_null == -1)
			errExit("open");
	}

	// start
	server = fork();
	if (server < 0)
		errExit("fork");
	if (server == 0) {
		if (arg_debug)
			printf("Starting xpra...\n");

		if (arg_quiet && fd_null != -1) {
			dup2(fd_null,0);
			dup2(fd_null,1);
			dup2(fd_null,2);
		}

		// restore original environment variables
		env_apply_all();

		// running without privileges - see drop_privs call above
		assert(env_get("LD_PRELOAD") == NULL);
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(server_argv[0], server_argv);
		perror("execvp");
		_exit(1);
	}

	// wait for server to end
	while (1) {
		pid_t pid = wait(NULL);
		if (pid == server) {
			free(start_child);
			exit(0);
		}
	}
}


void x11_start_xpra(int argc, char **argv) {
	EUID_ASSERT();

	env_store_name_val("FIREJAIL_X11", "yes", SETENV);

	// unfortunately, xpra does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}
	drop_privs(0);

	// check xpra
	if (!program_in_path("xpra")) {
		fprintf(stderr, "\nError: Xpra program was not found in /usr/bin directory, please install it:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n");
		fprintf(stderr, "   Arch: sudo pacman -S xpra\n");
		fprintf(stderr, "   Fedora: sudo dnf install xpra\n");
		exit(0);
	}

	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	if (checkcfg(CFG_XPRA_ATTACH))
		x11_start_xpra_new(argc, argv, display_str);
	else
		x11_start_xpra_old(argc, argv, display, display_str);
}


void x11_start(int argc, char **argv) {
	EUID_ASSERT();

	// unfortunately, xpra does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}

	// check xpra
	if (program_in_path("xpra"))
		x11_start_xpra(argc, argv);
	else if (program_in_path("Xephyr"))
		x11_start_xephyr(argc, argv);
	else {
		fprintf(stderr, "\nError: Xpra or Xephyr not found in /usr/bin directory, please install one of them:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xserver-xephyr\n");
		fprintf(stderr, "   Arch: sudo pacman -S xpra\n");
		fprintf(stderr, "   Arch: sudo pacman -S xorg-server-xephyr\n");
		fprintf(stderr, "   Fedora: sudo dnf install xpra\n");
		fprintf(stderr, "   Fedora: sudo dnf install xorg-x11-server-Xephyr\n");
		exit(0);
	}
}
#endif


void x11_xorg(void) {
#ifdef HAVE_X11

	// get DISPLAY env
	const char *display = env_get("DISPLAY");
	if (!display) {
		fputs("Error: --x11=xorg requires an 'outer' X11 server to use.\n", stderr);
		exit(1);
	}

	// check xauth utility is present in the system
	struct stat s;
	if (stat("/usr/bin/xauth", &s) == -1) {
		fprintf(stderr, "Error: xauth utility not found in /usr/bin. Please install it:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xauth\n");
		fprintf(stderr, "   Arch: sudo pacman -S xorg-xauth\n");
		fprintf(stderr, "   Fedora: sudo dnf install xorg-x11-xauth\n");
		exit(1);
	}
	if ((s.st_uid != 0 && s.st_gid != 0) || (s.st_mode & S_IWOTH)) {
		fprintf(stderr, "Error: invalid /usr/bin/xauth executable\n");
		exit(1);
	}
	if (s.st_size > 1024 * 1024) {
		fprintf(stderr, "Error: /usr/bin/xauth executable is too large\n");
		exit(1);
	}
	// copy /usr/bin/xauth in the sandbox and set mode to 0711
	// users are not able to trace the running xauth this way
	if (arg_debug)
		printf("Copying /usr/bin/xauth to %s\n", RUN_XAUTH_FILE);
	if (copy_file("/usr/bin/xauth", RUN_XAUTH_FILE, 0, 0, 0711)) {
		fprintf(stderr, "Error: cannot copy /usr/bin/xauth executable\n");
		exit(1);
	}

	fmessage("Generating a new .Xauthority file\n");
	mkdir_attr(RUN_XAUTHORITY_SEC_DIR, 0700, getuid(), getgid());
	// create new Xauthority file in RUN_XAUTHORITY_SEC_DIR
	EUID_USER();
	char tmpfname[] = RUN_XAUTHORITY_SEC_DIR "/.Xauth-XXXXXX";
	int fd = mkstemp(tmpfname);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot create .Xauthority file\n");
		exit(1);
	}
	close(fd);

	// run xauth
	if (arg_debug)
		sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 8, RUN_XAUTH_FILE, "-v", "-f", tmpfname,
			"generate", display, "MIT-MAGIC-COOKIE-1", "untrusted");
	else
		sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 7, RUN_XAUTH_FILE, "-f", tmpfname,
			"generate", display, "MIT-MAGIC-COOKIE-1", "untrusted");

	// ensure there is already a file ~/.Xauthority, so that bind-mount below will work.
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	if (access(dest, F_OK) == -1) {
		touch_file_as_user(dest, 0600);
		if (access(dest, F_OK) == -1) {
			fprintf(stderr, "Error: cannot create %s\n", dest);
			exit(1);
		}
	}
	// get a file descriptor for ~/.Xauthority
	int dst = safer_openat(-1, dest, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (dst == -1)
		errExit("safer_openat");
	// check if the actual mount destination is a user owned regular file
	if (fstat(dst, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode) || s.st_uid != getuid()) {
		if (S_ISLNK(s.st_mode))
			fprintf(stderr, "Error: .Xauthority is a symbolic link\n");
		else
			fprintf(stderr, "Error: .Xauthority is not a user owned regular file\n");
		exit(1);
	}
	// preserve a read-only mount
	struct statvfs vfs;
	if (fstatvfs(dst, &vfs) == -1)
		errExit("fstatvfs");
	if ((vfs.f_flag & MS_RDONLY) == MS_RDONLY)
		fs_remount(RUN_XAUTHORITY_SEC_DIR, MOUNT_READONLY, 0);

	// always mounting the new Xauthority file noexec,nodev,nosuid
	fs_remount(RUN_XAUTHORITY_SEC_DIR, MOUNT_NOEXEC, 0);

	// get a file descriptor for the new Xauthority file
	int src = safer_openat(-1, tmpfname, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (src == -1)
		errExit("safer_openat");
	if (fstat(src, &s) == -1)
		errExit("fstat");
	if (!S_ISREG(s.st_mode)) {
		errno = EPERM;
		errExit("mounting Xauthority file");
	}

	// mount via the link in /proc/self/fd
	if (arg_debug)
		printf("Mounting %s on %s\n", tmpfname, dest);
	EUID_ROOT();
	if (bind_mount_by_fd(src, dst)) {
		fprintf(stderr, "Error: cannot mount the new .Xauthority file\n");
		exit(1);
	}
	EUID_USER();
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, dest) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid .Xauthority mount");
	close(src);
	close(dst);

	ASSERT_PERMS(dest, getuid(), getgid(), 0600);

	// blacklist user .Xauthority file if it is not masked already
	const char *envar = env_get("XAUTHORITY");
	if (envar) {
		char *rp = realpath(envar, NULL);
		if (rp) {
			if (strcmp(rp, dest) != 0) {
				EUID_ROOT();
				disable_file_or_dir(rp);
				EUID_USER();
			}
			free(rp);
		}
	}
	// set environment variable
	env_store_name_val("XAUTHORITY", dest, SETENV);
	free(dest);

	// mask RUN_XAUTHORITY_SEC_DIR
	EUID_ROOT();
	if (mount("tmpfs", RUN_XAUTHORITY_SEC_DIR, "tmpfs", MS_NOSUID | MS_NODEV | MS_STRICTATIME,  "mode=755,gid=0") < 0)
		errExit("mounting tmpfs");
	fs_logger2("tmpfs", RUN_XAUTHORITY_SEC_DIR);

	// cleanup
	unlink(RUN_XAUTH_FILE);
#endif
}


void fs_x11(void) {
#ifdef HAVE_X11
	int display = x11_display();
	if (display <= 0)
		return;

	struct stat s1, s2;
	if (stat("/tmp", &s1) != 0 || lstat("/tmp/.X11-unix", &s2) != 0)
		return;
	if ((s1.st_mode & S_ISVTX) != S_ISVTX) {
		fwarning("cannot mask X11 sockets: sticky bit not set on /tmp directory\n");
		return;
	}
	if (s2.st_uid != 0) {
		fwarning("cannot mask X11 sockets: /tmp/.X11-unix not owned by root user\n");
		return;
	}

	// the mount source is under control of the user, so be careful and
	// mount without following symbolic links, using a file descriptor
	char *x11file;
	if (asprintf(&x11file, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	int src = open(x11file, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (src < 0) {
		free(x11file);
		return;
	}
	struct stat s3;
	if (fstat(src, &s3) < 0)
		errExit("fstat");
	if (!S_ISSOCK(s3.st_mode)) {
		close(src);
		free(x11file);
		return;
	}

	if (arg_debug || arg_debug_whitelists)
		fprintf(stderr, "Masking all X11 sockets except %s\n", x11file);
	// This directory must be mode 1777
	if (mount("tmpfs", "/tmp/.X11-unix", "tmpfs",
		MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME,
		"mode=1777,uid=0,gid=0") < 0)
		errExit("mounting tmpfs on /tmp/.X11-unix");
	selinux_relabel_path("/tmp/.X11-unix", "/tmp/.X11-unix");
	fs_logger("tmpfs /tmp/.X11-unix");

	// create an empty root-owned file which will have the desired socket bind-mounted over it
	int dst = open(x11file, O_RDONLY|O_CREAT|O_EXCL|O_CLOEXEC, S_IRUSR | S_IWUSR);
	if (dst < 0)
		errExit("open");

	if (bind_mount_by_fd(src, dst))
		errExit("mount bind");
	close(src);
	close(dst);
	fs_logger2("whitelist", x11file);
	free(x11file);
#endif
}


void x11_block(void) {
#ifdef HAVE_X11
	// check abstract socket presence and network namespace options
	if ((!arg_nonetwork && !arg_netns && !cfg.bridge0.configured && !cfg.interface0.configured)
	&& x11_abstract_sockets_present()) {
		fprintf(stderr, "ERROR: --x11=none specified, but abstract X11 socket still accessible.\n"
			"Additional setup required. To block abstract X11 socket you can either:\n"
			" * use network namespace in firejail (--net=none, --net=...)\n"
			" * add \"-nolisten local\" to xserver options\n"
			"   (eg. to your display manager config, or /etc/X11/xinit/xserverrc)\n");
		exit(1);
	}

	// blacklist sockets
	char *cmd = strdup("blacklist /tmp/.X11-unix");
	if (!cmd)
		errExit("strdup");
	profile_check_line(cmd, 0, NULL);
	profile_add(cmd);

	// blacklist .Xauthority
	cmd = strdup("blacklist ${HOME}/.Xauthority");
	if (!cmd)
		errExit("strdup");
	profile_check_line(cmd, 0, NULL);
	profile_add(cmd);
	const char *xauthority = env_get("XAUTHORITY");
	if (xauthority) {
		char *line;
		if (asprintf(&line, "blacklist %s", xauthority) == -1)
			errExit("asprintf");
		profile_check_line(line, 0, NULL);
		profile_add(line);
	}

	// clear environment
	env_store("DISPLAY", RMENV);
	env_store("XAUTHORITY", RMENV);
#endif
}

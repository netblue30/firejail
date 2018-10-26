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


// Parse the DISPLAY environment variable and return a display number.
// Returns -1 if DISPLAY is not set, or is set to anything other than :ddd.
int x11_display(void) {
	const char *display_str = getenv("DISPLAY");
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
	FILE *fp = fopen("/proc/net/unix", "r");
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
	struct stat s;
	pid_t jail = 0;
	pid_t server = 0;

	setenv("FIREJAIL_X11", "yes", 1);

	// mever try to run X servers as root!!!
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
		exit(0);
	}

	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	assert(xvfb_screen);

	char *server_argv[256] = {		  // rest initialyzed to NULL
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
		printf("\n*** Stating xvfb client:");
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

		// running without privileges - see drop_privs call above
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
		if (stat(fname, &s) == 0)
			break;
	};

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xvfb\n");
		exit(1);
	}
	free(fname);

	assert(display_str);
	setenv("DISPLAY", display_str, 1);
	// run attach command
	jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		fmessage("\n*** Attaching to Xvfb display %d ***\n\n", display);

		// running without privileges - see drop_privs call above
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
	struct stat s;
	pid_t jail = 0;
	pid_t server = 0;

	// default xephyr screen can be overwriten by a --xephyr-screen= command line option
	char *newscreen = extract_setting(argc, argv, "--xephyr-screen=");
	if (newscreen)
		xephyr_screen = newscreen;

	setenv("FIREJAIL_X11", "yes", 1);

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
		exit(0);
	}

	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	assert(xephyr_screen);
	char *server_argv[256] = {		  // rest initialyzed to NULL
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

		// running without privileges - see drop_privs call above
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
		if (stat(fname, &s) == 0)
			break;
	};

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xephyr\n");
		exit(1);
	}
	free(fname);

	assert(display_str);
	setenv("DISPLAY", display_str, 1);
	// run attach command
	jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		if (!arg_quiet)
			printf("\n*** Attaching to Xephyr display %d ***\n\n", display);

		// running without privileges - see drop_privs call above
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


void x11_start_xpra_old(int argc, char **argv, int display, char *display_str) {
	EUID_ASSERT();
	int i;
	struct stat s;
	pid_t client = 0;
	pid_t server = 0;

	// build the start command
	char *server_argv[256] = {		  // rest initialyzed to NULL
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

		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);
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
		if (stat(fname, &s) == 0)
			break;
	}

	if (n == 10) {
		fprintf(stderr, "Error: failed to start xpra\n");
		exit(1);
	}
	free(fname);

	// build attach command
	char *attach_argv[] = { "xpra", "--title=\"firejail x11 sandbox\"", "attach", display_str, NULL };

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

		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);
		execvp(attach_argv[0], attach_argv);
		perror("execvp");
		_exit(1);
	}

	assert(display_str);
	setenv("DISPLAY", display_str, 1);

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
		assert(getenv("LD_PRELOAD") == NULL);
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
				// running without privileges - see drop_privs call above
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
					printf("failed to stop xpra server gratefully\n");
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


void x11_start_xpra_new(int argc, char **argv, char *display_str) {
	EUID_ASSERT();
	int i;
	pid_t server = 0;

	// build the start command
	char *server_argv[256] = {		  // rest initialyzed to NULL
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
		strncat(start_child,firejail_argv[i],strlen(firejail_argv[i]));
		if((unsigned) i != fpos - 1)
			strncat(start_child," ",strlen(" "));
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

		// running without privileges - see drop_privs call above
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

	setenv("FIREJAIL_X11", "yes", 1);

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
		exit(0);
	}
}
#endif

// Porting notes:
//
// 1. merge #1100 from zackw:
//     Attempting to run xauth -f directly on a file in /run/firejail/mnt/ directory fails on Debian 8
//     with this message:
//            xauth:  timeout in locking authority file /run/firejail/mnt/sec.Xauthority-Qt5Mu4
//            Failed to create untrusted X cookie: xauth: exit 1
//     For this reason we run xauth on a file in a tmpfs filesystem mounted on /tmp. This was
//     a partial merge.
//
// 2. Since we cannot deal with the TOCTOU condition when mounting .Xauthority in user home
// directory, we need to make sure /usr/bin/xauth executable is the real thing, and not
// something picked up on $PATH.
//
// 3. If for any reason xauth command fails, we exit the sandbox. On Debian 8 this happens
// when using a network namespace. Somehow, xauth tries to connect to the abstract socket,
// and it fails because of the network namespace - it should try to connect to the regular
// Unix socket! If we ignore the fail condition, the program will be started on X server without
// the security extension loaded.
void x11_xorg(void) {
#ifdef HAVE_X11

	// check xauth utility is present in the system
	struct stat s;
	if (stat("/usr/bin/xauth", &s) == -1) {
		fprintf(stderr, "Error: xauth utility not found in /usr/bin. Please install it:\n"
			"   Debian/Ubuntu/Mint: sudo apt-get install xauth\n");
		exit(1);
	}
	if (s.st_uid != 0 && s.st_gid != 0) {
		fprintf(stderr, "Error: invalid /usr/bin/xauth executable\n");
		exit(1);
	}

	// get DISPLAY env
	char *display = getenv("DISPLAY");
	if (!display) {
		fputs("Error: --x11=xorg requires an 'outer' X11 server to use.\n", stderr);
		exit(1);
	}

	// temporarily mount a tempfs on top of /tmp directory
	if (mount("tmpfs", "/tmp", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=1777,gid=0") < 0)
		errExit("mounting /tmp");

	// create the temporary .Xauthority file
	if (arg_debug)
		printf("Generating a new .Xauthority file\n");
	char tmpfname[] = "/tmp/.tmpXauth-XXXXXX";
	int fd = mkstemp(tmpfname);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot create .Xauthority file\n");
		exit(1);
	}
	if (fchown(fd, getuid(), getgid()) == -1)
		errExit("chown");
	close(fd);

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		drop_privs(1);
		clearenv();
#ifdef HAVE_GCOV
		__gcov_flush();
#endif
		execlp("/usr/bin/xauth", "/usr/bin/xauth", "-v", "-f", tmpfname,
			"generate", display, "MIT-MAGIC-COOKIE-1", "untrusted", NULL);

		_exit(127);
	}

	// wait for the xauth process to finish
	int status;
	if (waitpid(child, &status, 0) != child)
		errExit("waitpid");
	if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
		/* success */
	}
	else if (WIFEXITED(status)) {
		fprintf(stderr, "Failed to create untrusted X cookie: xauth: exit %d\n",
			WEXITSTATUS(status));
		exit(1);
	}
	else if (WIFSIGNALED(status)) {
		fprintf(stderr, "Failed to create untrusted X cookie: xauth: %s\n",
			strsignal(WTERMSIG(status)));
		exit(1);
	}
	else {
		fprintf(stderr, "Failed to create untrusted X cookie: "
			"xauth: un-decodable exit status %04x\n", status);
		exit(1);
	}

	// move the temporary file in RUN_XAUTHORITY_SEC_FILE in order to have it deleted
	// automatically when the sandbox is closed (rename doesn't work)
						  // root needed
	if (copy_file(tmpfname, RUN_XAUTHORITY_SEC_FILE, getuid(), getgid(), 0600)) {
		fprintf(stderr, "Error: cannot create the new .Xauthority file\n");
		exit(1);
	}
	/* coverity[toctou] */
	unlink(tmpfname);
	umount("/tmp");

	// remount RUN_XAUTHORITY_SEC_FILE noexec, nodev, nosuid
	fs_noexec(RUN_XAUTHORITY_SEC_FILE);

	// Ensure there is already a file in the usual location, so that bind-mount below will work.
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	if (lstat(dest, &s) == -1)
		touch_file_as_user(dest, 0600);

	// get a file descriptor for .Xauthority
	fd = safe_fd(dest, O_PATH|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1)
		errExit("safe_fd");
	// check if the actual mount destination is a user owned regular file
	if (fstat(fd, &s) == -1)
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
	if (fstatvfs(fd, &vfs) == -1)
		errExit("fstatvfs");
	if ((vfs.f_flag & MS_RDONLY) == MS_RDONLY)
		fs_rdonly(RUN_XAUTHORITY_SEC_FILE);

	// mount via the link in /proc/self/fd
	char *proc;
	if (asprintf(&proc, "/proc/self/fd/%d", fd) == -1)
		errExit("asprintf");
	if (mount(RUN_XAUTHORITY_SEC_FILE, proc, "none", MS_BIND, "mode=0600") == -1) {
		fprintf(stderr, "Error: cannot mount the new .Xauthority file\n");
		exit(1);
	}
	free(proc);
	close(fd);
	// check /proc/self/mountinfo to confirm the mount is ok
	MountData *mptr = get_last_mount();
	if (strcmp(mptr->dir, dest) != 0 || strcmp(mptr->fstype, "tmpfs") != 0)
		errLogExit("invalid .Xauthority mount");

	ASSERT_PERMS(dest, getuid(), getgid(), 0600);
	free(dest);
#endif
}


void fs_x11(void) {
#ifdef HAVE_X11
	int display = x11_display();
	if (display <= 0)
		return;

	char *x11file;
	if (asprintf(&x11file, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	struct stat x11stat;
	if (stat(x11file, &x11stat) == -1 || !S_ISSOCK(x11stat.st_mode)) {
		free(x11file);
		return;
	}

	if (arg_debug || arg_debug_whitelists)
		fprintf(stderr, "Masking all X11 sockets except %s\n", x11file);

	// Move the real /tmp/.X11-unix to a scratch location
	// so we can still access x11file after we mount a
	// tmpfs over /tmp/.X11-unix.
	int rv = mkdir(RUN_WHITELIST_X11_DIR, 0700);
	if (rv == -1)
		errExit("mkdir");
	if (set_perms(RUN_WHITELIST_X11_DIR, 0, 0, 0700))
		errExit("set_perms");

	if (mount("/tmp/.X11-unix", RUN_WHITELIST_X11_DIR, 0, MS_BIND|MS_REC, 0) < 0)
		errExit("mount bind");

	// This directory must be mode 1777, or Xlib will barf.
	if (mount("tmpfs", "/tmp/.X11-unix", "tmpfs",
		MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_STRICTATIME | MS_REC,
		"mode=1777,uid=0,gid=0") < 0)
		errExit("mounting tmpfs on /tmp/.X11-unix");
	fs_logger("tmpfs /tmp/.X11-unix");

	// create an empty file which will have the desired socket bind-mounted over it
	int fd = open(x11file, O_RDWR|O_CREAT|O_EXCL, x11stat.st_mode & ~S_IFMT);
	if (fd < 0)
		errExit(x11file);
	if (fchown(fd, x11stat.st_uid, x11stat.st_gid))
		errExit("fchown");
	close(fd);

	// do the mount
	char *wx11file;
	if (asprintf(&wx11file, "%s/X%d", RUN_WHITELIST_X11_DIR, display) == -1)
		errExit("asprintf");
	if (mount(wx11file, x11file, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	fs_logger2("whitelist", x11file);

	free(x11file);
	free(wx11file);

	// block access to RUN_WHITELIST_X11_DIR
	if (mount(RUN_RO_DIR, RUN_WHITELIST_X11_DIR, 0, MS_BIND, 0) < 0)
		errExit("mount");
	fs_logger2("blacklist", RUN_WHITELIST_X11_DIR);
#endif
}


void x11_block(void) {
#ifdef HAVE_X11
	// check abstract socket presence and network namespace options
	if ((!arg_nonetwork && !cfg.bridge0.configured && !cfg.interface0.configured)
	&& x11_abstract_sockets_present()) {
		fprintf(stderr, "ERROR: --x11=none specified, but abstract X11 socket still accessible.\n"
			"Additional setup required. To block abstract X11 socket you can either:\n"
			" * use network namespace in firejail (--net=none, --net=...)\n"
			" * add \"-nolisten local\" to xserver options\n"
			"   (eg. to your display manager config, or /etc/X11/xinit/xserverrc)\n");
		exit(1);
	}

	// blacklist sockets
	profile_check_line("blacklist /tmp/.X11-unix", 0, NULL);
	profile_add(strdup("blacklist /tmp/.X11-unix"));

	// blacklist .Xauthority
	profile_check_line("blacklist ${HOME}/.Xauthority", 0, NULL);
	profile_add(strdup("blacklist ${HOME}/.Xauthority"));
	char *xauthority = getenv("XAUTHORITY");
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

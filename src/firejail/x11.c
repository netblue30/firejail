/*
 * Copyright (C) 2014-2017 Firejail Authors
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
#include <sys/socket.h>
#include <sys/un.h>
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/mount.h>
#include <sys/wait.h>
#include <errno.h>
#include <limits.h>

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
        if (endp == display_str+1 || *endp != '\0') {
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

	EUID_ROOT(); // grsecurity fix
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

        struct sockaddr_un sa;
        // The -1 here is because we need space to inject a
        // leading nul byte.
        int sun_pathmax = (int)(sizeof sa.sun_path - 1);
        assert((size_t)sun_pathmax == sizeof sa.sun_path - 1);
        int sun_pathlen;

        int sockfd = socket(AF_UNIX, SOCK_STREAM, 0);
        if (sockfd == -1)
                errExit("socket");

	for (int i = 0; i < 100; i++) {
                // We try display numbers in the range 21 through 1000.
                // Normal X servers typically use displays in the 0-10 range;
                // ssh's X11 forwarding uses 10-20, and login screens
                // (e.g. gdm3) may use displays above 1000.
                display = rand() % 979 + 21;

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

static void squelch_output_when_quiet(void) {
        int fd_null = open("/dev/null", O_RDWR);
        if (fd_null == -1)
                errExit("open");
        // stdin is always redirected from /dev/null
        dup2(fd_null, 0);
        // stdout and stderr are redirected to /dev/null when --quiet is in effect
        if (arg_quiet) {
                dup2(fd_null, 1);
                dup2(fd_null, 2);
        }
        close(fd_null);
}

static pid_t run_jailed_subprocess(int parent_argc, char **parent_argv,
                                   const char *cmdline, const char *label) {

        // safety check - caller should have used drop_privs
        assert(getenv("LD_PRELOAD") == NULL);
        assert(geteuid() == getuid());

        fflush(0);
        pid_t child = fork();
        if (child < 0)
                errExit("fork");
        else if (child > 0)
                return child;

        // Control reaches this point only in the child process.
        // Assembly of the command line is done here so we don't have
        // to worry about deallocating it.
        int argc_used = 0;
        int argc_alloc = 0;
        char **argv = 0;
        prepare_self_reinvocation(&argc_used, &argc_alloc, &argv, parent_argc, parent_argv);
        append_cmdline_to_argv(&argc_used, &argc_alloc, &argv, cmdline);
        debug_print_argv(argc_used, argv, label);

        squelch_output_when_quiet();
        execvp(argv[0], argv);
        perror(argv[0]);

#ifdef HAVE_GCOV
        __gcov_flush();
#endif
        _exit(127);
}

static pid_t run_jailed_subprocess_with_x11_display(int parent_argc, char **parent_argv,
                                                    const char *cmdline, int display,
                                                    const char *label) {

        // safety check - caller should have used drop_privs
        assert(getenv("LD_PRELOAD") == NULL);
        assert(geteuid() == getuid());

        fflush(0);
        pid_t child = fork();
        if (child < 0)
                errExit("fork");
        else if (child > 0)
                return child;

        // Control reaches this point only in the child process.
        // Assembly of the command line is done here so we don't have
        // to worry about deallocating it.

        char *display_str;
        if (asprintf(&display_str, ":%d", display) == -1)
                errExit("asprintf");

	setenv("DISPLAY", display_str, 1);
	setenv("FIREJAIL_X11", "yes", 1);

        int argc_used = 0;
        int argc_alloc = 0;
        char **argv = 0;
        prepare_self_reinvocation(&argc_used, &argc_alloc, &argv, parent_argc, parent_argv);
        append_cmdline_to_argv(&argc_used, &argc_alloc, &argv, cmdline);
        debug_print_argv(argc_used, argv, label);

        squelch_output_when_quiet();
        execvp(argv[0], argv);
        perror(argv[0]);

#ifdef HAVE_GCOV
        __gcov_flush();
#endif
        _exit(127);
}

static pid_t run_self_with_x11_display(int parent_argc, char **parent_argv,
                                       int display, char *label) {

        // safety check - caller should have used drop_privs
        assert(getenv("LD_PRELOAD") == NULL);
        assert(geteuid() == getuid());

        fflush(0);
        pid_t child = fork();
        if (child < 0)
                errExit("fork");
        else if (child > 0)
                return child;

        // Control reaches this point only in the child process.
        // Assembly of the command line is done here so we don't have
        // to worry about deallocating it.
        if (!arg_quiet)
                printf("\n*** Attaching to %s display %d ***\n\n", label, display);

        char *display_str;
        if (asprintf(&display_str, ":%d", display) == -1)
                errExit("asprintf");

	setenv("DISPLAY", display_str, 1);
	setenv("FIREJAIL_X11", "yes", 1);

	// remove --x11 arg for self-reinvocation
	char **jail_argv = calloc(parent_argc+2, sizeof(char *));
	int i, j = 0;
	for (i = 0; i < parent_argc; i++) {
		if (strncmp(parent_argv[i], "--x11", 5) == 0)
			continue;
		jail_argv[j] = parent_argv[i];
		j++;
	}
	jail_argv[j] = NULL;
	assert(j < parent_argc+2); // no overrun
        debug_print_argv(j, jail_argv, "X client:");
        execvp(jail_argv[0], jail_argv);
        perror(jail_argv[0]);

#ifdef HAVE_GCOV
        __gcov_flush();
#endif
        _exit(127);
}

static void wait_for_x11_socket(pid_t server, int display) {
	char *fname;
	if (asprintf(&fname, "/tmp/.X11-unix/X%d", display) == -1) {
                kill(server, SIGTERM);
		errExit("asprintf");
        }

	int n = 0;
	while (++n < 10) {
		sleep(1);
		if (access(fname, F_OK) == 0)
			break;
	}

	if (arg_debug) {
            	printf("X11 sockets: "); fflush(0);
            	int rv = system("ls /tmp/.X11-unix");
            	(void) rv;
	}

        if (n == 10) {
                kill(server, SIGTERM);
                fprintf(stderr, "Error: X11 socket %s not available after 10 seconds\n", fname);
                exit(1);
        }

        free(fname);
}

static void wait_kill_wait_all(pid_t a, pid_t b, pid_t c) {
        pid_t pid;
        while (a != -1 && b != -1 && c != -1) {
                pid = wait(0);

                if (a == pid) a = -1; else if (a != -1) kill(a, SIGTERM);
                if (b == pid) b = -1; else if (b != -1) kill(b, SIGTERM);
                if (c == pid) c = -1; else if (c != -1) kill(c, SIGTERM);
        }
}

//$ firejail -- Xephyr -ac -br -noreset -screen 800x600 :22 &
//$ DISPLAY=:22 firejail --net=eth0 --blacklist=/tmp/.X11-unix/x0 firefox
void x11_start_xephyr(int argc, char **argv) {
	pid_t jail = -1;
	pid_t server = -1;
        pid_t window_mgr = -1;

	EUID_ASSERT();
	// unfortunately, xephyr does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fputs("Error: X11 sandboxing is not available when running as root\n", stderr);
		exit(1);
	}
	drop_privs(0);

	// check xephyr
	if (!program_in_path("Xephyr")) {
                fputs("\nError: Xephyr program was not found in PATH, please install it:\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xserver-xephyr\n"
                      "   Arch: sudo pacman -S xorg-server-xephyr\n", stderr);
		exit(1);
	}

        int outer_display = x11_display();
        if (outer_display == -1) {
                fputs("Error: --x11=xephyr requires an 'outer' X11 server to use.\n", stderr);
                exit(1);
        }

	assert(xephyr_screen);
	assert(xephyr_extra_params); // should be "" if empty

	int display = random_display_number();
	char *xephyr_cmdline;
	if (asprintf(&xephyr_cmdline,
                     "Xephyr -ac -br -noreset -screen '%s' %s %s :%d",
                     xephyr_screen,
                     checkcfg(CFG_XEPHYR_WINDOW_TITLE) ? "-title 'firejail x11 sandbox'" : "",
                     xephyr_extra_params,
                     display) == -1)
		errExit("asprintf");

        server = run_jailed_subprocess_with_x11_display(argc, argv,
                                                        xephyr_cmdline, outer_display,
                                                        "xephyr server:");
	if (arg_debug)
		printf("xephyr server pid %d\n", server);

        wait_for_x11_socket(server, display);

        if (x11_window_manager)
                window_mgr = run_jailed_subprocess_with_x11_display(argc, argv, x11_window_manager,
                                                                    display, "window manager:");

        jail = run_self_with_x11_display(argc, argv, display, "jailed program:");

        wait_kill_wait_all(server, jail, window_mgr);
	exit(0);
}

void x11_start_xpra(int argc, char **argv) {
	pid_t jail = -1;
	pid_t server = -1;
        pid_t client = -1;

	EUID_ASSERT();
	// unfortunately, xpra does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fputs("Error: X11 sandboxing is not available when running as root\n", stderr);
		exit(1);
	}
	drop_privs(0);

	// check xpra
	if (!program_in_path("xpra")) {
		fputs("\nError: xpra program was not found in PATH, please install it:\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n", stderr);
		exit(1);
	}

        int outer_display = x11_display();
        if (outer_display == -1) {
                fputs("Error: --x11=xpra requires an 'outer' X11 server to use.\n", stderr);
                exit(1);
        }

        // xpra doesn't create its own screen, so there is no xpra_screen parameter
	int display = random_display_number();
        char *xpra_server_cmdline;
        if (asprintf(&xpra_server_cmdline, "xpra start :%d --no-daemon %s",
                     display, xpra_extra_params) == -1)
                errExit("asprintf");

        // The xpra server does not need to connect to the 'outer' X server.
        server = run_jailed_subprocess(argc, argv, xpra_server_cmdline, "xpra server:");
        if (arg_debug)
                printf("xpra server pid %d\n", server);

        wait_for_x11_socket(server, display);

        char *xpra_client_cmdline;
        if (asprintf(&xpra_client_cmdline, "xpra --title='firejail x11 sandbox' attach :%d",
                     display) == -1)
                errExit("asprintf");

        // The xpra *client*, however, *does* need to connect to the 'outer' X server.
        client = run_jailed_subprocess_with_x11_display(argc, argv, xpra_client_cmdline,
                                                        outer_display, "xpra client:");

        // xpra doesn't create its own screen, so running a window manager doesn't make sense
        jail = run_self_with_x11_display(argc, argv, display, "jailed program:");

        wait_kill_wait_all(server, client, jail);
        exit(0);
}

void x11_start(int argc, char **argv) {
	if (program_in_path("xpra"))
		x11_start_xpra(argc, argv);
	else if (program_in_path("Xephyr"))
		x11_start_xephyr(argc, argv);
	else {
                fputs("\nError: neither xpra nor Xephyr found in PATH.\n"
                      "Please install one of them:\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xserver-xephyr\n",
                      stderr);
		exit(1);
	}
}

void x11_start_xvfb(int argc, char **argv) {
	pid_t jail = -1;
	pid_t server = -1;
        pid_t window_mgr = -1;

	EUID_ASSERT();
	// unfortunately, xvfb does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fputs("Error: X11 sandboxing is not available when running as root\n", stderr);
		exit(1);
	}
	drop_privs(0);

        if (!program_in_path("Xvfb")) {
                fputs("\nError: Xvfb program was not found in PATH, please install it:\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xvfb\n", stderr);
		exit(1);
	}

	assert(xvfb_screen);
	assert(xvfb_extra_params); // should be "" if empty

	int display = random_display_number();
	char *xvfb_cmdline;
        if (asprintf(&xvfb_cmdline, "Xvfb -screen 0 '%s' %s :%d",
                     xvfb_screen, xvfb_extra_params, display) == -1)
                errExit("asprintf");

        server = run_jailed_subprocess(argc, argv, xvfb_cmdline, "xvfb server:");
	if (arg_debug)
		printf("Xvfb server pid %d\n", server);

        wait_for_x11_socket(server, display);

        if (x11_window_manager)
                window_mgr = run_jailed_subprocess_with_x11_display(argc, argv,x11_window_manager,
                                                                    display, "window manager:");

        jail = run_self_with_x11_display(argc, argv, display, "jailed program:");

        wait_kill_wait_all(server, jail, window_mgr);
	exit(0);
}
#endif

void x11_xorg(void) {
#ifdef HAVE_X11
	// check xauth utility is present in the system
	if (!program_in_path("xauth")) {
		fputs("Error: xauth utility not found in PATH.  Please install it:\n"
                      "   Debian/Ubuntu/Mint: sudo apt-get install xauth\n",
                      stderr);
		exit(1);
	}

        char *display = getenv("DISPLAY");
        if (!display) {
                fputs("Error: --x11=xorg requires an 'outer' X11 server to use.\n", stderr);
                exit(1);
        }

	// create an "untrusted" .Xauthority file using the 'xauth'
	// utility, in a private location
        if (arg_debug)
                fputs("Generating a new .Xauthority file\n", stderr);
	char tmpfname[] = RUN_XAUTHORITY_SEC_FILE "-XXXXXX";
	int fd = mkstemp(tmpfname);
	if (fd == -1)
                errExit(tmpfname);
	if (fchown(fd, getuid(), getgid()) == -1)
		errExit("chown");
	close(fd);

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		drop_privs(1);
		clearenv();
		execlp("xauth", "xauth", "-f", tmpfname,
			"generate", display, "MIT-MAGIC-COOKIE-1", "untrusted", NULL);
                perror("xauth");
#ifdef HAVE_GCOV
		__gcov_flush();
#endif
		_exit(127);
	}

	// wait for the xauth process to finish
        int status;
	if (waitpid(child, &status, 0) != child)
                errExit("waitpid");
        if (WIFEXITED(status) && WEXITSTATUS(status) == 0) {
                /* success */
        } else if (WIFEXITED(status)) {
                fprintf(stderr, "Failed to create untrusted X cookie: xauth: exit %d\n",
                        WEXITSTATUS(status));
                exit(1);
        } else if (WIFSIGNALED(status)) {
                fprintf(stderr, "Failed to create untrusted X cookie: xauth: %s\n",
                        strsignal(WTERMSIG(status)));
                exit(1);
        } else {
                fprintf(stderr, "Failed to create untrusted X cookie: "
                        "xauth: un-decodable exit status %04x\n", status);
                exit(1);
        }

        // ensure the file has the correct permissions and move it
        // into the correct location.
        if (set_perms(tmpfname, getuid(), getgid(), 0600))
		errExit(tmpfname);
        if (rename(tmpfname, RUN_XAUTHORITY_SEC_FILE))
                errExit(RUN_XAUTHORITY_SEC_FILE);

        // Ensure there is already a file in the usual location, so that the
        // bind-mount below will work.
        // FIXME TOCTOU races.
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(dest, &s) == -1) {
		// create an .Xauthority file
		touch_file_as_user(dest, getuid(), getgid(), 0600);
	}

	// mount
	if (mount(RUN_XAUTHORITY_SEC_FILE, dest, 0, MS_BIND, 0) == -1) {
		fprintf(stderr, "Error: failed to emplace untrusted .Xauthority file: %s\n",
                        strerror(errno));
		exit(1);
	}
	free(dest);
#endif
}

// Replace /tmp/.X11-unix with a directory containing only the socket mentioned
// in the DISPLAY environment variable.  If there is no DISPLAY, or if the socket
// doesn't exist, /tmp/.X11-unix is masked out entirely.
void fs_x11(void) {
#ifdef HAVE_X11
        if (!arg_x11_mask) {
                if (arg_debug || arg_debug_whitelists)
                        fputs("Not masking any X11 sockets\n", stderr);
                return;
        }

        char *x11file = 0;
        struct stat x11stat = { 0 };
	int display = x11_display();
	if (display >= 0) {
                if (asprintf(&x11file, "/tmp/.X11-unix/X%d", display) == -1)
                        errExit("asprintf");

                if (stat(x11file, &x11stat) < 0 || !S_ISSOCK(x11stat.st_mode)) {
                        free(x11file);
                        x11file = 0;
                }
        }

        if (x11file) {
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

        }
        else {
                if (arg_debug || arg_debug_whitelists)
                        fputs("Masking all X11 sockets\n", stderr);

                if (mount(RUN_RO_DIR, "/tmp/.X11-unix", 0, MS_BIND, 0) < 0)
                        errExit("mount");
                fs_logger2("blacklist", "/tmp/.X11-unix");
        }
#endif
}

void x11_block(void) {
#ifdef HAVE_X11
	// check abstract socket presence and network namespace options
	if ((!arg_nonetwork && !cfg.bridge0.configured && !cfg.interface0.configured)
            && x11_abstract_sockets_present()) {
		fputs("ERROR: --x11=none specified, but abstract X11 socket still accessible.\n"
                      "Additional setup required. To block abstract X11 socket you can either:\n"
                      " * use network namespace in firejail (--net=none, --net=...)\n"
                      " * add \"-nolisten local\" to xserver options\n"
                      "   (eg. to your display manager config, or /etc/X11/xinit/xserverrc)\n",
                      stderr);
		exit(1);
	}

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
                env_store("XAUTHORITY", RMENV);
	}

	// clear environment
        // in the child, fs_x11() will block access to the X11 socket directory
	env_store("DISPLAY", RMENV);
        env_store("FIREJAIL_X11", RMENV);
#endif
}

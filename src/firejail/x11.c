/*
 * Copyright (C) 2014-2016 Firejail Authors
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
#include <fcntl.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/mount.h>
#include <sys/wait.h>
int mask_x11_abstract_socket = 0;

#ifdef HAVE_X11
// return 1 if xpra is installed on the system
static int x11_check_xpra(void) {
	struct stat s;
	
	// check xpra
	if (stat("/usr/bin/xpra", &s) == -1)
		return 0;

	return 1;
}

// return 1 if xephyr is installed on the system
static int x11_check_xephyr(void) {
	struct stat s;
	
	// check xephyr
	if (stat("/usr/bin/Xephyr", &s) == -1)
		return 0;

	return 1;
}

// check for X11 abstract sockets
static int x11_abstract_sockets_present(void) {
	char *path;

	EUID_ROOT(); // grsecurity fix
	FILE *fp = fopen("/proc/net/unix", "r");
	EUID_USER();

	if (!fp)
		errExit("fopen");

	while (fscanf(fp, "%*s %*s %*s %*s %*s %*s %*s %ms\n", &path) != EOF) {
		if (path && strncmp(path, "@/tmp/.X11-unix/", 16) == 0) {
			free(path);
			fclose(fp);
			return 1;
		}
	}

	free(path);
	fclose(fp);

	return 0;
}

static int random_display_number(void) {
	int i;
	int found = 1;
	int display;
	for (i = 0; i < 100; i++) {
		display = rand() % 1024;
		if (display < 10)
			continue;
		char *fname;
		if (asprintf(&fname, "/tmp/.X11-unix/X%d", display) == -1)
			errExit("asprintf");
		struct stat s;
		if (stat(fname, &s) == -1) {
			found = 1;
			break;
		}
	}
	if (!found) {
		fprintf(stderr, "Error: cannot pick up a random X11 display number, exiting...\n");
		exit(1);
	}
	
	return display;
}
#endif

// return display number, -1 if not configured
int x11_display(void) {
	// extract display
	char *d = getenv("DISPLAY");
	if (!d)
		return - 1;
	
	int display;
	int rv = sscanf(d, ":%d", &display);
	if (rv != 1)
		return -1;
	if (arg_debug)
		printf("DISPLAY %s, %d\n", d, display);
	
	return display;
}

void fs_x11(void) {
#ifdef HAVE_X11
	int display = x11_display();
	if (display <= 0)
		return;

	char *x11file;
	if (asprintf(&x11file, "/tmp/.X11-unix/X%d", display) == -1)
		errExit("asprintf");
	struct stat s;
	if (stat(x11file, &s) == -1)
		return;

	// keep a copy of real /tmp/.X11-unix directory in WHITELIST_TMP_DIR
	int rv = mkdir(RUN_WHITELIST_X11_DIR, 1777);
	if (rv == -1)
		errExit("mkdir");
	if (chown(RUN_WHITELIST_X11_DIR, 0, 0) < 0)
		errExit("chown");
	if (chmod(RUN_WHITELIST_X11_DIR, 1777) < 0)
		errExit("chmod");

	if (mount("/tmp/.X11-unix", RUN_WHITELIST_X11_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");

	// mount tmpfs on /tmp/.X11-unix
	if (arg_debug || arg_debug_whitelists)
		printf("Mounting tmpfs on /tmp/.X11-unix directory\n");
	if (mount("tmpfs", "/tmp/.X11-unix", "tmpfs", MS_NOSUID | MS_STRICTATIME | MS_REC,  "mode=1777,gid=0") < 0)
		errExit("mounting tmpfs on /tmp");
	fs_logger("tmpfs /tmp/.X11-unix");

	// create an empty file
	FILE *fp = fopen(x11file, "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot create empty file in x11 directory\n");
		exit(1);
	}
	// set file properties
	SET_PERMS_STREAM(fp, s.st_uid, s.st_gid, s.st_mode);
	fclose(fp);

	// mount
	char *wx11file;
	if (asprintf(&wx11file, "%s/X%d", RUN_WHITELIST_X11_DIR, display) == -1)
		errExit("asprintf");
	if (mount(wx11file, x11file, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mount bind");
	 fs_logger2("whitelist", x11file);

	free(x11file);
	free(wx11file);
	
	// block access to RUN_WHITELIST_X11_DIR
	 if (mount(RUN_RO_DIR, RUN_WHITELIST_X11_DIR, "none", MS_BIND, "mode=400,gid=0") == -1)
	 	errExit("mount");
	 fs_logger2("blacklist", RUN_WHITELIST_X11_DIR);
#endif
}


#ifdef HAVE_X11
//$ Xephyr -ac -br -noreset -screen 800x600 :22 &
//$ DISPLAY=:22 firejail --net=eth0 --blacklist=/tmp/.X11-unix/x0 firefox
void x11_start_xephyr(int argc, char **argv) {
	EUID_ASSERT();
	int i;
	struct stat s;
	pid_t jail = 0;
	pid_t server = 0;
	
	setenv("FIREJAIL_X11", "yes", 1);

	// unfortunately, xephyr does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}
	drop_privs(0);

	// check xephyr
	if (x11_check_xephyr() == 0) {
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
	char *server_argv[256] = { "Xephyr", "-ac", "-br", "-noreset", "-screen", xephyr_screen }; // rest initialyzed to NULL
	unsigned pos = 0;
	while (server_argv[pos] != NULL) pos++;
	if (checkcfg(CFG_XEPHYR_WINDOW_TITLE)) {
		server_argv[pos++] = "-title";
		server_argv[pos++] = "firejail x11 sandbox";
	}

	assert(xephyr_extra_params); // should be "" if empty

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
				if (dquote) temp[i] = '\0'; // replace closing quote by \0
			}
			if (temp[i] == '\'') {
				squote = !squote;
				if (squote) temp[i] = '\0'; // replace closing quote by \0
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

		for (i = 0; i < (int) strlen(xephyr_extra_params)-1; i++) {
			if (pos >= (sizeof(server_argv)/sizeof(*server_argv))) {
				fprintf(stderr, "Error: arg count limit exceeded while parsing xephyr_extra_params\n");
				exit(1);
			}
			if (temp[i] == '\0' && (temp[i+1] == '\"' || temp[i+1] == '\'')) server_argv[pos++] = temp + i + 2;
			else if (temp[i] == '\0' && temp[i+1] != '\0') server_argv[pos++] = temp + i + 1;
		}
	}
	
	server_argv[pos++] = display_str;
	server_argv[pos++] = NULL;

	assert(pos < (sizeof(server_argv)/sizeof(*server_argv))); // no overrun
	assert(server_argv[pos-1] == NULL); // last element is null
	
	if (arg_debug) {
		size_t i = 0;
		printf("xephyr server:");
		while (server_argv[i]!=NULL) {
			printf(" \"%s\"", server_argv[i]);
			i++;
		}
		putchar('\n');
	}

	// remove --x11 arg
	char *jail_argv[argc+2];
	int j = 0;
	for (i = 0; i < argc; i++) {
		if (strcmp(argv[i], "--x11") == 0)
			continue;
		if (strcmp(argv[i], "--x11=xpra") == 0)
			continue;
		if (strcmp(argv[i], "--x11=xephyr") == 0)
			continue;
		jail_argv[j] = argv[i];
		j++;
	}
	jail_argv[j] = NULL;

	assert(j < argc+2); // no overrun

	if (arg_debug) {
		size_t i = 0;
		printf("xephyr client:");
		while (jail_argv[i]!=NULL) {
			printf(" \"%s\"", jail_argv[i]);
			i++;
		}
		putchar('\n');
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
	
	if (arg_debug) {
            	printf("X11 sockets: "); fflush(0);
            	int rv = system("ls /tmp/.X11-unix");
            	(void) rv;
	}

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
	} else if (pid == jail) {
		kill(server, SIGTERM);
	}

	// without this closing Xephyr window may mess your terminal:
	// "monitoring" process will release terminal before
	// jail process ends and releases terminal
	wait(NULL); // fulneral

	exit(0);
}

void x11_start_xpra(int argc, char **argv) {
	EUID_ASSERT();
	int i;
	struct stat s;
	pid_t client = 0;
	pid_t server = 0;
	
	setenv("FIREJAIL_X11", "yes", 1);

	// unfortunately, xpra does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}
	drop_privs(0);

	// check xpra
	if (x11_check_xpra() == 0) {
		fprintf(stderr, "\nError: Xpra program was not found in /usr/bin directory, please install it:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n");
		exit(0);
	}
	
	int display = random_display_number();
	char *display_str;
	if (asprintf(&display_str, ":%d", display) == -1)
		errExit("asprintf");

	// build the start command
	char *server_argv[] = { "xpra", "start", display_str, "--no-daemon",  NULL };

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
	
	if (arg_debug) {
                printf("X11 sockets: "); fflush(0);
                int rv = system("ls /tmp/.X11-unix");
                (void) rv;
        }

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

		if (!arg_quiet)
			printf("\n*** Attaching to xpra display %d ***\n\n", display);

		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);	
		execvp(attach_argv[0], attach_argv);
		perror("execvp");
		_exit(1);
	}

	setenv("DISPLAY", display_str, 1);

	// build jail command
	char *firejail_argv[argc+2];
	int pos = 0;
	for (i = 0; i < argc; i++) {
		if (strcmp(argv[i], "--x11") == 0)
			continue;
		if (strcmp(argv[i], "--x11=xpra") == 0)
			continue;
		if (strcmp(argv[i], "--x11=xephyr") == 0)
			continue;
		firejail_argv[pos] = argv[i];
		pos++;
	}
	firejail_argv[pos] = NULL;

	assert(pos < (argc+2));
	assert(!firejail_argv[pos]);

	// start jail
	pid_t jail = fork();
	if (jail < 0)
		errExit("fork");
	if (jail == 0) {
		// running without privileges - see drop_privs call above
		assert(getenv("LD_PRELOAD") == NULL);	
		if (firejail_argv[0]) // shut up llvm scan-build
			execvp(firejail_argv[0], firejail_argv);
		perror("execvp");
		exit(1);
	}

	if (!arg_quiet)
		printf("Xpra server pid %d, xpra client pid %d, jail %d\n", server, client, jail);

	sleep(1); // let jail start

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

void x11_start(int argc, char **argv) {
	EUID_ASSERT();

	// unfortunately, xpra does a number of weird things when started by root user!!!
	if (getuid() == 0) {
		fprintf(stderr, "Error: X11 sandboxing is not available when running as root\n");
		exit(1);
	}

	// check xpra
	if (x11_check_xpra() == 1)
		x11_start_xpra(argc, argv);
	else if (x11_check_xephyr() == 1)
		x11_start_xephyr(argc, argv);
	else {
		fprintf(stderr, "\nError: Xpra or Xephyr not found in /usr/bin directory, please install one of them:\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xpra\n");
		fprintf(stderr, "   Debian/Ubuntu/Mint: sudo apt-get install xserver-xephyr\n");
		exit(0);
	}
}

#endif

void x11_block(void) {
#ifdef HAVE_X11
	mask_x11_abstract_socket = 1;

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

void x11_xorg(void) {
#ifdef HAVE_X11
	// destination - create an empty ~/.Xauthotrity file if it doesn't exist already, and use it as a mount point
	char *dest;
	if (asprintf(&dest, "%s/.Xauthority", cfg.homedir) == -1)
		errExit("asprintf");
	struct stat s;
	if (stat(dest, &s) == -1) {
		// create an .Xauthority file
		FILE *fp = fopen(dest, "w");
		if (!fp)
			errExit("fopen");
		SET_PERMS_STREAM(fp, getuid(), getgid(), 0600);
		fclose(fp);
	}

	// check xauth utility is present in the system
	if (stat("/usr/bin/xauth", &s) == -1) {
		fprintf(stderr, "Error: cannot find /usr/bin/xauth executable\n");
		exit(1);
	}

	// create a temporary .Xauthority file
	char tmpfname[] = "/tmp/.tmpXauth-XXXXXX";
	int fd = mkstemp(tmpfname);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot create .Xauthority file\n");
		exit(1);
	}
	close(fd);
	if (chown(tmpfname, getuid(), getgid()) == -1)
		errExit("chown");

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// generate the new .Xauthority file using xauth utility
		if (arg_debug)
			printf("Generating a new .Xauthority file\n");
		drop_privs(1);

		char *display = getenv("DISPLAY");
		if (!display)
			display = ":0.0";
		
		clearenv();
		execlp("/usr/bin/xauth", "/usr/bin/xauth", "-f", tmpfname,
			"generate", display, "MIT-MAGIC-COOKIE-1", "untrusted", NULL); 
		
		_exit(0);
	}

	// wait for the child to finish
	waitpid(child, NULL, 0);

	// check the file was created and set mode and ownership
	if (stat(tmpfname, &s) == -1) {
		fprintf(stderr, "Error: cannot create the new .Xauthority file\n");
		exit(1);
	}
	if (chown(tmpfname, getuid(), getgid()) == -1)
		errExit("chown");
	if (chmod(tmpfname, 0600) == -1)
		errExit("chmod");
	
	// move the temporary file in RUN_XAUTHORITY_SEC_FILE in order to have it deleted
	// automatically when the sandbox is closed
	if (copy_file(tmpfname, RUN_XAUTHORITY_SEC_FILE, getuid(), getgid(), 0600)) {
		fprintf(stderr, "asdfdsfError: cannot create the new .Xauthority file\n");
		exit(1);
	}
	if (chown(RUN_XAUTHORITY_SEC_FILE, getuid(), getgid()) == -1)
		errExit("chown");
	if (chmod(RUN_XAUTHORITY_SEC_FILE, 0600) == -1)
		errExit("chmod");
	unlink(tmpfname);
	
	// mount
	if (mount(RUN_XAUTHORITY_SEC_FILE, dest, "none", MS_BIND, "mode=0600") == -1) {
		fprintf(stderr, "Error: cannot mount the new .Xauthority file\n");
		exit(1);
	}
	if (chown(dest, getuid(), getgid()) == -1)
		errExit("chown");
	if (chmod(dest, 0600) == -1)
		errExit("chmod");
	free(dest);
#endif	
}

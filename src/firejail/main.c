/*
 * Copyright (C) 2014-2019 Firejail Authors
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
#include "../include/pid.h"
#include "../include/firejail_user.h"
#define _GNU_SOURCE
#include <sys/utsname.h>
#include <sched.h>
#include <sys/mount.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <dirent.h>
#include <pwd.h>
#include <errno.h>
#include <limits.h>
#include <sys/file.h>
#include <sys/prctl.h>
#include <signal.h>
#include <time.h>
#include <net/if.h>
#include <sys/utsname.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#ifdef __ia64__
/* clone(2) has a different interface on ia64, as it needs to know
   the size of the stack */
int __clone2(int (*fn)(void *),
             void *child_stack_base, size_t stack_size,
             int flags, void *arg, ...
              /* pid_t *ptid, struct user_desc *tls, pid_t *ctid */ );
#endif

uid_t firejail_uid = 0;
gid_t firejail_gid = 0;

#define STACK_SIZE (1024 * 1024)
static char child_stack[STACK_SIZE];		// space for child's stack
Config cfg;					// configuration
int arg_private = 0;				// mount private /home and /tmp directoryu
int arg_private_cache = 0;		// mount private home/.cache
int arg_debug = 0;				// print debug messages
int arg_debug_blacklists = 0;			// print debug messages for blacklists
int arg_debug_whitelists = 0;			// print debug messages for whitelists
int arg_debug_private_lib = 0;			// print debug messages for private-lib
int arg_nonetwork = 0;				// --net=none
int arg_command = 0;				// -c
int arg_overlay = 0;				// overlay option
int arg_overlay_keep = 0;			// place overlay diff in a known directory
int arg_overlay_reuse = 0;			// allow the reuse of overlays

int arg_seccomp = 0;				// enable default seccomp filter
int arg_seccomp_postexec = 0;			// need postexec ld.preload library?
int arg_seccomp_block_secondary = 0;		// block any secondary architectures

int arg_caps_default_filter = 0;			// enable default capabilities filter
int arg_caps_drop = 0;				// drop list
int arg_caps_drop_all = 0;			// drop all capabilities
int arg_caps_keep = 0;			// keep list
char *arg_caps_list = NULL;			// optional caps list

int arg_trace = 0;				// syscall tracing support
char *arg_tracefile = NULL;			// syscall tracing file
int arg_tracelog = 0;				// blacklist tracing support
int arg_rlimit_cpu = 0;				// rlimit max cpu time
int arg_rlimit_nofile = 0;			// rlimit nofile
int arg_rlimit_nproc = 0;			// rlimit nproc
int arg_rlimit_fsize = 0;				// rlimit fsize
int arg_rlimit_sigpending = 0;			// rlimit fsize
int arg_rlimit_as = 0;				// rlimit as
int arg_nogroups = 0;				// disable supplementary groups
int arg_nonewprivs = 0;			// set the NO_NEW_PRIVS prctl
int arg_noroot = 0;				// create a new user namespace and disable root user
int arg_netfilter;				// enable netfilter
int arg_netfilter6;				// enable netfilter6
char *arg_netfilter_file = NULL;			// netfilter file
char *arg_netfilter6_file = NULL;		// netfilter6 file
char *arg_netns = NULL;			// "ip netns"-created network namespace to use
int arg_doubledash = 0;			// double dash
int arg_shell_none = 0;			// run the program directly without a shell
int arg_private_dev = 0;			// private dev directory
int arg_keep_dev_shm = 0;                       // preserve /dev/shm
int arg_private_etc = 0;			// private etc directory
int arg_private_opt = 0;			// private opt directory
int arg_private_srv = 0;			// private srv directory
int arg_private_bin = 0;			// private bin directory
int arg_private_tmp = 0;			// private tmp directory
int arg_private_lib = 0;			// private lib directory
int arg_private_cwd = 0;			// private working directory
int arg_scan = 0;				// arp-scan all interfaces
int arg_whitelist = 0;				// whitelist command
int arg_nosound = 0;				// disable sound
int arg_noautopulse = 0;			// disable automatic ~/.config/pulse init
int arg_novideo = 0;			//disable video devices in /dev
int arg_no3d;					// disable 3d hardware acceleration
int arg_quiet = 0;				// no output for scripting
int arg_join_network = 0;			// join only the network namespace
int arg_join_filesystem = 0;			// join only the mount namespace
int arg_nice = 0;				// nice value configured
int arg_ipc = 0;					// enable ipc namespace
int arg_writable_etc = 0;			// writable etc
int arg_writable_var = 0;			// writable var
int arg_keep_var_tmp = 0;                       // don't overwrite /var/tmp
int arg_writable_run_user = 0;			// writable /run/user
int arg_writable_var_log = 0;		// writable /var/log
int arg_appimage = 0;				// appimage
int arg_audit = 0;				// audit
char *arg_audit_prog = NULL;			// audit
int arg_apparmor = 0;				// apparmor
int arg_allow_debuggers = 0;			// allow debuggers
int arg_x11_block = 0;				// block X11
int arg_x11_xorg = 0;				// use X11 security extension
int arg_allusers = 0;				// all user home directories visible
int arg_machineid = 0;				// preserve /etc/machine-id
int arg_allow_private_blacklist = 0; 		// blacklist things in private directories
int arg_disable_mnt = 0;			// disable /mnt and /media
int arg_noprofile = 0; // use default.profile if none other found/specified
int arg_memory_deny_write_execute = 0;		// block writable and executable memory
int arg_notv = 0;	// --notv
int arg_nodvd = 0; // --nodvd
int arg_nodbus = 0; // -nodbus
int arg_nou2f = 0; // --nou2f
int arg_deterministic_exit_code = 0;	// always exit with first child's exit status
int login_shell = 0;


int parent_to_child_fds[2];
int child_to_parent_fds[2];

char *fullargv[MAX_ARGS];			// expanded argv for restricted shell
int fullargc = 0;
static pid_t child = 0;
pid_t sandbox_pid;
mode_t orig_umask = 022;
unsigned long long start_timestamp;

static void clear_atexit(void) {
	EUID_ROOT();
	delete_run_files(getpid());
}

static void myexit(int rv) {
	logmsg("exiting...");
	if (!arg_command)
		fmessage("\nParent is shutting down, bye...\n");


	// delete sandbox files in shared memory
	EUID_ROOT();
	delete_run_files(sandbox_pid);
	appimage_clear();
	flush_stdin();
	exit(rv);
}

static void my_handler(int s) {
	fmessage("\nParent received signal %d, shutting down the child process...\n", s);
	logsignal(s);
	if (waitpid(child, NULL, WNOHANG) == 0) {
		if (has_handler(child, s)) // signals are not delivered if there is no handler yet
			kill(child, s);
		else
			kill(child, SIGKILL);
		waitpid(child, NULL, 0);
	}
	myexit(s);
}

static void install_handler(void) {
	struct sigaction sga;

	// block SIGTERM while handling SIGINT
	sigemptyset(&sga.sa_mask);
	sigaddset(&sga.sa_mask, SIGTERM);
	sga.sa_handler = my_handler;
	sga.sa_flags = 0;
	sigaction(SIGINT, &sga, NULL);

	// block SIGINT while handling SIGTERM
	sigemptyset(&sga.sa_mask);
	sigaddset(&sga.sa_mask, SIGINT);
	sga.sa_handler = my_handler;
	sga.sa_flags = 0;
	sigaction(SIGTERM, &sga, NULL);
}

// return 1 if error, 0 if a valid pid was found
static int extract_pid(const char *name, pid_t *pid) {
	int retval = 0;
	EUID_ASSERT();
	if (!name || strlen(name) == 0) {
		fprintf(stderr, "Error: invalid sandbox name\n");
		exit(1);
	}

	EUID_ROOT();
	if (name2pid(name, pid)) {
		retval = 1;
	}
	EUID_USER();
	return retval;
}

// return 1 if error, 0 if a valid pid was found
static int read_pid(const char *name, pid_t *pid) {
	char *endptr;
	errno = 0;
	long int pidtmp = strtol(name, &endptr, 10);
	if ((errno == ERANGE && (pidtmp == LONG_MAX || pidtmp == LONG_MIN))
		|| (errno != 0 && pidtmp == 0)) {
		return extract_pid(name,pid);
	}
	// endptr points to '\0' char in name if the entire string is valid
	if (endptr == NULL || endptr[0]!='\0') {
		return extract_pid(name,pid);
	}
	*pid =(pid_t)pidtmp;
	return 0;
}

static pid_t require_pid(const char *name) {
	pid_t pid;
	if (read_pid(name,&pid)) {
		fprintf(stderr, "Error: cannot find sandbox %s\n", name);
		exit(1);
	}
	return pid;
}

// return 1 if there is a link somewhere in path of directory
static int has_link(const char *dir) {
	assert(dir);
	int fd = safe_fd(dir, O_PATH|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
	if (fd == -1) {
		if (errno == ENOTDIR && is_dir(dir))
			return 1;
	}
	else
		close(fd);
	return 0;
}

static void check_homedir(void) {
	assert(cfg.homedir);
	if (cfg.homedir[0] != '/' || cfg.homedir[1] == '\0') { // system users sometimes have root directory as home
		fprintf(stderr, "Error: invalid user directory \"%s\"\n", cfg.homedir);
		exit(1);
	}
	// symlinks are rejected in many places
	if (has_link(cfg.homedir)) {
		fprintf(stderr, "No full support for symbolic links in path of user directory.\n"
			"Please provide resolved path in password database (/etc/passwd).\n\n");
	}
}

// init configuration
static void init_cfg(int argc, char **argv) {
	EUID_ASSERT();
	memset(&cfg, 0, sizeof(cfg));

	cfg.original_argv = argv;
	cfg.original_argc = argc;
	cfg.bridge0.devsandbox = "eth0";
	cfg.bridge1.devsandbox = "eth1";
	cfg.bridge2.devsandbox = "eth2";
	cfg.bridge3.devsandbox = "eth3";

	// extract user data
	EUID_ROOT(); // rise permissions for grsecurity
	struct passwd *pw = getpwuid(getuid());
	if (!pw)
		errExit("getpwuid");
	EUID_USER();
	cfg.username = strdup(pw->pw_name);
	if (!cfg.username)
		errExit("strdup");

	// check user database
	if (!firejail_user_check(cfg.username)) {
		fprintf(stderr, "Error: the user is not allowed to use Firejail.\n"
			"Please add the user in %s/firejail.users file,\n"
			"either by running \"sudo firecfg\", or by editing the file directly.\n"
			"See \"man firejail-users\" for more details.\n\n", SYSCONFDIR);

		// attempt to run the program as is
		run_symlink(argc, argv, 1);
		exit(1);
	}

	cfg.cwd = getcwd(NULL, 0);
	if (!cfg.cwd && errno != ENOENT)
		errExit("getcwd");

	// build home directory name
	if (pw->pw_dir == NULL) {
		fprintf(stderr, "Error: user %s doesn't have a user directory assigned\n", cfg.username);
		exit(1);
	}
	cfg.homedir = clean_pathname(pw->pw_dir);
	check_homedir();

	// initialize random number generator
	sandbox_pid = getpid();
	time_t t = time(NULL);
	srand(t ^ sandbox_pid);
}

static void check_network(Bridge *br) {
	assert(br);
	if (br->macvlan == 0) // for bridge devices check network range or arp-scan and assign address
		net_configure_sandbox_ip(br);
	else if (br->ipsandbox) { // for macvlan check network range
		char *rv = in_netrange(br->ipsandbox, br->ip, br->mask);
		if (rv) {
			fprintf(stderr, "%s", rv);
			exit(1);
		}
	}
}

#ifdef HAVE_USERNS
void check_user_namespace(void) {
	EUID_ASSERT();
	if (getuid() == 0)
		goto errout;

	// test user namespaces available in the kernel
	struct stat s1;
	struct stat s2;
	struct stat s3;
	if (stat("/proc/self/ns/user", &s1) == 0 &&
	    stat("/proc/self/uid_map", &s2) == 0 &&
	    stat("/proc/self/gid_map", &s3) == 0)
		arg_noroot = 1;
	else
		goto errout;

	return;

errout:
	fwarning("noroot option is not available\n");
	arg_noroot = 0;

}
#endif


static void exit_err_feature(const char *feature) {
	fprintf(stderr, "Error: %s feature is disabled in Firejail configuration file\n", feature);
	exit(1);
}

// run independent commands and exit program
// this function handles command line options such as --version and --help
static void run_cmd_and_exit(int i, int argc, char **argv) {
	EUID_ASSERT();

	//*************************************
	// basic arguments
	//*************************************
	if (strcmp(argv[i], "--help") == 0 ||
	    strcmp(argv[i], "-?") == 0) {
		usage();
		exit(0);
	}
	else if (strcmp(argv[i], "--version") == 0) {
		printf("firejail version %s\n", VERSION);
		printf("\n");
		print_compiletime_support();
		printf("\n");
		exit(0);
	}
#ifdef HAVE_OVERLAYFS
	else if (strcmp(argv[i], "--overlay-clean") == 0) {
		if (checkcfg(CFG_OVERLAYFS)) {
			if (remove_overlay_directory()) {
				fprintf(stderr, "Error: cannot remove overlay directory\n");
				exit(1);
			}
		}
		else
			exit_err_feature("overlayfs");
		exit(0);
	}
#endif
#ifdef HAVE_X11
	else if (strcmp(argv[i], "--x11") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start(argc, argv);
			exit(0);
		}
		else
			exit_err_feature("x11");
	}
	else if (strcmp(argv[i], "--x11=xpra") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start_xpra(argc, argv);
			exit(0);
		}
		else
			exit_err_feature("x11");
	}
	else if (strcmp(argv[i], "--x11=xephyr") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start_xephyr(argc, argv);
			exit(0);
		}
		else
			exit_err_feature("x11");
	}
	else if (strcmp(argv[i], "--x11=xvfb") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start_xvfb(argc, argv);
			exit(0);
		}
		else
			exit_err_feature("x11");
	}
#endif
#ifdef HAVE_NETWORK
	else if (strncmp(argv[i], "--bandwidth=", 12) == 0) {
		if (checkcfg(CFG_NETWORK)) {
			logargs(argc, argv);

			// extract the command
			if ((i + 1) == argc) {
				fprintf(stderr, "Error: command expected after --bandwidth option\n");
				exit(1);
			}
			char *cmd = argv[i + 1];
			if (strcmp(cmd, "status") && strcmp(cmd, "clear") && strcmp(cmd, "set")) {
				fprintf(stderr, "Error: invalid --bandwidth command.\nValid commands: set, clear, status.\n");
				exit(1);
			}

			// extract network name
			char *dev = NULL;
			int down = 0;
			int up = 0;
			if (strcmp(cmd, "set") == 0 || strcmp(cmd, "clear") == 0) {
				// extract device name
				if ((i + 2) == argc) {
					fprintf(stderr, "Error: network name expected after --bandwidth %s option\n", cmd);
					exit(1);
				}
				dev = argv[i + 2];

				// check device name
				if (if_nametoindex(dev) == 0) {
					fprintf(stderr, "Error: network device %s not found\n", dev);
					exit(1);
				}

				// extract bandwidth
				if (strcmp(cmd, "set") == 0) {
					if ((i + 4) >= argc) {
						fprintf(stderr, "Error: invalid --bandwidth set command\n");
						exit(1);
					}

					down = atoi(argv[i + 3]);
					if (down < 0) {
						fprintf(stderr, "Error: invalid download speed\n");
						exit(1);
					}
					up = atoi(argv[i + 4]);
					if (up < 0) {
						fprintf(stderr, "Error: invalid upload speed\n");
						exit(1);
					}
				}
			}

			// extract pid or sandbox name
			pid_t pid = require_pid(argv[i] + 12);
			bandwidth_pid(pid, cmd, dev, down, up);
		}
		else
			exit_err_feature("networking");
		exit(0);
	}
	else if (strncmp(argv[i], "--netfilter.print=", 18) == 0) {
		// extract pid or sandbox name
		pid_t pid = require_pid(argv[i] + 18);
		netfilter_print(pid, 0);
		exit(0);
	}
	else if (strncmp(argv[i], "--netfilter6.print=", 19) == 0) {
		// extract pid or sandbox name
		pid_t pid = require_pid(argv[i] + 19);
		netfilter_print(pid, 1);
		exit(0);
	}
#endif
	//*************************************
	// independent commands - the program will exit!
	//*************************************
#ifdef HAVE_SECCOMP
	else if (strcmp(argv[i], "--debug-syscalls") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSECCOMP_MAIN, "debug-syscalls");
			exit(rv);
		}
		else
			exit_err_feature("seccomp");
	}
	else if (strcmp(argv[i], "--debug-errnos") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSECCOMP_MAIN, "debug-errnos");
			exit(rv);
		}
		else
			exit_err_feature("seccomp");
		exit(0);
	}
	else if (strncmp(argv[i], "--seccomp.print=", 16) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			// print seccomp filter for a sandbox specified by pid or by name
			pid_t pid = require_pid(argv[i] + 16);
			seccomp_print_filter(pid);
		}
		else
			exit_err_feature("seccomp");
		exit(0);
	}
	else if (strcmp(argv[i], "--debug-protocols") == 0) {
		int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FSECCOMP_MAIN, "debug-protocols");
		exit(rv);
	}
	else if (strncmp(argv[i], "--protocol.print=", 17) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			// print seccomp filter for a sandbox specified by pid or by name
			pid_t pid = require_pid(argv[i] + 17);
			protocol_print_filter(pid);
		}
		else
			exit_err_feature("seccomp");
		exit(0);
	}
#endif
	else if (strncmp(argv[i], "--profile.print=", 16) == 0) {
		pid_t pid = require_pid(argv[i] + 16);

		// print /run/firejail/profile/<PID> file
		char *fname;
		if (asprintf(&fname, RUN_FIREJAIL_PROFILE_DIR "/%d", pid) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Error: sandbox %s not found\n", argv[i] + 16);
			exit(1);
		}
#define MAXBUF 4096
		char buf[MAXBUF];
		if (fgets(buf, MAXBUF, fp))
			printf("%s", buf);
		fclose(fp);
		exit(0);

	}
	else if (strncmp(argv[i], "--cpu.print=", 12) == 0) {
		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 12);
		cpu_print_filter(pid);
		exit(0);
	}
	else if (strncmp(argv[i], "--apparmor.print=", 17) == 0) {
		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 17);
		char *pidstr;
		if (asprintf(&pidstr, "%u", pid) == -1)
			errExit("asprintf");
		sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 3, PATH_FIREMON, "--apparmor", pidstr);
		free(pidstr);
		exit(0);
	}
	else if (strncmp(argv[i], "--caps.print=", 13) == 0) {
		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 13);
		caps_print_filter(pid);
		exit(0);
	}
	else if (strncmp(argv[i], "--fs.print=", 11) == 0) {
		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 11);
		fs_logger_print_log(pid);
		exit(0);
	}
	else if (strncmp(argv[i], "--dns.print=", 12) == 0) {
		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 12);
		net_dns_print(pid);
		exit(0);
	}
	else if (strcmp(argv[i], "--debug-caps") == 0) {
		caps_print();
		exit(0);
	}
	else if (strcmp(argv[i], "--list") == 0) {
		if (pid_hidepid())
			sbox_run(SBOX_ROOT| SBOX_CAPS_HIDEPID | SBOX_SECCOMP, 2, PATH_FIREMON, "--list");
		else
			sbox_run(SBOX_USER| SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FIREMON, "--list");
		exit(0);
	}
	else if (strcmp(argv[i], "--tree") == 0) {
		if (pid_hidepid())
			sbox_run(SBOX_ROOT | SBOX_CAPS_HIDEPID | SBOX_SECCOMP, 2, PATH_FIREMON, "--tree");
		else
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 2, PATH_FIREMON, "--tree");
		exit(0);
	}
	else if (strcmp(argv[i], "--top") == 0) {
		if (pid_hidepid())
			sbox_run(SBOX_ROOT | SBOX_CAPS_HIDEPID | SBOX_SECCOMP | SBOX_ALLOW_STDIN,
				2, PATH_FIREMON, "--top");
		else
			sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP | SBOX_ALLOW_STDIN,
				2, PATH_FIREMON, "--top");
		exit(0);
	}
#ifdef HAVE_NETWORK
	else if (strcmp(argv[i], "--netstats") == 0) {
		if (checkcfg(CFG_NETWORK)) {
			struct stat s;
			if (stat("/proc/sys/kernel/grsecurity", &s) == 0 || pid_hidepid())
				sbox_run(SBOX_ROOT | SBOX_CAPS_HIDEPID | SBOX_SECCOMP | SBOX_ALLOW_STDIN,
					2, PATH_FIREMON, "--netstats");
			else
				sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP | SBOX_ALLOW_STDIN,
					2, PATH_FIREMON, "--netstats");
			exit(0);
		}
		else
			exit_err_feature("networking");
	}
	else if (strncmp(argv[i], "--net.print=", 12) == 0) {
		if (checkcfg(CFG_NETWORK)) {
			// extract pid or sandbox name
			pid_t pid = require_pid(argv[i] + 12);
			net_print(pid);
			exit(0);
		}
		else
			exit_err_feature("networking");
	}
#endif
#ifdef HAVE_FILE_TRANSFER
	else if (strncmp(argv[i], "--get=", 6) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			if (arg_private_cwd) {
				fprintf(stderr, "Error: --get and --private-cwd options are mutually exclusive\n");
				exit(1);
			}

			// verify path
			if ((i + 2) != argc) {
				fprintf(stderr, "Error: invalid --get option, path expected\n");
				exit(1);
			}
			char *path = argv[i + 1];
			 invalid_filename(path, 0); // no globbing
			 if (strstr(path, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path);
			 	exit(1);
			 }

			// get file
			pid_t pid = require_pid(argv[i] + 6);
			sandboxfs(SANDBOX_FS_GET, pid, path, NULL);
			exit(0);
		}
		else
			exit_err_feature("file transfer");
	}
	else if (strncmp(argv[i], "--put=", 6) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			if (arg_private_cwd) {
				fprintf(stderr, "Error: --put and --private-cwd options are mutually exclusive\n");
				exit(1);
			}

			// verify path
			if ((i + 3) != argc) {
				fprintf(stderr, "Error: invalid --put option, 2 paths expected\n");
				exit(1);
			}
			char *path1 = argv[i + 1];
			 invalid_filename(path1, 0); // no globbing
			 if (strstr(path1, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path1);
			 	exit(1);
			 }
			char *path2 = argv[i + 2];
			 invalid_filename(path2, 0); // no globbing
			 if (strstr(path2, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path2);
			 	exit(1);
			 }

			// get file
			pid_t pid = require_pid(argv[i] + 6);
			sandboxfs(SANDBOX_FS_PUT, pid, path1, path2);
			exit(0);
		}
		else
			exit_err_feature("file transfer");
	}
	else if (strncmp(argv[i], "--ls=", 5) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			if (arg_private_cwd) {
				fprintf(stderr, "Error: --ls and --private-cwd options are mutually exclusive\n");
				exit(1);
			}

			// verify path
			if ((i + 2) != argc) {
				fprintf(stderr, "Error: invalid --ls option, path expected\n");
				exit(1);
			}
			char *path = argv[i + 1];
			 invalid_filename(path, 0); // no globbing
			 if (strstr(path, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path);
			 	exit(1);
			 }

			// list directory contents
			pid_t pid = require_pid(argv[i] + 5);
			sandboxfs(SANDBOX_FS_LS, pid, path, NULL);
			exit(0);
		}
		else
			exit_err_feature("file transfer");
	}
#endif
	else if (strncmp(argv[i], "--join=", 7) == 0) {
		if (checkcfg(CFG_JOIN) || getuid() == 0) {
			logargs(argc, argv);

			if (arg_shell_none) {
				if (argc <= (i+1)) {
					fprintf(stderr, "Error: --shell=none set, but no command specified\n");
					exit(1);
				}
				cfg.original_program_index = i + 1;
			}

			if (!cfg.shell && !arg_shell_none)
				cfg.shell = guess_shell();

			// join sandbox by pid or by name
			pid_t pid = require_pid(argv[i] + 7);
			join(pid, argc, argv, i + 1);
			exit(0);
		}
		else
			exit_err_feature("join");

	}
	else if (strncmp(argv[i], "--join-or-start=", 16) == 0) {
		// NOTE: this is first part of option handler,
		// 		 sandbox name is set in other part
		if (checkcfg(CFG_JOIN) || getuid() == 0) {
			logargs(argc, argv);

			if (arg_shell_none) {
				if (argc <= (i+1)) {
					fprintf(stderr, "Error: --shell=none set, but no command specified\n");
					exit(1);
				}
				cfg.original_program_index = i + 1;
			}

			// try to join by name only
			pid_t pid;
			if (!read_pid(argv[i] + 16, &pid)) {
				if (!cfg.shell && !arg_shell_none)
					cfg.shell = guess_shell();

				join(pid, argc, argv, i + 1);
				exit(0);
			}
			// if there no such sandbox continue argument processing
		}
		else
			exit_err_feature("join");
	}
#ifdef HAVE_NETWORK
	else if (strncmp(argv[i], "--join-network=", 15) == 0) {
		if (checkcfg(CFG_NETWORK)) {
			logargs(argc, argv);
			arg_join_network = 1;
			if (getuid() != 0) {
				fprintf(stderr, "Error: --join-network is only available to root user\n");
				exit(1);
			}

			if (!cfg.shell && !arg_shell_none)
				cfg.shell = guess_shell();

			// join sandbox by pid or by name
			pid_t pid = require_pid(argv[i] + 15);
			join(pid, argc, argv, i + 1);
		}
		else
			exit_err_feature("networking");
		exit(0);
	}
#endif
	else if (strncmp(argv[i], "--join-filesystem=", 18) == 0) {
		logargs(argc, argv);
		arg_join_filesystem = 1;
		if (getuid() != 0) {
			fprintf(stderr, "Error: --join-filesystem is only available to root user\n");
			exit(1);
		}

		if (!cfg.shell && !arg_shell_none)
			cfg.shell = guess_shell();

		// join sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 18);
		join(pid, argc, argv, i + 1);
		exit(0);
	}
	else if (strncmp(argv[i], "--shutdown=", 11) == 0) {
		logargs(argc, argv);

		// shutdown sandbox by pid or by name
		pid_t pid = require_pid(argv[i] + 11);
		shut(pid);
		exit(0);
	}

}

char *guess_shell(void) {
	char *shell = NULL;
	struct stat s;

	shell = getenv("SHELL");
	if (shell) {
		invalid_filename(shell, 0); // no globbing
		if (!is_dir(shell) && strstr(shell, "..") == NULL && stat(shell, &s) == 0 && access(shell, X_OK) == 0)
			return shell;
	}

	// shells in order of preference
	char *shells[] = {"/bin/bash", "/bin/csh", "/usr/bin/zsh", "/bin/sh", "/bin/ash", NULL };

	int i = 0;
	while (shells[i] != NULL) {
		// access call checks as real UID/GID, not as effective UID/GID
		if (stat(shells[i], &s) == 0 && access(shells[i], X_OK) == 0) {
			shell = shells[i];
			break;
		}
		i++;
	}

	return shell;
}

static int check_arg(int argc, char **argv, const char *argument, int strict) {
	int i;
	int found = 0;
	for (i = 1; i < argc; i++) {
		if (strict) {
			if (strcmp(argv[i], argument) == 0) {
				found = 1;
				break;
			}
		}
		else {
			if (strncmp(argv[i], argument, strlen(argument)) == 0) {
				found = 1;
				break;
			}
		}

		// detect end of firejail params
		if (strcmp(argv[i], "--") == 0)
			break;
		if (strncmp(argv[i], "--", 2) != 0)
			break;
	}

	return found;
}

static void run_builder(int argc, char **argv) {
	EUID_ASSERT();
	(void) argc;

	// drop privileges
	if (setresgid(-1, getgid(), getgid()) != 0)
		errExit("setresgid");
	if (setresuid(-1, getuid(), getuid()) != 0)
		errExit("setresuid");

	assert(getenv("LD_PRELOAD") == NULL);
	umask(orig_umask);

	argv[0] = LIBDIR "/firejail/fbuilder";
	execvp(argv[0], argv);

	perror("execvp");
	exit(1);
}


//*******************************************
// Main program
//*******************************************
int main(int argc, char **argv) {
	int i;
	int prog_index = -1;			  // index in argv where the program command starts
	int lockfd_network = -1;
	int lockfd_directory = -1;
	int option_cgroup = 0;
	int custom_profile = 0;	// custom profile loaded
	int arg_caps_cmdline = 0; 	// caps requested on command line (used to break out of --chroot)

	// drop permissions by default and rise them when required
	EUID_INIT();
	EUID_USER();

	// sanitize the umask
	orig_umask = umask(022);

	// argument count should be larger than 0
	if (argc == 0) {
		fprintf(stderr, "Error: argv[0] is NULL\n");
		exit(1);
	}

	// check if the user is allowed to use firejail
	init_cfg(argc, argv);

	// get starting timestamp, process --quiet
	start_timestamp = getticks();
	char *env_quiet = getenv("FIREJAIL_QUIET");
	if (check_arg(argc, argv, "--quiet", 1) || (env_quiet && strcmp(env_quiet, "yes") == 0))
		arg_quiet = 1;

	// cleanup at exit
	EUID_ROOT();
	atexit(clear_atexit);

	// build /run/firejail directory structure
	preproc_build_firejail_dir();
	char *container_name = getenv("container");
	if (!container_name || strcmp(container_name, "firejail")) {
		lockfd_directory = open(RUN_DIRECTORY_LOCK_FILE, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
		if (lockfd_directory != -1) {
			int rv = fchown(lockfd_directory, 0, 0);
			(void) rv;
			flock(lockfd_directory, LOCK_EX);
		}
		preproc_clean_run();
		flock(lockfd_directory, LOCK_UN);
		close(lockfd_directory);
	}
	EUID_USER();


	// process allow-debuggers
	if (check_arg(argc, argv, "--allow-debuggers", 1)) {
		// check kernel version
		struct utsname u;
		int rv = uname(&u);
		if (rv != 0)
			errExit("uname");
		int major;
		int minor;
		if (2 != sscanf(u.release, "%d.%d", &major, &minor)) {
			fprintf(stderr, "Error: cannot extract Linux kernel version: %s\n", u.version);
			exit(1);
		}
		if (major < 4 || (major == 4 && minor < 8)) {
			fprintf(stderr, "Error: --allow-debuggers is disabled on Linux kernels prior to 4.8. "
				"A bug in ptrace call allows a full bypass of the seccomp filter. "
				"Your current kernel version is %d.%d.\n", major, minor);
			exit(1);
		}

		arg_allow_debuggers = 1;
		char *cmd = strdup("noblacklist ${PATH}/strace");
		if (!cmd)
			errExit("strdup");
		profile_add(cmd);
	}

	// profile builder
	if (check_arg(argc, argv, "--build", 0)) // supports both --build and --build=filename
		run_builder(argc, argv); // this function will not return

	// check argv[0] symlink wrapper if this is not a login shell
	if (*argv[0] != '-')
		run_symlink(argc, argv, 0); // if symlink detected, this function will not return

	// check if we already have a sandbox running
	// If LXC is detected, start firejail sandbox
	// otherwise try to detect a PID namespace by looking under /proc for specific kernel processes and:
	//	- start the application in a /bin/bash shell
	if (check_namespace_virt() == 0) {
		EUID_ROOT();
		int rv = check_kernel_procs();
		EUID_USER();
		if (rv == 0) {
			if (check_arg(argc, argv, "--version", 1)) {
				printf("firejail version %s\n", VERSION);
				exit(0);
			}

			// start the program directly without sandboxing
			run_no_sandbox(argc, argv);
			// it will never get here!
			assert(0);
		}
	}
	EUID_ASSERT();


	// check firejail directories
	EUID_ROOT();
	delete_run_files(sandbox_pid);
	EUID_USER();

	//check if the parent is sshd daemon
	int parent_sshd = 0;
	{
		pid_t ppid = getppid();
		EUID_ROOT();
		char *comm = pid_proc_comm(ppid);
		EUID_USER();
		if (comm) {
			if (strcmp(comm, "sshd") == 0) {
				arg_quiet = 1;
				parent_sshd = 1;

#ifdef DEBUG_RESTRICTED_SHELL
				{EUID_ROOT();
				FILE *fp = fopen("/firelog", "w");
				if (fp) {
					int i;
					fprintf(fp, "argc %d: ", argc);
					for (i = 0; i < argc; i++)
						fprintf(fp, "#%s# ", argv[i]);
					fprintf(fp, "\n");
					fclose(fp);
				}
				EUID_USER();}
#endif
				// run sftp and scp directly without any sandboxing
				// regular login has argv[0] == "-firejail"
				if (*argv[0] != '-') {
					if (strcmp(argv[1], "-c") == 0 && argc > 2) {
						if (strcmp(argv[2], "/usr/lib/openssh/sftp-server") == 0 ||
						    strncmp(argv[2], "scp ", 4) == 0) {
#ifdef DEBUG_RESTRICTED_SHELL
							{EUID_ROOT();
							FILE *fp = fopen("/firelog", "a");
							if (fp) {
								fprintf(fp, "run without a sandbox\n");
								fclose(fp);
							}
							EUID_USER();}
#endif

							drop_privs(1);
							umask(orig_umask);
							int rv = system(argv[2]);
							exit(rv);
						}
					}
				}
			}
			free(comm);
		}
	}
	EUID_ASSERT();

	// is this a login shell, or a command passed by sshd, insert command line options from /etc/firejail/login.users
	if (*argv[0] == '-' || parent_sshd) {
		if (argc == 1)
			login_shell = 1;
		fullargc = restricted_shell(cfg.username);
		if (fullargc) {

#ifdef DEBUG_RESTRICTED_SHELL
			{EUID_ROOT();
			FILE *fp = fopen("/firelog", "a");
			if (fp) {
				fprintf(fp, "fullargc %d: ",  fullargc);
				int i;
				for (i = 0; i < fullargc; i++)
					fprintf(fp, "#%s# ", fullargv[i]);
				fprintf(fp, "\n");
				fclose(fp);
			}
			EUID_USER();}
#endif

			int j;
			for (i = 1, j = fullargc; i < argc && j < MAX_ARGS; i++, j++, fullargc++)
				fullargv[j] = argv[i];

			// replace argc/argv with fullargc/fullargv
			argv = fullargv;
			argc = j;

#ifdef DEBUG_RESTRICTED_SHELL
			{EUID_ROOT();
			FILE *fp = fopen("/firelog", "a");
			if (fp) {
				fprintf(fp, "argc %d: ", argc);
				int i;
				for (i = 0; i < argc; i++)
					fprintf(fp, "#%s# ", argv[i]);
				fprintf(fp, "\n");
				fclose(fp);
			}
			EUID_USER();}
#endif
		}
	}
	else {
		// check --output option and execute it;
		check_output(argc, argv); // the function will not return if --output or --output-stderr option was found
	}
	EUID_ASSERT();


	// check for force-nonewprivs in /etc/firejail/firejail.config file
	if (checkcfg(CFG_FORCE_NONEWPRIVS))
		arg_nonewprivs = 1;

	// parse arguments
	for (i = 1; i < argc; i++) {
		run_cmd_and_exit(i, argc, argv); // will exit if the command is recognized

		if (strcmp(argv[i], "--debug") == 0 && !arg_quiet)
			arg_debug = 1;
		else if (strcmp(argv[i], "--debug-blacklists") == 0)
			arg_debug_blacklists = 1;
		else if (strcmp(argv[i], "--debug-whitelists") == 0)
			arg_debug_whitelists = 1;
		else if (strcmp(argv[i], "--debug-private-lib") == 0)
			arg_debug_private_lib = 1;
		else if (strcmp(argv[i], "--quiet") == 0) {
			arg_quiet = 1;
			arg_debug = 0;
		}
		else if (strcmp(argv[i], "--allow-debuggers") == 0) {
			// already handled
		}


		//*************************************
		// x11
		//*************************************

#ifdef HAVE_X11
		else if (strncmp(argv[i], "--xephyr-screen=", 16) == 0) {
			if (checkcfg(CFG_X11))
				; // the processing is done directly in x11.c
			else
				exit_err_feature("x11");
		}
#endif
		//*************************************
		// filtering
		//*************************************
#ifdef HAVE_APPARMOR
		else if (strcmp(argv[i], "--apparmor") == 0)
			arg_apparmor = 1;
#endif
#ifdef HAVE_SECCOMP
		else if (strncmp(argv[i], "--protocol=", 11) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (cfg.protocol) {
					fwarning("two protocol lists are present, \"%s\" will be installed\n", cfg.protocol);
				}
				else {
					// store list
					cfg.protocol = strdup(argv[i] + 11);
					if (!cfg.protocol)
						errExit("strdup");
				}
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strcmp(argv[i], "--seccomp") == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strncmp(argv[i], "--seccomp=", 10) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list = seccomp_check_list(argv[i] + 10);
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strncmp(argv[i], "--seccomp.drop=", 15) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list_drop = seccomp_check_list(argv[i] + 15);
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strncmp(argv[i], "--seccomp.keep=", 15) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list_keep = seccomp_check_list(argv[i] + 15);
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strcmp(argv[i], "--seccomp.block-secondary") == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				arg_seccomp_block_secondary = 1;
			}
			else
				exit_err_feature("seccomp");
		}
		else if (strcmp(argv[i], "--memory-deny-write-execute") == 0) {
			if (checkcfg(CFG_SECCOMP))
				arg_memory_deny_write_execute = 1;
			else
				exit_err_feature("seccomp");
		}
#endif
		else if (strcmp(argv[i], "--caps") == 0) {
			arg_caps_default_filter = 1;
			arg_caps_cmdline = 1;
		}
		else if (strcmp(argv[i], "--caps.drop=all") == 0)
			arg_caps_drop_all = 1;
		else if (strncmp(argv[i], "--caps.drop=", 12) == 0) {
			arg_caps_drop = 1;
			arg_caps_list = strdup(argv[i] + 12);
			if (!arg_caps_list)
				errExit("strdup");
			// verify caps list and exit if problems
			caps_check_list(arg_caps_list, NULL);
			arg_caps_cmdline = 1;
		}
		else if (strncmp(argv[i], "--caps.keep=", 12) == 0) {
			arg_caps_keep = 1;
			arg_caps_list = strdup(argv[i] + 12);
			if (!arg_caps_list)
				errExit("strdup");
			// verify caps list and exit if problems
			caps_check_list(arg_caps_list, NULL);
			arg_caps_cmdline = 1;
		}
		else if (strcmp(argv[i], "--trace") == 0)
			arg_trace = 1;
		else if (strncmp(argv[i], "--trace=", 8) == 0) {
			arg_trace = 1;
			arg_tracefile = argv[i] + 8;
			if (*arg_tracefile == '\0') {
				fprintf(stderr, "Error: invalid trace option\n");
				exit(1);
			}
			invalid_filename(arg_tracefile, 0); // no globbing
			if (strstr(arg_tracefile, "..")) {
				fprintf(stderr, "Error: invalid file name %s\n", arg_tracefile);
				exit(1);
			}
			// if the filename starts with ~, expand the home directory
			if (*arg_tracefile == '~') {
				char *tmp;
				if (asprintf(&tmp, "%s%s", cfg.homedir, arg_tracefile + 1) == -1)
					errExit("asprintf");
				arg_tracefile = tmp;
			}
		}
		else if (strcmp(argv[i], "--tracelog") == 0)
			arg_tracelog = 1;
		else if (strncmp(argv[i], "--rlimit-cpu=", 13) == 0) {
			check_unsigned(argv[i] + 13, "Error: invalid rlimit");
			sscanf(argv[i] + 13, "%llu", &cfg.rlimit_cpu);
			arg_rlimit_cpu = 1;
		}
		else if (strncmp(argv[i], "--rlimit-nofile=", 16) == 0) {
			check_unsigned(argv[i] + 16, "Error: invalid rlimit");
			sscanf(argv[i] + 16, "%llu", &cfg.rlimit_nofile);
			arg_rlimit_nofile = 1;
		}
		else if (strncmp(argv[i], "--rlimit-nproc=", 15) == 0) {
			check_unsigned(argv[i] + 15, "Error: invalid rlimit");
			sscanf(argv[i] + 15, "%llu", &cfg.rlimit_nproc);
			arg_rlimit_nproc = 1;
		}
		else if (strncmp(argv[i], "--rlimit-fsize=", 15) == 0) {
			check_unsigned(argv[i] + 15, "Error: invalid rlimit");
			sscanf(argv[i] + 15, "%llu", &cfg.rlimit_fsize);
			arg_rlimit_fsize = 1;
		}
		else if (strncmp(argv[i], "--rlimit-sigpending=", 20) == 0) {
			check_unsigned(argv[i] + 20, "Error: invalid rlimit");
			sscanf(argv[i] + 20, "%llu", &cfg.rlimit_sigpending);
			arg_rlimit_sigpending = 1;
		}
		else if (strncmp(argv[i], "--rlimit-as=", 12) == 0) {
			check_unsigned(argv[i] + 12, "Error: invalid rlimit");
			sscanf(argv[i] + 12, "%llu", &cfg.rlimit_as);
			arg_rlimit_as = 1;
		}
		else if (strncmp(argv[i], "--ipc-namespace", 15) == 0)
			arg_ipc = 1;
		else if (strncmp(argv[i], "--cpu=", 6) == 0)
			read_cpu_list(argv[i] + 6);
		else if (strncmp(argv[i], "--nice=", 7) == 0) {
			cfg.nice = atoi(argv[i] + 7);
			if (getuid() != 0 &&cfg.nice < 0)
				cfg.nice = 0;
			arg_nice = 1;
		}
		else if (strncmp(argv[i], "--cgroup=", 9) == 0) {
			if (checkcfg(CFG_CGROUP)) {
				if (option_cgroup) {
					fprintf(stderr, "Error: only a cgroup can be defined\n");
					exit(1);
				}

				option_cgroup = 1;
				cfg.cgroup = strdup(argv[i] + 9);
				if (!cfg.cgroup)
					errExit("strdup");
				set_cgroup(cfg.cgroup);
			}
			else
				exit_err_feature("cgroup");
		}

		//*************************************
		// filesystem
		//*************************************
		else if (strcmp(argv[i], "--allusers") == 0)
			arg_allusers = 1;
		else if (strncmp(argv[i], "--bind=", 7) == 0) {
			if (checkcfg(CFG_BIND)) {
				char *line;
				if (asprintf(&line, "bind %s", argv[i] + 7) == -1)
					errExit("asprintf");

				profile_check_line(line, 0, NULL);	// will exit if something wrong
				profile_add(line);
			}
			else
				exit_err_feature("bind");
		}
		else if (strncmp(argv[i], "--tmpfs=", 8) == 0) {
			char *line;
			if (asprintf(&line, "tmpfs %s", argv[i] + 8) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--blacklist=", 12) == 0) {
			char *line;
			if (asprintf(&line, "blacklist %s", argv[i] + 12) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--noblacklist=", 14) == 0) {
			char *line;
			if (asprintf(&line, "noblacklist %s", argv[i] + 14) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}

#ifdef HAVE_WHITELIST
		else if (strncmp(argv[i], "--whitelist=", 12) == 0) {
			if (checkcfg(CFG_WHITELIST)) {
				char *line;
				if (asprintf(&line, "whitelist %s", argv[i] + 12) == -1)
					errExit("asprintf");

				profile_check_line(line, 0, NULL);	// will exit if something wrong
				profile_add(line);
			}
			else
				exit_err_feature("whitelist");
		}
		else if (strncmp(argv[i], "--nowhitelist=", 14) == 0) {
			char *line;
			if (asprintf(&line, "nowhitelist %s", argv[i] + 14) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
#endif

		else if (strncmp(argv[i], "--read-only=", 12) == 0) {
			char *line;
			if (asprintf(&line, "read-only %s", argv[i] + 12) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--noexec=", 9) == 0) {
			char *line;
			if (asprintf(&line, "noexec %s", argv[i] + 9) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--read-write=", 13) == 0) {
			char *line;
			if (asprintf(&line, "read-write %s", argv[i] + 13) == -1)
				errExit("asprintf");

			profile_check_line(line, 0, NULL);	// will exit if something wrong
			profile_add(line);
		}
		else if (strcmp(argv[i], "--disable-mnt") == 0)
			arg_disable_mnt = 1;
#ifdef HAVE_OVERLAYFS
		else if (strcmp(argv[i], "--overlay") == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
				if (arg_overlay) {
					fprintf(stderr, "Error: only one overlay command is allowed\n");
					exit(1);
				}

				if (cfg.chrootdir) {
					fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
					exit(1);
				}
				struct stat s;
				if (stat("/proc/sys/kernel/grsecurity", &s) == 0) {
					fprintf(stderr, "Error: --overlay option is not available on Grsecurity systems\n");
					exit(1);
				}
				arg_overlay = 1;
				arg_overlay_keep = 1;

				char *subdirname;
				if (asprintf(&subdirname, "%d", getpid()) == -1)
					errExit("asprintf");
				cfg.overlay_dir = fs_check_overlay_dir(subdirname, arg_overlay_reuse);

				free(subdirname);
			}
			else
				exit_err_feature("overlayfs");
		}
		else if (strncmp(argv[i], "--overlay-named=", 16) == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
				if (arg_overlay) {
					fprintf(stderr, "Error: only one overlay command is allowed\n");
					exit(1);
				}
				if (cfg.chrootdir) {
					fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
					exit(1);
				}
				struct stat s;
				if (stat("/proc/sys/kernel/grsecurity", &s) == 0) {
					fprintf(stderr, "Error: --overlay option is not available on Grsecurity systems\n");
					exit(1);
				}
				arg_overlay = 1;
				arg_overlay_keep = 1;
				arg_overlay_reuse = 1;

				char *subdirname = argv[i] + 16;
				if (*subdirname == '\0') {
					fprintf(stderr, "Error: invalid overlay option\n");
					exit(1);
				}

				// check name
				invalid_filename(subdirname, 0); // no globbing
				if (strstr(subdirname, "..") || strstr(subdirname, "/")) {
					fprintf(stderr, "Error: invalid overlay name\n");
					exit(1);
				}
				cfg.overlay_dir = fs_check_overlay_dir(subdirname, arg_overlay_reuse);
			}
			else
				exit_err_feature("overlayfs");
		}
		else if (strcmp(argv[i], "--overlay-tmpfs") == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
				if (arg_overlay) {
					fprintf(stderr, "Error: only one overlay command is allowed\n");
					exit(1);
				}
				if (cfg.chrootdir) {
					fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
					exit(1);
				}
				struct stat s;
				if (stat("/proc/sys/kernel/grsecurity", &s) == 0) {
					fprintf(stderr, "Error: --overlay option is not available on Grsecurity systems\n");
					exit(1);
				}
				arg_overlay = 1;
			}
			else
				exit_err_feature("overlayfs");
		}
#endif
#ifdef HAVE_FIRETUNNEL
		else if (strcmp(argv[i], "--tunnel") == 0) {
			// try to connect to the default client side of the tunnel
			// if this fails, try the default server side of the tunnel
			if (access("/run/firetunnel/ftc", R_OK) == 0)
				profile_read("/run/firetunnel/ftc");
			else if (access("/run/firetunnel/fts", R_OK) == 0)
				profile_read("/run/firetunnel/fts");
			else {
				fprintf(stderr, "Error: no default firetunnel found, please specify it using --tunnel=devname option\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--tunnel=", 9) == 0) {
			char *fname;

			if (asprintf(&fname, "/run/firetunnel/%s", argv[i] + 9) == -1)
				errExit("asprintf");
			invalid_filename(fname, 0); // no globbing
			if (access(fname, R_OK) == 0)
				profile_read(fname);
			else {
				fprintf(stderr, "Error: tunnel not found\n");
				exit(1);
			}
		}
#endif
		else if (strncmp(argv[i], "--profile=", 10) == 0) {
			// multiple profile files are allowed!

			if (arg_noprofile) {
				fprintf(stderr, "Error: --noprofile and --profile options are mutually exclusive\n");
				exit(1);
			}

			char *ppath = expand_macros(argv[i] + 10);
			if (!ppath)
				errExit("strdup");

			// checking for strange chars in the file name, no globbing
			invalid_filename(ppath, 0);

			if (*ppath == ':' || access(ppath, R_OK) || is_dir(ppath)) {
				int has_colon = (*ppath == ':');
				char *ptr = ppath;
				while (*ptr != '/' && *ptr != '.' && *ptr != '\0')
					ptr++;
				// profile path contains no / or . chars,
				// assume its a profile name
				if (*ptr != '\0') {
					fprintf(stderr, "Error: inaccessible profile file: %s\n", ppath);
					exit(1);
				}

				// profile was not read in previously, try to see if
				// we were given a profile name.
				if (!profile_find_firejail(ppath + has_colon, 1)) {
					// do not fall through to default profile,
					// because the user should be notified that
					// given profile arg could not be used.
					fprintf(stderr, "Error: no profile with name \"%s\" found.\n", ppath);
					exit(1);
				}
				else
					custom_profile = 1;
			}
			else {
				profile_read(ppath);
				custom_profile = 1;
			}
			free(ppath);
		}
		else if (strcmp(argv[i], "--noprofile") == 0) {
			if (custom_profile) {
				fprintf(stderr, "Error: --profile and --noprofile options are mutually exclusive\n");
				exit(1);
			}
			arg_noprofile = 1;
		}
		else if (strncmp(argv[i], "--ignore=", 9) == 0) {
			if (custom_profile) {
				fprintf(stderr, "Error: please use --profile after --ignore\n");
				exit(1);
			}
			profile_add_ignore(argv[i] + 9);
		}
#ifdef HAVE_CHROOT
		else if (strncmp(argv[i], "--chroot=", 9) == 0) {
			if (checkcfg(CFG_CHROOT)) {
				if (arg_overlay) {
					fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
					exit(1);
				}

				struct stat s;
				if (stat("/proc/sys/kernel/grsecurity", &s) == 0) {
					fprintf(stderr, "Error: --chroot option is not available on Grsecurity systems\n");
					exit(1);
				}
				// extract chroot dirname
				cfg.chrootdir = argv[i] + 9;
				if (*cfg.chrootdir == '\0') {
					fprintf(stderr, "Error: invalid chroot option\n");
					exit(1);
				}
				invalid_filename(cfg.chrootdir, 0); // no globbing

				// if the directory starts with ~, expand the home directory
				if (*cfg.chrootdir == '~') {
					char *tmp;
					if (asprintf(&tmp, "%s%s", cfg.homedir, cfg.chrootdir + 1) == -1)
						errExit("asprintf");
					cfg.chrootdir = tmp;
				}
				// check chroot directory
				fs_check_chroot_dir();
			}
			else
				exit_err_feature("chroot");
		}
#endif
		else if (strcmp(argv[i], "--writable-etc") == 0) {
			if (cfg.etc_private_keep) {
				fprintf(stderr, "Error: --private-etc and --writable-etc are mutually exclusive\n");
				exit(1);
			}
			arg_writable_etc = 1;
		}
		else if (strcmp(argv[i], "--writable-var") == 0) {
			arg_writable_var = 1;
		}
		else if (strcmp(argv[i], "--keep-var-tmp") == 0) {
		        arg_keep_var_tmp = 1;
		}
		else if (strcmp(argv[i], "--writable-run-user") == 0) {
			arg_writable_run_user = 1;
		}
		else if (strcmp(argv[i], "--writable-var-log") == 0) {
			arg_writable_var_log = 1;
		}
		else if (strcmp(argv[i], "--machine-id") == 0) {
			arg_machineid = 1;
		}
		else if (strcmp(argv[i], "--private") == 0) {
			arg_private = 1;
		}
		else if (strncmp(argv[i], "--private=", 10) == 0) {
			if (cfg.home_private_keep) {
				fprintf(stderr, "Error: a private list of files was already defined with --private-home option.\n");
				exit(1);
			}

			// extract private home dirname
			cfg.home_private = argv[i] + 10;
			if (*cfg.home_private == '\0') {
				fprintf(stderr, "Error: invalid private option\n");
				exit(1);
			}
			fs_check_private_dir();

			// downgrade to --private if the directory is the user home directory
			if (strcmp(cfg.home_private, cfg.homedir) == 0) {
				free(cfg.home_private);
				cfg.home_private = NULL;
			}
			arg_private = 1;
		}
#ifdef HAVE_PRIVATE_HOME
		else if (strncmp(argv[i], "--private-home=", 15) == 0) {
			if (checkcfg(CFG_PRIVATE_HOME)) {
				if (cfg.home_private) {
					fprintf(stderr, "Error: a private home directory was already defined with --private option.\n");
					exit(1);
				}

				// extract private home dirname
				if (*(argv[i] + 15) == '\0') {
					fprintf(stderr, "Error: invalid private-home option\n");
					exit(1);
				}
				if (cfg.home_private_keep) {
					if ( asprintf(&cfg.home_private_keep, "%s,%s", cfg.home_private_keep, argv[i] + 15) < 0 )
						errExit("asprintf");
				} else
					cfg.home_private_keep = argv[i] + 15;
				arg_private = 1;
			}
			else
				exit_err_feature("private-home");
		}
#endif
		else if (strcmp(argv[i], "--private-dev") == 0) {
			arg_private_dev = 1;
		}
		else if (strcmp(argv[i], "--keep-dev-shm") == 0) {
			arg_keep_dev_shm = 1;
		}
		else if (strncmp(argv[i], "--private-etc=", 14) == 0) {
			if (arg_writable_etc) {
				fprintf(stderr, "Error: --private-etc and --writable-etc are mutually exclusive\n");
				exit(1);
			}

			// extract private etc list
			if (*(argv[i] + 14) == '\0') {
				fprintf(stderr, "Error: invalid private-etc option\n");
				exit(1);
			}
			if (cfg.etc_private_keep) {
				if ( asprintf(&cfg.etc_private_keep, "%s,%s", cfg.etc_private_keep, argv[i] + 14) < 0 )
					errExit("asprintf");
			} else
				cfg.etc_private_keep = argv[i] + 14;
			arg_private_etc = 1;
		}
		else if (strncmp(argv[i], "--private-opt=", 14) == 0) {
			// extract private opt list
			if (*(argv[i] + 14) == '\0') {
				fprintf(stderr, "Error: invalid private-opt option\n");
				exit(1);
			}
			if (cfg.opt_private_keep) {
				if ( asprintf(&cfg.opt_private_keep, "%s,%s", cfg.opt_private_keep, argv[i] + 14) < 0 )
					errExit("asprintf");
			} else
				cfg.opt_private_keep = argv[i] + 14;
			arg_private_opt = 1;
		}
		else if (strncmp(argv[i], "--private-srv=", 14) == 0) {
			// extract private srv list
			if (*(argv[i] + 14) == '\0') {
				fprintf(stderr, "Error: invalid private-srv option\n");
				exit(1);
			}
			if (cfg.srv_private_keep) {
				if ( asprintf(&cfg.srv_private_keep, "%s,%s", cfg.srv_private_keep, argv[i] + 14) < 0 )
					errExit("asprintf");
			} else
				cfg.srv_private_keep = argv[i] + 14;
			arg_private_srv = 1;
		}
		else if (strncmp(argv[i], "--private-bin=", 14) == 0) {
			// extract private bin list
			if (*(argv[i] + 14) == '\0') {
				fprintf(stderr, "Error: invalid private-bin option\n");
				exit(1);
			}
			if (cfg.bin_private_keep) {
				if ( asprintf(&cfg.bin_private_keep, "%s,%s", cfg.bin_private_keep, argv[i] + 14) < 0 )
					errExit("asprintf");
			} else
				cfg.bin_private_keep = argv[i] + 14;
			arg_private_bin = 1;
		}
		else if (strncmp(argv[i], "--private-lib", 13) == 0) {
			if (checkcfg(CFG_PRIVATE_LIB)) {
				// extract private lib list (if any)
				if (argv[i][13] == '=') {
					if (cfg.lib_private_keep) {
						if (argv[i][14] != '\0' && asprintf(&cfg.lib_private_keep, "%s,%s", cfg.lib_private_keep, argv[i] + 14) < 0)
							errExit("asprintf");
					} else
						cfg.lib_private_keep = argv[i] + 14;
				}
				arg_private_lib = 1;
			}
			else
				exit_err_feature("private-lib");
		}
		else if (strcmp(argv[i], "--private-tmp") == 0) {
			arg_private_tmp = 1;
		}
		else if (strcmp(argv[i], "--private-cache") == 0) {
			if (checkcfg(CFG_PRIVATE_CACHE))
				arg_private_cache = 1;
			else
				exit_err_feature("private-cache");
		}
		else if (strcmp(argv[i], "--private-cwd") == 0) {
			cfg.cwd = NULL;
			arg_private_cwd = 1;
		}
		else if (strncmp(argv[i], "--private-cwd=", 14) == 0) {
			if (*(argv[i] + 14) == '\0') {
				fprintf(stderr, "Error: invalid private-cwd option\n");
				exit(1);
			}

			fs_check_private_cwd(argv[i] + 14);
			arg_private_cwd = 1;
		}

		//*************************************
		// hostname, etc
		//*************************************
		else if (strncmp(argv[i], "--name=", 7) == 0) {
			cfg.name = argv[i] + 7;
			if (strlen(cfg.name) == 0) {
				fprintf(stderr, "Error: please provide a name for sandbox\n");
				return 1;
			}
		}
		else if (strncmp(argv[i], "--hostname=", 11) == 0) {
			cfg.hostname = argv[i] + 11;
			if (strlen(cfg.hostname) == 0) {
				fprintf(stderr, "Error: please provide a hostname for sandbox\n");
				return 1;
			}
		}
		else if (strcmp(argv[i], "--nogroups") == 0)
			arg_nogroups = 1;
#ifdef HAVE_USERNS
		else if (strcmp(argv[i], "--noroot") == 0) {
			if (checkcfg(CFG_USERNS))
				check_user_namespace();
			else
				exit_err_feature("noroot");
		}
#endif
		else if (strcmp(argv[i], "--nonewprivs") == 0)
			arg_nonewprivs = 1;
		else if (strncmp(argv[i], "--env=", 6) == 0)
			env_store(argv[i] + 6, SETENV);
		else if (strncmp(argv[i], "--rmenv=", 8) == 0)
			env_store(argv[i] + 8, RMENV);
		else if (strcmp(argv[i], "--nosound") == 0)
			arg_nosound = 1;
		else if (strcmp(argv[i], "--noautopulse") == 0)
			arg_noautopulse = 1;
		else if (strcmp(argv[i], "--novideo") == 0)
			arg_novideo = 1;
		else if (strcmp(argv[i], "--no3d") == 0)
			arg_no3d = 1;
		else if (strcmp(argv[i], "--notv") == 0)
			arg_notv = 1;
		else if (strcmp(argv[i], "--nodvd") == 0)
			arg_nodvd = 1;
		else if (strcmp(argv[i], "--nou2f") == 0)
			arg_nou2f = 1;
		else if (strcmp(argv[i], "--nodbus") == 0)
			arg_nodbus = 1;

		//*************************************
		// network
		//*************************************
		else if (strcmp(argv[i], "--net=none") == 0) {
			arg_nonetwork  = 1;
			cfg.bridge0.configured = 0;
			cfg.bridge1.configured = 0;
			cfg.bridge2.configured = 0;
			cfg.bridge3.configured = 0;
			cfg.interface0.configured = 0;
			cfg.interface1.configured = 0;
			cfg.interface2.configured = 0;
			cfg.interface3.configured = 0;
			continue;
		}
#ifdef HAVE_NETWORK
		else if (strncmp(argv[i], "--interface=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				// checks
				if (arg_nonetwork) {
					fprintf(stderr, "Error: --network=none and --interface are incompatible\n");
					exit(1);
				}
				if (strcmp(argv[i] + 12, "lo") == 0) {
					fprintf(stderr, "Error: cannot use lo device in --interface command\n");
					exit(1);
				}
				int ifindex = if_nametoindex(argv[i] + 12);
				if (ifindex <= 0) {
					fprintf(stderr, "Error: cannot find interface %s\n", argv[i] + 12);
					exit(1);
				}

				Interface *intf;
				if (cfg.interface0.configured == 0)
					intf = &cfg.interface0;
				else if (cfg.interface1.configured == 0)
					intf = &cfg.interface1;
				else if (cfg.interface2.configured == 0)
					intf = &cfg.interface2;
				else if (cfg.interface3.configured == 0)
					intf = &cfg.interface3;
				else {
					fprintf(stderr, "Error: maximum 4 interfaces are allowed\n");
					return 1;
				}

				intf->dev = strdup(argv[i] + 12);
				if (!intf->dev)
					errExit("strdup");

				if (net_get_if_addr(intf->dev, &intf->ip, &intf->mask, intf->mac, &intf->mtu)) {
					fwarning("interface %s is not configured\n", intf->dev);
				}
				intf->configured = 1;
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--net=", 6) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				if (strcmp(argv[i] + 6, "none") == 0) {
					arg_nonetwork  = 1;
					cfg.bridge0.configured = 0;
					cfg.bridge1.configured = 0;
					cfg.bridge2.configured = 0;
					cfg.bridge3.configured = 0;
					cfg.interface0.configured = 0;
					cfg.interface1.configured = 0;
					cfg.interface2.configured = 0;
					cfg.interface3.configured = 0;
					continue;
				}

				if (strcmp(argv[i] + 6, "lo") == 0) {
					fprintf(stderr, "Error: cannot attach to lo device\n");
					exit(1);
				}

				Bridge *br;
				if (cfg.bridge0.configured == 0)
					br = &cfg.bridge0;
				else if (cfg.bridge1.configured == 0)
					br = &cfg.bridge1;
				else if (cfg.bridge2.configured == 0)
					br = &cfg.bridge2;
				else if (cfg.bridge3.configured == 0)
					br = &cfg.bridge3;
				else {
					fprintf(stderr, "Error: maximum 4 network devices are allowed\n");
					return 1;
				}
				br->dev = argv[i] + 6;
				br->configured = 1;
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--veth-name=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				br->veth_name = strdup(argv[i] + 12);
				if (br->veth_name == NULL)
					errExit("strdup");
				if (*br->veth_name == '\0') {
					fprintf(stderr, "Error: no veth-name configured\n");
					exit(1);
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strcmp(argv[i], "--scan") == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_scan = 1;
			}
			else
				exit_err_feature("networking");
		}
		else if (strncmp(argv[i], "--iprange=", 10) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					return 1;
				}
				if (br->iprange_start || br->iprange_end) {
					fprintf(stderr, "Error: cannot configure the IP range twice for the same interface\n");
					return 1;
				}

				// parse option arguments
				char *firstip = argv[i] + 10;
				char *secondip = firstip;
				while (*secondip != '\0') {
					if (*secondip == ',')
						break;
					secondip++;
				}
				if (*secondip == '\0') {
					fprintf(stderr, "Error: invalid IP range\n");
					return 1;
				}
				*secondip = '\0';
				secondip++;

				// check addresses
				if (atoip(firstip, &br->iprange_start) || atoip(secondip, &br->iprange_end) ||
				    br->iprange_start >= br->iprange_end) {
					fprintf(stderr, "Error: invalid IP range\n");
					return 1;
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--mac=", 6) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				if (mac_not_zero(br->macsandbox)) {
					fprintf(stderr, "Error: cannot configure the MAC address twice for the same interface\n");
					exit(1);
				}

				// read the address
				if (atomac(argv[i] + 6, br->macsandbox)) {
					fprintf(stderr, "Error: invalid MAC address\n");
					exit(1);
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--mtu=", 6) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}

				if (sscanf(argv[i] + 6, "%d", &br->mtu) != 1 || br->mtu < 576 || br->mtu > 9198) {
					fprintf(stderr, "Error: invalid mtu value\n");
					exit(1);
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--ip=", 5) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				if (br->arg_ip_none || br->ipsandbox) {
					fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
					exit(1);
				}

				// configure this IP address for the last bridge defined
				if (strcmp(argv[i] + 5, "none") == 0)
					br->arg_ip_none = 1;
				else {
					if (atoip(argv[i] + 5, &br->ipsandbox)) {
						fprintf(stderr, "Error: invalid IP address\n");
						exit(1);
					}
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--netmask=", 10) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				if (br->arg_ip_none || br->mask) {
					fprintf(stderr, "Error: cannot configure the network mask twice for the same interface\n");
					exit(1);
				}

				// configure this network mask for the last bridge defined
				if (atoip(argv[i] + 10, &br->mask)) {
					fprintf(stderr, "Error: invalid  network mask\n");
					exit(1);
				}
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--ip6=", 6) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				if (br->ip6sandbox) {
					fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
					exit(1);
				}

				// configure this IP address for the last bridge defined
				if (check_ip46_address(argv[i] + 6) == 0) {
					fprintf(stderr, "Error: invalid IPv6 address\n");
					exit(1);
				}

				br->ip6sandbox = strdup(argv[i] + 6);
				if (br->ip6sandbox == NULL)
					errExit("strdup");
			}
			else
				exit_err_feature("networking");
		}


		else if (strncmp(argv[i], "--defaultgw=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				if (atoip(argv[i] + 12, &cfg.defaultgw)) {
					fprintf(stderr, "Error: invalid IP address\n");
					exit(1);
				}
			}
			else
				exit_err_feature("networking");
		}
#endif
		else if (strncmp(argv[i], "--dns=", 6) == 0) {
			if (check_ip46_address(argv[i] + 6) == 0) {
				fprintf(stderr, "Error: invalid DNS server IPv4 or IPv6 address\n");
				exit(1);
			}
			char *dns = strdup(argv[i] + 6);
			if (!dns)
				errExit("strdup");

			if (cfg.dns1 == NULL)
				cfg.dns1 = dns;
			else if (cfg.dns2 == NULL)
				cfg.dns2 = dns;
			else if (cfg.dns3 == NULL)
				cfg.dns3 = dns;
			else if (cfg.dns4 == NULL)
				cfg.dns4 = dns;
			else {
				fprintf(stderr, "Error: up to 4 DNS servers can be specified\n");
				free(dns);
				return 1;
			}
		}

		else if (strncmp(argv[i], "--hosts-file=", 13) == 0)
			cfg.hosts_file = fs_check_hosts_file(argv[i] + 13);

#ifdef HAVE_NETWORK
		else if (strcmp(argv[i], "--netfilter") == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter = 1;
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--netfilter=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter = 1;
				arg_netfilter_file = argv[i] + 12;
				check_netfilter_file(arg_netfilter_file);
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--netfilter6=", 13) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter6 = 1;
				arg_netfilter6_file = argv[i] + 13;
				check_netfilter_file(arg_netfilter6_file);
			}
			else
				exit_err_feature("networking");
		}

		else if (strncmp(argv[i], "--netns=", 8) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_netns = argv[i] + 8;
				check_netns(arg_netns);
			}
			else
				exit_err_feature("networking");
		}
#endif
		//*************************************
		// command
		//*************************************
		else if (strncmp(argv[i], "--timeout=", 10) == 0)
			cfg.timeout = extract_timeout(argv[i] + 10);
		else if (strcmp(argv[i], "--audit") == 0) {
			arg_audit_prog = LIBDIR "/firejail/faudit";
			arg_audit = 1;
		}
		else if (strncmp(argv[i], "--audit=", 8) == 0) {
			if (strlen(argv[i] + 8) == 0) {
				fprintf(stderr, "Error: invalid audit program\n");
				exit(1);
			}
			arg_audit_prog = strdup(argv[i] + 8);
			if (!arg_audit_prog)
				errExit("strdup");

			struct stat s;
			if (stat(arg_audit_prog, &s) != 0) {
				fprintf(stderr, "Error: cannot find the audit program %s\n", arg_audit_prog);
				exit(1);
			}
			arg_audit = 1;
		}
		else if (strcmp(argv[i], "--appimage") == 0)
			arg_appimage = 1;
		else if (strcmp(argv[i], "--shell=none") == 0) {
			arg_shell_none = 1;
			if (cfg.shell) {
				fprintf(stderr, "Error: a shell was already specified\n");
				return 1;
			}
		}
		else if (strncmp(argv[i], "--shell=", 8) == 0) {
			if (arg_shell_none) {
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			invalid_filename(argv[i] + 8, 0); // no globbing

			if (cfg.shell) {
				fprintf(stderr, "Error: only one user shell can be specified\n");
				return 1;
			}
			cfg.shell = argv[i] + 8;

			if (is_dir(cfg.shell) || strstr(cfg.shell, "..")) {
				fprintf(stderr, "Error: invalid shell\n");
				exit(1);
			}

			// access call checks as real UID/GID, not as effective UID/GID
			if(cfg.chrootdir) {
				char *shellpath;
				if (asprintf(&shellpath, "%s%s", cfg.chrootdir, cfg.shell) == -1)
					errExit("asprintf");
				if (access(shellpath, X_OK)) {
					fprintf(stderr, "Error: cannot access shell file in chroot\n");
					exit(1);
				}
				free(shellpath);
			} else if (access(cfg.shell, X_OK)) {
				fprintf(stderr, "Error: cannot access shell file\n");
				exit(1);
			}
		}
		else if (strcmp(argv[i], "-c") == 0) {
			arg_command = 1;
			if (i == (argc -  1)) {
				fprintf(stderr, "Error: option -c requires an argument\n");
				return 1;
			}
		}

		// unlike all other x11 features, this is available always
		else if (strcmp(argv[i], "--x11=none") == 0) {
			arg_x11_block = 1;
		}
#ifdef HAVE_X11
		else if (strcmp(argv[i], "--x11=xorg") == 0) {
			if (checkcfg(CFG_X11))
				arg_x11_xorg = 1;
			else
				exit_err_feature("x11");
		}
#endif
		else if (strncmp(argv[i], "--join-or-start=", 16) == 0) {
			// NOTE: this is second part of option handler,
			//		 atempt to find and join sandbox is done in other one

			// set sandbox name and start normally
			cfg.name = argv[i] + 16;
			if (strlen(cfg.name) == 0) {
				fprintf(stderr, "Error: please provide a name for sandbox\n");
				return 1;
			}
		}
		else if (strcmp(argv[i], "--deterministic-exit-code") == 0) {
			arg_deterministic_exit_code = 1;
		}
		else {
			// double dash - positional params to follow
			if (strcmp(argv[i], "--") == 0) {
				arg_doubledash = 1;
				i++;
				if (i  >= argc) {
					fprintf(stderr, "Error: program name not found\n");
					exit(1);
				}
			}
			// is this an invalid option?
			else if (*argv[i] == '-') {
				fprintf(stderr, "Error: invalid %s command line option\n", argv[i]);
				return 1;
			}

			// we have a program name coming
			if (arg_appimage) {
				cfg.command_name = strdup(argv[i]);
				if (!cfg.command_name)
					errExit("strdup");

				// disable shell=* for appimages
				arg_shell_none = 0;
			}
			else
				extract_command_name(i, argv);
			prog_index = i;
			break;
		}
	}
	EUID_ASSERT();

	// exit chroot, overlay and appimage sandboxes when caps are explicitly specified on command line
	if (getuid() != 0 && arg_caps_cmdline) {
		char *opt = NULL;
		if (arg_appimage)
			opt = "appimage";
		else if (arg_overlay)
			opt = "overlay";
		else if (cfg.chrootdir)
			opt = "chroot";

		if (opt) {
			fprintf(stderr, "Error: all capabilities are dropped for %s by default.\n"
				"Please remove --caps options from the command line.\n", opt);
			exit(1);
		}
	}

	// prog_index could still be -1 if no program was specified
	if (prog_index == -1 && arg_shell_none) {
		fprintf(stderr, "Error: shell=none configured, but no program specified\n");
		exit(1);
	}

	// check trace configuration
	if (arg_trace && arg_tracelog) {
		fwarning("--trace and --tracelog are mutually exclusive; --tracelog disabled\n");
	}

	// check user namespace (--noroot) options
	if (arg_noroot) {
		if (arg_overlay) {
			fwarning("--overlay and --noroot are mutually exclusive, --noroot disabled...\n");
			arg_noroot = 0;
		}
		else if (cfg.chrootdir) {
			fwarning("--chroot and --noroot are mutually exclusive, --noroot disabled...\n");
			arg_noroot = 0;
		}
	}

	// enable seccomp if only seccomp.block-secondary was specified
	if (arg_seccomp_block_secondary)
		arg_seccomp = 1;

	// log command
	logargs(argc, argv);
	if (fullargc) {
		char *msg;
		if (asprintf(&msg, "user %s entering restricted shell", cfg.username) == -1)
			errExit("asprintf");
		logmsg(msg);
		free(msg);
	}

	// guess shell if unspecified
	if (!arg_shell_none && !cfg.shell) {
		cfg.shell = guess_shell();
		if (!cfg.shell) {
			fprintf(stderr, "Error: unable to guess your shell, please set explicitly by using --shell option.\n");
			exit(1);
		}
		if (arg_debug)
			printf("Autoselecting %s as shell\n", cfg.shell);
	}

	// build the sandbox command
	if (prog_index == -1 && cfg.shell) {
		cfg.command_line = cfg.shell;
		cfg.window_title = cfg.shell;
		cfg.command_name = cfg.shell;
	}
	else if (arg_appimage) {
		if (arg_debug)
			printf("Configuring appimage environment\n");
		appimage_set(cfg.command_name);
		build_appimage_cmdline(&cfg.command_line, &cfg.window_title, argc, argv, prog_index, cfg.command_line);
	}
	else {
		build_cmdline(&cfg.command_line, &cfg.window_title, argc, argv, prog_index);
	}
/*	else {
		fprintf(stderr, "Error: command must be specified when --shell=none used.\n");
		exit(1);
	}*/

	assert(cfg.command_name);
	if (arg_debug)
		printf("Command name #%s#\n", cfg.command_name);


	// load the profile
	if (!arg_noprofile && !custom_profile) {
		custom_profile = profile_find_firejail(cfg.command_name, 1);
	}

	// use default.profile as the default
	if (!custom_profile && !arg_noprofile) {
		char *profile_name = DEFAULT_USER_PROFILE;
		if (getuid() == 0)
			profile_name = DEFAULT_ROOT_PROFILE;
		if (arg_debug)
			printf("Attempting to find %s.profile...\n", profile_name);

		custom_profile = profile_find_firejail(profile_name, 1);

		if (!custom_profile) {
			fprintf(stderr, "Error: no default.profile installed\n");
			exit(1);
		}

		if (custom_profile)
			fmessage("\n** Note: you can use --noprofile to disable %s.profile **\n\n", profile_name);
	}
	EUID_ASSERT();

	// block X11 sockets
	if (arg_x11_block)
		x11_block();

	// check network configuration options - it will exit if anything went wrong
	net_check_cfg();

	// check and assign an IP address - for macvlan it will be done again in the sandbox!
	if (any_bridge_configured()) {
		EUID_ROOT();
		lockfd_network = open(RUN_NETWORK_LOCK_FILE, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
		if (lockfd_network != -1) {
			int rv = fchown(lockfd_network, 0, 0);
			(void) rv;
			flock(lockfd_network, LOCK_EX);
		}

		if (cfg.bridge0.configured && cfg.bridge0.arg_ip_none == 0)
			check_network(&cfg.bridge0);
		if (cfg.bridge1.configured && cfg.bridge1.arg_ip_none == 0)
			check_network(&cfg.bridge1);
		if (cfg.bridge2.configured && cfg.bridge2.arg_ip_none == 0)
			check_network(&cfg.bridge2);
		if (cfg.bridge3.configured && cfg.bridge3.arg_ip_none == 0)
			check_network(&cfg.bridge3);

		// save network mapping in shared memory
		network_set_run_file(sandbox_pid);
		EUID_USER();
	}
	EUID_ASSERT();

 	// create the parent-child communication pipe
 	if (pipe(parent_to_child_fds) < 0)
 		errExit("pipe");
 	if (pipe(child_to_parent_fds) < 0)
		errExit("pipe");

	if (arg_noroot && arg_overlay) {
		fwarning("--overlay and --noroot are mutually exclusive, noroot disabled\n");
		arg_noroot = 0;
	}
	else if (arg_noroot && cfg.chrootdir) {
		fwarning("--chroot and --noroot are mutually exclusive, noroot disabled\n");
		arg_noroot = 0;
	}


	// set name and x11 run files
	EUID_ROOT();
	lockfd_directory = open(RUN_DIRECTORY_LOCK_FILE, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
	if (lockfd_directory != -1) {
		int rv = fchown(lockfd_directory, 0, 0);
		(void) rv;
		flock(lockfd_directory, LOCK_EX);
	}
	if (cfg.name)
		set_name_run_file(sandbox_pid);
	int display = x11_display();
	if (display > 0)
		set_x11_run_file(sandbox_pid, display);
	if (lockfd_directory != -1) {
		flock(lockfd_directory, LOCK_UN);
		close(lockfd_directory);
	}
	EUID_USER();

	// clone environment
	int flags = CLONE_NEWNS | CLONE_NEWPID | CLONE_NEWUTS | SIGCHLD;

	// in root mode also enable CLONE_NEWIPC
	// in user mode CLONE_NEWIPC will break MIT Shared Memory Extension (MIT-SHM)
	if (getuid() == 0 || arg_ipc) {
		flags |= CLONE_NEWIPC;
		if (arg_debug)
			printf("Enabling IPC namespace\n");
	}

	if (any_bridge_configured() || any_interface_configured() || arg_nonetwork) {
		flags |= CLONE_NEWNET;
	}
	else if (arg_debug)
		printf("Using the local network stack\n");

	EUID_ASSERT();
	EUID_ROOT();
#ifdef __ia64__
	child = __clone2(sandbox,
		child_stack,
		STACK_SIZE,
		flags,
		NULL);
#else
	child = clone(sandbox,
		child_stack + STACK_SIZE,
		flags,
		NULL);
#endif
	if (child == -1)
		errExit("clone");
	EUID_USER();

	if (!arg_command && !arg_quiet) {
		fmessage("Parent pid %u, child pid %u\n", sandbox_pid, child);
		// print the path of the new log directory
		if (getuid() == 0) // only for root
			printf("The new log directory is /proc/%d/root/var/log\n", child);
	}

	if (!arg_nonetwork) {
		EUID_ROOT();
		pid_t net_child = fork();
		if (net_child < 0)
			errExit("fork");
		if (net_child == 0) {
			// elevate privileges in order to get grsecurity working
			if (setreuid(0, 0))
				errExit("setreuid");
			if (setregid(0, 0))
				errExit("setregid");
			network_main(child);
			if (arg_debug)
				printf("Host network configured\n");
#ifdef HAVE_GCOV
			__gcov_flush();
#endif
			_exit(0);
		}

		// wait for the child to finish
		waitpid(net_child, NULL, 0);
		EUID_USER();
	}
	EUID_ASSERT();

 	// close each end of the unused pipes
 	close(parent_to_child_fds[0]);
 	close(child_to_parent_fds[1]);

	// notify child that base setup is complete
 	notify_other(parent_to_child_fds[1]);

 	// wait for child to create new user namespace with CLONE_NEWUSER
 	wait_for_other(child_to_parent_fds[0]);
 	close(child_to_parent_fds[0]);

 	if (arg_noroot) {
	 	// update the UID and GID maps in the new child user namespace
		// uid
	 	char *map_path;
	 	if (asprintf(&map_path, "/proc/%d/uid_map", child) == -1)
	 		errExit("asprintf");

	 	char *map;
	 	uid_t uid = getuid();
	 	if (asprintf(&map, "%d %d 1", uid, uid) == -1)
	 		errExit("asprintf");
 		EUID_ROOT();
	 	update_map(map, map_path);
	 	EUID_USER();
	 	free(map);
	 	free(map_path);

	 	// gid file
		if (asprintf(&map_path, "/proc/%d/gid_map", child) == -1)
			errExit("asprintf");
	 	char gidmap[1024];
	 	char *ptr = gidmap;
	 	*ptr = '\0';

	 	// add user group
	 	gid_t gid = getgid();
	 	sprintf(ptr, "%d %d 1\n", gid, gid);
	 	ptr += strlen(ptr);

	 	if (!arg_nogroups) {
		 	//  add tty group
		 	gid_t g = get_group_id("tty");
		 	if (g) {
		 		sprintf(ptr, "%d %d 1\n", g, g);
		 		ptr += strlen(ptr);
		 	}

		 	//  add audio group
		 	g = get_group_id("audio");
		 	if (g) {
		 		sprintf(ptr, "%d %d 1\n", g, g);
		 		ptr += strlen(ptr);
		 	}

		 	//  add video group
		 	g = get_group_id("video");
		 	if (g) {
		 		sprintf(ptr, "%d %d 1\n", g, g);
		 		ptr += strlen(ptr);
		 	}

		 	//  add games group
		 	g = get_group_id("games");
		 	if (g) {
		 		sprintf(ptr, "%d %d 1\n", g, g);
		 	}
		 }

 		EUID_ROOT();
	 	update_map(gidmap, map_path);
	 	EUID_USER();
	 	free(map_path);
 	}
	EUID_ASSERT();

 	// notify child that UID/GID mapping is complete
 	notify_other(parent_to_child_fds[1]);
 	close(parent_to_child_fds[1]);

 	EUID_ROOT();
	if (lockfd_network != -1) {
		flock(lockfd_network, LOCK_UN);
		close(lockfd_network);
	}
	EUID_USER();

	int status = 0;
	//*****************************
	// following code is signal-safe

	// handle CTRL-C in parent
	install_handler();

	// wait for the child to finish
	waitpid(child, &status, 0);

	// restore default signal actions
	signal(SIGTERM, SIG_DFL);
	signal(SIGINT, SIG_DFL);

	// end of signal-safe code
	//*****************************

	// free globals
	if (cfg.profile) {
		ProfileEntry *prf = cfg.profile;
		while (prf != NULL) {
			ProfileEntry *next = prf->next;
			free(prf->data);
			free(prf->link);
			free(prf);
			prf = next;
		}
	}

	if (WIFEXITED(status)){
		myexit(WEXITSTATUS(status));
	} else if (WIFSIGNALED(status)) {
		myexit(WTERMSIG(status));
	} else {
		myexit(0);
	}

	return 0;
}

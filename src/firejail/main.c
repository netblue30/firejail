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
#include "../include/pid.h"
#define _GNU_SOURCE
#include <sys/utsname.h>
#include <sched.h>
#include <sys/mount.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <pwd.h>
#include <errno.h>
#include <limits.h>
#include <sys/file.h>
#include <sys/prctl.h>
#include <signal.h>
#include <time.h>
#include <net/if.h>

#if 0
#include <sys/times.h>
{
struct tms tm;
clock_t systick = times(&tm);
printf("time %s:%d %u\n", __FILE__, __LINE__, (uint32_t) systick);
}
#endif

uid_t firejail_uid = 0;
gid_t firejail_gid = 0;

#define STACK_SIZE (1024 * 1024)
static char child_stack[STACK_SIZE];		// space for child's stack
Config cfg;					// configuration
int arg_private = 0;				// mount private /home and /tmp directoryu
int arg_private_template = 0; // mount private /home using a template
int arg_debug = 0;				// print debug messages
int arg_debug_check_filename;		// print debug messages for filename checking
int arg_debug_blacklists;			// print debug messages for blacklists
int arg_debug_whitelists;			// print debug messages for whitelists
int arg_nonetwork = 0;				// --net=none
int arg_command = 0;				// -c
int arg_overlay = 0;				// overlay option
int arg_overlay_keep = 0;			// place overlay diff in a known directory
int arg_overlay_reuse = 0;			// allow the reuse of overlays

int arg_seccomp = 0;				// enable default seccomp filter

int arg_caps_default_filter = 0;			// enable default capabilities filter
int arg_caps_drop = 0;				// drop list
int arg_caps_drop_all = 0;			// drop all capabilities
int arg_caps_keep = 0;			// keep list
char *arg_caps_list = NULL;			// optional caps list

int arg_trace = 0;				// syscall tracing support
int arg_tracelog = 0;				// blacklist tracing support
int arg_rlimit_nofile = 0;			// rlimit nofile
int arg_rlimit_nproc = 0;			// rlimit nproc
int arg_rlimit_fsize = 0;				// rlimit fsize
int arg_rlimit_sigpending = 0;			// rlimit fsize
int arg_nogroups = 0;				// disable supplementary groups
int arg_nonewprivs = 0;			// set the NO_NEW_PRIVS prctl
int arg_noroot = 0;				// create a new user namespace and disable root user
int arg_netfilter;				// enable netfilter
int arg_netfilter6;				// enable netfilter6
char *arg_netfilter_file = NULL;			// netfilter file
char *arg_netfilter6_file = NULL;		// netfilter6 file
int arg_doubledash = 0;			// double dash
int arg_shell_none = 0;			// run the program directly without a shell
int arg_private_dev = 0;			// private dev directory
int arg_private_etc = 0;			// private etc directory
int arg_private_bin = 0;			// private bin directory
int arg_private_tmp = 0;			// private tmp directory
int arg_scan = 0;				// arp-scan all interfaces
int arg_whitelist = 0;				// whitelist commad
int arg_nosound = 0;				// disable sound
int arg_no3d;					// disable 3d hardware acceleration
int arg_quiet = 0;				// no output for scripting
int arg_join_network = 0;			// join only the network namespace
int arg_join_filesystem = 0;			// join only the mount namespace
int arg_nice = 0;				// nice value configured
int arg_ipc = 0;					// enable ipc namespace
int arg_writable_etc = 0;			// writable etc
int arg_writable_var = 0;			// writable var
int arg_appimage = 0;				// appimage
int arg_audit = 0;				// audit
char *arg_audit_prog = NULL;			// audit
int arg_apparmor = 0;				// apparmor
int arg_allow_debuggers = 0;			// allow debuggers
int arg_x11_block = 0;				// block X11
int arg_x11_xorg = 0;				// use X11 security extention
int arg_allusers = 0;				// all user home directories visible

int login_shell = 0;


int parent_to_child_fds[2];
int child_to_parent_fds[2];

char *fullargv[MAX_ARGS];			// expanded argv for restricted shell
int fullargc = 0;
static pid_t child = 0;
pid_t sandbox_pid;

static void set_name_file(pid_t pid);
static void delete_name_file(pid_t pid);
static void set_x11_file(pid_t pid, int display);
static void delete_x11_file(pid_t pid);

void clear_run_files(pid_t pid) {
	bandwidth_del_run_file(pid);		// bandwidth file
	network_del_run_file(pid);		// network map file
	delete_name_file(pid);
	delete_x11_file(pid);
}

static void myexit(int rv) {
	logmsg("exiting...");
	if (!arg_command && !arg_quiet)
		printf("\nParent is shutting down, bye...\n");


	// delete sandbox files in shared memory
	EUID_ROOT();
	clear_run_files(sandbox_pid);
	appimage_clear();
	flush_stdin();
	exit(rv); 
}

static void my_handler(int s){
	EUID_ROOT();
	if (!arg_quiet) {
		printf("\nParent received signal %d, shutting down the child process...\n", s);
		fflush(0);
	}
	logsignal(s);
	kill(child, SIGTERM);
	myexit(1);
}

// return 1 if error, 0 if a valid pid was found
static inline int read_pid(char *str, pid_t *pid) {
	char *endptr;
	errno = 0;
	long int pidtmp = strtol(str, &endptr, 10);
	if ((errno == ERANGE && (pidtmp == LONG_MAX || pidtmp == LONG_MIN))
		|| (errno != 0 && pidtmp == 0)) {
		return 1;
	}
	// endptr points to '\0' char in str if the entire string is valid
	if (endptr == NULL || endptr[0]!='\0') {
		return 1;
	}
	*pid = (pid_t)pidtmp;
	return 0;
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

	// build home directory name
	cfg.homedir = NULL;
	if (pw->pw_dir != NULL) {
		cfg.homedir = strdup(pw->pw_dir);
		if (!cfg.homedir)
			errExit("strdup");
	}
	else {
		fprintf(stderr, "Error: user %s doesn't have a user directory assigned\n", cfg.username);
		exit(1);
	}
	cfg.cwd = getcwd(NULL, 0);

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
	if (getuid() == 0) {
		fprintf(stderr, "Error: --noroot option cannot be used when starting the sandbox as root.\n");
		exit(1);
	}
	
	// test user namespaces available in the kernel
	struct stat s1;
	struct stat s2;
	struct stat s3;
	if (stat("/proc/self/ns/user", &s1) == 0 &&
	    stat("/proc/self/uid_map", &s2) == 0 &&
	    stat("/proc/self/gid_map", &s3) == 0)
		arg_noroot = 1;
	else {
		if (!arg_quiet || arg_debug)
			fprintf(stderr, "Warning: user namespaces not available in the current kernel.\n");
		arg_noroot = 0;
	}
}
#endif


// exit commands
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
			char *path;
			if (asprintf(&path, "%s/.firejail", cfg.homedir) == -1)
				errExit("asprintf");
			EUID_ROOT();
			if (setreuid(0, 0) < 0)
				errExit("setreuid");
			if (setregid(0, 0) < 0)
				errExit("setregid");
			errno = 0;
			int rv = remove_directory(path);
			if (rv) {
				fprintf(stderr, "Error: cannot removed overlays stored in ~/.firejail directory, errno %d\n", errno);
				exit(1);
			}
		}
		else {
			fprintf(stderr, "Error: overlayfs feature is disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
#endif
#ifdef HAVE_X11
	else if (strcmp(argv[i], "--x11") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start(argc, argv);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --x11 feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
	else if (strcmp(argv[i], "--x11=xpra") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start_xpra(argc, argv);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --x11 feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
	else if (strcmp(argv[i], "--x11=xephyr") == 0) {
		if (checkcfg(CFG_X11)) {
			x11_start_xephyr(argc, argv);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --x11 feature is disabled in Firejail configuration file\n");
			exit(1);
		}
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
			pid_t pid;
			if (read_pid(argv[i] + 12, &pid) == 0)
				bandwidth_pid(pid, cmd, dev, down, up);
			else
				bandwidth_name(argv[i] + 12, cmd, dev, down, up);
		}
		else {
			fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
#endif
	//*************************************
	// independent commands - the program will exit!
	//*************************************
#ifdef HAVE_SECCOMP
	else if (strcmp(argv[i], "--debug-syscalls") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			syscall_print();
			exit(0);
		}
		else {
			fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
	else if (strcmp(argv[i], "--debug-errnos") == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			errno_print();
		}
		else {
			fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
	else if (strncmp(argv[i], "--seccomp.print=", 16) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			// print seccomp filter for a sandbox specified by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 16, &pid) == 0)		
				seccomp_print_filter(pid);
			else
				seccomp_print_filter_name(argv[i] + 16);
		}
		else {
			fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
	else if (strcmp(argv[i], "--debug-protocols") == 0) {
		protocol_list();
		exit(0);
	}
	else if (strncmp(argv[i], "--protocol.print=", 17) == 0) {
		if (checkcfg(CFG_SECCOMP)) {
			// print seccomp filter for a sandbox specified by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 17, &pid) == 0)		
				protocol_print_filter(pid);
			else
				protocol_print_filter_name(argv[i] + 17);
		}
		else {
			fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
#endif
	else if (strncmp(argv[i], "--cpu.print=", 12) == 0) {
		// join sandbox by pid or by name
		pid_t pid;
		if (read_pid(argv[i] + 12, &pid) == 0)		
			cpu_print_filter(pid);
		else
			cpu_print_filter_name(argv[i] + 12);
		exit(0);
	}
	else if (strncmp(argv[i], "--caps.print=", 13) == 0) {
		// join sandbox by pid or by name
		pid_t pid;
		if (read_pid(argv[i] + 13, &pid) == 0)		
			caps_print_filter(pid);
		else
			caps_print_filter_name(argv[i] + 13);
		exit(0);
	}
	else if (strncmp(argv[i], "--fs.print=", 11) == 0) {
		// join sandbox by pid or by name
		pid_t pid;
		if (read_pid(argv[i] + 11, &pid) == 0)		
			fs_logger_print_log(pid);
		else
			fs_logger_print_log_name(argv[i] + 11);
		exit(0);
	}
	else if (strncmp(argv[i], "--dns.print=", 12) == 0) {
		// join sandbox by pid or by name
		pid_t pid;
		if (read_pid(argv[i] + 12, &pid) == 0)		
			net_dns_print(pid);
		else
			net_dns_print_name(argv[i] + 12);
		exit(0);
	}
	else if (strcmp(argv[i], "--debug-caps") == 0) {
		caps_print();
		exit(0);
	}
	else if (strcmp(argv[i], "--list") == 0) {
		list();
		exit(0);
	}
	else if (strcmp(argv[i], "--tree") == 0) {
		tree();
		exit(0);
	}
	else if (strcmp(argv[i], "--top") == 0) {
		top();
		exit(0);
	}
#ifdef HAVE_NETWORK	
	else if (strcmp(argv[i], "--netstats") == 0) {
		if (checkcfg(CFG_NETWORK)) {
			netstats();
		}
		else {
			fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
			exit(1);
		}
		exit(0);
	}
#endif	
#ifdef HAVE_FILE_TRANSFER
	else if (strncmp(argv[i], "--get=", 6) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			
			// verify path
			if ((i + 2) != argc) {
				fprintf(stderr, "Error: invalid --get option, path expected\n");
				exit(1);
			}
			char *path = argv[i + 1];
			 invalid_filename(path);
			 if (strstr(path, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path);
			 	exit(1);
			 }
			 
			// get file
			pid_t pid;
			if (read_pid(argv[i] + 6, &pid) == 0)		
				sandboxfs(SANDBOX_FS_GET, pid, path, NULL);
			else
				sandboxfs_name(SANDBOX_FS_GET, argv[i] + 6, path, NULL);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --get feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
	else if (strncmp(argv[i], "--put=", 6) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			
			// verify path
			if ((i + 3) != argc) {
				fprintf(stderr, "Error: invalid --put option, 2 paths expected\n");
				exit(1);
			}
			char *path1 = argv[i + 1];
			 invalid_filename(path1);
			 if (strstr(path1, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path1);
			 	exit(1);
			 }
			char *path2 = argv[i + 2];
			 invalid_filename(path2);
			 if (strstr(path2, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path2);
			 	exit(1);
			 }
			 
			// get file
			pid_t pid;
			if (read_pid(argv[i] + 6, &pid) == 0)		
				sandboxfs(SANDBOX_FS_PUT, pid, path1, path2);
			else
				sandboxfs_name(SANDBOX_FS_PUT, argv[i] + 6, path1, path2);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --get feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
	else if (strncmp(argv[i], "--ls=", 5) == 0) {
		if (checkcfg(CFG_FILE_TRANSFER)) {
			logargs(argc, argv);
			
			// verify path
			if ((i + 2) != argc) {
				fprintf(stderr, "Error: invalid --ls option, path expected\n");
				exit(1);
			}
			char *path = argv[i + 1];
			 invalid_filename(path);
			 if (strstr(path, "..")) {
			 	fprintf(stderr, "Error: invalid file name %s\n", path);
			 	exit(1);
			 }
			 
			// list directory contents
			pid_t pid;
			if (read_pid(argv[i] + 5, &pid) == 0)		
				sandboxfs(SANDBOX_FS_LS, pid, path, NULL);
			else
				sandboxfs_name(SANDBOX_FS_LS, argv[i] + 5, path, NULL);
			exit(0);
		}
		else {
			fprintf(stderr, "Error: --ls feature is disabled in Firejail configuration file\n");
			exit(1);
		}
	}
#endif
	else if (strncmp(argv[i], "--join=", 7) == 0) {
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
		pid_t pid;
		if (read_pid(argv[i] + 7, &pid) == 0)		
			join(pid, argc, argv, i + 1);
		else
			join_name(argv[i] + 7, argc, argv, i + 1);
		exit(0);

	}
	else if (strncmp(argv[i], "--join-or-start=", 16) == 0) {
		// NOTE: this is first part of option handler,
		// 		 sandbox name is set in other part
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
		if (!name2pid(argv[i] + 16, &pid)) {
			if (!cfg.shell && !arg_shell_none)
				cfg.shell = guess_shell();

			join(pid, argc, argv, i + 1);
			exit(0);
		}
		// if there no such sandbox continue argument processing
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
			pid_t pid;
			if (read_pid(argv[i] + 15, &pid) == 0)		
				join(pid, argc, argv, i + 1);
			else
				join_name(argv[i] + 15, argc, argv, i + 1);
		}
		else {
			fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
			exit(1);
		}

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
		pid_t pid;
		if (read_pid(argv[i] + 18, &pid) == 0)		
			join(pid, argc, argv, i + 1);
		else
			join_name(argv[i] + 18, argc, argv, i + 1);
		exit(0);
	}
	else if (strncmp(argv[i], "--shutdown=", 11) == 0) {
		logargs(argc, argv);
		
		// shutdown sandbox by pid or by name
		pid_t pid;
		if (read_pid(argv[i] + 11, &pid) == 0)
			shut(pid);
		else
			shut_name(argv[i] + 11);
		exit(0);
	}

}

static void set_name_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_NAME_DIR, pid) == -1)
		errExit("asprintf");

	// the file is deleted first
	FILE *fp = fopen(fname, "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot create %s\n", fname);
		exit(1);
	}
	fprintf(fp, "%s\n", cfg.name);

	// mode and ownership
	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
}

static void delete_name_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_NAME_DIR, pid) == -1)
		errExit("asprintf");
	int rv = unlink(fname);
	(void) rv;
	free(fname);
}

static void set_x11_file(pid_t pid, int display) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_X11_DIR, pid) == -1)
		errExit("asprintf");

	// the file is deleted first
	FILE *fp = fopen(fname, "w");
	if (!fp) {
		fprintf(stderr, "Error: cannot create %s\n", fname);
		exit(1);
	}
	fprintf(fp, "%d\n", display);

	// mode and ownership
	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
}

static void delete_x11_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_X11_DIR, pid) == -1)
		errExit("asprintf");
	int rv = unlink(fname);
	(void) rv;
	free(fname);
}

static void detect_quiet(int argc, char **argv) {
	int i;
	
	// detect --quiet
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--quiet") == 0) {
			arg_quiet = 1;
			break;
		}
		
		// detect end of firejail params
		if (strcmp(argv[i], "--") == 0)
			break;
		if (strncmp(argv[i], "--", 2) != 0)
			break;
	}
}

static void detect_allow_debuggers(int argc, char **argv) {
	int i;
	
	// detect --allow-debuggers
	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "--allow-debuggers") == 0) {
			arg_allow_debuggers = 1;
			break;
		}
		
		// detect end of firejail params
		if (strcmp(argv[i], "--") == 0)
			break;
		if (strncmp(argv[i], "--", 2) != 0)
			break;
	}
}

char *guess_shell(void) {
	char *shell = NULL;
	// shells in order of preference
	char *shells[] = {"/bin/bash", "/bin/csh", "/usr/bin/zsh", "/bin/sh", "/bin/ash", NULL };

	int i = 0;
	while (shells[i] != NULL) {
		struct stat s;
		// access call checks as real UID/GID, not as effective UID/GID
		if (stat(shells[i], &s) == 0 && access(shells[i], R_OK) == 0) {
			shell = shells[i];
			break;
		}
		i++;
	}

	return shell;
}

//*******************************************
// Main program
//*******************************************
int main(int argc, char **argv) {
	int i;
	int prog_index = -1;			  // index in argv where the program command starts
	int lockfd = -1;
	int option_cgroup = 0;
	int option_force = 0;
	int custom_profile = 0;	// custom profile loaded
	char *custom_profile_dir = NULL; // custom profile directory
	int arg_noprofile = 0; // use default.profile if none other found/specified
#ifdef HAVE_SECCOMP
	int highest_errno = errno_highest_nr();
#endif

	detect_quiet(argc, argv);
	detect_allow_debuggers(argc, argv);

	// drop permissions by default and rise them when required
	EUID_INIT();
	EUID_USER();


	// check argv[0] symlink wrapper if this is not a login shell
	if (*argv[0] != '-')
		run_symlink(argc, argv);

	// check if we already have a sandbox running
	// If LXC is detected, start firejail sandbox
	// otherwise try to detect a PID namespace by looking under /proc for specific kernel processes and:
	//	- if --force flag is set, start firejail sandbox
	//	-- if --force flag is not set, start the application in a /bin/bash shell 
	if (check_namespace_virt() == 0) {
		EUID_ROOT();
		int rv = check_kernel_procs();
		EUID_USER();
		if (rv == 0) {
			// if --force option is passed to the program, disregard the existing sandbox
			int found = 0;
			for (i = 1; i < argc; i++) {
				if (strcmp(argv[i], "--force") == 0 ||
				    strcmp(argv[i], "--list") == 0 ||	
				    strcmp(argv[i], "--netstats") == 0 ||	
				    strcmp(argv[i], "--tree") == 0 ||	
				    strcmp(argv[i], "--top") == 0 ||
				    strncmp(argv[i], "--ls=", 5) == 0 ||
				    strncmp(argv[i], "--get=", 6) == 0 ||
				    strcmp(argv[i], "--debug-caps") == 0 ||
				    strcmp(argv[i], "--debug-errnos") == 0 ||
				    strcmp(argv[i], "--debug-syscalls") == 0 ||
				    strcmp(argv[i], "--debug-protocols") == 0 ||
				    strcmp(argv[i], "--help") == 0 ||
				    strcmp(argv[i], "--version") == 0 ||
				    strcmp(argv[i], "--overlay-clean") == 0 ||
				    strncmp(argv[i], "--dns.print=", 12) == 0 ||
				    strncmp(argv[i], "--bandwidth=", 12) == 0 ||
				    strncmp(argv[i], "--caps.print=", 13) == 0 ||
				    strncmp(argv[i], "--cpu.print=", 12) == 0 ||
	//********************************************************************************
	// todo: fix the following problems
				    strncmp(argv[i], "--join=", 7) == 0 ||
	//[netblue@debian Downloads]$ firejail --join=896
	//Switching to pid 897, the first child process inside the sandbox
	//Error: seccomp file not found
	//********************************************************************************
	
				    strncmp(argv[i], "--join-filesystem=", 18) == 0 ||
				    strncmp(argv[i], "--join-network=", 15) == 0 ||
				    strncmp(argv[i], "--fs.print=", 11) == 0 ||
				    strncmp(argv[i], "--protocol.print=", 17) == 0 ||
				    strncmp(argv[i], "--seccomp.print", 15) == 0 ||
				    strncmp(argv[i], "--shutdown=", 11) == 0) {
					found = 1;
					break;
				}
	
				// detect end of firejail params
				if (strcmp(argv[i], "--") == 0)
					break;
				if (strncmp(argv[i], "--", 2) != 0)
					break;
			}
			
			if (found == 0) {
				// start the program directly without sandboxing
				run_no_sandbox(argc, argv);
				// it will never get here!
				assert(0);
			}
			else
				option_force = 1;
		}
	}
	
	// check root/suid
	EUID_ROOT();
	if (geteuid()) {
		// detect --version
		for (i = 1; i < argc; i++) {
			if (strcmp(argv[i], "--version") == 0) {
				printf("firejail version %s\n", VERSION);
				exit(0);
			}
			
			// detect end of firejail params
			if (strcmp(argv[i], "--") == 0)
				break;
			if (strncmp(argv[i], "--", 2) != 0)
				break;
		}
		exit(1);
	}
	EUID_USER();

	// initialize globals
	init_cfg(argc, argv);


	// check firejail directories
	EUID_ROOT();
	fs_build_firejail_dir();
	bandwidth_del_run_file(sandbox_pid);
	network_del_run_file(sandbox_pid);
	delete_name_file(sandbox_pid);
	delete_x11_file(sandbox_pid);
	
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
						    	int rv = system(argv[2]);
						    	exit(rv);
						}
					}
				}
			}
			free(comm);
		}
	}
	
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
		check_output(argc, argv); // the function will not return if --output option was found
	}
	
	
	// check for force-nonewprivs in /etc/firejail/firejail.config file
	if (checkcfg(CFG_FORCE_NONEWPRIVS))
		arg_nonewprivs = 1;
	
	if (arg_allow_debuggers) {
		char *cmd = strdup("noblacklist ${PATH}/strace");
		if (!cmd)
			errExit("strdup");
		profile_add(cmd);
	}
	
	// parse arguments
	for (i = 1; i < argc; i++) {
		run_cmd_and_exit(i, argc, argv); // will exit if the command is recognized
		
		if (strcmp(argv[i], "--debug") == 0) {
			if (!arg_quiet) {
				arg_debug = 1;
				if (option_force)
					printf("Entering sandbox-in-sandbox mode\n");
			}
		}
		else if (strcmp(argv[i], "--debug-check-filename") == 0)
			arg_debug_check_filename = 1;
		else if (strcmp(argv[i], "--debug-blacklists") == 0)
			arg_debug_blacklists = 1;
		else if (strcmp(argv[i], "--debug-whitelists") == 0)
			arg_debug_whitelists = 1;
		else if (strcmp(argv[i], "--quiet") == 0) {
			arg_quiet = 1;
			arg_debug = 0;
		}
		else if (strcmp(argv[i], "--force") == 0)
			;
		else if (strcmp(argv[i], "--allow-debuggers") == 0) {
			// already handled
		}

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
				protocol_store(argv[i] + 11);
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strcmp(argv[i], "--seccomp") == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--seccomp=", 10) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list = strdup(argv[i] + 10);
				if (!cfg.seccomp_list)
					errExit("strdup");
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--seccomp.drop=", 15) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list_drop = strdup(argv[i] + 15);
				if (!cfg.seccomp_list_drop)
					errExit("strdup");
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--seccomp.keep=", 15) == 0) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list_keep = strdup(argv[i] + 15);
				if (!cfg.seccomp_list_keep)
					errExit("strdup");
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--seccomp.e", 11) == 0 && strchr(argv[i], '=')) {
			if (checkcfg(CFG_SECCOMP)) {
				if (arg_seccomp && !cfg.seccomp_list_errno) {
					fprintf(stderr, "Error: seccomp already enabled\n");
					exit(1);
				}
				char *eq = strchr(argv[i], '=');
				char *errnoname = strndup(argv[i] + 10, eq - (argv[i] + 10));
				int nr = errno_find_name(errnoname);
				if (nr == -1) {
					fprintf(stderr, "Error: unknown errno %s\n", errnoname);
					free(errnoname);
					exit(1);
				}
	
				if (!cfg.seccomp_list_errno)
					cfg.seccomp_list_errno = calloc(highest_errno+1, sizeof(cfg.seccomp_list_errno[0]));
	
				if (cfg.seccomp_list_errno[nr]) {
					fprintf(stderr, "Error: errno %s already configured\n", errnoname);
					free(errnoname);
					exit(1);
				}
				arg_seccomp = 1;
				cfg.seccomp_list_errno[nr] = strdup(eq+1);
				if (!cfg.seccomp_list_errno[nr])
					errExit("strdup");
				free(errnoname);
			}
			else {
				fprintf(stderr, "Error: seccomp feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif		
		else if (strcmp(argv[i], "--caps") == 0)
			arg_caps_default_filter = 1;
		else if (strcmp(argv[i], "--caps.drop=all") == 0)
			arg_caps_drop_all = 1;
		else if (strncmp(argv[i], "--caps.drop=", 12) == 0) {
			arg_caps_drop = 1;
			arg_caps_list = strdup(argv[i] + 12);
			if (!arg_caps_list)
				errExit("strdup");
			// verify caps list and exit if problems
			if (caps_check_list(arg_caps_list, NULL))
				return 1;
		}
		else if (strncmp(argv[i], "--caps.keep=", 12) == 0) {
			arg_caps_keep = 1;
			arg_caps_list = strdup(argv[i] + 12);
			if (!arg_caps_list)
				errExit("strdup");
			// verify caps list and exit if problems
			if (caps_check_list(arg_caps_list, NULL))
				return 1;
		}


		else if (strcmp(argv[i], "--trace") == 0)
			arg_trace = 1;
		else if (strcmp(argv[i], "--tracelog") == 0)
			arg_tracelog = 1;
		else if (strncmp(argv[i], "--rlimit-nofile=", 16) == 0) {
			if (not_unsigned(argv[i] + 16)) {
				fprintf(stderr, "Error: invalid rlimt nofile\n");
				exit(1);
			}
			sscanf(argv[i] + 16, "%u", &cfg.rlimit_nofile);
			arg_rlimit_nofile = 1;
		}		
		else if (strncmp(argv[i], "--rlimit-nproc=", 15) == 0) {
			if (not_unsigned(argv[i] + 15)) {
				fprintf(stderr, "Error: invalid rlimt nproc\n");
				exit(1);
			}
			sscanf(argv[i] + 15, "%u", &cfg.rlimit_nproc);
			arg_rlimit_nproc = 1;
		}	
		else if (strncmp(argv[i], "--rlimit-fsize=", 15) == 0) {
			if (not_unsigned(argv[i] + 15)) {
				fprintf(stderr, "Error: invalid rlimt fsize\n");
				exit(1);
			}
			sscanf(argv[i] + 15, "%u", &cfg.rlimit_fsize);
			arg_rlimit_fsize = 1;
		}	
		else if (strncmp(argv[i], "--rlimit-sigpending=", 20) == 0) {
			if (not_unsigned(argv[i] + 20)) {
				fprintf(stderr, "Error: invalid rlimt sigpending\n");
				exit(1);
			}
			sscanf(argv[i] + 20, "%u", &cfg.rlimit_sigpending);
			arg_rlimit_sigpending = 1;
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
		
		//*************************************
		// filesystem
		//*************************************
		else if (strcmp(argv[i], "--allusers") == 0)
			arg_allusers = 1;
#ifdef HAVE_BIND		
		else if (strncmp(argv[i], "--bind=", 7) == 0) {
			if (checkcfg(CFG_BIND)) {
				char *line;
				if (asprintf(&line, "bind %s", argv[i] + 7) == -1)
					errExit("asprintf");
	
				profile_check_line(line, 0, NULL);	// will exit if something wrong
				profile_add(line);
			}
			else {
				fprintf(stderr, "Error: --bind feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif
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
			else {
				fprintf(stderr, "Error: whitelist feature is disabled in Firejail configuration file\n");
				exit(1);
			}
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
#ifdef HAVE_OVERLAYFS
		else if (strcmp(argv[i], "--overlay") == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
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
			else {
				fprintf(stderr, "Error: overlayfs feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
		else if (strncmp(argv[i], "--overlay-named=", 16) == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
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
				if (subdirname == '\0') {
					fprintf(stderr, "Error: invalid overlay option\n");
					exit(1);
				}
				
				// check name
				invalid_filename(subdirname);
				if (strstr(subdirname, "..") || strstr(subdirname, "/")) {
					fprintf(stderr, "Error: invalid overlay name\n");
					exit(1);
				}
				cfg.overlay_dir = fs_check_overlay_dir(subdirname, arg_overlay_reuse);
			}
			else {
				fprintf(stderr, "Error: overlayfs feature is disabled in Firejail configuration file\n");
				exit(1);
			}

		}
#if 0 // disabled for now, it could be used to overwrite system directories	
		else if (strncmp(argv[i], "--overlay-path=", 15) == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
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
				
				char *dirname = argv[i] + 15;
				if (dirname == '\0') {
					fprintf(stderr, "Error: invalid overlay option\n");
					exit(1);
				}
				cfg.overlay_dir = expand_home(dirname, cfg.homedir);
			}
			else {
				fprintf(stderr, "Error: overlayfs feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif
		else if (strcmp(argv[i], "--overlay-tmpfs") == 0) {
			if (checkcfg(CFG_OVERLAYFS)) {
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
			else {
				fprintf(stderr, "Error: overlayfs feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif
		else if (strncmp(argv[i], "--profile=", 10) == 0) {
			if (arg_noprofile) {
				fprintf(stderr, "Error: --noprofile and --profile options are mutually exclusive\n");
				exit(1);
			}
			
			char *ppath = expand_home(argv[i] + 10, cfg.homedir);
			if (!ppath)
				errExit("strdup");
			invalid_filename(ppath);
			
			// multiple profile files are allowed!
			if (is_dir(ppath) || is_link(ppath) || strstr(ppath, "..")) {
				fprintf(stderr, "Error: invalid profile file\n");
				exit(1);
			}
			
			// access call checks as real UID/GID, not as effective UID/GID
			if (access(ppath, R_OK)) {
				fprintf(stderr, "Error: cannot access profile file\n");
				return 1;
			}

			profile_read(ppath);
			custom_profile = 1;
			free(ppath);
		}
		else if (strncmp(argv[i], "--profile-path=", 15) == 0) {
			if (arg_noprofile) {
				fprintf(stderr, "Error: --noprofile and --profile-path options are mutually exclusive\n");
				exit(1);
			}
			custom_profile_dir = expand_home(argv[i] + 15, cfg.homedir);
			invalid_filename(custom_profile_dir);
			if (!is_dir(custom_profile_dir) || is_link(custom_profile_dir) || strstr(custom_profile_dir, "..")) {
				fprintf(stderr, "Error: invalid profile path\n");
				exit(1);
			}
			
			// access call checks as real UID/GID, not as effective UID/GID
			if (access(custom_profile_dir, R_OK)) {
				fprintf(stderr, "Error: cannot access profile directory\n");
				return 1;
			}
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

			if (*(argv[i] + 9) == '\0') {
				fprintf(stderr, "Error: invalid ignore option\n");
				exit(1);
			}
			
			// find an empty entry in profile_ignore array
			int j;
			for (j = 0; j < MAX_PROFILE_IGNORE; j++) {
				if (cfg.profile_ignore[j] == NULL) 
					break;
			}
			if (j >= MAX_PROFILE_IGNORE) {
				fprintf(stderr, "Error: maximum %d --ignore options are permitted\n", MAX_PROFILE_IGNORE);
				exit(1);
			}
			// ... and configure it
			else
				cfg.profile_ignore[j] = argv[i] + 9;
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
				
				
				invalid_filename(argv[i] + 9);
				
				// extract chroot dirname
				cfg.chrootdir = argv[i] + 9;
				// if the directory starts with ~, expand the home directory
				if (*cfg.chrootdir == '~') {
					char *tmp;
					if (asprintf(&tmp, "%s%s", cfg.homedir, cfg.chrootdir + 1) == -1)
						errExit("asprintf");
					cfg.chrootdir = tmp;
				}
				
				// check chroot dirname exists
				if (strstr(cfg.chrootdir, "..") || !is_dir(cfg.chrootdir) || is_link(cfg.chrootdir)) {
					fprintf(stderr, "Error: invalid directory %s\n", cfg.chrootdir);
					return 1;
				}
				
				// don't allow "--chroot=/"
				char *rpath = realpath(cfg.chrootdir, NULL);
				if (rpath == NULL || strcmp(rpath, "/") == 0) {
					fprintf(stderr, "Error: invalid chroot directory\n");
					exit(1);
				}
				free(rpath);
				
				// check chroot directory structure
				if (fs_check_chroot_dir(cfg.chrootdir)) {
					fprintf(stderr, "Error: invalid chroot\n");
					exit(1);
				}
			}
			else {
				fprintf(stderr, "Error: --chroot feature is disabled in Firejail configuration file\n");
				exit(1);
			}
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
				cfg.home_private_keep = argv[i] + 15;
				fs_check_home_list();
				arg_private = 1;
			}
			else {
				fprintf(stderr, "Error: --private-home feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif		
		else if (strcmp(argv[i], "--private-dev") == 0) {
			arg_private_dev = 1;
		}
		else if (strncmp(argv[i], "--private-etc=", 14) == 0) {
			if (arg_writable_etc) {
				fprintf(stderr, "Error: --private-etc and --writable-etc are mutually exclusive\n");
				exit(1);
			}
			
			// extract private etc list
			cfg.etc_private_keep = argv[i] + 14;
			if (*cfg.etc_private_keep == '\0') {
				fprintf(stderr, "Error: invalid private-etc option\n");
				exit(1);
			}
			fs_check_etc_list();
			arg_private_etc = 1;
		}
		else if (strncmp(argv[i], "--private-bin=", 14) == 0) {
			// extract private bin list
			cfg.bin_private_keep = argv[i] + 14;
			if (*cfg.bin_private_keep == '\0') {
				fprintf(stderr, "Error: invalid private-bin option\n");
				exit(1);
			}
			arg_private_bin = 1;
			fs_check_bin_list();
		}
		else if (strcmp(argv[i], "--private-tmp") == 0) {
			arg_private_tmp = 1;
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
			else {
				fprintf(stderr, "Error: --noroot feature is disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif
		else if (strcmp(argv[i], "--nonewprivs") == 0) {
			arg_nonewprivs = 1;
		}
		else if (strncmp(argv[i], "--env=", 6) == 0)
			env_store(argv[i] + 6, SETENV);
		else if (strncmp(argv[i], "--rmenv=", 8) == 0)
			env_store(argv[i] + 8, RMENV);
		else if (strcmp(argv[i], "--nosound") == 0) {
			arg_nosound = 1;
		}
		else if (strcmp(argv[i], "--no3d") == 0) {
			arg_no3d = 1;
		}
				
		//*************************************
		// network
		//*************************************
#ifdef HAVE_NETWORK	
		else if (strncmp(argv[i], "--interface=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
#ifdef HAVE_NETWORK_RESTRICTED
				// compile time restricted networking
				if (getuid() != 0) {
					fprintf(stderr, "Error: --interface is allowed only to root user\n");
					exit(1);
				}
#endif
				// run time restricted networking
				if (checkcfg(CFG_RESTRICTED_NETWORK) && getuid() != 0) {
					fprintf(stderr, "Error: --interface is allowed only to root user\n");
					exit(1);
				}
		
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
					if (!arg_quiet || arg_debug)
						fprintf(stderr, "Warning:  interface %s is not configured\n", intf->dev);
				}
				intf->configured = 1;
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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

#ifdef HAVE_NETWORK_RESTRICTED
				// compile time restricted networking
				if (getuid() != 0) {
					fprintf(stderr, "Error: only --net=none is allowed to non-root users\n");
					exit(1);
				}
#endif
				// run time restricted networking
				if (checkcfg(CFG_RESTRICTED_NETWORK) && getuid() != 0) {
					fprintf(stderr, "Error: only --net=none is allowed to non-root users\n");
					exit(1);
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
				net_configure_bridge(br, argv[i] + 6);
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}

		else if (strcmp(argv[i], "--scan") == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_scan = 1;
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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
				if (in_netrange(br->iprange_start, br->ip, br->mask) || in_netrange(br->iprange_end, br->ip, br->mask)) {
					fprintf(stderr, "Error: IP range addresses not in network range\n");
					return 1;
				}
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
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
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}

		else if (strncmp(argv[i], "--ip6=", 6) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				Bridge *br = last_bridge_configured();
				if (br == NULL) {
					fprintf(stderr, "Error: no network device configured\n");
					exit(1);
				}
				if (br->arg_ip_none || br->ip6sandbox) {
					fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
					exit(1);
				}
	
				// configure this IP address for the last bridge defined
				// todo: verify ipv6 syntax
				br->ip6sandbox = argv[i] + 6;
//				if (atoip(argv[i] + 5, &br->ipsandbox)) {
//					fprintf(stderr, "Error: invalid IP address\n");
//					exit(1);
//				}
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}


		else if (strncmp(argv[i], "--defaultgw=", 12) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				if (atoip(argv[i] + 12, &cfg.defaultgw)) {
					fprintf(stderr, "Error: invalid IP address\n");
					exit(1);
				}
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif		
		else if (strncmp(argv[i], "--dns=", 6) == 0) {
			uint32_t dns;
			if (atoip(argv[i] + 6, &dns)) {
				fprintf(stderr, "Error: invalid DNS server IP address\n");
				return 1;
			}
			
			if (cfg.dns1 == 0)
				cfg.dns1 = dns;
			else if (cfg.dns2 == 0)
				cfg.dns2 = dns;
			else if (cfg.dns3 == 0)
				cfg.dns3 = dns;
			else {
				fprintf(stderr, "Error: up to 3 DNS servers can be specified\n");
				return 1;
			}
		}

#ifdef HAVE_NETWORK
		else if (strcmp(argv[i], "--netfilter") == 0) {
#ifdef HAVE_NETWORK_RESTRICTED
			// compile time restricted networking
			if (getuid() != 0) {
				fprintf(stderr, "Error: --netfilter is only allowed for root\n");
				exit(1);
			}
#endif
			// run time restricted networking
			if (checkcfg(CFG_RESTRICTED_NETWORK) && getuid() != 0) {
				fprintf(stderr, "Error: --netfilter is only allowed for root\n");
				exit(1);
			}
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter = 1;
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}

		else if (strncmp(argv[i], "--netfilter=", 12) == 0) {
#ifdef HAVE_NETWORK_RESTRICTED
			// compile time restricted networking
			if (getuid() != 0) {
				fprintf(stderr, "Error: --netfilter is only allowed for root\n");
				exit(1);
			}
#endif
			// run time restricted networking
			if (checkcfg(CFG_RESTRICTED_NETWORK) && getuid() != 0) {
				fprintf(stderr, "Error: --netfilter is only allowed for root\n");
				exit(1);
			}
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter = 1;
				arg_netfilter_file = argv[i] + 12;
				check_netfilter_file(arg_netfilter_file);
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}

		else if (strncmp(argv[i], "--netfilter6=", 13) == 0) {
			if (checkcfg(CFG_NETWORK)) {
				arg_netfilter6 = 1;
				arg_netfilter6_file = argv[i] + 13;
				check_netfilter_file(arg_netfilter6_file);
			}
			else {
				fprintf(stderr, "Error: networking features are disabled in Firejail configuration file\n");
				exit(1);
			}
		}
#endif
		//*************************************
		// command
		//*************************************
		else if (strcmp(argv[i], "--audit") == 0) {
			if (asprintf(&arg_audit_prog, "%s/firejail/faudit", LIBDIR) == -1)
				errExit("asprintf");
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
			arg_audit = 1;
		}
		else if (strcmp(argv[i], "--appimage") == 0)
			arg_appimage = 1;
		else if (strcmp(argv[i], "--csh") == 0) {
			if (arg_shell_none) {
			
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			if (cfg.shell) {
				fprintf(stderr, "Error: only one default user shell can be specified\n");
				return 1;
			}
			cfg.shell = "/bin/csh";
		}
		else if (strcmp(argv[i], "--zsh") == 0) {
			if (arg_shell_none) {
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			if (cfg.shell) {
				fprintf(stderr, "Error: only one default user shell can be specified\n");
				return 1;
			}
			cfg.shell = "/bin/zsh";
		}
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
			invalid_filename(argv[i] + 8);
			
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
				if (access(shellpath, R_OK)) {
					fprintf(stderr, "Error: cannot access shell file in chroot\n");
					exit(1);
				}
				free(shellpath);
			} else if (access(cfg.shell, R_OK)) {
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
			else {
				fprintf(stderr, "Error: --x11 feature is disabled in Firejail configuration file\n");
				exit(1);
			}
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
		else if (strcmp(argv[i], "--") == 0) {
			// double dash - positional params to follow
			arg_doubledash = 1;
			i++;
			if (i  >= argc) {
				fprintf(stderr, "Error: program name not found\n");
				exit(1);
			}
			extract_command_name(i, argv);
			prog_index = i;
			break;
		}
		else {
			// is this an invalid option?
			if (*argv[i] == '-') {
				fprintf(stderr, "Error: invalid %s command line option\n", argv[i]);
				return 1;
			}
			
			// we have a program name coming
			if (arg_appimage) {
				cfg.command_name = strdup(argv[i]);
				if (!cfg.command_name)
					errExit("strdup");
			}
			else
				extract_command_name(i, argv);
			prog_index = i;
			break;
		}
	}
	
	// prog_index could still be -1 if no program was specified
	if (prog_index == -1 && arg_shell_none) {
		fprintf(stderr, "shell=none configured, but no program specified\n");
		exit(1);
	}

	// check trace configuration
	if (arg_trace && arg_tracelog) {
		if (!arg_quiet || arg_debug)
			fprintf(stderr, "Warning: --trace and --tracelog are mutually exclusive; --tracelog disabled\n");
	}
	
	// disable x11 abstract socket
	if (getenv("FIREJAIL_X11"))
		mask_x11_abstract_socket = 1;
	
	// check user namespace (--noroot) options
	if (arg_noroot) {
		if (arg_overlay) {
			fprintf(stderr, "Error: --overlay and --noroot are mutually exclusive.\n");
			exit(1);
		}
		else if (cfg.chrootdir) {
			fprintf(stderr, "Error: --chroot and --noroot are mutually exclusive.\n");
			exit(1);
		}
	}

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
		cfg.window_title = "appimage";
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
	if (!arg_noprofile) {
		if (!custom_profile) {
			// look for a profile in ~/.config/firejail directory
			char *usercfgdir;
			if (asprintf(&usercfgdir, "%s/.config/firejail", cfg.homedir) == -1)
				errExit("asprintf");
			int rv = profile_find(cfg.command_name, usercfgdir);
			free(usercfgdir);
			custom_profile = rv;
		}
		if (!custom_profile) {
			// look for a user profile in /etc/firejail directory
			int rv;
			if (custom_profile_dir)
				rv = profile_find(cfg.command_name, custom_profile_dir);
			else
				rv = profile_find(cfg.command_name, SYSCONFDIR);
			custom_profile = rv;
		}
	}

	// use default.profile as the default
	if (!custom_profile && !arg_noprofile) {
		if (cfg.chrootdir) {
			if (!arg_quiet || arg_debug)
				fprintf(stderr, "Warning: default profile disabled by --chroot option\n");
		}
		else if (arg_overlay) {
			if (!arg_quiet || arg_debug)
				fprintf(stderr, "Warning: default profile disabled by --overlay option\n");
		}
		else {
			// try to load a default profile
			char *profile_name = DEFAULT_USER_PROFILE;
			if (getuid() == 0)
				profile_name = DEFAULT_ROOT_PROFILE;
			if (arg_debug)
				printf("Attempting to find %s.profile...\n", profile_name);
	
			// look for the profile in ~/.config/firejail directory
			char *usercfgdir;
			if (asprintf(&usercfgdir, "%s/.config/firejail", cfg.homedir) == -1)
				errExit("asprintf");
			custom_profile = profile_find(profile_name, usercfgdir);
			free(usercfgdir);
	
			if (!custom_profile) {
				// look for the profile in /etc/firejail directory
				if (custom_profile_dir)
					custom_profile = profile_find(profile_name, custom_profile_dir);
				else
					custom_profile = profile_find(profile_name, SYSCONFDIR);
			}
			if (!custom_profile) {
				fprintf(stderr, "Error: no default.profile installed\n");
				exit(1);
			}
			
			if (custom_profile && !arg_quiet)
				printf("\n** Note: you can use --noprofile to disable %s.profile **\n\n", profile_name);
		}
	}

	// block X11 sockets
	if (arg_x11_block)
		x11_block();

	// check network configuration options - it will exit if anything went wrong
	net_check_cfg();
	
	// check and assign an IP address - for macvlan it will be done again in the sandbox!
	if (any_bridge_configured()) {
		EUID_ROOT();
		lockfd = open(RUN_NETWORK_LOCK_FILE, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
		if (lockfd != -1) {
			int rv = fchown(lockfd, 0, 0);
			(void) rv;
			flock(lockfd, LOCK_EX);
		}
		
		check_network(&cfg.bridge0);
		check_network(&cfg.bridge1);
		check_network(&cfg.bridge2);
		check_network(&cfg.bridge3);
			
		// save network mapping in shared memory
		network_set_run_file(sandbox_pid);
		EUID_USER();
	}

 	// create the parent-child communication pipe
 	if (pipe(parent_to_child_fds) < 0)
 		errExit("pipe");
 	if (pipe(child_to_parent_fds) < 0)
		errExit("pipe");

	if (arg_noroot && arg_overlay) {
		if (!arg_quiet || arg_debug)
			fprintf(stderr, "Warning: --overlay and --noroot are mutually exclusive, noroot disabled\n");
		arg_noroot = 0;
	}
	else if (arg_noroot && cfg.chrootdir) {
		if (!arg_quiet || arg_debug)
			fprintf(stderr, "Warning: --chroot and --noroot are mutually exclusive, noroot disabled\n");
		arg_noroot = 0;
	}


	// set name file
	EUID_ROOT();
	if (cfg.name)
		set_name_file(sandbox_pid);
	int display = x11_display();
	if (display > 0)
		set_x11_file(sandbox_pid, display);
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

	EUID_ROOT();
	child = clone(sandbox,
		child_stack + STACK_SIZE,
		flags,
		NULL);
	if (child == -1)
		errExit("clone");
	EUID_USER();

	if (!arg_command && !arg_quiet) {
		printf("Parent pid %u, child pid %u\n", sandbox_pid, child);
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
			_exit(0);			
		}

		// wait for the child to finish
		waitpid(net_child, NULL, 0);
		EUID_USER();
	}

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
	 	
 		EUID_ROOT();
	 	update_map(gidmap, map_path);
	 	EUID_USER();
	 	free(map_path);
 	}
 	
 	// notify child that UID/GID mapping is complete
 	notify_other(parent_to_child_fds[1]);
 	close(parent_to_child_fds[1]);
 
 	EUID_ROOT();
	if (lockfd != -1) {
		flock(lockfd, LOCK_UN);
		close(lockfd);
	}

	// create name file under /run/firejail
	

	// handle CTRL-C in parent
	signal (SIGINT, my_handler);
	signal (SIGTERM, my_handler);

	
	// wait for the child to finish
	EUID_USER();
	int status = 0;
	waitpid(child, &status, 0);

	// free globals
#ifdef HAVE_SECCOMP
	if (cfg.seccomp_list_errno) {
		for (i = 0; i < highest_errno; i++)
			free(cfg.seccomp_list_errno[i]);
		free(cfg.seccomp_list_errno);
	}
#endif
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

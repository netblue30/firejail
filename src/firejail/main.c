/*
 * Copyright (C) 2014, 2015 Firejail Authors
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

#define STACK_SIZE (1024 * 1024)
static char child_stack[STACK_SIZE];		// space for child's stack
Config cfg;					// configuration
int arg_private = 0;				// mount private /home and /tmp directoryu
int arg_debug = 0;				// print debug messages
int arg_nonetwork = 0;				// --net=none
int arg_command = 0;				// -c
int arg_overlay = 0;				// overlay option
int arg_overlay_keep = 0;			// place overlay diff directory in ~/.firejail
int arg_zsh = 0;				// use zsh as default shell
int arg_csh = 0;				// use csh as default shell

int arg_seccomp = 0;				// enable default seccomp filter
char *arg_seccomp_list = NULL;		// optional seccomp list on top of default filter
char *arg_seccomp_list_drop = NULL;		// seccomp drop list
char *arg_seccomp_list_keep = NULL;		// seccomp keep list

int arg_caps_default_filter = 0;			// enable default capabilities filter
int arg_caps_drop = 0;				// drop list
int arg_caps_drop_all = 0;			// drop all capabilities
int arg_caps_keep = 0;			// keep list
char *arg_caps_list = NULL;			// optional caps list

int arg_trace = 0;				// syscall tracing support
int arg_rlimit_nofile = 0;			// rlimit nofile
int arg_rlimit_nproc = 0;			// rlimit nproc
int arg_rlimit_fsize = 0;				// rlimit fsize
int arg_rlimit_sigpending = 0;			// rlimit fsize
int arg_nox11 = 0;				// kill the program if x11 unix domain socket is accessed
int arg_nodbus = 0;				// kill the program if D-Bus is accessed
int arg_nogroups = 0;				// disable supplementary groups
int arg_noroot = 0;				// create a new user namespace and disable root user
int arg_netfilter;				// enable netfilter
char *arg_netfilter_file = NULL;			// netfilter file
int arg_doubledash = 0;			// double dash
int arg_shell_none = 0;			// run the program directly without a shell
int arg_private_dev = 0;			// private dev directory
int arg_private_etc = 0;			// private etc directory
int arg_scan = 0;				// arp-scan all interfaces

int parent_to_child_fds[2];
int child_to_parent_fds[2];

char *fullargv[MAX_ARGS];			// expanded argv for restricted shell
int fullargc = 0;
static pid_t child = 0;
pid_t sandbox_pid;

static void myexit(int rv) {
	logmsg("exiting...");
	if (!arg_command)
		printf("\nparent is shutting down, bye...\n");
	
	struct stat s;
	if (stat("/proc/firejail", &s) == 0) {
		/* coverity[toctou] */
		FILE *fp = fopen("/proc/firejail", "w");
		if (fp) {
			// deregistration
			fprintf(fp, "release\n");
			fflush(0);
			fclose(fp);
		}
	}

	// delete sandbox files in shared memory
	bandwidth_shm_del_file(sandbox_pid);		// bandwidht file
	network_shm_del_file(sandbox_pid);		// network map file
	
	exit(rv); 
}

static void my_handler(int s){
	printf("\nSignal %d caught, shutting down the child process\n", s);
	logsignal(s);
	kill(child, SIGKILL);
	myexit(1);
}

static void extract_user_data(void) {
	// check suid
	if (geteuid()) {
		fprintf(stderr, "Error: the sandbox is not setuid root\n");
		exit(1);
	}

	struct passwd *pw = getpwuid(getuid());
	if (!pw)
		errExit("getpwuid");
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
}




static inline Bridge *last_bridge_configured(void) {
	if (cfg.bridge3.configured)
		return &cfg.bridge3;
	else if (cfg.bridge2.configured)
		return &cfg.bridge2;
	else if (cfg.bridge1.configured)
		return &cfg.bridge1;
	else if (cfg.bridge0.configured)
		return &cfg.bridge0;
	else
		return NULL;
}



// return 1 if error, 0 if a valid pid was found
static int read_pid(char *str, pid_t *pid) {
	char *endptr;
	errno = 0;
	long int pidtmp = strtol(str, &endptr, 10);
	if ((errno == ERANGE && (pidtmp == LONG_MAX || pidtmp == LONG_MIN))
		|| (errno != 0 && pidtmp == 0)) {
		return 1;
	}
	if (endptr == str) {
		return 1;
	}
	*pid = (pid_t)pidtmp;
	return 0;
}

static void init_cfg(void) {
	memset(&cfg, 0, sizeof(cfg));
	
	cfg.bridge0.devsandbox = "eth0";
	cfg.bridge1.devsandbox = "eth1";
	cfg.bridge2.devsandbox = "eth2";
	cfg.bridge3.devsandbox = "eth3";
	
	extract_user_data();
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


void check_user_namespace(void) {
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
		fprintf(stderr, "Warning: user namespaces not available in the current kernel.\n");
		arg_noroot = 0;
	}
}

//*******************************************
// Main program
//*******************************************
int main(int argc, char **argv) {
	int i;
	int prog_index = -1;			  // index in argv where the program command starts
	int lockfd = -1;
	int arg_ipc = 0;
	int arg_cgroup = 0;
	int custom_profile = 0;	// custom profile loaded

	// initialize globals
	init_cfg();
	cfg.original_argv = argv;
	cfg.original_argc = argc;
	

	// initialize random number generator
	sandbox_pid = getpid();
	time_t t = time(NULL);
	srand(t ^ sandbox_pid);

	// check firejail directories
	fs_build_firejail_dir();
	shm_create_firejail_dir();	
	bandwidth_shm_del_file(sandbox_pid);

	// is this a login shell?
	if (*argv[0] == '-') {
		fullargc = restricted_shell(cfg.username);
		if (fullargc) {
			int j;
			for (i = 1, j = fullargc; i < argc && j < MAX_ARGS; i++, j++, fullargc++)
				fullargv[j] = argv[i];

			// replace argc/argv with fullargc/fullargv
			argv = fullargv;
			argc = j;
		}
	}
	else {
		// check --output option and execute it;
		check_output(argc, argv); // the function will not return if --output option was found
	}
		
	// parse arguments
	for (i = 1; i < argc; i++) {
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
			exit(0);
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;

		else if (strncmp(argv[i], "--bandwidth=", 12) == 0) {
			logargs(argc, argv);
			
			// extract the command
			if ((i + 1) == argc) {
				fprintf(stderr, "Error: command expected after --bandwidth option\n");
				exit(1);
			}
			char *cmd = argv[i + 1];
			if (strcmp(cmd, "status") && strcmp(cmd, "clear") && strcmp(cmd, "set")) {
				fprintf(stderr, "Error: invalid --bandwidth command\n");
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
 			
 			// it will never get here
 			exit(0);
		}

		//*************************************
		// independent commands - the program will exit!
		//*************************************
#ifdef HAVE_SECCOMP
		else if (strcmp(argv[i], "--debug-syscalls") == 0) {
			syscall_print();
			exit(0);
		}
		else if (strncmp(argv[i], "--seccomp.print=", 16) == 0) {
			// join sandbox by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 16, &pid) == 0)		
				seccomp_print_filter(pid);
			else
				seccomp_print_filter_name(argv[i] + 16);
				
			// it will never get here!!!
			exit(0);
		}
#endif
		else if (strncmp(argv[i], "--caps.print=", 13) == 0) {
			// join sandbox by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 13, &pid) == 0)		
				caps_print_filter(pid);
			else
				caps_print_filter_name(argv[i] + 13);
				
			// it will never get here!!!
			exit(0);
		}
	
		else if (strncmp(argv[i], "--dns.print=", 12) == 0) {
			// join sandbox by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 12, &pid) == 0)		
				net_dns_print(pid);
			else
				net_dns_print_name(argv[i] + 12);
				
			// it will never get here!!!
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
		else if (strcmp(argv[i], "--netstats") == 0) {
			netstats();
			exit(0);
		}
		else if (strncmp(argv[i], "--join=", 7) == 0) {
			logargs(argc, argv);
			
			// join sandbox by pid or by name
			pid_t pid;
			if (read_pid(argv[i] + 7, &pid) == 0)		
				join(pid, cfg.homedir, argc, argv, i + 1);
			else
				join_name(argv[i] + 7, cfg.homedir, argc, argv, i + 1);
				
			// it will never get here!!!
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

			// it will never get here!!!
			exit(0);
		}
		
		//*************************************
		// filtering
		//*************************************
#ifdef HAVE_SECCOMP
		else if (strcmp(argv[i], "--seccomp") == 0) {
			if (arg_seccomp) {
				fprintf(stderr, "Error: seccomp already enabled\n");
				exit(1);
			}
			arg_seccomp = 1;
		}
		else if (strncmp(argv[i], "--seccomp=", 10) == 0) {
			if (arg_seccomp) {
				fprintf(stderr, "Error: seccomp already enabled\n");
				exit(1);
			}
			arg_seccomp = 1;
			arg_seccomp_list = strdup(argv[i] + 10);
			if (!arg_seccomp_list)
				errExit("strdup");
		}
		else if (strncmp(argv[i], "--seccomp.drop=", 15) == 0) {
			if (arg_seccomp) {
				fprintf(stderr, "Error: seccomp already enabled\n");
				exit(1);
			}
			arg_seccomp = 1;
			arg_seccomp_list_drop = strdup(argv[i] + 15);
			if (!arg_seccomp_list_drop)
				errExit("strdup");
		}
		else if (strncmp(argv[i], "--seccomp.keep=", 15) == 0) {
			if (arg_seccomp) {
				fprintf(stderr, "Error: seccomp already enabled\n");
				exit(1);
			}
			arg_seccomp = 1;
			arg_seccomp_list_keep = strdup(argv[i] + 15);
			if (!arg_seccomp_list_keep)
				errExit("strdup");
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
		else if (strcmp(argv[i], "--nox11") == 0) {
			// check if firejail lkm is present
			struct stat s;
			if (stat("/proc/firejail", &s) < 0) {
				fprintf(stderr, "Error: firejail Linux kernel module not found. The module"
					" is required for --nox11 option to work.\n");
				exit(1);
			}
			arg_nox11 = 1;
		}
		else if (strcmp(argv[i], "--nodbus") == 0) {
			// check if firejail lkm is present
			struct stat s;
			if (stat("/proc/firejail", &s) < 0) {
				fprintf(stderr, "Error: firejail Linux kernel module not found. The module"
					" is required for --nodbus option to work.\n");
				exit(1);
			}
			arg_nodbus = 1;
		}
		else if (strncmp(argv[i], "--cgroup=", 9) == 0) {
			if (arg_cgroup) {
				fprintf(stderr, "Error: only a cgroup can be defined\n");
				exit(1);
			}
			arg_cgroup = 1;
			cfg.cgroup = strdup(argv[i] + 9);
			if (!cfg.cgroup)
				errExit("strdup");
			set_cgroup(cfg.cgroup);
		}
		
		//*************************************
		// filesystem
		//*************************************
#ifdef HAVE_BIND		
		else if (strncmp(argv[i], "--bind=", 7) == 0) {
			char *line;
			if (asprintf(&line, "bind %s", argv[i] + 7) == -1)
				errExit("asprintf");

			profile_check_line(line, 0);	// will exit if something wrong
			profile_add(line);
		}
#endif
		else if (strncmp(argv[i], "--tmpfs=", 8) == 0) {
			char *line;
			if (asprintf(&line, "tmpfs %s", argv[i] + 8) == -1)
				errExit("asprintf");
			
			profile_check_line(line, 0);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--blacklist=", 12) == 0) {
			char *line;
			if (asprintf(&line, "blacklist %s", argv[i] + 12) == -1)
				errExit("asprintf");
			
			profile_check_line(line, 0);	// will exit if something wrong
			profile_add(line);
		}
		else if (strncmp(argv[i], "--read-only=", 12) == 0) {
			char *line;
			if (asprintf(&line, "read-only %s", argv[i] + 12) == -1)
				errExit("asprintf");
			
			profile_check_line(line, 0);	// will exit if something wrong
			profile_add(line);
		}
		else if (strcmp(argv[i], "--overlay") == 0) {
			if (cfg.chrootdir) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			arg_overlay = 1;
			arg_overlay_keep = 1;
			
			// create ~/.firejail directory
			char *dirname;
			if (asprintf(&dirname, "%s/.firejail", cfg.homedir) == -1)
				errExit("asprintf");
			struct stat s;
			if (stat(dirname, &s) == -1) {
				if (mkdir(dirname, S_IRWXU | S_IRWXG | S_IRWXO))
					errExit("mkdir");
				if (chown(dirname, getuid(), getgid()) < 0)
					errExit("chown");
				if (chmod(dirname, S_IRWXU  | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH) < 0)
					errExit("chmod");
			}
			free(dirname);
			
			// check overlay directory
			if (asprintf(&dirname, "%s/.firejail/%d", cfg.homedir, getpid()) == -1)
				errExit("asprintf");
			if (stat(dirname, &s) == 0) {
				fprintf(stderr, "Error: overlay directory already exists: %s\n", dirname);
				exit(1);
			}
			cfg.overlay_dir = dirname;
		}
		else if (strcmp(argv[i], "--overlay-tmpfs") == 0) {
			if (cfg.chrootdir) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			arg_overlay = 1;
		}
		else if (strncmp(argv[i], "--profile=", 10) == 0) {
			// multiple profile files are allowed!
			char *ptr = argv[i] + 10;
			if (is_dir(ptr) || is_link(ptr) || strstr(ptr, "..")) {
				fprintf(stderr, "Error: invalid profile file\n");
				exit(1);
			}
			
			// access call checks as real UID/GID, not as effective UID/GID
			if (access(argv[i] + 10, R_OK)) {
				fprintf(stderr, "Error: cannot access profile file\n");
				return 1;
			}

			profile_read(argv[i] + 10, NULL, NULL);
			custom_profile = 1;
		}
#ifdef HAVE_CHROOT		
		else if (strncmp(argv[i], "--chroot=", 9) == 0) {
			if (arg_overlay) {
				fprintf(stderr, "Error: --overlay and --chroot options are mutually exclusive\n");
				exit(1);
			}
			
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
			
			// check chroot directory structure
			if (fs_check_chroot_dir(cfg.chrootdir)) {
				fprintf(stderr, "Error: invalid chroot\n");
				exit(1);
			}
		}
#endif
		else if (strcmp(argv[i], "--private") == 0)
			arg_private = 1;
		else if (strncmp(argv[i], "--private=", 10) == 0) {
			if (cfg.home_private_keep) {
				fprintf(stderr, "Error: a private list of files was already defined with --private-home option.\n");
				exit(1);
			}
			
			// extract private home dirname
			cfg.home_private = argv[i] + 10;
			fs_check_private_dir();
			arg_private = 1;
		}
		else if ((strncmp(argv[i], "--private.keep=", 15) == 0)
		      || (strncmp(argv[i], "--private-home=", 15) == 0)) {
			if (cfg.home_private) {
				fprintf(stderr, "Error: a private home directory was already defined with --private option.\n");
				exit(1);
			}
			
			// extract private home dirname
			cfg.home_private_keep = argv[i] + 15;
			fs_check_home_list();
			arg_private = 1;
		}
		else if (strcmp(argv[i], "--private-dev") == 0) {
			arg_private_dev = 1;
		}
		else if (strncmp(argv[i], "--private-etc=", 14) == 0) {
			// extract private etc dirname
			cfg.etc_private_keep = argv[i] + 14;
			fs_check_etc_list();
			arg_private_etc = 1;
		}
			


		//*************************************
		// hostname, etc
		//*************************************
		else if (strncmp(argv[i], "--name=", 7) == 0) {
			cfg.hostname = argv[i] + 7;
			if (strlen(cfg.hostname) == 0) {
				fprintf(stderr, "Error: please provide a name for sandbox\n");
				return 1;
			}
		}
		else if (strcmp(argv[i], "--nogroups") == 0)
			arg_nogroups = 1;
		else if (strcmp(argv[i], "--noroot") == 0) {
			check_user_namespace();
		}
		
		//*************************************
		// network
		//*************************************
		else if (strncmp(argv[i], "--net=", 6) == 0) {
			if (strcmp(argv[i] + 6, "none") == 0) {
				arg_nonetwork  = 1;
				cfg.bridge0.configured = 0;
				cfg.bridge1.configured = 0;
				cfg.bridge2.configured = 0;
				cfg.bridge3.configured = 0;
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
				fprintf(stderr, "Error: maximum 4 network devices allowed\n");
				return 1;
			}
			net_configure_bridge(br, argv[i] + 6);
		}
		else if (strcmp(argv[i], "--scan") == 0) {
			arg_scan = 1;
		}
		else if (strncmp(argv[i], "--iprange=", 10) == 0) {
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
		else if (strncmp(argv[i], "--mac=", 6) == 0) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				return 1;
			}
			if (mac_not_zero(br->macsandbox)) {
				fprintf(stderr, "Error: cannot configure the MAC address twice for the same interface\n");
				return 1;
			}

			// read the address
			if (atomac(argv[i] + 6, br->macsandbox)) {
				fprintf(stderr, "Error: invalid MAC address\n");
				return 1;
			}
		}
		else if (strncmp(argv[i], "--ip=", 5) == 0) {
			Bridge *br = last_bridge_configured();
			if (br == NULL) {
				fprintf(stderr, "Error: no network device configured\n");
				return 1;
			}
			if (br->arg_ip_none || br->ipsandbox) {
				fprintf(stderr, "Error: cannot configure the IP address twice for the same interface\n");
				return 1;
			}

			// configure this IP address for the last bridge defined
			if (strcmp(argv[i] + 5, "none") == 0)
				br->arg_ip_none = 1;
			else {
				if (atoip(argv[i] + 5, &br->ipsandbox)) {
					fprintf(stderr, "Error: invalid IP address\n");
					return 1;
				}
			}
		}
		else if (strncmp(argv[i], "--defaultgw=", 12) == 0) {
			if (atoip(argv[i] + 12, &cfg.defaultgw)) {
				fprintf(stderr, "Error: invalid IP address\n");
				return 1;
			}
		}
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
		else if (strcmp(argv[i], "--netfilter") == 0)
			arg_netfilter = 1;
		else if (strncmp(argv[i], "--netfilter=", 12) == 0) {
			arg_netfilter = 1;
			arg_netfilter_file = argv[i] + 12;
			check_netfilter_file(arg_netfilter_file);
		}

		//*************************************
		// command
		//*************************************
		else if (strcmp(argv[i], "--csh") == 0) {
			if (arg_shell_none) {
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			if (arg_zsh || cfg.shell ) {
				fprintf(stderr, "Error: only one default user shell can be specified\n");
				return 1;
			}
			arg_csh = 1;
		}
		else if (strcmp(argv[i], "--zsh") == 0) {
			if (arg_shell_none) {
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			if (arg_csh || cfg.shell ) {
				fprintf(stderr, "Error: only one default user shell can be specified\n");
				return 1;
			}
			arg_zsh = 1;
		}
		else if (strcmp(argv[i], "--shell=none") == 0) {
			arg_shell_none = 1;
			if (arg_csh || arg_zsh || cfg.shell) {
				fprintf(stderr, "Error: a shell was already specified\n");
				return 1;
			}
		}
		else if (strncmp(argv[i], "--shell=", 8) == 0) {
			if (arg_shell_none) {
				fprintf(stderr, "Error: --shell=none was already specified.\n");
				return 1;
			}
			if (arg_csh || arg_zsh || cfg.shell) {
				fprintf(stderr, "Error: only one user shell can be specified\n");
				return 1;
			}
			cfg.shell = argv[i] + 8;

			if (is_dir(cfg.shell) || is_link(cfg.shell) || strstr(cfg.shell, "..")) {
				fprintf(stderr, "Error: invalid shell\n");
				exit(1);
			}
			
			// access call checks as real UID/GID, not as effective UID/GID
			if (access(cfg.shell, R_OK)) {
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
		else if (strcmp(argv[i], "--") == 0) {
			// double dash - positional params to follow
			arg_doubledash = 1;
			i++;
			if (i  >= argc) {
				fprintf(stderr, "Error: program name not found\n");
				exit(1);
			}
			extract_command_name(argv[i]);
			prog_index = i;
			cfg.original_program_index = i;
			break;
		}
		else {
			// is this an invalid option?
			if (*argv[i] == '-') {
				fprintf(stderr, "Error: invalid %s command line option\n", argv[i]);
				return 1;
			}
			
			// we have a program name coming
			extract_command_name(argv[i]);
			prog_index = i;
			cfg.original_program_index = i;
			break;
		}
	}

	// check network configuration options - it will exit if anything went wrong
	net_check_cfg();
	
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

	// build the sandbox command
	if (prog_index == -1 && arg_zsh) {
		cfg.command_line = "/usr/bin/zsh";
		cfg.command_name = "zsh";
	}
	else if (prog_index == -1 && arg_csh) {
		cfg.command_line = "/bin/csh";
		cfg.command_name = "csh";
	}
	else if (prog_index == -1 && cfg.shell) {
		cfg.command_line = cfg.shell;
		cfg.command_name = cfg.shell;
	}
	else if (prog_index == -1) {
		cfg.command_line = "/bin/bash";
		cfg.command_name = "bash";
	}
	else {
		// calculate the length of the command
		int i;
		int len = 0;
		int argcnt = argc - prog_index;
		for (i = 0; i < argcnt; i++)
			len += strlen(argv[i + prog_index]) + 1; // + ' '

		// build the string
		cfg.command_line = malloc(len + 1); // + '\0'
		if (!cfg.command_line)
			errExit("malloc");
		char *ptr = cfg.command_line;
		for (i = 0; i < argcnt; i++) {
			sprintf(ptr, "%s ", argv[i + prog_index]);
			ptr += strlen(ptr);
		}
	}
	
	// load the profile
	{
		assert(cfg.command_name);
		if (arg_debug)
			printf("Command name #%s#\n", cfg.command_name);		
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
			int rv = profile_find(cfg.command_name, "/etc/firejail");
			custom_profile = rv;
		}
	}

	// check and assign an IP address - for macvlan it will be done again in the sandbox!
	if (any_bridge_configured()) {
		lockfd = open("/tmp/firejail/firejail.lock", O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
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
		network_shm_set_file(sandbox_pid);
	}

 	// create the parent-child communication pipe
 	if (pipe(parent_to_child_fds) < 0)
 		errExit("pipe");
 	if (pipe(child_to_parent_fds) < 0)
		errExit("pipe");

	// clone environment
	int flags = CLONE_NEWNS | CLONE_NEWPID | CLONE_NEWUTS | SIGCHLD;
	
	// in root mode also enable CLONE_NEWIPC
	// in user mode CLONE_NEWIPC will break MIT Shared Memory Extension (MIT-SHM)
	if (getuid() == 0 || arg_ipc)
		flags |= CLONE_NEWIPC;
	
	if (any_bridge_configured() || arg_nonetwork) {
		flags |= CLONE_NEWNET;
	}
	else if (arg_debug)
		printf("Using the local network stack\n");

	child = clone(sandbox,
		child_stack + STACK_SIZE,
		flags,
		NULL);
	if (child == -1)
		errExit("clone");

	if (!arg_command) {
		printf("Parent pid %u, child pid %u\n", sandbox_pid, child);
		// print the path of the new log directory
		if (getuid() == 0) // only for root
			printf("The new log directory is /proc/%d/root/var/log\n", child);
	}
	
	

	// create veth pair or macvlan device
	if (cfg.bridge0.configured && !arg_nonetwork) {
		if (cfg.bridge0.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge0, "eth0", child);
		else
			net_create_macvlan(cfg.bridge0.devsandbox, cfg.bridge0.dev, child);
	}
	
	if (cfg.bridge1.configured && !arg_nonetwork) {
		if (cfg.bridge1.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge1, "eth1", child);
		else
			net_create_macvlan(cfg.bridge1.devsandbox, cfg.bridge1.dev, child);
	}
	
	if (cfg.bridge2.configured && !arg_nonetwork) {
		if (cfg.bridge2.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge2, "eth2", child);
		else
			net_create_macvlan(cfg.bridge2.devsandbox, cfg.bridge2.dev, child);
	}
	
	if (cfg.bridge3.configured && !arg_nonetwork) {
		if (cfg.bridge3.macvlan == 0)
			net_configure_veth_pair(&cfg.bridge3, "eth3", child);
		else
			net_create_macvlan(cfg.bridge3.devsandbox, cfg.bridge3.dev, child);
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
	 	update_map(map, map_path);
	 	free(map);
	 	free(map_path);
	 
	 	//gid
	 	if (asprintf(&map_path, "/proc/%d/gid_map", child) == -1)
	 		errExit("asprintf");
	 	gid_t gid = getgid();
	 	if (asprintf(&map, "%d %d 1", gid, gid) == -1)
	 		errExit("asprintf");
	 	update_map(map, map_path);
	 	free(map);
	 	free(map_path);
 	}
 	
 	// notify child that UID/GID mapping is complete
 	notify_other(parent_to_child_fds[1]);
 	close(parent_to_child_fds[1]);
 
	if (lockfd != -1)
		flock(lockfd, LOCK_UN);

	// handle CTRL-C in parent
	signal (SIGINT, my_handler);
	signal (SIGTERM, my_handler);
	
	// wait for the child to finish
	waitpid(child, NULL, 0);
	myexit(0);
	return 0;
}

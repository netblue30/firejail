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
#include "../include/seccomp.h"
#include <sys/mount.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <syscall.h>

#include <sched.h>
#ifndef CLONE_NEWUSER
#define CLONE_NEWUSER	0x10000000
#endif

#include <sys/prctl.h>
#ifndef PR_SET_NO_NEW_PRIVS
#define PR_SET_NO_NEW_PRIVS 38
#endif
#ifndef PR_GET_NO_NEW_PRIVS
#define PR_GET_NO_NEW_PRIVS 39
#endif

#ifdef HAVE_APPARMOR
#include <sys/apparmor.h>
#endif


static int force_nonewprivs = 0;

static int monitored_pid = 0;
static void sandbox_handler(int sig){
	usleep(10000); // don't race to print a message
	fmessage("\nChild received signal %d, shutting down the sandbox...\n", sig);

	// broadcast sigterm to all processes in the group
	kill(-1, SIGTERM);
	sleep(1);

	if (monitored_pid) {
		int monsec = 9;
		char *monfile;
		if (asprintf(&monfile, "/proc/%d/cmdline", monitored_pid) == -1)
			errExit("asprintf");
		while (monsec) {
			FILE *fp = fopen(monfile, "r");
			if (!fp)
				break;

			char c;
			size_t count = fread(&c, 1, 1, fp);
			fclose(fp);
			if (count == 0)
				break;

			if (arg_debug)
				printf("Waiting on PID %d to finish\n", monitored_pid);
			sleep(1);
			monsec--;
		}
		free(monfile);
	}

	// broadcast a SIGKILL
	kill(-1, SIGKILL);
	flush_stdin();

	exit(sig);
}

static void install_handler(void) {
	struct sigaction sga;

	// block SIGTERM while handling SIGINT
	sigemptyset(&sga.sa_mask);
	sigaddset(&sga.sa_mask, SIGTERM);
	sga.sa_handler = sandbox_handler;
	sga.sa_flags = 0;
	sigaction(SIGINT, &sga, NULL);

	// block SIGINT while handling SIGTERM
	sigemptyset(&sga.sa_mask);
	sigaddset(&sga.sa_mask, SIGINT);
	sga.sa_handler = sandbox_handler;
	sga.sa_flags = 0;
	sigaction(SIGTERM, &sga, NULL);
}

static void set_caps(void) {
	if (arg_caps_drop_all)
		caps_drop_all();
	else if (arg_caps_drop)
		caps_drop_list(arg_caps_list);
	else if (arg_caps_keep)
		caps_keep_list(arg_caps_list);
	else if (arg_caps_default_filter)
		caps_default_filter();

	// drop discretionary access control capabilities for root sandboxes
	// if caps.keep, the user has to set it manually in the list
	if (!arg_caps_keep)
		caps_drop_dac_override();
}

#ifdef HAVE_APPARMOR
void set_apparmor(void) {
	EUID_ASSERT();
	if (checkcfg(CFG_APPARMOR) && arg_apparmor) {
		if (aa_change_onexec("firejail-default")) {
			fwarning("Cannot confine the application using AppArmor.\n"
				"Maybe firejail-default AppArmor profile is not loaded into the kernel.\n"
				"As root, run \"aa-enforce firejail-default\" to load it.\n");
		}
		else if (arg_debug)
			printf("AppArmor enabled\n");
	}
}
#endif

static void save_nogroups(void) {
	if (arg_nogroups == 0)
		return;

	FILE *fp = fopen(RUN_GROUPS_CFG, "w");
	if (fp) {
		fprintf(fp, "\n");
		SET_PERMS_STREAM(fp, 0, 0, 0644); // assume mode 0644
		fclose(fp);
	}
	else {
		fprintf(stderr, "Error: cannot save nogroups state\n");
		exit(1);
	}
}

static void save_nonewprivs(void) {
	if (arg_nonewprivs == 0)
		return;

	FILE *fp = fopen(RUN_NONEWPRIVS_CFG, "wxe");
	if (fp) {
		fprintf(fp, "\n");
		SET_PERMS_STREAM(fp, 0, 0, 0644); // assume mode 0644
		fclose(fp);
	}
	else {
		fprintf(stderr, "Error: cannot save nonewprivs state\n");
		exit(1);
	}
}

static void save_umask(void) {
	FILE *fp = fopen(RUN_UMASK_FILE, "wxe");
	if (fp) {
		fprintf(fp, "%o\n", orig_umask);
		SET_PERMS_STREAM(fp, 0, 0, 0644); // assume mode 0644
		fclose(fp);
	}
	else {
		fprintf(stderr, "Error: cannot save umask\n");
		exit(1);
	}
}

static FILE *create_ready_for_join_file(void) {
	FILE *fp = fopen(RUN_READY_FOR_JOIN, "wxe");
	if (fp) {
		ASSERT_PERMS_STREAM(fp, 0, 0, 0644);
		return fp;
	}
	else {
		fprintf(stderr, "Error: cannot create %s\n", RUN_READY_FOR_JOIN);
		exit(1);
	}
}

#ifdef HAVE_SECCOMP
static void seccomp_debug(void) {
	if (arg_debug == 0)
		return;

	pid_t child = fork();
	if (child < 0)
		errExit("fork");
	if (child == 0) {
		// dropping privs before calling system(3)
		drop_privs(1);
		printf("Seccomp directory:\n");
		int rv = system("ls -l "  RUN_SECCOMP_DIR);
		(void) rv;
		printf("Active seccomp files:\n");
		rv = system("cat " RUN_SECCOMP_LIST);
		(void) rv;
#ifdef HAVE_GCOV
		__gcov_flush();
#endif
		_exit(0);
	}
	waitpid(child, NULL, 0);
}
#endif

static void sandbox_if_up(Bridge *br) {
	assert(br);
	if (!br->configured)
		return;

	char *dev = br->devsandbox;
	net_if_up(dev);

	if (br->arg_ip_none == 1);	// do nothing
	else if (br->arg_ip_none == 0 && br->macvlan == 0) {
		if (br->ipsandbox == br->ip) {
			fprintf(stderr, "Error: %d.%d.%d.%d is interface %s address.\n", PRINT_IP(br->ipsandbox), br->dev);
			exit(1);
		}

		// just assign the address
		assert(br->ipsandbox);
		if (arg_debug)
			printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(br->ipsandbox), dev);
		net_config_interface(dev, br->ipsandbox, br->mask, br->mtu);
		arp_announce(dev, br);
	}
	else if (br->arg_ip_none == 0 && br->macvlan == 1) {
		// reassign the macvlan address
		if (br->ipsandbox == 0)
			// ip address assigned by arp-scan for a macvlan device
			br->ipsandbox = arp_assign(dev, br); //br->ip, br->mask);
		else {
			if (br->ipsandbox == br->ip) {
				fprintf(stderr, "Error: %d.%d.%d.%d is interface %s address.\n", PRINT_IP(br->ipsandbox), br->dev);
				exit(1);
			}

			uint32_t rv = arp_check(dev, br->ipsandbox);
			if (rv) {
				fprintf(stderr, "Error: the address %d.%d.%d.%d is already in use.\n", PRINT_IP(br->ipsandbox));
				exit(1);
			}
		}

		if (arg_debug)
			printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(br->ipsandbox), dev);
		net_config_interface(dev, br->ipsandbox, br->mask, br->mtu);
		arp_announce(dev, br);
	}

	if (br->ip6sandbox)
		 net_if_ip6(dev, br->ip6sandbox);
}

static void chk_chroot(void) {
	// if we are starting firejail inside some other container technology, we don't care about this
	char *mycont = getenv("container");
	if (mycont)
		return;

	// check if this is a regular chroot
	struct stat s;
	if (stat("/", &s) == 0) {
		if (s.st_ino != 2)
			return;
	}

	fprintf(stderr, "Error: cannot mount filesystem as slave\n");
	exit(1);
}

static int monitor_application(pid_t app_pid) {
	EUID_ASSERT();
	monitored_pid = app_pid;

	// block signals and install handler
	sigset_t oldmask, newmask;
	sigemptyset(&oldmask);
	sigemptyset(&newmask);
	sigaddset(&newmask, SIGTERM);
	sigaddset(&newmask, SIGINT);
	sigprocmask(SIG_BLOCK, &newmask, &oldmask);
	install_handler();

	// handle --timeout
	int options = 0;;
	unsigned timeout = 0;
	if (cfg.timeout) {
		options = WNOHANG;
		timeout = cfg.timeout;
		sleep(1);
	}

	int status = 0;
	int app_status = 0;
	while (monitored_pid) {
		usleep(20000);
		char *msg;
		if (asprintf(&msg, "monitoring pid %d\n", monitored_pid) == -1)
			errExit("asprintf");
		logmsg(msg);
		if (arg_debug)
			printf("%s\n", msg);
		free(msg);

		pid_t rv;
		do {
			// handle signals asynchronously
			sigprocmask(SIG_SETMASK, &oldmask, NULL);

			rv = waitpid(-1, &status, options);

			// block signals again
			sigprocmask(SIG_BLOCK, &newmask, NULL);

			if (rv == -1) { // we can get here if we have processes joining the sandbox (ECHILD)
				sleep(1);
				break;
			}
			else if (rv == app_pid)
				app_status = status;

			// handle --timeout
			if (options) {
				if (--timeout == 0)  {
					// SIGTERM might fail if the process ignores it (SIG_IGN)
					// we give it 100ms to close properly and after that we SIGKILL it
					kill(-1, SIGTERM);
					usleep(100000);
					kill(-1, SIGKILL);
					flush_stdin();
					_exit(1);
				}
				else
					sleep(1);
			}
		}
		while(rv != monitored_pid);
		if (arg_debug)
			printf("Sandbox monitor: waitpid %d retval %d status %d\n", monitored_pid, rv, status);

		DIR *dir;
		if (!(dir = opendir("/proc"))) {
			// sleep 2 seconds and try again
			sleep(2);
			if (!(dir = opendir("/proc"))) {
				fprintf(stderr, "Error: cannot open /proc directory\n");
				exit(1);
			}
		}

		struct dirent *entry;
		monitored_pid = 0;
		while ((entry = readdir(dir)) != NULL) {
			unsigned pid;
			if (sscanf(entry->d_name, "%u", &pid) != 1)
				continue;
			if (pid == 1)
				continue;
			if ((pid_t) pid == dhclient4_pid || (pid_t) pid == dhclient6_pid)
				continue;

			// todo: make this generic
			// Dillo browser leaves a dpid process running, we need to shut it down
			int found = 0;
			if (strcmp(cfg.command_name, "dillo") == 0) {
				char *pidname = pid_proc_comm(pid);
				if (pidname && strcmp(pidname, "dpid") == 0)
					found = 1;
				free(pidname);
			}
			if (found)
				break;

			monitored_pid = pid;
			break;
		}
		closedir(dir);

		if (monitored_pid != 0 && arg_debug)
			printf("Sandbox monitor: monitoring %d\n", monitored_pid);
	}

	// return the appropriate exit status.
	return arg_deterministic_exit_code ? app_status : status;
}

static void print_time(void) {
	if (start_timestamp) {
		unsigned long long end_timestamp = getticks();
		// measure 1 ms
		usleep(1000);
		unsigned long long onems = getticks() - end_timestamp;
		if (onems) {
			fmessage("Child process initialized in %.02f ms\n",
				(float) (end_timestamp - start_timestamp) / (float) onems);
			return;
		}
	}

	fmessage("Child process initialized\n");
}


// check execute permissions for the program
// this is done typically by the shell
// we are here because of --shell=none
// we duplicate execvp functionality (man execvp):
//	[...] if  the  specified
//	filename  does  not contain a slash (/) character. The file is sought
//	in the colon-separated list of directory pathnames  specified  in  the
//	PATH  environment  variable.
static int ok_to_run(const char *program) {
	if (strstr(program, "/")) {
		if (access(program, X_OK) == 0) // it will also dereference symlinks
			return 1;
	}
	else { // search $PATH
		char *path1 = getenv("PATH");
		if (path1) {
			if (arg_debug)
				printf("Searching $PATH for %s\n", program);
			char *path2 = strdup(path1);
			if (!path2)
				errExit("strdup");

			// use path2 to count the entries
			char *ptr = strtok(path2, ":");
			while (ptr) {
				char *fname;

				if (asprintf(&fname, "%s/%s", ptr, program) == -1)
					errExit("asprintf");
				if (arg_debug)
					printf("trying #%s#\n", fname);

				struct stat s;
				int rv = stat(fname, &s);
				if (rv == 0) {
					if (access(fname, X_OK) == 0) {
						free(path2);
						free(fname);
						return 1;
					}
					else
						fprintf(stderr, "Error: execute permission denied for %s\n", fname);

					free(fname);
					break;
				}

				free(fname);
				ptr = strtok(NULL, ":");
			}
			free(path2);
		}
	}
	return 0;
}

void start_application(int no_sandbox, FILE *fp) {
	// set environment
	if (no_sandbox == 0) {
		env_defaults();
		env_apply();
	}
	// restore original umask
	umask(orig_umask);

	if (arg_debug) {
		printf("starting application\n");
		printf("LD_PRELOAD=%s\n", getenv("LD_PRELOAD"));
	}

	//****************************************
	// audit
	//****************************************
	if (arg_audit) {
		assert(arg_audit_prog);

		if (fp) {
			fprintf(fp, "ready\n");
			fclose(fp);
		}
#ifdef HAVE_GCOV
		__gcov_dump();
#endif
#ifdef HAVE_SECCOMP
		seccomp_install_filters();
#endif
		execl(arg_audit_prog, arg_audit_prog, NULL);

		perror("execl");
		exit(1);
	}
	//****************************************
	// start the program without using a shell
	//****************************************
	else if (arg_shell_none) {
		if (arg_debug) {
			int i;
			for (i = cfg.original_program_index; i < cfg.original_argc; i++) {
				if (cfg.original_argv[i] == NULL)
					break;
				printf("execvp argument %d: %s\n", i - cfg.original_program_index, cfg.original_argv[i]);
			}
		}

		if (cfg.original_program_index == 0) {
			fprintf(stderr, "Error: --shell=none configured, but no program specified\n");
			exit(1);
		}

		if (!arg_command && !arg_quiet)
			print_time();

		int rv = ok_to_run(cfg.original_argv[cfg.original_program_index]);

		if (fp) {
			fprintf(fp, "ready\n");
			fclose(fp);
		}
#ifdef HAVE_GCOV
		__gcov_dump();
#endif
#ifdef HAVE_SECCOMP
		seccomp_install_filters();
#endif
		if (rv)
			execvp(cfg.original_argv[cfg.original_program_index], &cfg.original_argv[cfg.original_program_index]);
		else
			fprintf(stderr, "Error: no suitable %s executable found\n", cfg.original_argv[cfg.original_program_index]);
		exit(1);
	}
	//****************************************
	// start the program using a shell
	//****************************************
	else {
		assert(cfg.shell);
		assert(cfg.command_line);

		char *arg[5];
		int index = 0;
		arg[index++] = cfg.shell;
		if (login_shell) {
			arg[index++] = "-l";
			if (arg_debug)
				printf("Starting %s login shell\n", cfg.shell);
		} else {
			arg[index++] = "-c";
			if (arg_debug)
				printf("Running %s command through %s\n", cfg.command_line, cfg.shell);
			if (arg_doubledash)
				arg[index++] = "--";
			arg[index++] = cfg.command_line;
		}
		arg[index] = NULL;
		assert(index < 5);

		if (arg_debug) {
			char *msg;
			if (asprintf(&msg, "sandbox %d, execvp into %s", sandbox_pid, cfg.command_line) == -1)
				errExit("asprintf");
			logmsg(msg);
			free(msg);
		}

		if (arg_debug) {
			int i;
			for (i = 0; i < 5; i++) {
				if (arg[i] == NULL)
					break;
				printf("execvp argument %d: %s\n", i, arg[i]);
			}
		}

		if (!arg_command && !arg_quiet)
			print_time();

		if (fp) {
			fprintf(fp, "ready\n");
			fclose(fp);
		}
#ifdef HAVE_GCOV
		__gcov_dump();
#endif
#ifdef HAVE_SECCOMP
		seccomp_install_filters();
#endif
		execvp(arg[0], arg);
	}

	perror("execvp");
	exit(1); // it should never get here!!!
}

static void enforce_filters(void) {
	// enforce NO_NEW_PRIVS
	arg_nonewprivs = 1;
	force_nonewprivs = 1;

	// disable all capabilities
	fmessage("\n**     Warning: dropping all Linux capabilities     **\n\n");
	arg_caps_drop_all = 1;

	// drop all supplementary groups; /etc/group file inside chroot
	// is controlled by a regular usr
	arg_nogroups = 1;
}

int sandbox(void* sandbox_arg) {
	// Get rid of unused parameter warning
	(void)sandbox_arg;

	pid_t child_pid = getpid();
	if (arg_debug)
		printf("Initializing child process\n");

 	// close each end of the unused pipes
 	close(parent_to_child_fds[1]);
 	close(child_to_parent_fds[0]);

 	// wait for parent to do base setup
 	wait_for_other(parent_to_child_fds[0]);

	if (arg_debug && child_pid == 1)
		printf("PID namespace installed\n");


	//****************************
	// set hostname
	//****************************
	if (cfg.hostname) {
		if (sethostname(cfg.hostname, strlen(cfg.hostname)) < 0)
			errExit("sethostname");
	}

	//****************************
	// mount namespace
	//****************************
	// mount events are not forwarded between the host the sandbox
	if (mount(NULL, "/", NULL, MS_SLAVE | MS_REC, NULL) < 0) {
		chk_chroot();
	}
	// ... and mount a tmpfs on top of /run/firejail/mnt directory
	preproc_mount_mnt_dir();
	// bind-mount firejail binaries and helper programs
	if (mount(LIBDIR "/firejail", RUN_FIREJAIL_LIB_DIR, NULL, MS_BIND, NULL) < 0 ||
	    mount(NULL, RUN_FIREJAIL_LIB_DIR, NULL, MS_RDONLY|MS_NOSUID|MS_NODEV|MS_BIND|MS_REMOUNT, NULL) < 0)
		errExit("mounting " RUN_FIREJAIL_LIB_DIR);

	//****************************
	// log sandbox data
	//****************************
	if (cfg.name)
		fs_logger2("sandbox name:", cfg.name);
	fs_logger2int("sandbox pid:", (int) sandbox_pid);
	if (cfg.chrootdir)
		fs_logger("sandbox filesystem: chroot");
	else if (arg_overlay)
		fs_logger("sandbox filesystem: overlay");
	else
		fs_logger("sandbox filesystem: local");
	fs_logger("install mount namespace");

	//****************************
	// netfilter
	//****************************
	if (arg_netfilter && any_bridge_configured()) { // assuming by default the client filter
		netfilter(arg_netfilter_file);
	}
	if (arg_netfilter6 && any_bridge_configured()) { // assuming by default the client filter
		netfilter6(arg_netfilter6_file);
	}

	//****************************
	// networking
	//****************************
	int gw_cfg_failed = 0; // default gw configuration flag
	if (arg_nonetwork) {
		net_if_up("lo");
		if (arg_debug)
			printf("Network namespace enabled, only loopback interface available\n");
	}
	else if (arg_netns) {
		netns(arg_netns);
		if (arg_debug)
			printf("Network namespace '%s' activated\n", arg_netns);
	}
	else if (any_bridge_configured() || any_interface_configured()) {
		// configure lo and eth0...eth3
		net_if_up("lo");

		if (mac_not_zero(cfg.bridge0.macsandbox))
			net_config_mac(cfg.bridge0.devsandbox, cfg.bridge0.macsandbox);
		sandbox_if_up(&cfg.bridge0);

		if (mac_not_zero(cfg.bridge1.macsandbox))
			net_config_mac(cfg.bridge1.devsandbox, cfg.bridge1.macsandbox);
		sandbox_if_up(&cfg.bridge1);

		if (mac_not_zero(cfg.bridge2.macsandbox))
			net_config_mac(cfg.bridge2.devsandbox, cfg.bridge2.macsandbox);
		sandbox_if_up(&cfg.bridge2);

		if (mac_not_zero(cfg.bridge3.macsandbox))
			net_config_mac(cfg.bridge3.devsandbox, cfg.bridge3.macsandbox);
		sandbox_if_up(&cfg.bridge3);


		// moving an interface in a namespace using --interface will reset the interface configuration;
		// we need to put the configuration back
		if (cfg.interface0.configured && cfg.interface0.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface0.ip), cfg.interface0.dev);
			net_config_interface(cfg.interface0.dev, cfg.interface0.ip, cfg.interface0.mask, cfg.interface0.mtu);
		}
		if (cfg.interface1.configured && cfg.interface1.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface1.ip), cfg.interface1.dev);
			net_config_interface(cfg.interface1.dev, cfg.interface1.ip, cfg.interface1.mask, cfg.interface1.mtu);
		}
		if (cfg.interface2.configured && cfg.interface2.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface2.ip), cfg.interface2.dev);
			net_config_interface(cfg.interface2.dev, cfg.interface2.ip, cfg.interface2.mask, cfg.interface2.mtu);
		}
		if (cfg.interface3.configured && cfg.interface3.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface3.ip), cfg.interface3.dev);
			net_config_interface(cfg.interface3.dev, cfg.interface3.ip, cfg.interface3.mask, cfg.interface3.mtu);
		}

		// add a default route
		if (cfg.defaultgw) {
			// set the default route
			if (net_add_route(0, 0, cfg.defaultgw)) {
				fwarning("cannot configure default route\n");
				gw_cfg_failed = 1;
			}
		}

		if (arg_debug)
			printf("Network namespace enabled\n");
	}

	// print network configuration
	if (!arg_quiet) {
		if (any_bridge_configured() || any_interface_configured() || cfg.defaultgw || cfg.dns1) {
			fmessage("\n");
			if (any_bridge_configured() || any_interface_configured()) {
				if (arg_scan)
					sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 3, PATH_FNET, "printif", "scan");
				else
					sbox_run(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, 2, PATH_FNET, "printif");

			}
			if (cfg.defaultgw != 0) {
				if (gw_cfg_failed)
					fmessage("Default gateway configuration failed\n");
				else
					fmessage("Default gateway %d.%d.%d.%d\n", PRINT_IP(cfg.defaultgw));
			}
			if (cfg.dns1 != NULL)
				fmessage("DNS server %s\n", cfg.dns1);
			if (cfg.dns2 != NULL)
				fmessage("DNS server %s\n", cfg.dns2);
			if (cfg.dns3 != NULL)
				fmessage("DNS server %s\n", cfg.dns3);
			if (cfg.dns4 != NULL)
				fmessage("DNS server %s\n", cfg.dns4);
			fmessage("\n");
		}
	}

	// load IBUS env variables
	if (arg_nonetwork || any_bridge_configured() || any_interface_configured()) {
		// do nothing - there are problems with ibus version 1.5.11
	}
	else {
		EUID_USER();
		env_ibus_load();
		EUID_ROOT();
	}

	//****************************
	// fs pre-processing:
	//  - build seccomp filters
	//  - create an empty /etc/ld.so.preload
	//****************************
#ifdef HAVE_SECCOMP
	if (cfg.protocol) {
		if (arg_debug)
			printf("Build protocol filter: %s\n", cfg.protocol);

		// build the seccomp filter as a regular user
		int rv = sbox_run(SBOX_USER | SBOX_CAPS_NONE | SBOX_SECCOMP, 5,
			PATH_FSECCOMP, "protocol", "build", cfg.protocol, RUN_SECCOMP_PROTOCOL);
		if (rv)
			exit(rv);
	}
#endif

	// need ld.so.preload if tracing or seccomp with any non-default lists
	bool need_preload = arg_trace || arg_tracelog || arg_seccomp_postexec;
	// for --appimage, --chroot and --overlay* we force NO_NEW_PRIVS
	// and drop all capabilities
	if (getuid() != 0 && (arg_appimage || cfg.chrootdir || arg_overlay)) {
		enforce_filters();
		need_preload = arg_trace || arg_tracelog;
	}

	// trace pre-install
	if (need_preload)
		fs_trace_preload();

	// store hosts file
	if (cfg.hosts_file)
		fs_store_hosts_file();

	//****************************
	// configure filesystem
	//****************************
#ifdef HAVE_CHROOT
	if (cfg.chrootdir) {
		fs_chroot(cfg.chrootdir);

		//****************************
		// trace pre-install, this time inside chroot
		//****************************
		if (need_preload)
			fs_trace_preload();
	}
	else
#endif
#ifdef HAVE_OVERLAYFS
	if (arg_overlay)
		fs_overlayfs();
	else
#endif
		fs_basic_fs();

	//****************************
	// private mode
	//****************************
	if (arg_private) {
		if (cfg.home_private) {	// --private=
			if (cfg.chrootdir)
				fwarning("private=directory feature is disabled in chroot\n");
			else if (arg_overlay)
				fwarning("private=directory feature is disabled in overlay\n");
			else
				fs_private_homedir();
		}
		else if (cfg.home_private_keep) { // --private-home=
			if (cfg.chrootdir)
				fwarning("private-home= feature is disabled in chroot\n");
			else if (arg_overlay)
				fwarning("private-home= feature is disabled in overlay\n");
			else
				fs_private_home_list();
		}
		else // --private
			fs_private();
	}

	if (arg_private_dev)
		fs_private_dev();

	if (arg_private_opt) {
		if (cfg.chrootdir)
			fwarning("private-opt feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-opt feature is disabled in overlay\n");
		else {
			fs_private_dir_list("/opt", RUN_OPT_DIR, cfg.opt_private_keep);
		}
	}

	if (arg_private_srv) {
		if (cfg.chrootdir)
			fwarning("private-srv feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-srv feature is disabled in overlay\n");
		else {
			fs_private_dir_list("/srv", RUN_SRV_DIR, cfg.srv_private_keep);
		}
	}

	// private-bin is disabled for appimages
	if (arg_private_bin && !arg_appimage) {
		if (cfg.chrootdir)
			fwarning("private-bin feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-bin feature is disabled in overlay\n");
		else {
			// for --x11=xorg we need to add xauth command
			if (arg_x11_xorg) {
				EUID_USER();
				char *tmp;
				if (asprintf(&tmp, "%s,xauth", cfg.bin_private_keep) == -1)
					errExit("asprintf");
				cfg.bin_private_keep = tmp;
				EUID_ROOT();
			}
			fs_private_bin_list();
		}
	}

	// private-lib is disabled for appimages
	if (arg_private_lib && !arg_appimage) {
		if (cfg.chrootdir)
			fwarning("private-lib feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-lib feature is disabled in overlay\n");
		else {
			fs_private_lib();
		}
	}

	if (arg_private_cache) {
		if (cfg.chrootdir)
			fwarning("private-cache feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-cache feature is disabled in overlay\n");
		else
			fs_private_cache();
	}

	if (arg_private_tmp) {
		// private-tmp is implemented as a whitelist
		EUID_USER();
		fs_private_tmp();
		EUID_ROOT();
	}

	//****************************
	// Session D-BUS
	//****************************
	dbus_apply_policy();


	//****************************
	// hosts and hostname
	//****************************
	if (cfg.hostname)
		fs_hostname(cfg.hostname);

	if (cfg.hosts_file)
		fs_mount_hosts_file();

	//****************************
	// /etc overrides from the network namespace
	//****************************
	if (arg_netns)
		netns_mounts(arg_netns);

	//****************************
	// update /proc, /sys, /dev, /boot directory
	//****************************
	fs_proc_sys_dev_boot();

	//****************************
	// handle /mnt and /media
	//****************************
	if (checkcfg(CFG_DISABLE_MNT))
		fs_mnt(1);
	else if (arg_disable_mnt)
		fs_mnt(0);

	// Install new /etc last, so we can use it as long as possible
	if (arg_private_etc) {
		if (cfg.chrootdir)
			fwarning("private-etc feature is disabled in chroot\n");
		else if (arg_overlay)
			fwarning("private-etc feature is disabled in overlay\n");
		else {
			fs_private_dir_list("/etc", RUN_ETC_DIR, cfg.etc_private_keep);
			fs_private_dir_list("/usr/etc", RUN_USR_ETC_DIR, cfg.etc_private_keep); // openSUSE
			// create /etc/ld.so.preload file again
			if (need_preload)
				fs_trace_preload();
		}
	}

	//****************************
	// apply the profile file
	//****************************
	// apply all whitelist commands ...
	fs_whitelist();

	// ... followed by blacklist commands
	fs_blacklist(); // mkdir and mkfile are processed all over again

	//****************************
	// nosound/no3d/notv/novideo and fix for pulseaudio 7.0
	//****************************
	if (arg_nosound) {
		// disable pulseaudio
		pulseaudio_disable();

		// disable /dev/snd
		fs_dev_disable_sound();
	}
	else if (!arg_noautopulse)
		pulseaudio_init();

	if (arg_no3d)
		fs_dev_disable_3d();

	if (arg_notv)
		fs_dev_disable_tv();

	if (arg_nodvd)
		fs_dev_disable_dvd();

	if (arg_nou2f)
		fs_dev_disable_u2f();

	if (arg_novideo)
		fs_dev_disable_video();

	//****************************
	// install trace
	//****************************
	if (need_preload)
		fs_trace();

	//****************************
	// set dns
	//****************************
	fs_resolvconf();

	//****************************
	// fs post-processing
	//****************************
	fs_logger_print();
	fs_logger_change_owner();

	//****************************
	// start dhcp client
	//****************************
	dhcp_start();

	//****************************
	// set application environment
	//****************************
	EUID_USER();
	int cwd = 0;
	if (cfg.cwd) {
		if (chdir(cfg.cwd) == 0)
			cwd = 1;
		else if (arg_private_cwd) {
			fprintf(stderr, "Error: unable to enter private working directory: %s: %s\n", cfg.cwd, strerror(errno));
			exit(1);
		}
	}

	if (!cwd) {
		if (chdir("/") < 0)
			errExit("chdir");
		if (cfg.homedir) {
			struct stat s;
			if (stat(cfg.homedir, &s) == 0) {
				/* coverity[toctou] */
				if (chdir(cfg.homedir) < 0)
					errExit("chdir");
			}
		}
	}
	if (arg_debug) {
		char *cpath = get_current_dir_name();
		if (cpath) {
			printf("Current directory: %s\n", cpath);
			free(cpath);
		}
	}

	EUID_ROOT();
	// clean /tmp/.X11-unix sockets
	fs_x11();
	if (arg_x11_xorg)
		x11_xorg();

	// save original umask
	save_umask();

	//****************************
	// set security filters
	//****************************
	// save state of nonewprivs
	save_nonewprivs();

	// save cpu affinity mask to CPU_CFG file
	save_cpu();

	// save cgroup in CGROUP_CFG file
	save_cgroup();

	// set seccomp
#ifdef HAVE_SECCOMP
	// install protocol filter
#ifdef SYS_socket
	if (cfg.protocol) {
		if (arg_debug)
			printf("Install protocol filter: %s\n", cfg.protocol);
		seccomp_load(RUN_SECCOMP_PROTOCOL);	// install filter
		protocol_filter_save();	// save filter in RUN_PROTOCOL_CFG
	}
	else {
		int rv = unlink(RUN_SECCOMP_PROTOCOL);
		(void) rv;
	}
#endif

	// if a keep list is available, disregard the drop list
	if (arg_seccomp == 1) {
		if (cfg.seccomp_list_keep)
			seccomp_filter_keep(true);
		else
			seccomp_filter_drop(true);
	}
	if (arg_seccomp32 == 1) {
		if (cfg.seccomp_list_keep32)
			seccomp_filter_keep(false);
		else
			seccomp_filter_drop(false);

	}

	if (arg_memory_deny_write_execute) {
		if (arg_seccomp_error_action != EPERM) {
			seccomp_filter_mdwx(true);
			seccomp_filter_mdwx(false);
		}
		if (arg_debug)
			printf("Install memory write&execute filter\n");
		seccomp_load(RUN_SECCOMP_MDWX);	// install filter
		seccomp_load(RUN_SECCOMP_MDWX_32);
	}

	// make seccomp filters read-only
	fs_remount(RUN_SECCOMP_DIR, MOUNT_READONLY, 0);
	seccomp_debug();
#endif

	// set capabilities
	set_caps();

	//****************************************
	// communicate progress of sandbox set up
	// to --join
	//****************************************

	FILE *rj = create_ready_for_join_file();

	//****************************************
	// create a new user namespace
	//     - too early to drop privileges
	//****************************************
	save_nogroups();
	if (arg_noroot) {
		int rv = unshare(CLONE_NEWUSER);
		if (rv == -1) {
			fwarning("cannot create a new user namespace, going forward without it...\n");
			arg_noroot = 0;
		}
	}

	// notify parent that new user namespace has been created so a proper
 	// UID/GID map can be setup
 	notify_other(child_to_parent_fds[1]);
 	close(child_to_parent_fds[1]);

 	// wait for parent to finish setting up a proper UID/GID map
 	wait_for_other(parent_to_child_fds[0]);
 	close(parent_to_child_fds[0]);

	// somehow, the new user namespace resets capabilities;
	// we need to do them again
	if (arg_noroot) {
		if (arg_debug)
			printf("noroot user namespace installed\n");
		set_caps();
	}

	//****************************************
	// Set NO_NEW_PRIVS if desired
	//****************************************
	if (arg_nonewprivs) {
		prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);

		if (prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0) != 1) {
			fwarning("cannot set NO_NEW_PRIVS, it requires a Linux kernel version 3.5 or newer.\n");
			if (force_nonewprivs) {
				fprintf(stderr, "Error: NO_NEW_PRIVS required for this sandbox, exiting ...\n");
				exit(1);
			}
		}
		else if (arg_debug)
			printf("NO_NEW_PRIVS set\n");
	}

	//****************************************
	// drop privileges
	//****************************************
	drop_privs(arg_nogroups);

	// kill the sandbox in case the parent died
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);

	//****************************************
	// set cpu affinity
	//****************************************

	if (cfg.cpus)
		set_cpu_affinity();

	//****************************************
	// fork the application and monitor it
	//****************************************
	pid_t app_pid = fork();
	if (app_pid == -1)
		errExit("fork");

	if (app_pid == 0) {
#ifdef HAVE_APPARMOR
		// add apparmor confinement after the execve
		set_apparmor();
#endif

		// set nice and rlimits
		if (arg_nice)
			set_nice(cfg.nice);
		set_rlimits();

		start_application(0, rj);
	}

	fclose(rj);

	int status = monitor_application(app_pid);	// monitor application
	flush_stdin();

	if (WIFEXITED(status)) {
		// if we had a proper exit, return that exit status
		return WEXITSTATUS(status);
	} else {
		// something else went wrong!
		return -1;
	}
}

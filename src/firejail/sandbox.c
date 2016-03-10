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
#include <sys/mount.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/prctl.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <sys/types.h>
#include <dirent.h>
#include <errno.h>

#include <sched.h>
#ifndef CLONE_NEWUSER
#define CLONE_NEWUSER	0x10000000
#endif

static void set_caps(void) {
	if (arg_caps_drop_all)
		caps_drop_all();
	else if (arg_caps_drop)
		caps_drop_list(arg_caps_list);
	else if (arg_caps_keep)
		caps_keep_list(arg_caps_list);
	else if (arg_caps_default_filter)
		caps_default_filter();
}

void save_nogroups(void) {
	if (arg_nogroups == 0)
		return;

	FILE *fp = fopen(RUN_GROUPS_CFG, "w");
	if (fp) {
		fprintf(fp, "\n");
		fclose(fp);
		if (chown(RUN_GROUPS_CFG, 0, 0) < 0)
			errExit("chown");
	}
	else {
		fprintf(stderr, "Error: cannot save nogroups state\n");
		exit(1);
	}
	
}

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
		net_if_ip(dev, br->ipsandbox, br->mask, br->mtu);
		net_if_up(dev);
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
			
			uint32_t rv = arp_check(dev, br->ipsandbox, br->ip);
			if (rv) {
				fprintf(stderr, "Error: the address %d.%d.%d.%d is already in use.\n", PRINT_IP(br->ipsandbox));
				exit(1);
			}
		}
			
		if (arg_debug)
			printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(br->ipsandbox), dev);
		net_if_ip(dev, br->ipsandbox, br->mask, br->mtu);
		net_if_up(dev);
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
	int status;
	while (app_pid) {
		usleep(20000);

		pid_t rv;
		do {
			rv = waitpid(-1, &status, 0);
			if (rv == -1)
				break;
		}
		while(rv != app_pid);
		if (arg_debug)
			printf("Sandbox monitor: waitpid %u retval %d status %d\n", app_pid, rv, status);

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
		app_pid = 0;
		while ((entry = readdir(dir)) != NULL) {
			unsigned pid;
			if (sscanf(entry->d_name, "%u", &pid) != 1)
				continue;
			if (pid == 1)
				continue;
			app_pid = pid;
			break;
		}
		closedir(dir);

		if (app_pid != 0 && arg_debug)
			printf("Sandbox monitor: monitoring %u\n", app_pid);
	}

	// return the latest exit status.
	return status;

#if 0
// todo: find a way to shut down interfaces before closing the namespace
// the problem is we don't have enough privileges to shutdown interfaces in this moment
	// shut down bridge/macvlan interfaces
	if (any_bridge_configured()) {
		
		if (cfg.bridge0.configured) {
			printf("Shutting down %s\n", cfg.bridge0.devsandbox);
			net_if_down( cfg.bridge0.devsandbox);
		}
		if (cfg.bridge1.configured) {
			printf("Shutting down %s\n", cfg.bridge1.devsandbox);
			net_if_down( cfg.bridge1.devsandbox);
		}
		if (cfg.bridge2.configured) {
			printf("Shutting down %s\n", cfg.bridge2.devsandbox);
			net_if_down( cfg.bridge2.devsandbox);
		}
		if (cfg.bridge3.configured) {
			printf("Shutting down %s\n", cfg.bridge3.devsandbox);
			net_if_down( cfg.bridge3.devsandbox);
		}
		usleep(20000);	// 20 ms sleep
	}	
#endif	
}


static void start_application(void) {
	//****************************************
	// start the program without using a shell
	//****************************************
	if (arg_shell_none) {
		if (arg_debug) {
			int i;
			for (i = cfg.original_program_index; i < cfg.original_argc; i++) {
				if (cfg.original_argv[i] == NULL)
					break;
				printf("execvp argument %d: %s\n", i - cfg.original_program_index, cfg.original_argv[i]);
			}
		}

		if (!arg_command && !arg_quiet)
			printf("Child process initialized\n");
		execvp(cfg.original_argv[cfg.original_program_index], &cfg.original_argv[cfg.original_program_index]);
	}
	//****************************************
	// start the program using a shell
	//****************************************
	else {
		// choose the shell requested by the user, or use bash as default
		char *sh;
		if (cfg.shell)
	 		sh = cfg.shell;
		else if (arg_zsh)
			sh = "/usr/bin/zsh";
		else if (arg_csh)
			sh = "/bin/csh";
		else
			sh = "/bin/bash";
			
		char *arg[5];
		int index = 0;
		arg[index++] = sh;
		arg[index++] = "-c";
		assert(cfg.command_line);
		if (arg_debug)
			printf("Starting %s\n", cfg.command_line);
		if (arg_doubledash) 
			arg[index++] = "--";
		arg[index++] = cfg.command_line;
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
			printf("Child process initialized\n");
		execvp(sh, arg);
	}
	
	perror("execvp");
	exit(1); // it should never get here!!!
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
	// netfilter etc.
	//****************************
	if (arg_netfilter && any_bridge_configured()) { // assuming by default the client filter
		netfilter(arg_netfilter_file);
	}
	if (arg_netfilter6 && any_bridge_configured()) { // assuming by default the client filter
		netfilter6(arg_netfilter6_file);
	}

	// load IBUS env variables
	if (arg_nonetwork || any_bridge_configured() || any_interface_configured()) {
		// do nothing - there are problems with ibus version 1.5.11
	}
	else
		env_ibus_load();
	
	// grab a copy of cp command
	fs_build_cp_command();
	
	// trace pre-install
	if (arg_trace || arg_tracelog)
		fs_trace_preload();

	//****************************
	// configure filesystem
	//****************************
#ifdef HAVE_SECCOMP
	int enforce_seccomp = 0;
#endif
#ifdef HAVE_CHROOT		
	if (cfg.chrootdir) {
		fs_chroot(cfg.chrootdir);
		// redo cp command
		fs_build_cp_command();
		
		// force caps and seccomp if not started as root
		if (getuid() != 0) {
			// force default seccomp inside the chroot, no keep or drop list
			// the list build on top of the default drop list is kept intact
			arg_seccomp = 1;
#ifdef HAVE_SECCOMP
			enforce_seccomp = 1;
#endif
			if (cfg.seccomp_list_drop) {
				free(cfg.seccomp_list_drop);
				cfg.seccomp_list_drop = NULL;
			}
			if (cfg.seccomp_list_keep) {
				free(cfg.seccomp_list_keep);
				cfg.seccomp_list_keep = NULL;
			}
			
			// disable all capabilities
			if (arg_caps_default_filter || arg_caps_list)
				fprintf(stderr, "Warning: all capabilities disabled for a regular user during chroot\n");
			arg_caps_drop_all = 1;
			
			// drop all supplementary groups; /etc/group file inside chroot
			// is controlled by a regular usr
			arg_nogroups = 1;
			if (!arg_quiet)
				printf("Dropping all Linux capabilities and enforcing default seccomp filter\n");
		}
		else
			arg_seccomp = 1;
						
		//****************************
		// trace pre-install, this time inside chroot
		//****************************
		if (arg_trace || arg_tracelog)
			fs_trace_preload();
	}
	else 
#endif		
	if (arg_overlay)	
		fs_overlayfs();
	else
		fs_basic_fs();
	

	//****************************
	// set hostname in /etc/hostname
	//****************************
	if (cfg.hostname) {
		fs_hostname(cfg.hostname);
	}
	
	//****************************
	// private mode
	//****************************
	if (arg_private) {
		if (cfg.home_private)	// --private=
			fs_private_homedir();
		else // --private
			fs_private();
	}
	
	if (arg_private_dev)
		fs_private_dev();
	if (arg_private_etc) {
		fs_private_etc_list();
		// create /etc/ld.so.preload file again
		if (arg_trace || arg_tracelog)
			fs_trace_preload();
	}
	if (arg_private_bin)
		fs_private_bin_list();
	if (arg_private_tmp)
		fs_private_tmp();
	
	//****************************
	// apply the profile file
	//****************************
	if (cfg.profile) {
		// apply all whitelist commands ... 
		fs_whitelist();
		
		// ... followed by blacklist commands
		fs_blacklist();
	}
	
	//****************************
	// install trace
	//****************************
	if (arg_trace || arg_tracelog)
		fs_trace();
		
	//****************************
	// update /proc, /dev, /boot directorymy
	//****************************
	fs_proc_sys_dev_boot();
	
	//****************************
	// --nosound and fix for pulseaudio 7.0
	//****************************
	if (arg_nosound)
		pulseaudio_disable();
	else
		pulseaudio_init();
	
	//****************************
	// networking
	//****************************
	if (arg_nonetwork) {
		net_if_up("lo");
		if (arg_debug)
			printf("Network namespace enabled, only loopback interface available\n");
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
		
		// add a default route
		if (cfg.defaultgw) {
			// set the default route
			if (net_add_route(0, 0, cfg.defaultgw))
				fprintf(stderr, "Warning: cannot configure default route\n");
		}
		
		// enable interfaces
		if (cfg.interface0.configured && cfg.interface0.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface0.ip), cfg.interface0.dev);
			net_if_ip(cfg.interface0.dev, cfg.interface0.ip, cfg.interface0.mask, cfg.interface0.mtu);
			net_if_up(cfg.interface0.dev);
		}			
		if (cfg.interface1.configured && cfg.interface1.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface1.ip), cfg.interface1.dev);
			net_if_ip(cfg.interface1.dev, cfg.interface1.ip, cfg.interface1.mask, cfg.interface1.mtu);
			net_if_up(cfg.interface1.dev);
		}			
		if (cfg.interface2.configured && cfg.interface2.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface2.ip), cfg.interface2.dev);
			net_if_ip(cfg.interface2.dev, cfg.interface2.ip, cfg.interface2.mask, cfg.interface2.mtu);
			net_if_up(cfg.interface2.dev);
		}			
		if (cfg.interface3.configured && cfg.interface3.ip) {
			if (arg_debug)
				printf("Configuring %d.%d.%d.%d address on interface %s\n", PRINT_IP(cfg.interface3.ip), cfg.interface3.dev);
			net_if_ip(cfg.interface3.dev, cfg.interface3.ip, cfg.interface3.mask, cfg.interface3.mtu);
			net_if_up(cfg.interface3.dev);
		}			
			
		if (arg_debug)
			printf("Network namespace enabled\n");
	}
	
	// if any dns server is configured, it is time to set it now
	fs_resolvconf();
	fs_logger_print();
	fs_logger_change_owner();

	// print network configuration
	if (!arg_quiet) {
		if (any_bridge_configured() || any_interface_configured() || cfg.defaultgw || cfg.dns1) {
			printf("\n");
			if (any_bridge_configured() || any_interface_configured())
				net_ifprint();
			if (cfg.defaultgw != 0)
				printf("Default gateway %d.%d.%d.%d\n", PRINT_IP(cfg.defaultgw));
			if (cfg.dns1 != 0)
				printf("DNS server %d.%d.%d.%d\n", PRINT_IP(cfg.dns1));
			if (cfg.dns2 != 0)
				printf("DNS server %d.%d.%d.%d\n", PRINT_IP(cfg.dns2));
			if (cfg.dns3 != 0)
				printf("DNS server %d.%d.%d.%d\n", PRINT_IP(cfg.dns3));
			printf("\n");
		}
	}
	
	fs_delete_cp_command();

	//****************************
	// set application environment
	//****************************
	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0); // kill the child in case the parent died
	int cwd = 0;
	if (cfg.cwd) {
		if (chdir(cfg.cwd) == 0)
			cwd = 1;
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
	
	// set environment
	env_defaults();
	
	// set user-supplied environment variables
	env_apply();

	// set nice
	if (arg_nice) {
		errno = 0;
		int rv = nice(cfg.nice);
		(void) rv;
		if (errno) {
			fprintf(stderr, "Warning: cannot set nice value\n");
			errno = 0;
		}
	}
	
	// clean /tmp/.X11-unix sockets
	fs_x11();
	
	//****************************
	// set security filters
	//****************************
	// set capabilities
	if (!arg_noroot)
		set_caps();

	// set rlimits
	set_rlimits();

	// set seccomp
#ifdef HAVE_SECCOMP
	// install protocol filter
	if (cfg.protocol) {
		protocol_filter();	// install filter	
		protocol_filter_save();	// save filter in PROTOCOL_CFG
	}

	// if a keep list is available, disregard the drop list
	if (arg_seccomp == 1) {
		if (cfg.seccomp_list_keep)
			seccomp_filter_keep();
		else if (cfg.seccomp_list_errno)
			seccomp_filter_errno(); 
		else
			seccomp_filter_drop(enforce_seccomp);
	}
#endif

	// set cpu affinity
	if (cfg.cpus) {
		save_cpu(); // save cpu affinity mask to CPU_CFG file
		set_cpu_affinity();
	}
	
	// save cgroup in CGROUP_CFG file
	if (cfg.cgroup)
		save_cgroup();

	//****************************************
	// drop privileges or create a new user namespace
	//****************************************
	save_nogroups();
	if (arg_noroot) {
		int rv = unshare(CLONE_NEWUSER);
		if (rv == -1) {
			fprintf(stderr, "Error: cannot mount a new user namespace\n");
			perror("unshare");
			drop_privs(arg_nogroups);
		}
	}
	else
		drop_privs(arg_nogroups);
 	
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
		set_caps();
		if (arg_debug)
			printf("noroot user namespace installed\n");
	}


	//****************************************
	// fork the application and monitor it
	//****************************************
	pid_t app_pid = fork();
	if (app_pid == -1)
		errExit("fork");
		
	if (app_pid == 0) {
		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0); // kill the child in case the parent died
		start_application();	// start app
	}

	int status = monitor_application(app_pid);	// monitor application

	if WIFEXITED(status) {
		// if we had a proper exit, return that exit status
		return WEXITSTATUS(status);
	} else {
		// something else went wrong!
		return -1;
	}
}

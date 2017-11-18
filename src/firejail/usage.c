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

void usage(void) {
	printf("firejail - version %s\n\n", VERSION);
	printf("Firejail is a SUID sandbox program that reduces the risk of security breaches by\n");
	printf("restricting the running environment of untrusted applications using Linux\n");
	printf("namespaces.\n");
	printf("\n");
	printf("Usage: firejail [options] [program and arguments]\n");
	printf("\n");
	printf("Options:\n");
	printf("    -- - signal the end of options and disables further option processing.\n");
	printf("    --allow-debuggers - allow tools such as strace and gdb inside the sandbox.\n");
	printf("    --allow-private-blacklist - allow blacklisting files in private\n");
	printf("\thome directories.\n");
	printf("    --allusers - all user home directories are visible inside the sandbox.\n");
	printf("    --apparmor - enable AppArmor confinement.\n");
	printf("    --appimage - sandbox an AppImage application.\n");
	printf("    --audit[=test-program] - audit the sandbox.\n");
#ifdef HAVE_NETWORK
	printf("    --bandwidth=name|pid - set bandwidth limits.\n");
#endif
#ifdef HAVE_BIND
	printf("    --bind=dirname1,dirname2 - mount-bind dirname1 on top of dirname2.\n");
	printf("    --bind=filename1,filename2 - mount-bind filename1 on top of filename2.\n");
#endif
	printf("    --blacklist=filename - blacklist directory or file.\n");
	printf("    --build - build a whitelisted profile for the application.\n");
	printf("    --build=filename - build a whitelisted profile for the application.\n");
	printf("    -c - execute command and exit.\n");
	printf("    --caps - enable default Linux capabilities filter.\n");
	printf("    --caps.drop=all - drop all capabilities.\n");
	printf("    --caps.drop=capability,capability - blacklist capabilities filter.\n");
	printf("    --caps.keep=capability,capability - whitelist capabilities filter.\n");
	printf("    --caps.print=name|pid - print the caps filter.\n");
	printf("    --cgroup=tasks-file - place the sandbox in the specified control group.\n");
#ifdef HAVE_CHROOT
	printf("    --chroot=dirname - chroot into directory.\n");
#endif
	printf("    --cpu=cpu-number,cpu-number - set cpu affinity.\n");
	printf("    --cpu.print=name|pid - print the cpus in use.\n");
	printf("    --csh - use /bin/csh as default shell.\n");
	printf("    --debug - print sandbox debug messages.\n");
	printf("    --debug-blacklists - debug blacklisting.\n");
	printf("    --debug-caps - print all recognized capabilities.\n");
	printf("    --debug-check-filename - debug filename checking.\n");
	printf("    --debug-errnos - print all recognized error numbers.\n");
	printf("    --debug-private-lib - debug for --private-lib option.\n");
	printf("    --debug-protocols - print all recognized protocols.\n");
	printf("    --debug-syscalls - print all recognized system calls.\n");
#ifdef HAVE_WHITELIST
	printf("    --debug-whitelists - debug whitelisting.\n");
#endif
#ifdef HAVE_NETWORK
	printf("    --defaultgw=address - configure default gateway.\n");
#endif
	printf("    --dns=address - set DNS server.\n");
	printf("    --dns.print=name|pid - print DNS configuration.\n");

	printf("    --env=name=value - set environment variable.\n");
	printf("    --force - attempt to start a new sandbox inside the existing sandbox.\n");
	printf("    --fs.print=name|pid - print the filesystem log.\n");
	printf("    --get=name|pid filename - get a file from sandbox container.\n");
#ifdef HAVE_GIT_INSTALL
	printf("    --git-install - download, compile and install mainline git version\n");
	printf("\tof Firejail.\n");
	printf("    --git-uninstall - uninstall mainline git version of Firejail\n");
#endif
	printf("    --help, -? - this help screen.\n");
	printf("    --hostname=name - set sandbox hostname.\n");
	printf("    --hosts-file=file - use file as /etc/hosts.\n");
	printf("    --ignore=command - ignore command in profile files.\n");
#ifdef HAVE_NETWORK
	printf("    --interface=name - move interface in sandbox.\n");
	printf("    --ip=address - set interface IP address.\n");
	printf("    --ip=none - no IP address and no default gateway are configured.\n");
	printf("    --ip6=address - set interface IPv6 address.\n");
	printf("    --iprange=address,address - configure an IP address in this range.\n");
#endif
	printf("    --ipc-namespace - enable a new IPC namespace.\n");
	printf("    --join=name|pid - join the sandbox.\n");
	printf("    --join-filesystem=name|pid - join the mount namespace.\n");
#ifdef HAVE_NETWORK
	printf("    --join-network=name|pid - join the network namespace.\n");
#endif
	printf("    --join-or-start=name|pid - join the sandbox or start a new one.\n");
	printf("    --list - list all sandboxes.\n");
	printf("    --ls=name|pid dir_or_filename - list files in sandbox container.\n");
#ifdef HAVE_NETWORK
	printf("    --mac=xx:xx:xx:xx:xx:xx - set interface MAC address.\n");
#endif
	printf("    --machine-id - preserve /etc/machine-id\n");
#ifdef HAVE_SECCOMP
	printf("    --memory-deny-write-execute - seccomp filter to block attempts to create\n");
	printf("\tmemory mappings  that are both writable and executable.\n");
#endif
#ifdef HAVE_NETWORK
	printf("    --mtu=number - set interface MTU.\n");
#endif
	printf("    --name=name - set sandbox name.\n");
#ifdef HAVE_NETWORK
	printf("    --net=bridgename - enable network namespaces and connect to this bridge.\n");
	printf("    --net=ethernet_interface - enable network namespaces and connect to this\n");
	printf("\tEthernet interface.\n");
	printf("    --net=none - enable a new, unconnected network namespace.\n");
	printf("    --netfilter[=filename,arg1,arg2,arg3 ...] - enable firewall.\n");
	printf("    --netfilter.print=name|pid - print the firewall.\n");
	printf("    --netfilter6=filename - enable IPv6 firewall.\n");
	printf("    --netfilter6.print=name|pid - print the IPv6 firewall.\n");
	printf("    --netns=name - Run the program in a named, persistent network namespace.\n");
	printf("    --netstats - monitor network statistics.\n");
#endif
	printf("    --nice=value - set nice value.\n");
	printf("    --no3d - disable 3D hardware acceleration.\n");
	printf("    --noblacklist=filename - disable blacklist for file or directory .\n");
	printf("    --noexec=filename - remount the file or directory noexec nosuid and nodev.\n");
	printf("    --nogroups - disable supplementary groups.\n");
	printf("    --nonewprivs - sets the NO_NEW_PRIVS prctl.\n");
	printf("    --noprofile - do not use a security profile.\n");
#ifdef HAVE_USERNS
	printf("    --noroot - install a user namespace with only the current user.\n");
#endif
	printf("    --nosound - disable sound system.\n");
	printf("    --novideo - disable video devices.\n");
	printf("    --nowhitelist=filename - disable whitelist for file or directory .\n");
	printf("    --output=logfile - stdout logging and log rotation.\n");
	printf("    --output-stderr=logfile - stdout and stderr logging and log rotation.\n");
	printf("    --overlay - mount a filesystem overlay on top of the current filesystem.\n");
	printf("    --overlay-named=name - mount a filesystem overlay on top of the current\n");
	printf("\tfilesystem, and store it in name directory.\n");
	printf("    --overlay-tmpfs - mount a temporary filesystem overlay on top of the\n");
	printf("\tcurrent filesystem.\n");
	printf("    --overlay-clean - clean all overlays stored in $HOME/.firejail directory.\n");
	printf("    --private - temporary home directory.\n");
	printf("    --private=directory - use directory as user home.\n");
	printf("    --private-home=file,directory - build a new user home in a temporary\n");
	printf("\tfilesystem, and copy the files and directories in the list in\n");
	printf("\tthe new home.\n");
	printf("    --private-bin=file,file - build a new /bin in a temporary filesystem,\n");
	printf("\tand copy the programs in the list.\n");
	printf("    --private-dev - create a new /dev directory with a small number of\n");
	printf("\tcommon device files.\n");
	printf("    --private-etc=file,directory - build a new /etc in a temporary\n");
	printf("\tfilesystem, and copy the files and directories in the list.\n");
	printf("    --private-tmp - mount a tmpfs on top of /tmp directory.\n");
	printf("    --private-opt=file,directory - build a new /opt in a temporary filesystem.\n");
	printf("    --profile=filename - use a custom profile.\n");
	printf("    --profile.print=name|pid - print the name of profile file.\n");
	printf("    --profile-path=directory - use this directory to look for profile files.\n");
	printf("    --protocol=protocol,protocol,protocol - enable protocol filter.\n");
	printf("    --protocol.print=name|pid - print the protocol filter.\n");
	printf("    --put=name|pid src-filename dest-filename - put a file in sandbox\n");
	printf("\tcontainer.\n");
	printf("    --quiet - turn off Firejail's output.\n");
	printf("    --read-only=filename - set directory or file read-only..\n");
	printf("    --read-write=filename - set directory or file read-write.\n");
	printf("    --rlimit-as=number - set the maximum size of the process's virtual memory\n");
	printf("\t(address space) in bytes.\n");
	printf("    --rlimit-cpu=number - set the maximum CPU time in seconds.\n");
	printf("    --rlimit-fsize=number - set the maximum file size that can be created\n");
	printf("\tby a process.\n");
	printf("    --rlimit-nofile=number - set the maximum number of files that can be\n");
	printf("\topened by a process.\n");
	printf("    --rlimit-nproc=number - set the maximum number of processes that can be\n");
	printf("\tcreated for the real user ID of the calling process.\n");
	printf("    --rlimit-sigpending=number - set the maximum number of pending signals\n");
	printf("\tfor a process.\n");
	printf("    --rmenv=name - remove environment variable in the new sandbox.\n");
#ifdef HAVE_NETWORK
	printf("    --scan - ARP-scan all the networks from inside a network namespace.\n");
#endif
#ifdef HAVE_SECCOMP
	printf("    --seccomp - enable seccomp filter and apply the default blacklist.\n");
	printf("    --seccomp=syscall,syscall,syscall - enable seccomp filter, blacklist the\n");
	printf("\tdefault syscall list and the syscalls specified by the command.\n");
	printf("    --seccomp.block-secondary - build only the native architecture filters.\n");
	printf("    --seccomp.drop=syscall,syscall,syscall - enable seccomp filter, and\n");
	printf("\tblacklist the syscalls specified by the command.\n");
	printf("    --seccomp.keep=syscall,syscall,syscall - enable seccomp filter, and\n");
	printf("\twhitelist the syscalls specified by the command.\n");
	printf("    --seccomp.print=name|pid - print the seccomp filter for the sandbox\n");
	printf("\tidentified by name or PID.\n");
#endif
	printf("    --shell=none - run the program directly without a user shell.\n");
	printf("    --shell=program - set default user shell.\n");
	printf("    --shutdown=name|pid - shutdown the sandbox identified by name or PID.\n");
	printf("    --timeout=hh:mm:ss - kill the sandbox automatically after the time\n");
	printf("\thas elapsed.\n");
	printf("    --tmpfs=dirname - mount a tmpfs filesystem on directory dirname.\n");
	printf("    --top - monitor the most CPU-intensive sandboxes.\n");
	printf("    --trace - trace open, access and connect system calls.\n");
	printf("    --tracelog - add a syslog message for every access to files or\n");
	printf("\tdirectoires blacklisted by the security profile.\n");
	printf("    --tree - print a tree of all sandboxed processes.\n");
	printf("    --version - print program version and exit.\n");
#ifdef HAVE_NETWORK
	printf("    --veth-name=name - use this name for the interface connected to the bridge.\n");
#endif
#ifdef HAVE_WHITELIST
	printf("    --whitelist=filename - whitelist directory or file.\n");
#endif
	printf("    --writable-etc - /etc directory is mounted read-write.\n");
	printf("    --writable-run-user - allow access to /run/user/$UID/systemd and\n");
 	printf("\t/run/user/$UID/gnupg.\n");
	printf("    --writable-var - /var directory is mounted read-write.\n");
	printf("    --writable-var-log - use the real /var/log directory, not a clone.\n");
#ifdef HAVE_X11
	printf("    --x11 - enable X11 sandboxing. The software checks first if Xpra is\n");
	printf("\tinstalled, then it checks if Xephyr is installed. If all fails, it will\n");
	printf("\tattempt to use X11 security extension.\n");
	printf("    --x11=none - disable access to X11 sockets.\n");
	printf("    --x11=xephyr - enable Xephyr X11 server. The window size is 800x600.\n");
	printf("    --x11=xorg - enable X11 security extension.\n");
	printf("    --x11=xpra - enable Xpra X11 server.\n");
	printf("    --x11=xvfb - enable Xvfb X11 server.\n");
	printf("    --xephyr-screen=WIDTHxHEIGHT - set screen size for --x11=xephyr.\n");
#endif
	printf("    --zsh - use /usr/bin/zsh as default shell.\n");
	printf("\n");
	printf("Examples:\n");
	printf("    $ firejail firefox\n");
	printf("\tstart Mozilla Firefox\n");
	printf("    $ firejail --debug firefox\n");
	printf("\tdebug Firefox sandbox\n");
	printf("    $ firejail --private --dns=8.8.8.8 firefox\n");
	printf("\tstart Firefox with a new, empty home directory, and a well-known DNS\n");
	printf("\tserver setting.\n");
	printf("    $ firejail --net=eth0 firefox\n");
	printf("\tstart Firefox in a new network namespace\n");
	printf("    $ firejail --x11=xorg firefox\n");
	printf("\tstart Firefox and sandbox X11\n");
	printf("    $ firejail --list\n");
	printf("\tlist all running sandboxes\n");
	printf("\n");
	printf("License GPL version 2 or later\n");
	printf("Homepage: http://firejail.wordpress.com\n");
	printf("\n");
}

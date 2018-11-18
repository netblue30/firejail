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

static char *usage_str =
	"Firejail is a SUID sandbox program that reduces the risk of security breaches by\n"
	"restricting the running environment of untrusted applications using Linux\n"
	"namespaces.\n"
	"\n"
	"Usage: firejail [options] [program and arguments]\n"
	"\n"
	"Options:\n"
	"    -- - signal the end of options and disables further option processing.\n"
	"    --allow-debuggers - allow tools such as strace and gdb inside the sandbox.\n"
	"    --allusers - all user home directories are visible inside the sandbox.\n"
	"    --apparmor - enable AppArmor confinement.\n"
	"    --apparmor.print=name|pid - print apparmor status.\n"
	"    --appimage - sandbox an AppImage application.\n"
	"    --audit[=test-program] - audit the sandbox.\n"
#ifdef HAVE_NETWORK
	"    --bandwidth=name|pid - set bandwidth limits.\n"
#endif
	"    --bind=dirname1,dirname2 - mount-bind dirname1 on top of dirname2.\n"
	"    --bind=filename1,filename2 - mount-bind filename1 on top of filename2.\n"
	"    --blacklist=filename - blacklist directory or file.\n"
	"    --build - build a whitelisted profile for the application.\n"
	"    --build=filename - build a whitelisted profile for the application.\n"
	"    --caps - enable default Linux capabilities filter.\n"
	"    --caps.drop=all - drop all capabilities.\n"
	"    --caps.drop=capability,capability - blacklist capabilities filter.\n"
	"    --caps.keep=capability,capability - whitelist capabilities filter.\n"
	"    --caps.print=name|pid - print the caps filter.\n"
	"    --cgroup=tasks-file - place the sandbox in the specified control group.\n"
#ifdef HAVE_CHROOT
	"    --chroot=dirname - chroot into directory.\n"
#endif
	"    --cpu=cpu-number,cpu-number - set cpu affinity.\n"
	"    --cpu.print=name|pid - print the cpus in use.\n"
	"    --debug - print sandbox debug messages.\n"
	"    --debug-blacklists - debug blacklisting.\n"
	"    --debug-caps - print all recognized capabilities.\n"
	"    --debug-errnos - print all recognized error numbers.\n"
	"    --debug-private-lib - debug for --private-lib option.\n"
	"    --debug-protocols - print all recognized protocols.\n"
	"    --debug-syscalls - print all recognized system calls.\n"
#ifdef HAVE_WHITELIST
	"    --debug-whitelists - debug whitelisting.\n"
#endif
#ifdef HAVE_NETWORK
	"    --defaultgw=address - configure default gateway.\n"
#endif
	"    --dns=address - set DNS server.\n"
	"    --dns.print=name|pid - print DNS configuration.\n"
	"    --env=name=value - set environment variable.\n"
	"    --fs.print=name|pid - print the filesystem log.\n"
#ifdef HAVE_FILE_TRANSFER
	"    --get=name|pid filename - get a file from sandbox container.\n"
#endif
	"    --help, -? - this help screen.\n"
	"    --hostname=name - set sandbox hostname.\n"
	"    --hosts-file=file - use file as /etc/hosts.\n"
	"    --ignore=command - ignore command in profile files.\n"
#ifdef HAVE_NETWORK
	"    --interface=name - move interface in sandbox.\n"
	"    --ip=address - set interface IP address.\n"
	"    --ip=none - no IP address and no default gateway are configured.\n"
	"    --ip6=address - set interface IPv6 address.\n"
	"    --iprange=address,address - configure an IP address in this range.\n"
#endif
	"    --ipc-namespace - enable a new IPC namespace.\n"
	"    --join=name|pid - join the sandbox.\n"
	"    --join-filesystem=name|pid - join the mount namespace.\n"
#ifdef HAVE_NETWORK
	"    --join-network=name|pid - join the network namespace.\n"
#endif
	"    --join-or-start=name|pid - join the sandbox or start a new one.\n"
        "    --keep-dev-shm - /dev/shm directory is untouched (even with --private-dev).\n"
	"    --keep-var-tmp - /var/tmp directory is untouched.\n"
	"    --list - list all sandboxes.\n"
#ifdef HAVE_FILE_TRANSFER
	"    --ls=name|pid dir_or_filename - list files in sandbox container.\n"
#endif
#ifdef HAVE_NETWORK
	"    --mac=xx:xx:xx:xx:xx:xx - set interface MAC address.\n"
#endif
	"    --machine-id - preserve /etc/machine-id\n"
#ifdef HAVE_SECCOMP
	"    --memory-deny-write-execute - seccomp filter to block attempts to create\n"
	"\tmemory mappings  that are both writable and executable.\n"
#endif
#ifdef HAVE_NETWORK
	"    --mtu=number - set interface MTU.\n"
#endif
	"    --name=name - set sandbox name.\n"
#ifdef HAVE_NETWORK
	"    --net=bridgename - enable network namespaces and connect to this bridge.\n"
	"    --net=ethernet_interface - enable network namespaces and connect to this\n"
	"\tEthernet interface.\n"
	"    --net=none - enable a new, unconnected network namespace.\n"
	"    --net.print=name|pid - print network interface configuration.\n"
	"    --netfilter[=filename,arg1,arg2,arg3 ...] - enable firewall.\n"
	"    --netfilter.print=name|pid - print the firewall.\n"
	"    --netfilter6=filename - enable IPv6 firewall.\n"
	"    --netfilter6.print=name|pid - print the IPv6 firewall.\n"
	"    --netmask=address - define a network mask when dealing with unconfigured"
	"\tparrent interfaces.\n"
	"    --netns=name - Run the program in a named, persistent network namespace.\n"
	"    --netstats - monitor network statistics.\n"
#endif
	"    --nice=value - set nice value.\n"
	"    --no3d - disable 3D hardware acceleration.\n"
	"    --noblacklist=filename - disable blacklist for file or directory.\n"
	"    --nodbus - disable D-Bus access.\n"
	"    --nodvd - disable DVD and audio CD devices.\n"
	"    --noexec=filename - remount the file or directory noexec nosuid and nodev.\n"
	"    --nogroups - disable supplementary groups.\n"
	"    --nonewprivs - sets the NO_NEW_PRIVS prctl.\n"
	"    --noprofile - do not use a security profile.\n"
#ifdef HAVE_USERNS
	"    --noroot - install a user namespace with only the current user.\n"
#endif
	"    --nosound - disable sound system.\n"
	"    --noautopulse - disable automatic ~/.config/pulse init.\n"
	"    --novideo - disable video devices.\n"
	"    --nou2f - disable U2F devices.\n"
	"    --nowhitelist=filename - disable whitelist for file or directory .\n"
	"    --output=logfile - stdout logging and log rotation.\n"
	"    --output-stderr=logfile - stdout and stderr logging and log rotation.\n"
	"    --overlay - mount a filesystem overlay on top of the current filesystem.\n"
	"    --overlay-named=name - mount a filesystem overlay on top of the current\n"
	"\tfilesystem, and store it in name directory.\n"
	"    --overlay-tmpfs - mount a temporary filesystem overlay on top of the\n"
	"\tcurrent filesystem.\n"
	"    --overlay-clean - clean all overlays stored in $HOME/.firejail directory.\n"
	"    --private - temporary home directory.\n"
	"    --private=directory - use directory as user home.\n"
	"    --private-cache - temporary ~/.cache directory.\n"
	"    --private-home=file,directory - build a new user home in a temporary\n"
	"\tfilesystem, and copy the files and directories in the list in\n"
	"\tthe new home.\n"
	"    --private-bin=file,file - build a new /bin in a temporary filesystem,\n"
	"\tand copy the programs in the list.\n"
	"    --private-dev - create a new /dev directory with a small number of\n"
	"\tcommon device files.\n"
	"    --private-etc=file,directory - build a new /etc in a temporary\n"
	"\tfilesystem, and copy the files and directories in the list.\n"
	"    --private-tmp - mount a tmpfs on top of /tmp directory.\n"
	"    --private-opt=file,directory - build a new /opt in a temporary filesystem.\n"
	"    --private-srv=file,directory - build a new /srv in a temporary filesystem.\n"
	"    --profile=filename|profile_name - use a custom profile.\n"
	"    --profile.print=name|pid - print the name of profile file.\n"
	"    --profile-path=directory - use this directory to look for profile files.\n"
	"    --protocol=protocol,protocol,protocol - enable protocol filter.\n"
	"    --protocol.print=name|pid - print the protocol filter.\n"
#ifdef HAVE_FILE_TRANSFER
	"    --put=name|pid src-filename dest-filename - put a file in sandbox\n"
	"\tcontainer.\n"
#endif
	"    --quiet - turn off Firejail's output.\n"
	"    --read-only=filename - set directory or file read-only..\n"
	"    --read-write=filename - set directory or file read-write.\n"
	"    --rlimit-as=number - set the maximum size of the process's virtual memory\n"
	"\t(address space) in bytes.\n"
	"    --rlimit-cpu=number - set the maximum CPU time in seconds.\n"
	"    --rlimit-fsize=number - set the maximum file size that can be created\n"
	"\tby a process.\n"
	"    --rlimit-nofile=number - set the maximum number of files that can be\n"
	"\topened by a process.\n"
	"    --rlimit-nproc=number - set the maximum number of processes that can be\n"
	"\tcreated for the real user ID of the calling process.\n"
	"    --rlimit-sigpending=number - set the maximum number of pending signals\n"
	"\tfor a process.\n"
	"    --rmenv=name - remove environment variable in the new sandbox.\n"
#ifdef HAVE_NETWORK
	"    --scan - ARP-scan all the networks from inside a network namespace.\n"
#endif
#ifdef HAVE_SECCOMP
	"    --seccomp - enable seccomp filter and apply the default blacklist.\n"
	"    --seccomp=syscall,syscall,syscall - enable seccomp filter, blacklist the\n"
	"\tdefault syscall list and the syscalls specified by the command.\n"
	"    --seccomp.block-secondary - build only the native architecture filters.\n"
	"    --seccomp.drop=syscall,syscall,syscall - enable seccomp filter, and\n"
	"\tblacklist the syscalls specified by the command.\n"
	"    --seccomp.keep=syscall,syscall,syscall - enable seccomp filter, and\n"
	"\twhitelist the syscalls specified by the command.\n"
	"    --seccomp.print=name|pid - print the seccomp filter for the sandbox\n"
	"\tidentified by name or PID.\n"
#endif
	"    --shell=none - run the program directly without a user shell.\n"
	"    --shell=program - set default user shell.\n"
	"    --shutdown=name|pid - shutdown the sandbox identified by name or PID.\n"
	"    --timeout=hh:mm:ss - kill the sandbox automatically after the time\n"
	"\thas elapsed.\n"
	"    --tmpfs=dirname - mount a tmpfs filesystem on directory dirname.\n"
	"    --top - monitor the most CPU-intensive sandboxes.\n"
	"    --trace - trace open, access and connect system calls.\n"
	"    --tracelog - add a syslog message for every access to files or\n"
	"\tdirectories blacklisted by the security profile.\n"
	"    --tree - print a tree of all sandboxed processes.\n"
	"    --tunnel[=devname] - connect the sandbox to a tunnel created by\n"
	"\tfiretunnel utility.\n"
	"    --version - print program version and exit.\n"
#ifdef HAVE_NETWORK
	"    --veth-name=name - use this name for the interface connected to the bridge.\n"
#endif
#ifdef HAVE_WHITELIST
	"    --whitelist=filename - whitelist directory or file.\n"
#endif
	"    --writable-etc - /etc directory is mounted read-write.\n"
	"    --writable-run-user - allow access to /run/user/$UID/systemd and\n"
	"\t/run/user/$UID/gnupg.\n"
	"    --writable-var - /var directory is mounted read-write.\n"
	"    --writable-var-log - use the real /var/log directory, not a clone.\n"
#ifdef HAVE_X11
	"    --x11 - enable X11 sandboxing. The software checks first if Xpra is\n"
	"\tinstalled, then it checks if Xephyr is installed. If all fails, it will\n"
	"\tattempt to use X11 security extension.\n"
	"    --x11=none - disable access to X11 sockets.\n"
	"    --x11=xephyr - enable Xephyr X11 server. The window size is 800x600.\n"
	"    --x11=xorg - enable X11 security extension.\n"
	"    --x11=xpra - enable Xpra X11 server.\n"
	"    --x11=xvfb - enable Xvfb X11 server.\n"
	"    --xephyr-screen=WIDTHxHEIGHT - set screen size for --x11=xephyr.\n"
#endif
	"\n"
	"Examples:\n"
	"    $ firejail firefox\n"
	"\tstart Mozilla Firefox\n"
	"    $ firejail --debug firefox\n"
	"\tdebug Firefox sandbox\n"
	"    $ firejail --private --dns=8.8.8.8 firefox\n"
	"\tstart Firefox with a new, empty home directory, and a well-known DNS\n"
	"\tserver setting.\n"
	"    $ firejail --net=eth0 firefox\n"
	"\tstart Firefox in a new network namespace\n"
	"    $ firejail --x11=xorg firefox\n"
	"\tstart Firefox and sandbox X11\n"
	"    $ firejail --list\n"
	"\tlist all running sandboxes\n"
	"\n"
	"License GPL version 2 or later\n"
	"Homepage: https://firejail.wordpress.com\n"
	"\n";


void usage(void) {
	printf("firejail - version %s\n\n", VERSION);
	puts(usage_str);
}

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
	printf("namespaces. It includes a sandbox profile for Mozilla Firefox.\n\n");
	printf("\n");
	printf("Usage: firejail [options] [program and arguments]\n\n");
	printf("\n");
	printf("Without any options, the sandbox consists of a filesystem chroot build from the\n");
	printf("current system directories  mounted  read-only,  and  new PID and IPC\n");
	printf("namespaces. If no program is specified as an argument, /bin/bash is started by\n");
	printf("default in the sandbox.\n\n");
	printf("\n");
	printf("Options:\n\n");
	printf("    -- - signal the end of options and disables further option processing.\n\n");
	printf("    --allow-debuggers - allow tools such as strace and gdb inside the sandbox.\n\n");
	printf("    --allusers - all user home directories are visible inside the sandbox.\n\n");
	printf("    --apparmor - enable AppArmor confinement\n\n");
	printf("    --appimage - sandbox an AppImage application\n\n");
	printf("    --audit - audit the sandbox, see Audit section for more details\n\n");
	printf("    --audit=test-program - audit the sandbox, see Audit section for more details\n\n");
#ifdef HAVE_NETWORK	
	printf("    --bandwidth=name|pid - set  bandwidth  limits  for  the sandbox identified\n");
	printf("\tby name or PID, see Traffic Shaping section fo more details.\n\n");
#endif
#ifdef HAVE_BIND		
	printf("    --bind=dirname1,dirname2 - mount-bind dirname1 on top of dirname2.\n\n");
	printf("    --bind=filename1,filename2 - mount-bind filename1 on top of filename2.\n\n");
#endif
	printf("    --blacklist=dirname_or_filename - blacklist directory or file.\n\n");
	printf("    -c - execute command and exit.\n\n");
	printf("    --caps - enable default Linux capabilities filter.\n\n");
	printf("    --caps.drop=all - drop all capabilities.\n\n");
	printf("    --caps.drop=capability,capability - blacklist capabilities filter.\n\n");
	printf("    --caps.keep=capability,capability - whitelist capabilities filter.\n\n");
	printf("    --caps.print=name|pid - print the caps filter for the sandbox identified\n");
	printf("\tby name or PID.\n\n");
	printf("    --cgroup=tasks-file - place the sandbox in the specified control group.\n");
	printf("\ttasks-file is the full path of cgroup tasks file.\n\n");
#ifdef HAVE_CHROOT		
	printf("    --chroot=dirname - chroot into directory.\n\n");
#endif
	printf("    --cpu=cpu-number,cpu-number - set cpu affinity.\n\n");
	printf("    --cpu.print=name|pid - print the cup in use by the sandbox identified\n");
	printf("\tby name or PID.\n\n");
	printf("    --csh - use /bin/csh as default shell.\n\n");
	
	printf("    --debug - print sandbox debug messages.\n\n");
	printf("    --debug-blacklists - debug blacklisting.\n\n");
	printf("    --debug-caps - print all recognized capabilities in the current Firejail\n");
	printf("\tsoftware build.\n\n");
	printf("    --debug-check-filename - debug filename checking.\n\n");
	printf("    --debug-errnos - print all recognized error numbers in the current Firejail\n");
	printf("\tsoftware build.\n\n");
	printf("    --debug-protocols - print all recognized protocols in the current Firejail\n");
	printf("\tsoftware build.\n\n");
	printf("    --debug-syscalls - print all recognized system calls in the current Firejail\n");
	printf("\tsoftware build.\n\n");
#ifdef HAVE_WHITELIST	
	printf("    --debug-whitelists - debug whitelisting.\n\n");
#endif


#ifdef HAVE_NETWORK	
	printf("    --defaultgw=address - use this address as default gateway in the new network\n");
	printf("\tnamespace.\n\n");
#endif
	printf("    --dns=address - set a DNS server for the sandbox. Up to three DNS servers\n");
	printf("\tcan be defined.\n\n");
	printf("    --dns.print=name|pid - print DNS configuration for the sandbox identified\n");
	printf("\tby name or PID.\n\n");
	
	printf("    --env=name=value - set environment variable in the new sandbox.\n\n");
	printf("    --fs.print=name|pid - print the filesystem log for the sandbox identified\n");
	printf("\tby name or PID.\n\n");
	printf("    --get=name|pid filename - get a file from sandbox container.\n\n");
	printf("    --help, -? - this help screen.\n\n");
	printf("    --hostname=name - set sandbox hostname.\n\n");
	printf("    --ignore=command - ignore command in profile files.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --interface=name - move interface in a new network namespace. Up to four\n");
	printf("\t--interface options can be specified.\n\n");
	printf("    --ip=address - set interface IP address.\n\n");
	printf("    --ip=none - no IP address and no default gateway address are configured\n");
	printf("\tin the new network namespace. Use this option in case you intend to\n");
	printf("\tstart an external DHCP client in the sandbox.\n\n");
	printf("    --ip6=address - set interface IPv6 address.\n\n");
	printf("    --iprange=address,address - configure an IP address in this range.\n\n");
#endif
	printf("    --ipc-namespace - enable a new IPC namespace if the sandbox was started as\n");
	printf("\tregular user. IPC namespace is enabled by default only if the sandbox\n");
	printf("\tis started as root.\n\n");
	printf("    --join=name|pid - join the sandbox identified by name or PID.\n\n");
	printf("    --join-filesystem=name|pid - join the mount namespace of the sandbox\n");
	printf("\tidentified by name or PID.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --join-network=name|pid - join the network namespace of the sandbox\n");
	printf("\tidentified by name or PID.\n\n");
#endif
	printf("    --list - list all sandboxes.\n\n");
	printf("    --ls=name|pid dir_or_filename - list files in sandbox container.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --mac=xx:xx:xx:xx:xx:xx - set interface MAC address.\n\n");
#endif
	printf("    --machine-id - preserve /etc/machine-id\n");
#ifdef HAVE_NETWORK	
	printf("    --mtu=number - set interface MTU.\n\n");
#endif
	printf("    --name=name - set sandbox name.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --net=bridgename - enable network namespaces and connect to this bridge\n");
	printf("\tdevice. Up to four --net devices can be defined.\n\n");

	printf("    --net=ethernet_interface - enable network namespaces and connect to this\n");
	printf("\tEthernet interface using the standard Linux macvlan driver. Up to four\n");
	printf("\t--net devices can be defined.\n\n");
	
	printf("    --net=none - enable a new, unconnected network namespace.\n\n");

	printf("    --netfilter - enable the default client network filter in the new\n");
	printf("\tnetwork namespace.\n\n");
	printf("    --netfilter=filename - enable the network filter specified by\n");
	printf("\tfilename in the new network namespace. The filter file format\n");
	printf("\tis the format of iptables-save and iptable-restore commands.\n\n");
	printf("    --netfilter6=filename - enable the IPv6 network filter specified by\n");
	printf("\tfilename in the new network namespace. The filter file format\n");
	printf("\tis the format of ip6tables-save and ip6table-restore commands.\n\n");

	printf("    --netstats - monitor network statistics for sandboxes creating a new\n");
	printf("\tnetwork namespace.\n\n");
#endif
	printf("    --nice=value - set nice value.\n\n");
	printf("    --no3d - disable 3D hardware acceleration.\n\n");
	printf("    --noblacklist=dirname_or_filename - disable blacklist for directory or\n");
	printf("\tfile.\n\n");
	printf("    --noexec=dirname_of_filenam - remount the file or directory noexec\n");
	printf("\tnosuid and nodev\n\n");
	printf("    --nogroups - disable supplementary groups. Without this option,\n");
	printf("\tsupplementary groups are enabled for the user starting the sandbox.\n");
	printf("\tFor root, groups are always disabled.\n\n");

	printf("    --noprofile - do not use a profile.  Profile priority is use the one\n");
	printf("\tspecified on the command line, next try to find one that\n");
	printf("\tmatches the command name, and lastly use %s.profile\n", DEFAULT_USER_PROFILE);
	printf("\tif running as regular user or %s.profile if running as\n", DEFAULT_ROOT_PROFILE);
	printf("\troot.\n\n");
#ifdef HAVE_USERNS		 	
	printf("    --noroot - install a user namespace with a single user - the current\n");
	printf("\tuser. root user does not exist in the new namespace. This option\n");
	printf("\tis not supported for --chroot and --overlay configurations.\n\n");
#endif
	printf("    --nonewprivs - sets the NO_NEW_PRIVS prctl - the child processes\n");
	printf("\tcannot gain privileges using execve(2); in particular, this prevents\n");
	printf("\tgaining privileges by calling a suid binary\n\n");
	printf("    --nosound - disable sound system.\n\n");
		
	printf("    --output=logfile - stdout logging and log rotation. Copy stdout and stderr\n");
	printf("\tto logfile, and keep the size of the file under 500KB using log\n");
	printf("\trotation. Five files with prefixes .1 to .5 are used in\n");
	printf("\trotation.\n\n");
	
	printf("    --overlay - mount a filesystem overlay on top of the current filesystem.\n");
	printf("\tThe upper filesystem layer is persistent, and stored in\n");
	printf("\t$HOME/.firejail/<PID> directory. (OverlayFS support is required in\n");
	printf("\tLinux kernel for this option to work). \n\n");

	printf("    --overlay-named=name - mount a filesystem overlay on top of the current\n");
	printf("\tfilesystem. The upper filesystem layer is persistent, and stored in\n");
	printf("\t$HOME/.firejail/<NAME> directory. (OverlayFS support is required in\n");
	printf("\tLinux kernel for this option to work). \n\n");

	printf("    --overlay-tmpfs - mount a filesystem overlay on top of the current\n");
	printf("\tfilesystem. The upper layer is stored in a tmpfs filesystem,\n");
	printf("\tand it is discarded when the sandbox is closed. (OverlayFS\n");
	printf("\tsupport is required in Linux kernel for this option to work).\n\n");   
	
	printf("    --overlay-clean - clean all overlays stored in $HOME/.firejail directory.\n\n");

	printf("    --private - mount new /root and /home/user directories in temporary\n");
	printf("\tfilesystems. All modifications are discarded when the sandbox is\n");
	printf("\tclosed.\n\n");
	printf("    --private=directory - use directory as user home.\n\n");
	printf("    --private-home=file,directory - build a new user home in a temporary\n");
	printf("\t\tfilesystem, and copy the files and directories in the list in\n");
	printf("\t\tthe new home. All modifications are discarded when the sandbox\n");
	printf("\t\tis closed.\n\n");

	printf("    --private-bin=file,file - build a new /bin in a temporary filesystem,\n");
	printf("\tand copy the programs in the list.\n\n");

	printf("    --private-dev - create a new /dev directory. Only dri, null, full, zero,\n");
	printf("\ttty, pst, ptms, random, snd, urandom, log and shm devices are available.\n\n");

	printf("    --private-etc=file,directory - build a new /etc in a temporary\n");
	printf("\tfilesystem, and copy the files and directories in the list.\n");
	printf("\tAll modifications are discarded when the sandbox is closed.\n\n");
	
	printf("    --private-tmp - mount a tmpfs on top of /tmp directory\n\n");
	
	printf("    --profile=filename - use a custom profile.\n\n");
	printf("    --profile-path=directory - use this directory to look for profile files.\n\n");
	
	printf("    --protocol=protocol,protocol,protocol - enable protocol filter.\n");
	printf("\tProtocol values: unix, inet, inet6, netlink, packet.\n\n");
	printf("    --protocol.print=name|pid - print the protocol filter for the sandbox\n");
	printf("\tidentified by name or PID.\n\n");
	
	printf("    --put=name|pid src-filename dest-filename - put a file in sandbox container.\n\n");
	
	printf("    --quiet - turn off Firejail's output.\n\n");
	printf("    --read-only=dirname_or_filename - set directory or file read-only..\n\n");
	printf("    --read-write=dirname_or_filename - set directory or file read-write..\n\n");
	printf("    --rlimit-fsize=number - set the maximum file size that can be created\n");
	printf("\tby a process.\n\n");
	printf("    --rlimit-nofile=number - set the maximum number of files that can be\n");
	printf("\topened by a process.\n\n");
	printf("    --rlimit-nproc=number - set the maximum number of processes that can be\n");
	printf("\tcreated for the real user ID of the calling process.\n\n");
	printf("    --rlimit-sigpending=number - set the maximum number of pending signals\n");
	printf("\tfor a process.\n\n");
	printf("    --rmenv=name - remove environment variable in the new sandbox.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --scan - ARP-scan all the networks from inside a network namespace.\n");
	printf("\tThis makes it possible to detect macvlan kernel device drivers\n");
	printf("\trunning on the current host.\n\n");
#endif	
#ifdef HAVE_SECCOMP
	printf("    --seccomp - enable seccomp filter and apply the default blacklist.\n\n");
	
	printf("    --seccomp=syscall,syscall,syscall - enable seccomp filter, blacklist the\n");
	printf("\tdefault syscall list and the syscalls specified by the command.\n\n");
	
	printf("    --seccomp.drop=syscall,syscall,syscall - enable seccomp filter, and\n");
	printf("\tblacklist the syscalls specified by the command.\n\n");
	
	printf("    --seccomp.keep=syscall,syscall,syscall - enable seccomp filter, and\n");
	printf("\twhitelist the syscalls specified by the command.\n\n");
	
	printf("    --seccomp.<errno>=syscall,syscall,syscall - enable seccomp filter, and\n");
	printf("\treturn errno for the syscalls specified by the command.\n\n");
	
	printf("    --seccomp.print=name|pid - print the seccomp filter for the sandbox\n");
	printf("\tidentified by name or PID.\n\n");
#endif

	printf("    --shell=none - run the program directly without a user shell.\n\n");
	printf("    --shell=program - set default user shell.\n\n");
	printf("    --shutdown=name|pid - shutdown the sandbox identified by name or PID.\n\n");
	printf("    --tmpfs=dirname - mount a tmpfs filesystem on directory dirname.\n");
	printf("\tThis option is available only when running the sandbox as root.\n\n");
	printf("    --top - monitor the most CPU-intensive sandboxes.\n\n");
	printf("    --trace - trace open, access and connect system calls.\n\n");
	printf("    --tracelog - add a syslog message for every access to files or\n");
	printf("\tdirectoires blacklisted by the security profile.\n\n");
	printf("    --tree - print a tree of all sandboxed processes.\n\n");
	printf("    --version - print program version and exit.\n\n");
#ifdef HAVE_NETWORK	
	printf("    --veth-name=name - use this name for the interface connected to the bridge\n");
	printf("\tfor --net=bridgename commands, instead of the default one.\n\n"); 
#endif	
#ifdef HAVE_WHITELIST	
	printf("    --whitelist=dirname_or_filename - whitelist directory or file.\n\n");
#endif	
	printf("    --writable-etc - /etc directory is mounted read-write.\n\n");
	printf("    --writable-var - /var directory is mounted read-write.\n\n");
	
	printf("    --x11 - enable X11 sandboxing. The software checks first if Xpra is\n");
	printf("\tinstalled, then it checks if Xephyr is installed. If all fails, it will\n");
	printf("\tattempt to use X11 security extension.\n\n");
	printf("    --x11=none - disable access to X11 sockets.\n\n");
	printf("    --x11=xephyr - enable Xephyr X11 server. The window size is 800x600.\n\n");
	printf("    --x11=xorg - enable X11 security extension.\n\n");
	printf("    --x11=xpra - enable Xpra X11 server.\n\n");
	printf("    --zsh - use /usr/bin/zsh as default shell.\n\n");
	printf("\n");
	printf("\n");


#ifdef HAVE_NETWORK	
	printf("Traffic Shaping\n\n");
	
	printf("Network bandwidth is an expensive resource shared among  all  sandboxes\n");
	printf("running  on a system.  Traffic shaping allows the user to increase network\n");
	printf("performance by controlling the amount of data that flows into and out of the\n");
	printf("sandboxes. Firejail  implements  a simple rate-limiting shaper based on Linux\n");
	printf("command tc. The shaper works at sandbox level, and can be used  only  for\n");
	printf("sandboxes configured with new network namespaces.\n\n");

	printf("Set rate-limits:\n");
	printf("    firejail  --bandwidth={name|pid} set network-name down-speed up-speed\n\n");
	printf("Clear rate-limits:\n");
	printf("    firejail --bandwidth={name|pid} clear network-name\n\n");
	printf("Status:\n");
	printf("    firejail --bandwidth={name|pid} status\n\n");
	printf("where:\n");
            printf("    name - sandbox name\n");
            printf("    pid - sandbox pid\n");
            printf("    network-name - network name as used by --net option\n");
            printf("    down-speed - download speed in KB/s (decimal kilobyte per second)\n");
            printf("    up-speed - upload speed in KB/s (decimal kilobyte per second)\n");
	printf("\n");
	printf("Example:\n");
            printf("    $ firejail --name=mybrowser --net=eth0 firefox &\n");
            printf("    $ firejail --bandwidth=mybrowser set eth0 80 20\n");
            printf("    $ firejail --bandwidth=mybrowser status\n");
            printf("    $ firejail --bandwidth=mybrowser clear eth0\n");
	printf("\n");
	printf("\n");
#endif

	printf("Audit\n\n");
	printf("Audit feature allows the user to point out gaps in security profiles. The\n");
	printf("implementation replaces the program to be sandboxed with a test program. By\n");
	printf("default, we use faudit program distributed with Firejail. A custom test program\n");
	printf("can also be supplied by the user. Examples:\n\n");
	printf("Running the default audit program:\n");
	printf("    $ firejail --audit transmission-gtk\n\n");
	printf("Running a custom audit program:\n");
	printf("    $ firejail --audit=~/sandbox-test transmission-gtk\n\n");
	printf("In the examples above, the sandbox configures transmission-gtk profile and\n");
	printf("starts the test program. The real program, transmission-gtk, will not be\n");
	printf("started.\n\n\n");
	
	printf("Monitoring\n\n");

	printf("Option --list prints a list of all sandboxes. The format for each entry is as\n");
	printf("follows:\n\n");
	printf("    PID:USER:Command\n\n");

	printf("Option --tree prints the tree of processes running in the sandbox. The format\n");
	printf("for each process entry is as follows:\n\n");
	printf("    PID:USER:Command\n\n");

	printf("Option --top is similar to the UNIX top command, however it applies only to\n");
	printf("sandboxes. Listed below are the available fields (columns) in alphabetical\n");
	printf("order:\n\n");
	printf("    Command - command used to start the sandbox.\n");
	printf("    CPU%% - CPU usage, the sandbox share of the elapsed CPU time since the\n");
	printf("\tlast screen update\n");
	printf("    PID - Unique process ID for the task controlling the sandbox.\n");
	printf("    Prcs - number of processes running in sandbox, including the controlling\n");
	printf("\tprocess.\n");
	printf("    RES - Resident Memory Size (KiB), sandbox non-swapped physical memory.\n");
	printf("\tIt is a sum of the RES values for all processes running in the\n");
	printf("\tsandbox.\n");
	printf("    SHR - Shared Memory Size (KiB), it reflects memory shared with other\n");
	printf("\tprocesses. It is a sum of the SHR values for all processes running\n");
	printf("\tin the sandbox, including the controlling process.\n");
	printf("    Uptime - sandbox running time in hours:minutes:seconds format.\n");
	printf("    User - The owner of the sandbox.\n");
	printf("\n");
	printf("\n");
	printf("Profile files\n\n");
	printf("Several command line configuration options can be passed to the program using\n");
	printf("profile files. Default Firejail profile files are stored in /etc/firejail\n");
	printf("directory, user profile files are stored in ~/.config/firejail directory. See\n");
	printf("man 5 firejail-profile for more information.\n\n");
	printf("\n");
	printf("Restricted shell\n\n");
	printf("To  configure a restricted shell, replace /bin/bash with /usr/bin/firejail in\n");
	printf("/etc/passwd file for each user that needs to  be  restricted.\n");
	printf("Alternatively, you can specify /usr/bin/firejail  in adduser command:\n\n");
	printf("   adduser --shell /usr/bin/firejail username\n\n");
	printf("Arguments to be passed to firejail executable upon login are  declared  in\n");
	printf("/etc/firejail/login.users file.\n\n");
	printf("\n");
	printf("Examples:\n\n");
	printf("    $ firejail\n");
	printf("\tstart a regular /bin/bash session in sandbox\n");
	printf("    $ firejail firefox\n");
	printf("\tstart Mozilla Firefox\n");
	printf("    $ firejail --debug firefox\n");
	printf("\tdebug Firefox sandbox\n");
	printf("    $ firejail --private firefox\n");
	printf("\tstart Firefox with a new, empty home directory\n");
	printf("    $ firejail --net=br0 ip=10.10.20.10\n");
	printf("\tstart a /bin/bash session in a new network namespace; the session is\n");
	printf("\tconnected to the main network using br0 bridge device, an IP address\n");
	printf("\tof 10.10.20.10 is assigned to the sandbox\n");
	printf("    $ firejail --net=br0 --net=br1 --net=br2\n");
	printf("\tstart a /bin/bash session in a new network namespace and connect it\n");
	printf("\tto br0, br1, and br2 host bridge devices\n");
	printf("    $ firejail --list\n");
	printf("\tlist all running sandboxes\n");
	printf("\n");
	printf("License GPL version 2 or later\n");
	printf("Homepage: http://firejail.wordpress.com\n");
	printf("\n");
}

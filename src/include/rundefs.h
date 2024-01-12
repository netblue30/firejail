/*
 * Copyright (C) 2014-2024 Firejail Authors
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

#ifndef RUNDEFS_H
#define RUNDEFS_H
// filesystem
#define RUN_FIREJAIL_BASEDIR		"/run"
#define RUN_FIREJAIL_DIR		RUN_FIREJAIL_BASEDIR "/firejail"
#define RUN_FIREJAIL_SANDBOX_DIR	RUN_FIREJAIL_DIR "/sandbox"
#define RUN_FIREJAIL_APPIMAGE_DIR	RUN_FIREJAIL_DIR "/appimage"
#define RUN_FIREJAIL_NAME_DIR		RUN_FIREJAIL_DIR "/name" // also used in src/lib/pid.c - todo: move it in a common place
#define RUN_FIREJAIL_LIB_DIR		RUN_FIREJAIL_DIR "/lib"
#define RUN_FIREJAIL_X11_DIR		RUN_FIREJAIL_DIR "/x11"
#define RUN_FIREJAIL_NETWORK_DIR	RUN_FIREJAIL_DIR "/network"
#define RUN_FIREJAIL_BANDWIDTH_DIR	RUN_FIREJAIL_DIR "/bandwidth"
#define RUN_FIREJAIL_PROFILE_DIR	RUN_FIREJAIL_DIR "/profile"
#define RUN_FIREJAIL_DBUS_DIR RUN_FIREJAIL_DIR "/dbus"
#define RUN_NETWORK_LOCK_FILE		RUN_FIREJAIL_DIR "/firejail-network.lock"
#define RUN_DIRECTORY_LOCK_FILE		RUN_FIREJAIL_DIR "/firejail-run.lock"
#define RUN_RO_DIR			RUN_FIREJAIL_DIR "/firejail.ro.dir"
#define RUN_RO_FILE			RUN_FIREJAIL_DIR "/firejail.ro.file"
#define RUN_MNT_DIR			RUN_FIREJAIL_DIR "/mnt"	// a tmpfs is mounted on this directory before any of the files below are created
#define RUN_CPU_CFG			RUN_MNT_DIR "/cpu"
#define RUN_GROUPS_CFG			RUN_MNT_DIR "/groups"
#define RUN_PROTOCOL_CFG		RUN_MNT_DIR "/protocol"
#define RUN_NONEWPRIVS_CFG		RUN_MNT_DIR "/nonewprivs"
#define RUN_HOME_DIR			RUN_MNT_DIR "/home"
#define RUN_ETC_DIR			RUN_MNT_DIR "/etc"
#define RUN_USR_ETC_DIR		RUN_MNT_DIR "/usretc"
#define RUN_OPT_DIR			RUN_MNT_DIR "/opt"
#define RUN_SRV_DIR			RUN_MNT_DIR "/srv"
#define RUN_BIN_DIR			RUN_MNT_DIR "/bin"
#define RUN_PULSE_DIR			RUN_MNT_DIR "/pulse"
#define RUN_LIB_DIR			RUN_MNT_DIR "/lib"
#define RUN_LIB_FILE			RUN_MNT_DIR "/libfiles"
#define RUN_DNS_ETC			RUN_MNT_DIR "/dns-etc"
#define RUN_DHCLIENT_DIR			RUN_MNT_DIR "/dhclient-dir"
#define RUN_DHCLIENT_4_LEASES_FILE		RUN_DHCLIENT_DIR "/dhclient.leases"
#define RUN_DHCLIENT_6_LEASES_FILE		RUN_DHCLIENT_DIR "/dhclient6.leases"
#define RUN_DHCLIENT_4_LEASES_FILE		RUN_DHCLIENT_DIR "/dhclient.leases"
#define RUN_DHCLIENT_4_PID_FILE			RUN_DHCLIENT_DIR "/dhclient.pid"
#define RUN_DHCLIENT_6_PID_FILE			RUN_DHCLIENT_DIR "/dhclient6.pid"
#define RUN_DBUS_DIR        RUN_MNT_DIR "/dbus"
#define RUN_DBUS_USER_SOCKET        RUN_DBUS_DIR "/user"
#define RUN_DBUS_SYSTEM_SOCKET      RUN_DBUS_DIR "/system"

#define RUN_SECCOMP_DIR			RUN_MNT_DIR "/seccomp"
#define RUN_SECCOMP_LIST		RUN_SECCOMP_DIR "/seccomp.list"		// list of seccomp files installed
#define RUN_SECCOMP_PROTOCOL		RUN_SECCOMP_DIR "/seccomp.protocol"		// protocol filter
#define RUN_SECCOMP_CFG			RUN_SECCOMP_DIR "/seccomp"			// configured filter
#define RUN_SECCOMP_32			RUN_SECCOMP_DIR "/seccomp.32"			// 32bit arch filter installed on 64bit architectures
#define RUN_SECCOMP_MDWX		RUN_SECCOMP_DIR "/seccomp.mdwx"			// filter for memory-deny-write-execute
#define RUN_SECCOMP_MDWX_32		RUN_SECCOMP_DIR "/seccomp.mdwx.32"
#define RUN_SECCOMP_NS			RUN_SECCOMP_DIR "/seccomp.namespaces"
#define RUN_SECCOMP_NS_32		RUN_SECCOMP_DIR "/seccomp.namespaces.32"
#define RUN_SECCOMP_BLOCK_SECONDARY	RUN_SECCOMP_DIR "/seccomp.block_secondary"	// secondary arch blocking filter
#define RUN_SECCOMP_POSTEXEC		RUN_SECCOMP_DIR "/seccomp.postexec"		// filter for post-exec library
#define RUN_SECCOMP_POSTEXEC_32		RUN_SECCOMP_DIR "/seccomp.postexec32"		// filter for post-exec library
#define PATH_SECCOMP_DEFAULT 		LIBDIR "/firejail/seccomp"			// default filter built during make
#define PATH_SECCOMP_DEFAULT_DEBUG 	LIBDIR "/firejail/seccomp.debug"		// debug filter built during make
#define PATH_SECCOMP_32 		LIBDIR "/firejail/seccomp.32"			// 32bit arch filter built during make
#define PATH_SECCOMP_DEBUG_32 		LIBDIR "/firejail/seccomp.debug32"		// 32bit arch debug filter built during make
#define PATH_SECCOMP_MDWX 		LIBDIR "/firejail/seccomp.mdwx"			// filter for memory-deny-write-execute built during make
#define PATH_SECCOMP_MDWX_32 		LIBDIR "/firejail/seccomp.mdwx.32"
#define PATH_SECCOMP_NAMESPACES	LIBDIR "/firejail/seccomp.namespaces"	// filter for restrict-namespaces
#define PATH_SECCOMP_NAMESPACES_32	LIBDIR "/firejail/seccomp.namespaces.32"
#define PATH_SECCOMP_BLOCK_SECONDARY 	LIBDIR "/firejail/seccomp.block_secondary"	// secondary arch blocking filter built during make

#define RUN_DEV_DIR			RUN_MNT_DIR "/dev"
#define RUN_DEVLOG_FILE			RUN_MNT_DIR "/devlog"
#define RUN_XAUTHORITY_FILE		RUN_MNT_DIR "/.Xauthority"		// private options
#define RUN_XAUTH_FILE			RUN_MNT_DIR "/xauth"			// x11=xorg
#define RUN_XAUTHORITY_SEC_DIR		RUN_MNT_DIR "/.sec.Xauthority"		// x11=xorg
#define RUN_ASOUNDRC_FILE		RUN_MNT_DIR "/.asoundrc"
#define RUN_HOSTNAME_FILE		RUN_MNT_DIR "/hostname"
#define RUN_HOSTS_FILE			RUN_MNT_DIR "/hosts"
#define RUN_HOSTS_FILE2			RUN_MNT_DIR "/hosts2"
#define RUN_MACHINEID			RUN_MNT_DIR "/machine-id"
#define RUN_LDPRELOAD_FILE		RUN_MNT_DIR "/ld.so.preload"
#define RUN_UTMP_FILE			RUN_MNT_DIR "/utmp"
#define RUN_PASSWD_FILE			RUN_MNT_DIR "/passwd"
#define RUN_GROUP_FILE			RUN_MNT_DIR "/group"
#define RUN_FSLOGGER_FILE		RUN_MNT_DIR "/fslogger"
#define RUN_TRACE_FILE			RUN_MNT_DIR "/trace"
#define RUN_UMASK_FILE			RUN_MNT_DIR "/umask"
#define RUN_JOIN_FILE	 		RUN_MNT_DIR "/join"
#define RUN_OVERLAY_ROOT		RUN_MNT_DIR "/oroot"
#define RUN_RESOLVCONF_FILE		RUN_MNT_DIR "/resolv.conf"


#endif

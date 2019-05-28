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

#ifndef RUNDEFS_H
#define RUNDEFS_H
// filesystem
#define RUN_FIREJAIL_BASEDIR	"/run"
#define RUN_FIREJAIL_DIR	"/run/firejail"
#define RUN_FIREJAIL_APPIMAGE_DIR	"/run/firejail/appimage"
#define RUN_FIREJAIL_NAME_DIR	"/run/firejail/name" // also used in src/lib/pid.c - todo: move it in a common place
#define RUN_FIREJAIL_LIB_DIR		"/run/firejail/lib"
#define RUN_FIREJAIL_X11_DIR	"/run/firejail/x11"
#define RUN_FIREJAIL_NETWORK_DIR	"/run/firejail/network"
#define RUN_FIREJAIL_BANDWIDTH_DIR	"/run/firejail/bandwidth"
#define RUN_FIREJAIL_PROFILE_DIR		"/run/firejail/profile"
#define RUN_NETWORK_LOCK_FILE	"/run/firejail/firejail-network.lock"
#define RUN_DIRECTORY_LOCK_FILE	"/run/firejail/firejail-run.lock"
#define RUN_RO_DIR	"/run/firejail/firejail.ro.dir"
#define RUN_RO_FILE	"/run/firejail/firejail.ro.file"
#define RUN_MNT_DIR	"/run/firejail/mnt"	// a tmpfs is mounted on this directory before any of the files below are created
#define RUN_CGROUP_CFG	"/run/firejail/mnt/cgroup"
#define RUN_CPU_CFG	"/run/firejail/mnt/cpu"
#define RUN_GROUPS_CFG	"/run/firejail/mnt/groups"
#define RUN_PROTOCOL_CFG	"/run/firejail/mnt/protocol"
#define RUN_NONEWPRIVS_CFG	"/run/firejail/mnt/nonewprivs"
#define RUN_HOME_DIR	"/run/firejail/mnt/home"
#define RUN_ETC_DIR	"/run/firejail/mnt/etc"
#define RUN_OPT_DIR	"/run/firejail/mnt/opt"
#define RUN_SRV_DIR	"/run/firejail/mnt/srv"
#define RUN_BIN_DIR	"/run/firejail/mnt/bin"
#define RUN_PULSE_DIR	"/run/firejail/mnt/pulse"
#define RUN_LIB_DIR	"/run/firejail/mnt/lib"
#define RUN_LIB_FILE	"/run/firejail/mnt/libfiles"
#define RUN_DNS_ETC	"/run/firejail/mnt/dns-etc"

#define RUN_SECCOMP_DIR	"/run/firejail/mnt/seccomp"
#define RUN_SECCOMP_LIST	(RUN_SECCOMP_DIR "/seccomp.list")	// list of seccomp files installed
#define RUN_SECCOMP_PROTOCOL	(RUN_SECCOMP_DIR "/seccomp.protocol")	// protocol filter
#define RUN_SECCOMP_CFG	(RUN_SECCOMP_DIR "/seccomp")			// configured filter
#define RUN_SECCOMP_32		(RUN_SECCOMP_DIR "/seccomp.32")		// 32bit arch filter installed on 64bit architectures
#define RUN_SECCOMP_MDWX	(RUN_SECCOMP_DIR "/seccomp.mdwx")		// filter for memory-deny-write-execute
#define RUN_SECCOMP_BLOCK_SECONDARY	(RUN_SECCOMP_DIR "/seccomp.block_secondary")	// secondary arch blocking filter
#define RUN_SECCOMP_POSTEXEC	(RUN_SECCOMP_DIR "/seccomp.postexec")		// filter for post-exec library
#define PATH_SECCOMP_DEFAULT (LIBDIR "/firejail/seccomp")			// default filter built during make
#define PATH_SECCOMP_DEFAULT_DEBUG (LIBDIR "/firejail/seccomp.debug")	// default filter built during make
#define PATH_SECCOMP_32 (LIBDIR "/firejail/seccomp.32")			// 32bit arch filter built during make
#define PATH_SECCOMP_MDWX (LIBDIR "/firejail/seccomp.mdwx")		// filter for memory-deny-write-execute built during make
#define PATH_SECCOMP_BLOCK_SECONDARY (LIBDIR "/firejail/seccomp.block_secondary")	// secondary arch blocking filter built during make


#define RUN_DEV_DIR		"/run/firejail/mnt/dev"
#define RUN_DEVLOG_FILE	"/run/firejail/mnt/devlog"

#define RUN_WHITELIST_X11_DIR	"/run/firejail/mnt/orig-x11"
#define RUN_WHITELIST_HOME_DIR	"/run/firejail/mnt/orig-home"	// default home directory masking
#define RUN_WHITELIST_RUN_DIR	"/run/firejail/mnt/orig-run"	// default run directory masking
#define RUN_WHITELIST_HOME_USER_DIR	"/run/firejail/mnt/orig-home-user"	// home directory whitelisting
#define RUN_WHITELIST_RUN_USER_DIR	"/run/firejail/mnt/orig-run-user"	// run directory whitelisting
#define RUN_WHITELIST_TMP_DIR	"/run/firejail/mnt/orig-tmp"
#define RUN_WHITELIST_MEDIA_DIR	"/run/firejail/mnt/orig-media"
#define RUN_WHITELIST_MNT_DIR	"/run/firejail/mnt/orig-mnt"
#define RUN_WHITELIST_VAR_DIR	"/run/firejail/mnt/orig-var"
#define RUN_WHITELIST_DEV_DIR	"/run/firejail/mnt/orig-dev"
#define RUN_WHITELIST_OPT_DIR	"/run/firejail/mnt/orig-opt"
#define RUN_WHITELIST_SRV_DIR   "/run/firejail/mnt/orig-srv"
#define RUN_WHITELIST_ETC_DIR   "/run/firejail/mnt/orig-etc"
#define RUN_WHITELIST_SHARE_DIR   "/run/firejail/mnt/orig-share"
#define RUN_WHITELIST_MODULE_DIR   "/run/firejail/mnt/orig-module"

#define RUN_XAUTHORITY_FILE	"/run/firejail/mnt/.Xauthority"
#define RUN_XAUTHORITY_SEC_FILE	"/run/firejail/mnt/sec.Xauthority"
#define RUN_ASOUNDRC_FILE	"/run/firejail/mnt/.asoundrc"
#define RUN_HOSTNAME_FILE	"/run/firejail/mnt/hostname"
#define RUN_HOSTS_FILE	"/run/firejail/mnt/hosts"
#define RUN_MACHINEID	"/run/firejail/mnt/machine-id"
#define RUN_LDPRELOAD_FILE	"/run/firejail/mnt/ld.so.preload"
#define RUN_UTMP_FILE		"/run/firejail/mnt/utmp"
#define RUN_PASSWD_FILE		"/run/firejail/mnt/passwd"
#define RUN_GROUP_FILE		"/run/firejail/mnt/group"
#define RUN_FSLOGGER_FILE		"/run/firejail/mnt/fslogger"
#define RUN_UMASK_FILE		"/run/firejail/mnt/umask"
#define RUN_OVERLAY_ROOT	"/run/firejail/mnt/oroot"
#define RUN_READY_FOR_JOIN 	"/run/firejail/mnt/ready-for-join"

#endif

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
#ifndef FIREJAIL_H
#define FIREJAIL_H
#include "../include/common.h"
#include "../include/euid_common.h"
#include "../include/rundefs.h"
#include <stdarg.h>
#include <sys/stat.h>

// debug restricted shell
//#define DEBUG_RESTRICTED_SHELL



// profiles
#define DEFAULT_USER_PROFILE	"default"
#define DEFAULT_ROOT_PROFILE	"server"
#define MAX_INCLUDE_LEVEL 16		// include levels in profile files


#define ASSERT_PERMS(file, uid, gid, mode) \
	do { \
		assert(file);\
		struct stat s;\
		if (stat(file, &s) == -1) errExit("stat");\
		assert(s.st_uid == uid);\
		assert(s.st_gid == gid);\
		assert((s.st_mode & 07777) == (mode));\
	} while (0)
#define ASSERT_PERMS_FD(fd, uid, gid, mode) \
	do { \
		struct stat s;\
		if (fstat(fd, &s) == -1) errExit("fstat");\
		assert(s.st_uid == uid);\
		assert(s.st_gid == gid);\
		assert((s.st_mode & 07777) == (mode));\
	} while (0)
#define ASSERT_PERMS_STREAM(file, uid, gid, mode) \
	do { \
		int fd = fileno(file);\
		if (fd == -1) errExit("fileno");\
		ASSERT_PERMS_FD(fd, uid, gid, (mode));\
	} while (0)

#define SET_PERMS_FD(fd, uid, gid, mode) \
	do { \
		if (fchmod(fd, (mode)) == -1)	errExit("chmod");\
		if (fchown(fd, uid, gid) == -1) errExit("chown");\
	} while (0)
#define SET_PERMS_STREAM(stream, uid, gid, mode) \
	do { \
		int fd = fileno(stream);\
		if (fd == -1) errExit("fileno");\
		SET_PERMS_FD(fd, uid, gid, (mode));\
	} while (0)
#define SET_PERMS_STREAM_NOERR(stream, uid, gid, mode) \
	do { \
		int fd = fileno(stream);\
		if (fd == -1) continue;\
		int rv = fchmod(fd, (mode));\
		(void) rv;\
		rv = fchown(fd, uid, gid);\
		(void) rv;\
	} while (0)

// main.c
typedef struct bridge_t {
	// on the host
	char *dev;		// interface device name: bridge or regular ethernet
	uint32_t ip;		// interface device IP address
	uint32_t mask;		// interface device mask
	uint8_t mac[6];		// interface mac address
	int mtu;		// interface mtu

	char *veth_name;	// veth name for the device connected to the bridge

	// inside the sandbox
	char *devsandbox;	// name of the device inside the sandbox
	uint32_t ipsandbox;	// ip address inside the sandbox
	uint32_t masksandbox;	// network mask inside the sandbox
	char *ip6sandbox;	// ipv6 address inside the sandbox
	uint8_t macsandbox[6]; // mac address inside the sandbox
	uint32_t iprange_start;// iprange arp scan start range
	uint32_t iprange_end;	// iprange arp scan end range

	// flags
	uint8_t arg_ip_none;	// --ip=none
	uint8_t macvlan;	// set by --net=eth0 (or eth1, ...); reset by --net=br0 (or br1, ...)
	uint8_t configured;
	uint8_t scan;		// set by --scan
}  Bridge;

typedef struct interface_t {
	char *dev;
	uint32_t ip;
	uint32_t mask;
	uint8_t mac[6];
	int mtu;

	uint8_t configured;
} Interface;

typedef struct profile_entry_t {
	struct profile_entry_t *next;
	char *data;	// command

	// whitelist command parameters
	char *link;	// link name - set if the file is a link
	enum {
		WLDIR_HOME = 1,	// whitelist in home directory
		WLDIR_TMP,	// whitelist in /tmp directory
		WLDIR_MEDIA,	// whitelist in /media directory
		WLDIR_MNT,	// whitelist in /mnt directory
		WLDIR_VAR,	// whitelist in /var directory
		WLDIR_DEV,	// whitelist in /dev directory
		WLDIR_OPT,	// whitelist in /opt directory
		WLDIR_SRV,	// whitelist in /srv directory
		WLDIR_ETC,	// whitelist in /etc directory
		WLDIR_SHARE,	// whitelist in /usr/share directory
		WLDIR_MODULE,	// whitelist in /sys/module directory
		WLDIR_RUN	// whitelist in /run/user/$uid directory
	} wldir;
} ProfileEntry;

typedef struct config_t {
	// user data
	char *username;
	char *homedir;

	// filesystem
	ProfileEntry *profile;
#define MAX_PROFILE_IGNORE 32
	char *profile_ignore[MAX_PROFILE_IGNORE];
	char *chrootdir;	// chroot directory
	char *home_private;	// private home directory
	char *home_private_keep;	// keep list for private home directory
	char *etc_private_keep;	// keep list for private etc directory
	char *opt_private_keep;	// keep list for private opt directory
	char *srv_private_keep;	// keep list for private srv directory
	char *bin_private_keep;	// keep list for private bin directory
	char *bin_private_lib;	// executable list sent by private-bin to private-lib
	char *lib_private_keep;	// keep list for private bin directory
	char *cwd;		// current working directory
	char *overlay_dir;

	// networking
	char *name;		// sandbox name
	char *hostname;	// host name
	char *hosts_file;		// hosts file to be installed in the sandbox
	uint32_t defaultgw;	// default gateway
	Bridge bridge0;
	Bridge bridge1;
	Bridge bridge2;
	Bridge bridge3;
	Interface interface0;
	Interface interface1;
	Interface interface2;
	Interface interface3;
	char *dns1;	// up to 4 IP (v4/v6) addresses for dns servers
	char *dns2;
	char *dns3;
	char *dns4;

	// seccomp
	char *seccomp_list;//  optional seccomp list on top of default filter
	char *seccomp_list_drop;	// seccomp drop list
	char *seccomp_list_keep;	// seccomp keep list
	char *protocol;			// protocol list

	// rlimits
	long long unsigned rlimit_cpu;
	long long unsigned rlimit_nofile;
	long long unsigned rlimit_nproc;
	long long unsigned rlimit_fsize;
	long long unsigned rlimit_sigpending;
	long long unsigned rlimit_as;
	unsigned timeout;	// maximum time elapsed before killing the sandbox

	// cpu affinity, nice and control groups
	uint32_t cpus;
	int nice;
	char *cgroup;

	// command line
	char *command_line;
	char *window_title;
	char *command_name;
	char *shell;
	char **original_argv;
	int original_argc;
	int original_program_index;
} Config;
extern Config cfg;

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

static inline int any_bridge_configured(void) {
	if (cfg.bridge0.configured || cfg.bridge1.configured || cfg.bridge2.configured || cfg.bridge3.configured)
		return 1;
	else
		return 0;
}

static inline int any_interface_configured(void) {
	if (cfg.interface0.configured || cfg.interface1.configured || cfg.interface2.configured || cfg.interface3.configured)
		return 1;
	else
		return 0;
}

extern int arg_private;		// mount private /home
extern int arg_private_cache;	// private home/.cache
extern int arg_debug;		// print debug messages
extern int arg_debug_blacklists;	// print debug messages for blacklists
extern int arg_debug_whitelists;	// print debug messages for whitelists
extern int arg_debug_private_lib;	// print debug messages for private-lib
extern int arg_nonetwork;	// --net=none
extern int arg_command;	// -c
extern int arg_overlay;		// overlay option
extern int arg_overlay_keep;	// place overlay diff in a known directory
extern int arg_overlay_reuse;	// allow the reuse of overlays

extern int arg_seccomp;	// enable default seccomp filter
extern int arg_seccomp_postexec;	// need postexec ld.preload library?
extern int arg_seccomp_block_secondary;	// block any secondary architectures

extern int arg_caps_default_filter;	// enable default capabilities filter
extern int arg_caps_drop;		// drop list
extern int arg_caps_drop_all;		// drop all capabilities
extern int arg_caps_keep;		// keep list
extern char *arg_caps_list;		// optional caps list

extern int arg_trace;		// syscall tracing support
extern char *arg_tracefile;	// syscall tracing file
extern int arg_tracelog;	// blacklist tracing support
extern int arg_rlimit_cpu;	// rlimit cpu
extern int arg_rlimit_nofile;	// rlimit nofile
extern int arg_rlimit_nproc;	// rlimit nproc
extern int arg_rlimit_fsize;	// rlimit fsize
extern int arg_rlimit_sigpending;// rlimit sigpending
extern int arg_rlimit_as;	//rlimit as
extern int arg_nogroups;	// disable supplementary groups
extern int arg_nonewprivs;	// set the NO_NEW_PRIVS prctl
extern int arg_noroot;		// create a new user namespace and disable root user
extern int arg_netfilter;	// enable netfilter
extern int arg_netfilter6;	// enable netfilter6
extern char *arg_netfilter_file;	// netfilter file
extern char *arg_netfilter6_file;	// netfilter file
extern char *arg_netns;		// "ip netns"-created network namespace to use
extern int arg_doubledash;	// double dash
extern int arg_shell_none;	// run the program directly without a shell
extern int arg_private_dev;	// private dev directory
extern int arg_keep_dev_shm;    // preserve /dev/shm
extern int arg_private_etc;	// private etc directory
extern int arg_private_opt;	// private opt directory
extern int arg_private_srv;	// private srv directory
extern int arg_private_bin;	// private bin directory
extern int arg_private_tmp;	// private tmp directory
extern int arg_private_lib;	// private lib directory
extern int arg_private_cwd;	// private working directory
extern int arg_scan;		// arp-scan all interfaces
extern int arg_whitelist;	// whitelist command
extern int arg_nosound;	// disable sound
extern int arg_noautopulse; // disable automatic ~/.config/pulse init
extern int arg_novideo; //disable video devices in /dev
extern int arg_no3d;		// disable 3d hardware acceleration
extern int arg_quiet;		// no output for scripting
extern int arg_join_network;	// join only the network namespace
extern int arg_join_filesystem;	// join only the mount namespace
extern int arg_nice;		// nice value configured
extern int arg_ipc;		// enable ipc namespace
extern int arg_writable_etc;	// writable etc
extern int arg_writable_var;	// writable var
extern int arg_keep_var_tmp; // don't overwrite /var/tmp
extern int arg_writable_run_user;	// writable /run/user
extern int arg_writable_var_log; // writable /var/log
extern int arg_appimage;	// appimage
extern int arg_audit;		// audit
extern char *arg_audit_prog;	// audit
extern int arg_apparmor;	// apparmor
extern int arg_allow_debuggers;	// allow debuggers
extern int arg_x11_block;	// block X11
extern int arg_x11_xorg;	// use X11 security extension
extern int arg_allusers;	// all user home directories visible
extern int arg_machineid;	// preserve /etc/machine-id
extern int arg_disable_mnt;	// disable /mnt and /media
extern int arg_noprofile;	// use default.profile if none other found/specified
extern int arg_memory_deny_write_execute;	// block writable and executable memory
extern int arg_notv;	// --notv
extern int arg_nodvd;	// --nodvd
extern int arg_nou2f;   // --nou2f
extern int arg_nodbus; // -nodbus
extern int arg_deterministic_exit_code;	// always exit with first child's exit status

extern int login_shell;
extern int parent_to_child_fds[2];
extern int child_to_parent_fds[2];
extern pid_t sandbox_pid;
extern mode_t orig_umask;
extern unsigned long long start_timestamp;

#define MAX_ARGS 128		// maximum number of command arguments (argc)
extern char *fullargv[MAX_ARGS];
extern int fullargc;

// main.c
void check_user_namespace(void);
char *guess_shell(void);

// sandbox.c
int sandbox(void* sandbox_arg);
void start_application(int no_sandbox, FILE *fp);

// network_main.c
void net_configure_sandbox_ip(Bridge *br);
void net_configure_veth_pair(Bridge *br, const char *ifname, pid_t child);
void net_check_cfg(void);
void net_dns_print(pid_t pid);
void network_main(pid_t child);
void net_print(pid_t pid);

// network.c
int check_ip46_address(const char *addr);
void net_if_up(const char *ifname);
void net_if_down(const char *ifname);
void net_if_ip(const char *ifname, uint32_t ip, uint32_t mask, int mtu);
void net_if_ip6(const char *ifname, const char *addr6);
int net_get_if_addr(const char *bridge, uint32_t *ip, uint32_t *mask, uint8_t mac[6], int *mtu);
int net_add_route(uint32_t dest, uint32_t mask, uint32_t gw);
uint32_t network_get_defaultgw(void);
int net_config_mac(const char *ifname, const unsigned char mac[6]);
int net_get_mac(const char *ifname, unsigned char mac[6]);
void net_config_interface(const char *dev, uint32_t ip, uint32_t mask, int mtu);

// preproc.c
void preproc_build_firejail_dir(void);
void preproc_mount_mnt_dir(void);
void preproc_clean_run(void);

// fs.c
typedef enum {
	BLACKLIST_FILE,
	BLACKLIST_NOLOG,
	MOUNT_READONLY,
	MOUNT_TMPFS,
	MOUNT_NOEXEC,
	MOUNT_RDWR,
	OPERATION_MAX
} OPERATION;

// blacklist files or directories by mounting empty files on top of them
void fs_blacklist(void);
// mount a writable tmpfs
void fs_tmpfs(const char *dir, unsigned check_owner);
// remount noexec/nodev/nosuid or read-only or read-write
void fs_remount(const char *dir, OPERATION op, unsigned check_mnt);
void fs_remount_rec(const char *dir, OPERATION op, unsigned check_mnt);
// mount /proc and /sys directories
void fs_proc_sys_dev_boot(void);
// blacklist firejail configuration and runtime directories
void disable_config(void);
// build a basic read-only filesystem
void fs_basic_fs(void);
// mount overlayfs on top of / directory
char *fs_check_overlay_dir(const char *subdirname, int allow_reuse);
void fs_overlayfs(void);
void fs_private_tmp(void);
void fs_private_cache(void);
void fs_mnt(const int enforce);

// chroot.c
// chroot into an existing directory; mount existing /dev and update /etc/resolv.conf
void fs_check_chroot_dir(void);
void fs_chroot(const char *rootdir);

// profile.c
// find and read the profile specified by name from dir directory
int profile_find_firejail(const char *name, int add_ext);
// read a profile file
void profile_read(const char *fname);
// check profile line; if line == 0, this was generated from a command line option
// return 1 if the command is to be added to the linked list of profile commands
// return 0 if the command was already executed inside the function
int profile_check_line(char *ptr, int lineno, const char *fname);
// add a profile entry in cfg.profile list; use str to populate the list
void profile_add(char *str);
void profile_add_ignore(const char *str);

// list.c
void list(void);
void tree(void);
void top(void);
void netstats(void);

// usage.c
void usage(void);

// join.c
void join(pid_t pid, int argc, char **argv, int index);
pid_t switch_to_child(pid_t pid);

// shutdown.c
void shut(pid_t pid);

// restricted_shell.c
int restricted_shell(const char *user);

// arp.c
void arp_announce(const char *dev, Bridge *br);
// returns 0 if the address is not in use, -1 otherwise
int arp_check(const char *dev, uint32_t destaddr);
// assign an IP address using arp scanning
uint32_t arp_assign(const char *dev, Bridge *br);

// macros.c
char *expand_macros(const char *path);
char *resolve_macro(const char *name);
void invalid_filename(const char *fname, int globbing);
int is_macro(const char *name);
int macro_id(const char *name);


// util.c
void errLogExit(char* fmt, ...);
void fwarning(char* fmt, ...);
void fmessage(char* fmt, ...);
void drop_privs(int nogroups);
int mkpath_as_root(const char* path);
void extract_command_name(int index, char **argv);
void logsignal(int s);
void logmsg(const char *msg);
void logargs(int argc, char **argv) ;
void logerr(const char *msg);
void set_nice(int inc);
int copy_file(const char *srcname, const char *destname, uid_t uid, gid_t gid, mode_t mode);
void copy_file_as_user(const char *srcname, const char *destname, uid_t uid, gid_t gid, mode_t mode);
void copy_file_from_user_to_root(const char *srcname, const char *destname, uid_t uid, gid_t gid, mode_t mode);
void touch_file_as_user(const char *fname, mode_t mode);
int is_dir(const char *fname);
int is_link(const char *fname);
void trim_trailing_slash_or_dot(char *path);
char *line_remove_spaces(const char *buf);
char *split_comma(char *str);
char *clean_pathname(const char *path);
void check_unsigned(const char *str, const char *msg);
int find_child(pid_t parent, pid_t *child);
void check_private_dir(void);
void update_map(char *mapping, char *map_file);
void wait_for_other(int fd);
void notify_other(int fd);
const char *gnu_basename(const char *path);
uid_t pid_get_uid(pid_t pid);
uid_t get_group_id(const char *group);
int remove_overlay_directory(void);
void flush_stdin(void);
int create_empty_dir_as_user(const char *dir, mode_t mode);
void create_empty_dir_as_root(const char *dir, mode_t mode);
void create_empty_file_as_root(const char *dir, mode_t mode);
int set_perms(const char *fname, uid_t uid, gid_t gid, mode_t mode);
void mkdir_attr(const char *fname, mode_t mode, uid_t uid, gid_t gid);
unsigned extract_timeout(const char *str);
void disable_file_or_dir(const char *fname);
void disable_file_path(const char *path, const char *file);
int safe_fd(const char *path, int flags);
int invalid_sandbox(const pid_t pid);
int has_handler(pid_t pid, int signal);
void enter_network_namespace(pid_t pid);

// Get info regarding the last kernel mount operation from /proc/self/mountinfo
// The return value points to a static area, and will be overwritten by subsequent calls.
// The function does an exit(1) if anything goes wrong.
typedef struct {
	int mountid; // id of the mount
	char *fsname; // the pathname of the directory in the filesystem which forms the root of this mount
	char *dir;	// mount destination
	char *fstype; // filesystem type
} MountData;

// mountinfo.c
MountData *get_last_mount(void);
int get_mount_id(const char *path);
char **build_mount_array(const int mount_id, const char *path);

// fs_var.c
void fs_var_log(void);	// mounting /var/log
void fs_var_lib(void);	// various other fixes for software in /var directory
void fs_var_cache(void); // various other fixes for software in /var/cache directory
void fs_var_run(void);
void fs_var_lock(void);
void fs_var_tmp(void);
void fs_var_utmp(void);
void dbg_test_dir(const char *dir);

// fs_dev.c
void fs_dev_shm(void);
void fs_private_dev(void);
void fs_dev_disable_sound(void);
void fs_dev_disable_3d(void);
void fs_dev_disable_video(void);
void fs_dev_disable_tv(void);
void fs_dev_disable_dvd(void);
void fs_dev_disable_u2f(void);

// fs_home.c
// private mode (--private)
void fs_private(void);
// private mode (--private=homedir)
void fs_private_homedir(void);
// check new private home directory (--private= option) - exit if it fails
void fs_check_private_dir(void);
// check new private working directory (--private-cwd= option) - exit if it fails
void fs_check_private_cwd(const char *dir);
void fs_private_home_list(void);


// seccomp.c
char *seccomp_check_list(const char *str);
int seccomp_install_filters(void);
int seccomp_load(const char *fname);
int seccomp_filter_drop(void);
int seccomp_filter_keep(void);
void seccomp_print_filter(pid_t pid);

// caps.c
void seccomp_load_file_list(void);
int caps_default_filter(void);
void caps_print(void);
void caps_drop_all(void);
void caps_set(uint64_t caps);
void caps_check_list(const char *clist, void (*callback)(int));
void caps_drop_list(const char *clist);
void caps_keep_list(const char *clist);
void caps_print_filter(pid_t pid);
void caps_drop_dac_override(void);

// fs_trace.c
void fs_trace_preload(void);
void fs_tracefile(void);
void fs_trace(void);

// fs_hostname.c
void fs_hostname(const char *hostname);
void fs_resolvconf(void);
char *fs_check_hosts_file(const char *fname);
void fs_store_hosts_file(void);
void fs_mount_hosts_file(void);

// rlimit.c
void set_rlimits(void);

// cpu.c
void read_cpu_list(const char *str);
void set_cpu_affinity(void);
void load_cpu(const char *fname);
void save_cpu(void);
void cpu_print_filter(pid_t pid);

// cgroup.c
void save_cgroup(void);
void load_cgroup(const char *fname);
void set_cgroup(const char *path);

// output.c
void check_output(int argc, char **argv);

// netfilter.c
void check_netfilter_file(const char *fname);
void netfilter(const char *fname);
void netfilter6(const char *fname);
void netfilter_print(pid_t pid, int ipv6);

// netns.c
void check_netns(const char *nsname);
void netns(const char *nsname);
void netns_mounts(const char *nsname);

// bandwidth.c
void bandwidth_pid(pid_t pid, const char *command, const char *dev, int down, int up);
void network_set_run_file(pid_t pid);

// fs_etc.c
void fs_machineid(void);
void fs_private_dir_list(const char *private_dir, const char *private_run_dir, const char *private_list);

// no_sandbox.c
int check_namespace_virt(void);
int check_kernel_procs(void);
void run_no_sandbox(int argc, char **argv);

// env.c
typedef enum {
	SETENV = 0,
	RMENV
} ENV_OP;

void env_store(const char *str, ENV_OP op);
void env_apply(void);
void env_defaults(void);
void env_ibus_load(void);

// fs_whitelist.c
void fs_whitelist(void);

// pulseaudio.c
void pulseaudio_init(void);
void pulseaudio_disable(void);

// fs_bin.c
void fs_private_bin_list(void);

// fs_lib.c
void fs_private_lib(void);

// protocol.c
void protocol_filter_save(void);
void protocol_filter_load(const char *fname);
void protocol_print_filter(pid_t pid);

// restrict_users.c
void restrict_users(void);

// fs_logger.c
void fs_logger(const char *msg);
void fs_logger2(const char *msg1, const char *msg2);
void fs_logger2int(const char *msg1, int d);
void fs_logger3(const char *msg1, const char *msg2, const char *msg3);
void fs_logger_print(void);
void fs_logger_change_owner(void);
void fs_logger_print_log(pid_t pid);

// run_symlink.c
void run_symlink(int argc, char **argv, int run_as_is);

// paths.c
char **build_paths(void);
unsigned int count_paths(void);
int program_in_path(const char *program);

// fs_mkdir.c
void fs_mkdir(const char *name);
void fs_mkfile(const char *name);

// x11.c

// X11 display range as assigned by --x11 options
//     We try display numbers in the range 21 through 1000.
//     Normal X servers typically use displays in the 0-10 range;
//     ssh's X11 forwarding uses 10-20, and login screens
//     (e.g. gdm3) may use displays above 1000.
#define X11_DISPLAY_START 21
#define X11_DISPLAY_END 1000

void fs_x11(void);
int x11_display(void);
void x11_start(int argc, char **argv);
void x11_start_xpra(int argc, char **argv);
void x11_start_xephyr(int argc, char **argv);
void x11_block(void);
void x11_start_xvfb(int argc, char **argv);
void x11_xorg(void);

// ls.c
enum {
	SANDBOX_FS_LS = 0,
	SANDBOX_FS_GET,
	SANDBOX_FS_PUT,
	SANDBOX_FS_MAX // this should always be the last entry
};
void sandboxfs(int op, pid_t pid, const char *path1, const char *path2);

// checkcfg.c
#define DEFAULT_ARP_PROBES 2
enum {
	CFG_FILE_TRANSFER = 0,
	CFG_X11,
	CFG_BIND,
	CFG_USERNS,
	CFG_CHROOT,
	CFG_SECCOMP,
	CFG_NETWORK,
	CFG_RESTRICTED_NETWORK,
	CFG_FORCE_NONEWPRIVS,
	CFG_WHITELIST,
	CFG_XEPHYR_WINDOW_TITLE,
	CFG_OVERLAYFS,
	CFG_PRIVATE_HOME,
	CFG_PRIVATE_BIN_NO_LOCAL,
	CFG_FIREJAIL_PROMPT,
	CFG_FOLLOW_SYMLINK_AS_USER,
	CFG_DISABLE_MNT,
	CFG_JOIN,
	CFG_ARP_PROBES,
	CFG_XPRA_ATTACH,
	CFG_BROWSER_DISABLE_U2F,
	CFG_BROWSER_ALLOW_DRM,
	CFG_PRIVATE_LIB,
	CFG_APPARMOR,
	CFG_DBUS,
	CFG_PRIVATE_CACHE,
	CFG_CGROUP,
	CFG_NAME_CHANGE,
	// CFG_FILE_COPY_LIMIT - file copy limit handled using setenv/getenv
	CFG_MAX // this should always be the last entry
};
extern char *xephyr_screen;
extern char *xephyr_extra_params;
extern char *xpra_extra_params;
extern char *xvfb_screen;
extern char *xvfb_extra_params;
extern char *netfilter_default;
int checkcfg(int val);
void print_compiletime_support(void);

// appimage.c
void appimage_set(const char *appimage_path);
void appimage_clear(void);
const char *appimage_getdir(void);

// appimage_size.c
long unsigned int appimage2_size(const char *fname);

// cmdline.c
void build_cmdline(char **command_line, char **window_title, int argc, char **argv, int index);
void build_appimage_cmdline(char **command_line, char **window_title, int argc, char **argv, int index, char *apprun_path);

// sbox.c
// programs
#define PATH_FNET_MAIN (LIBDIR "/firejail/fnet")		// when called from main thread
#define PATH_FNET (RUN_FIREJAIL_LIB_DIR "/fnet")	// when called from sandbox thread

//#define PATH_FNETFILTER (LIBDIR "/firejail/fnetfilter")
#define PATH_FNETFILTER (RUN_FIREJAIL_LIB_DIR "/fnetfilter")

#define PATH_FIREMON (PREFIX "/bin/firemon")
#define PATH_FIREJAIL (PREFIX "/bin/firejail")

#define PATH_FSECCOMP_MAIN (LIBDIR "/firejail/fseccomp")		// when called from main thread
#define PATH_FSECCOMP ( RUN_FIREJAIL_LIB_DIR "/fseccomp")	// when called from sandbox thread

// FSEC_PRINT is run outside of sandbox by --seccomp.print
// it is also run from inside the sandbox by --debug; in this case we do an access(filename, X_OK) test first
#define PATH_FSEC_PRINT (LIBDIR "/firejail/fsec-print")

//#define PATH_FSEC_OPTIMIZE (LIBDIR "/firejail/fsec-optimize")
#define PATH_FSEC_OPTIMIZE (RUN_FIREJAIL_LIB_DIR "/fsec-optimize")

//#define PATH_FCOPY (LIBDIR "/firejail/fcopy")
#define PATH_FCOPY (RUN_FIREJAIL_LIB_DIR "/fcopy")

#define SBOX_STDIN_FILE "/run/firejail/mnt/sbox_stdin"

//#define PATH_FLDD (LIBDIR "/firejail/fldd")
#define PATH_FLDD (RUN_FIREJAIL_LIB_DIR "/fldd")

// bitmapped filters for sbox_run
#define SBOX_ROOT (1 << 0)			// run the sandbox as root
#define SBOX_USER (1 << 1)			// run the sandbox as a regular user
#define SBOX_SECCOMP (1 << 2)		// install seccomp
#define SBOX_CAPS_NONE (1 << 3)		// drop all capabilities
#define SBOX_CAPS_NETWORK (1 << 4)	// caps filter for programs running network programs
#define SBOX_ALLOW_STDIN (1 << 5)		// don't close stdin
#define SBOX_STDIN_FROM_FILE (1 << 6)	// open file and redirect it to stdin
#define SBOX_CAPS_HIDEPID (1 << 7)	// hidepid caps filter for running firemon

// run sbox
int sbox_run(unsigned filter, int num, ...);

// run_files.c
void delete_run_files(pid_t pid);
void delete_bandwidth_run_file(pid_t pid);
void set_name_run_file(pid_t pid);
void set_x11_run_file(pid_t pid, int display);
void set_profile_run_file(pid_t pid, const char *fname);

// dbus.c
void dbus_disable(void);

#endif

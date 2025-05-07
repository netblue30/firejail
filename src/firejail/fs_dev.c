/*
 * Copyright (C) 2014-2025 Firejail Authors
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
#include <sys/stat.h>
#include <assert.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <glob.h>
#include <libgen.h>
#include <pwd.h>
#ifndef _BSD_SOURCE
#define _BSD_SOURCE
#endif
#include <sys/sysmacros.h>
#include <sys/types.h>

// device type
typedef enum {
	DEV_NONE = 0,
	DEV_SOUND,
	DEV_3D,
	DEV_VIDEO,
	DEV_TV,
	DEV_DVD,
	DEV_TPM,
	DEV_U2F,
	DEV_INPUT,
	DEV_NTSYNC,
	DEV_MAX
} DEV_TYPE;

typedef struct {
	DEV_TYPE type;
	const char *str;
} DevTypeStr;

static DevTypeStr dev_type_str[] = {
	{DEV_NONE, "none"},
	{DEV_SOUND, "sound"},
	{DEV_3D, "3d"},
	{DEV_VIDEO, "video"},
	{DEV_TV, "tv"},
	{DEV_DVD, "dvd"},
	{DEV_TPM, "tpm"},
	{DEV_U2F, "u2f"},
	{DEV_INPUT, "input"},
	{DEV_NTSYNC, "ntsync"},
	{DEV_MAX, "max"}
};

typedef struct {
	const char *dev_pattern;
	const char *run_pattern;
	DEV_TYPE type;
} DevEntry;

static DevEntry dev[] = {
	{"/dev/snd", RUN_DEV_DIR "/snd", DEV_SOUND}, // sound device
	{"/dev/dri", RUN_DEV_DIR "/dri", DEV_3D}, // 3d devices
	{"/dev/kfd", RUN_DEV_DIR "/kfd", DEV_3D},
	{"/dev/nvidia[0-9]*", RUN_DEV_DIR "/nvidia[0-9]*", DEV_3D},
	{"/dev/nvidiactl", RUN_DEV_DIR "/nvidiactl", DEV_3D},
	{"/dev/nvidia-modeset", RUN_DEV_DIR "/nvidia-modeset", DEV_3D},
	{"/dev/nvidia-uvm", RUN_DEV_DIR "/nvidia-uvm", DEV_3D},
	{"/dev/video[0-9]*", RUN_DEV_DIR "/video[0-9]*", DEV_VIDEO}, // video camera devices
	{"/dev/dvb", RUN_DEV_DIR "/dvb", DEV_TV}, // DVB (Digital Video Broadcasting) - TV device
	{"/dev/sr[0-9]*", RUN_DEV_DIR "/sr[0-9]*", DEV_DVD}, // for DVD and audio CD players
	{"/dev/tcm[0-9]*", RUN_DEV_DIR "/tcm[0-9]*", DEV_TPM}, // TCM (Trusted Cryptography Module) devices
	{"/dev/tcmrm[0-9]*", RUN_DEV_DIR "/tcmrm[0-9]*", DEV_TPM},
	{"/dev/tpm[0-9]*", RUN_DEV_DIR "/tpm[0-9]*", DEV_TPM}, // TPM (Trusted Platform Module) devices
	{"/dev/tpmrm[0-9]*", RUN_DEV_DIR "/tpmrm[0-9]*", DEV_TPM},
	{"/dev/hidraw[0-9]*", RUN_DEV_DIR "/hidraw[0-9]*", DEV_U2F},
	{"/dev/usb", RUN_DEV_DIR "/usb", DEV_U2F}, // USB devices such as Yubikey, U2F
	{"/dev/input", RUN_DEV_DIR "/input", DEV_INPUT},
	{"/dev/ntsync", RUN_DEV_DIR "/ntsync", DEV_NTSYNC},
	{NULL, NULL, DEV_NONE}
};

// check device type and subsystem configuration
static int should_mount(DEV_TYPE type) {
	int ret =
	    (type == DEV_SOUND && arg_nosound == 0) ||
	    (type == DEV_3D && arg_no3d == 0) ||
	    (type == DEV_VIDEO && arg_novideo == 0) ||
	    (type == DEV_TV && arg_notv == 0) ||
	    (type == DEV_DVD && arg_nodvd == 0) ||
	    (type == DEV_TPM && arg_keep_dev_tpm == 1) ||
	    (type == DEV_U2F && arg_nou2f == 0) ||
	    (type == DEV_INPUT && arg_noinput == 0) ||
	    (type == DEV_NTSYNC && arg_keep_dev_ntsync == 1);

	return ret;
}

static void deventry_mount(const char *source,
                           const char *target, DEV_TYPE type) {
	assert(source);
	assert(target);
	assert(type >= DEV_NONE && type < DEV_MAX);

	const char *typestr = dev_type_str[type].str;
	struct stat s;
	if (stat(source, &s) == -1) {
		if (arg_debug) {
			printf("cannot stat %s (type=%s): %s, ignoring\n",
			       source, typestr, strerror(errno));
		}
		return;
	}

	if (!should_mount(type)) {
		if (arg_debug) {
			printf("skipping %s on %s due to its type (type=%s)\n",
			       source, target, typestr);
		}
		return;
	}

	int dir = is_dir(source);
	if (arg_debug) {
		printf("mounting %s on %s (type=%s) %s\n", source, target,
		       typestr, (dir) ? "directory" : "file");
	}
	if (dir) {
		mkdir_attr(target, 0755, 0, 0);
	}
	else {
		struct stat s;
		if (stat(source, &s) == -1) {
			if (arg_debug) {
				fwarning("cannot stat %s (type=%s) file: %s\n",
				         source, typestr, strerror(errno));
			}
			return;
		}
		FILE *fp = fopen(target, "we");
		if (fp) {
			fprintf(fp, "\n");
			SET_PERMS_STREAM(fp, s.st_uid, s.st_gid, s.st_mode);
			fclose(fp);
		}
	}

	if (mount(source, target, NULL, MS_BIND|MS_REC, NULL) < 0) {
		fprintf(stderr, "Error: failed to mount %s on %s (type=%s)\n",
		        source, target, typestr);
		errExit("mounting dev file");
	}
	fs_logger2("whitelist", target);
}

// For every path in source_pattern, mount it on the dirname of target_pattern.
//
// Example:
//
//     deventry_mount_glob("/run/foo*", "/dev/foo*") ->
//                   mount("/run/foo1", "/dev/foo1")
//                   mount("/run/foo2", "/dev/foo2")
//                   ...
static void deventry_mount_glob(const char *source_pattern,
                                const char *target_pattern, DEV_TYPE type) {
	assert(source_pattern);
	assert(target_pattern);
	assert(type >= DEV_NONE && type < DEV_MAX);

	const char *typestr = dev_type_str[type].str;
	if (arg_debug) {
		printf("Globbing %s on %s (type=%s)\n", source_pattern,
		       target_pattern, typestr);
	}

	// sanity check to avoid arguments like ("/run/foo*", "/dev/bar*")
	const char *source_pattern_base = gnu_basename(source_pattern);
	const char *target_pattern_base = gnu_basename(target_pattern);
	if (strcmp(source_pattern_base, target_pattern_base) != 0) {
		fprintf(stderr, "Error: patterns do not match: %s / %s (type=%s)\n",
		        source_pattern_base, target_pattern_base, typestr);
		exit(1);
	}

	EUID_USER();
	glob_t globbuf;
	int globerr = glob(source_pattern, 0, NULL, &globbuf);
	EUID_ROOT();
	if (globerr == GLOB_NOMATCH) {
		if (arg_debug) {
			printf("No match %s (type=%s)\n", source_pattern,
			       typestr);
		}
		return;
	} else if (globerr) {
		fwarning("failed to glob pattern %s (type=%s): %s\n",
		         source_pattern, typestr, strerror(errno));
		return;
	}

	// strdup for dirname
	char *tmp = strdup(target_pattern);
	if (!tmp)
		errExit("strdup");
	const char *target_dir = dirname(tmp);
	if (strcmp(target_dir, ".") == 0 ||
	    strcmp(target_dir, "..") == 0) {
		fprintf(stderr, "Error: invalid target_dir: %s -> %s (type=%s)\n",
		        target_pattern, target_dir, typestr);
		exit(1);
	}

	size_t i;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		const char *source = globbuf.gl_pathv[i];
		assert(source);

		const char *source_base = gnu_basename(source);
		if (strcmp(source_base, ".") == 0 ||
		    strcmp(source_base, "..") == 0) {
			fprintf(stderr, "Error: invalid source_base: %s -> %s -> %s (type=%s)\n",
			        source_pattern, source, source_base, typestr);
			exit(1);
		}

		char *target = NULL;
		if (asprintf(&target, "%s/%s", target_dir, source_base) == -1)
			errExit("asprintf");

		deventry_mount(source, target, type);
		free(target);
	}

	free(tmp);
	globfree(&globbuf);
}

// Note: By the time that this function is called for private-dev, RUN_DEV_DIR
// points to the real /dev directory and tmpfs is mounted on top of /dev, so
// run_pattern is the source path and dev_pattern is the target path when
// bind-mounting.
static void deventry_mount_all(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		deventry_mount_glob(dev[i].run_pattern, dev[i].dev_pattern,
		                    dev[i].type);
		i++;
	}
}

static void create_char_dev(const char *path, mode_t mode, int major, int minor) {
	dev_t device = makedev(major, minor);
	if (mknod(path, S_IFCHR | mode, device) == -1)
		goto errexit;
	if (chmod(path, mode) < 0)
		goto errexit;
	ASSERT_PERMS(path, 0, 0, mode);
	fs_logger2("create", path);

	return;

errexit:
	fprintf(stderr, "Error: cannot create %s device: %s\n", path, strerror(errno));
	exit(1);
}

static void create_link(const char *oldpath, const char *newpath) {
	if (symlink(oldpath, newpath) == -1) {
		fprintf(stderr, "Error: cannot create %s device\n", newpath);
		exit(1);
	}
	fs_logger2("create", newpath);
	return;
}

static void empty_dev_shm(void) {
	// create an empty /dev/shm directory
	mkdir_attr("/dev/shm", 01777, 0, 0);
	selinux_relabel_path("/dev/shm", "/dev/shm");
	fs_logger("mkdir /dev/shm");
	fs_logger("create /dev/shm");
}

static void mount_dev_shm(void) {
	mkdir_attr("/dev/shm", 01777, 0, 0);
	int rv = mount(RUN_DEV_DIR "/shm", "/dev/shm", "none", MS_BIND, "mode=01777,gid=0");
	if (rv == -1) {
		fwarning("cannot mount the old /dev/shm in private-dev\n");
		empty_dev_shm();
		return;
	}
}

static void process_dev_shm(void) {
	// Jack audio keeps an Unix socket under (/dev/shm/jack_default_1000_0 or /dev/shm/jack/...)
	// looking for jack socket
	EUID_USER();
	glob_t globbuf;
	int globerr = glob(RUN_DEV_DIR "/shm/jack*", GLOB_NOSORT, NULL, &globbuf);
	EUID_ROOT();
	if (globerr && !arg_keep_dev_shm) {
		empty_dev_shm();
		return;
	}
	globfree(&globbuf);

	// if we got here, it means we have a jack server installed
	// mount-bind the old /dev/shm
	mount_dev_shm();
}

void fs_private_dev(void) {
	// install a new /dev directory
	if (arg_debug)
		printf("Mounting tmpfs on /dev\n");

	// create DRI_DIR
	// keep a copy of dev directory
	mkdir_attr(RUN_DEV_DIR, 0755, 0, 0);
	if (mount("/dev", RUN_DEV_DIR, NULL, MS_BIND|MS_REC, NULL) < 0)
		errExit("mounting /dev");

	// create DEVLOG_FILE
	int have_devlog = 0;
	struct stat s;
	if (stat("/dev/log", &s) == 0) {
		have_devlog = 1;
		FILE *fp = fopen(RUN_DEVLOG_FILE, "we");
		if (!fp)
			have_devlog = 0;
		else {
			fprintf(fp, "\n");
			fclose(fp);
			if (mount("/dev/log", RUN_DEVLOG_FILE, NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mounting /dev/log");
		}
	}

	// mount tmpfs on top of /dev
	if (mount("tmpfs", "/dev", "tmpfs", MS_NOSUID | MS_STRICTATIME, "mode=755,gid=0") < 0)
		errExit("mounting /dev");
	fs_logger("tmpfs /dev");
	selinux_relabel_path("/dev", "/dev");

	// optional devices: sound, video cards etc...
	deventry_mount_all();

	// bring back /dev/log
	if (have_devlog) {
		FILE *fp = fopen("/dev/log", "we");
		if (fp) {
			fprintf(fp, "\n");
			fclose(fp);
			if (mount(RUN_DEVLOG_FILE, "/dev/log", NULL, MS_BIND|MS_REC, NULL) < 0)
				errExit("mounting /dev/log");
			fs_logger("clone /dev/log");
		}
		if (mount(RUN_RO_FILE, RUN_DEVLOG_FILE, "none", MS_BIND, "mode=400,gid=0") < 0)
			errExit("blacklisting " RUN_DEVLOG_FILE);
	}

	// bring forward the current /dev/shm directory if necessary
	if (arg_debug)
		printf("Process /dev/shm directory\n");
	process_dev_shm();

	if (mount(RUN_RO_DIR, RUN_DEV_DIR, "none", MS_BIND, "mode=400,gid=0") < 0)
		errExit("disable run dev directory");

	// create default devices
	create_char_dev("/dev/zero", 0666, 1, 5); // mknod -m 666 /dev/zero c 1 5
	fs_logger("mknod /dev/zero");
	selinux_relabel_path("/dev/zero", "/dev/zero");
	create_char_dev("/dev/null", 0666, 1, 3); // mknod -m 666 /dev/null c 1 3
	fs_logger("mknod /dev/null");
	selinux_relabel_path("/dev/null", "/dev/null");
	create_char_dev("/dev/full", 0666, 1, 7); // mknod -m 666 /dev/full c 1 7
	fs_logger("mknod /dev/full");
	selinux_relabel_path("/dev/full", "/dev/full");
	create_char_dev("/dev/random", 0666, 1, 8); // Mknod -m 666 /dev/random c 1 8
	fs_logger("mknod /dev/random");
	selinux_relabel_path("/dev/random", "/dev/random");
	create_char_dev("/dev/urandom", 0666, 1, 9); // mknod -m 666 /dev/urandom c 1 9
	fs_logger("mknod /dev/urandom");
	selinux_relabel_path("/dev/urandom", "/dev/urandom");
	create_char_dev("/dev/tty", 0666, 5, 0); // mknod -m 666 /dev/tty c 5 0
	fs_logger("mknod /dev/tty");
	selinux_relabel_path("/dev/tty", "/dev/tty");
#if 0
	create_dev("/dev/tty0", "mknod -m 666 /dev/tty0 c 4 0");
	create_dev("/dev/console", "mknod -m 622 /dev/console c 5 1");
#endif

	// pseudo-terminal
	mkdir_attr("/dev/pts", 0755, 0, 0);
	fs_logger("mkdir /dev/pts");
	selinux_relabel_path("/dev/pts", "/dev/pts");
	fs_logger("create /dev/pts");
	create_char_dev("/dev/pts/ptmx", 0666, 5, 2); //"mknod -m 666 /dev/pts/ptmx c 5 2");
	selinux_relabel_path("/dev/pts/ptmx", "/dev/pts/ptmx");
	fs_logger("mknod /dev/pts/ptmx");
	create_link("/dev/pts/ptmx", "/dev/ptmx");
	selinux_relabel_path("/dev/ptmx", "/dev/ptmx");

// code before github issue #351
	// mount -vt devpts -o newinstance -o ptmxmode=0666 devpts //dev/pts
//	if (mount("devpts", "/dev/pts", "devpts", MS_MGC_VAL, "newinstance,ptmxmode=0666") < 0)
//		errExit("mounting /dev/pts");

	// mount /dev/pts
	gid_t ttygid = get_group_id("tty");
	char *data;
	if (asprintf(&data, "newinstance,gid=%d,mode=620,ptmxmode=0666", (int) ttygid) == -1)
		errExit("asprintf");
	if (mount("devpts", "/dev/pts", "devpts", MS_MGC_VAL, data) < 0)
		errExit("mounting /dev/pts");
	free(data);
	fs_logger("clone /dev/pts");

	// stdin, stdout, stderr
	create_link("/proc/self/fd", "/dev/fd");
	selinux_relabel_path("/dev/fd", "/dev/fd");
	create_link("/proc/self/fd/0", "/dev/stdin");
	selinux_relabel_path("/dev/stdin", "/dev/stdin");
	create_link("/proc/self/fd/1", "/dev/stdout");
	selinux_relabel_path("/dev/stdout", "/dev/stdout");
	create_link("/proc/self/fd/2", "/dev/stderr");
	selinux_relabel_path("/dev/stderr", "/dev/stderr");

	// symlinks for DVD/CD players
	if (stat("/dev/sr0", &s) == 0) {
		create_link("/dev/sr0", "/dev/cdrom");
		selinux_relabel_path("/dev/cdrom", "/dev/cdrom");
		create_link("/dev/sr0", "/dev/cdrw");
		selinux_relabel_path("/dev/cdrw", "/dev/cdrw");
		create_link("/dev/sr0", "/dev/dvd");
		selinux_relabel_path("/dev/dvd", "/dev/dvd");
		create_link("/dev/sr0", "/dev/dvdrw");
		selinux_relabel_path("/dev/dvdrw", "/dev/dvdrw");
	}
}

void fs_dev_disable_glob(const char *pattern, DEV_TYPE type,
                         int skip_symlinks) {
	assert(pattern);
	assert(type >= DEV_NONE && type < DEV_MAX);

	const char *typestr = dev_type_str[type].str;
	if (arg_debug) {
		printf("Globbing %s (type=%s skip_symlinks=%d)\n", pattern,
		       typestr, skip_symlinks);
	}

	EUID_USER();
	glob_t globbuf;
	int globerr = glob(pattern, 0, NULL, &globbuf);
	EUID_ROOT();
	if (globerr == GLOB_NOMATCH) {
		if (arg_debug)
			printf("No match %s (type=%s)\n", pattern, typestr);
		return;
	} else if (globerr) {
		fwarning("failed to glob pattern %s (type=%s): %s\n", pattern,
		         typestr, strerror(errno));
		return;
	}

	size_t i;
	for (i = 0; i < globbuf.gl_pathc; i++) {
		char *path = globbuf.gl_pathv[i];
		assert(path);

		if (skip_symlinks && is_link(path)) {
			fwarning("skipping %s because it is a symbolic link (type=%s)\n",
			         pattern, path);
			continue;
		}
		disable_file_or_dir(path);
	}

	globfree(&globbuf);
}

void fs_dev_disable_sound(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_SOUND)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_SOUND, 0);
		i++;
	}

	// disable all jack sockets in /dev/shm
	fs_dev_disable_glob("/dev/shm/jack*", DEV_SOUND, 1);
}

void fs_dev_disable_video(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_VIDEO)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_VIDEO, 0);
		i++;
	}
}

void fs_dev_disable_3d(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_3D)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_3D, 0);
		i++;
	}
}

void fs_dev_disable_tv(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_TV)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_TV, 0);
		i++;
	}
}

void fs_dev_disable_dvd(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_DVD)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_DVD, 0);
		i++;
	}
}

void fs_dev_disable_tpm(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_TPM)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_TPM, 0);
		i++;
	}
}

void fs_dev_disable_u2f(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_U2F)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_U2F, 0);
		i++;
	}
}

void fs_dev_disable_input(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_INPUT)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_INPUT, 0);
		i++;
	}
}

void fs_dev_disable_ntsync(void) {
	int i = 0;
	while (dev[i].dev_pattern != NULL) {
		if (dev[i].type == DEV_NTSYNC)
			fs_dev_disable_glob(dev[i].dev_pattern, DEV_NTSYNC, 0);
		i++;
	}
}

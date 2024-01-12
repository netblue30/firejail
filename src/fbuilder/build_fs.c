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

#include "fbuilder.h"

// common file processing function, using the callback for each line in the file
static void process_file(const char *fname, const char *dir, void (*callback)(char *)) {
	assert(fname);
	assert(dir);
	assert(callback);

	int dir_len = strlen(dir);

	// process trace file
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", fname);
		exit(1);
	}

	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fp)) {
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// parse line: 4:galculator:access /etc/fonts/conf.d:0
		// number followed by :
		ptr = buf;
		if (!isdigit(*ptr))
			continue;
		while (isdigit(*ptr))
			ptr++;
		if (*ptr != ':')
			continue;
		ptr++;

		// next :
		ptr = strchr(ptr, ':');
		if (!ptr)
			continue;
		ptr++;
		if (strncmp(ptr, "access ", 7) == 0)
			ptr +=  7;
		else if (strncmp(ptr, "fopen ", 6) == 0)
			ptr += 6;
		else if (strncmp(ptr, "fopen64 ", 8) == 0)
			ptr += 8;
		else if (strncmp(ptr, "open64 ", 7) == 0)
			ptr += 7;
		else if (strncmp(ptr, "open ", 5) == 0)
			ptr += 5;
		else if (strncmp(ptr, "opendir ", 8) == 0)
			ptr += 8;
		else if (strncmp(ptr, "connect ", 8) == 0) {
			ptr += 8;
			// file descriptor argument
			if (!isdigit(*ptr))
				continue;
			while (isdigit(*ptr))
				ptr++;
			if (*ptr++ != ' ')
				continue;
			if (*ptr != '/')
				continue;
		}
		else
			continue;

		if (strncmp(ptr, dir, dir_len) != 0)
			continue;

		// end of filename
		char *ptr2 = strchr(ptr, ':');
		if (!ptr2)
			continue;
		*ptr2 = '\0';

		callback(ptr);
	}

	fclose(fp);
}

// process fname, fname.1, fname.2, fname.3, fname.4, fname.5
static void process_files(const char *fname, const char *dir, void (*callback)(char *)) {
	assert(fname);
	assert(dir);
	assert(callback);

	// run fname
	process_file(fname, dir, callback);

	// run all the rest
	struct stat s;
	int i;
	for (i = 1; i <= 5; i++) {
		char *newname;
		if (asprintf(&newname, "%s.%d", fname, i) == -1)
			errExit("asprintf");
		if (stat(newname, &s) == 0)
			process_file(newname, dir, callback);
		free(newname);
	}
}

//*******************************************
// etc directory
//*******************************************
static FileDB *etc_out = NULL;

static void etc_callback(char *ptr) {
	// skip firejail directory
	if (strncmp(ptr, "/etc/firejail", 13) == 0)
		return;

	// extract the directory:
	assert(strncmp(ptr, "/etc", 4) == 0);
	ptr += 4;
	if (*ptr != '/')
		return;
	ptr++;

	if (*ptr == '/')	// double '/'
		ptr++;
	if (*ptr == '\0')
		return;

	// add only top files and directories
	char *end = strchr(ptr, '/');
	if (end)
		*end = '\0';
	etc_out = filedb_add(etc_out, ptr);
}

void build_etc(const char *fname, FILE *fp) {
	assert(fname);

	process_files(fname, "/etc", etc_callback);

	fprintf(fp, "private-etc ");
	if (etc_out == NULL)
		fprintf(fp, "none\n");
	else {
		FileDB *ptr = etc_out;
		while (ptr) {
			fprintf(fp, "%s,", ptr->fname);
			ptr = ptr->next;
		}
		fprintf(fp, "\n");
	}
}

//*******************************************
// var directory
//*******************************************
#if 0
// todo: load the list from whitelist-var-common.inc
static char *var_skip[] = {
	"/var/lib/ca-certificates",
	"/var/lib/dbus",
	"/var/lib/menu-xdg",
	"/var/lib/uim",
	"/var/cache/fontconfig",
	"/var/tmp",
	"/var/run",
	"/var/lock",
	NULL
};
#endif
static FileDB *var_out = NULL;
static FileDB *var_skip = NULL;
static void var_callback(char *ptr) {
	// skip /var/lib/flatpak, /var/lib/snapd directory
	if (strncmp(ptr, "/var/lib/flatpak", 16) == 0 ||
	    strncmp(ptr, "/var/lib/snapd", 14) == 0)
		return;

	// extract the directory:
	assert(strncmp(ptr, "/var", 4) == 0);
	char *p1 = ptr + 4;
	if (*p1 != '/')
		return;
	p1++;

	if (*p1 == '/')	// double '/'
		p1++;
	if (*p1 == '\0')
		return;

	if (!filedb_find(var_skip, p1))
		var_out = filedb_add(var_out, p1);
}

void build_var(const char *fname, FILE *fp) {
	assert(fname);

	var_skip = filedb_load_whitelist(var_skip, "whitelist-var-common.inc", "whitelist /var/");
	process_files(fname, "/var", var_callback);

	// always whitelist /var
	if (var_out)
		filedb_print(var_out, "whitelist /var/", fp);
	fprintf(fp, "include whitelist-var-common.inc\n");
}

//*******************************************
// run directory
//*******************************************
static FileDB *run_out = NULL;
static FileDB *run_skip = NULL;
static void run_callback(char *ptr) {
	// skip /run/firejail
	if (strncmp(ptr, "/run/firejail", 13) == 0)
		return;
	// skip files in /run/user
	if (strncmp(ptr, "/run/user", 9) == 0)
		return;

	// extract the directory:
	assert(strncmp(ptr, "/run", 4) == 0);
	char *p1 = ptr + 4;
	if (*p1 != '/')
		return;
	p1++;

	if (*p1 == '/')	// double '/'
		p1++;
	if (*p1 == '\0')
		return;

	if (!filedb_find(run_skip, p1))
		run_out = filedb_add(run_out, p1);
}

void build_run(const char *fname, FILE *fp) {
	assert(fname);

	run_skip = filedb_load_whitelist(run_skip, "whitelist-run-common.inc", "whitelist /run/");
	process_files(fname, "/run", run_callback);

	// always whitelist /run
	if (run_out)
		filedb_print(run_out, "whitelist /run/", fp);
	fprintf(fp, "include whitelist-run-common.inc\n");
}

//*******************************************
// ${RUNUSER} directory
//*******************************************
static char *runuser_fname = NULL;
static FileDB *runuser_out = NULL;
static FileDB *runuser_skip = NULL;
static void runuser_callback(char *ptr) {
	// extract the directory:
	assert(runuser_fname);
	assert(strncmp(ptr, runuser_fname, strlen(runuser_fname)) == 0);
	char *p1 = ptr + strlen(runuser_fname);
	if (*p1 != '/')
		return;
	p1++;

	if (*p1 == '/')	// double '/'
		p1++;
	if (*p1 == '\0')
		return;

	if (!filedb_find(runuser_skip, p1))
		runuser_out = filedb_add(runuser_out, p1);
}

void build_runuser(const char *fname, FILE *fp) {
	assert(fname);

	if (asprintf(&runuser_fname, "/run/user/%d", getuid()) < 0)
		errExit("asprintf");

	if (!is_dir(runuser_fname))
		return;

	runuser_skip = filedb_load_whitelist(runuser_skip, "whitelist-runuser-common.inc", "whitelist ${RUNUSER}/");
	process_files(fname, runuser_fname, runuser_callback);

	// always whitelist /run/user/$UID
	if (runuser_out)
		filedb_print(runuser_out, "whitelist ${RUNUSER}/", fp);
	fprintf(fp, "include whitelist-runuser-common.inc\n");
}

//*******************************************
// usr/share directory
//*******************************************
static FileDB *share_out = NULL;
static FileDB *share_skip = NULL;
static void share_callback(char *ptr) {
	// extract the directory:
	assert(strncmp(ptr, "/usr/share", 10) == 0);
	char *p1 = ptr + 10;
	if (*p1 != '/')
		return;
	p1++;
	if (*p1 == '/')	// double '/'
		p1++;
	if (*p1 == '\0')
		return;

	// "/usr/share/bash-completion/bash_completion"  becomes "/usr/share/bash-completion"
	char *p2 = strchr(p1, '/');
	if (p2)
		*p2 = '\0';


	if (!filedb_find(share_skip, p1))
		share_out = filedb_add(share_out, p1);
}

void build_share(const char *fname, FILE *fp) {
	assert(fname);

	share_skip = filedb_load_whitelist(share_skip, "whitelist-usr-share-common.inc", "whitelist /usr/share/");
	process_files(fname, "/usr/share", share_callback);

	// always whitelist /usr/share
	if (share_out)
		filedb_print(share_out, "whitelist /usr/share/", fp);
	fprintf(fp, "include whitelist-usr-share-common.inc\n");
}

//*******************************************
// tmp directory
//*******************************************
static FileDB *tmp_out = NULL;
static void tmp_callback(char *ptr) {
	if (strncmp(ptr, "/tmp/runtime-", 13) == 0)
		return;
	if (strcmp(ptr, "/tmp") == 0)
		return;

	tmp_out = filedb_add(tmp_out, ptr);
}

void build_tmp(const char *fname, FILE *fp) {
	assert(fname);

	process_files(fname, "/tmp", tmp_callback);

	if (tmp_out == NULL)
		fprintf(fp, "private-tmp\n");
	else {
		fprintf(fp, "#private-tmp\n");
		fprintf(fp, "# File accessed in /tmp directory:\n");
		fprintf(fp, "# ");
		FileDB *ptr = tmp_out;
		while (ptr) {
			fprintf(fp, "%s,", ptr->fname);
			ptr = ptr->next;
		}
		printf("\n");
	}
}

//*******************************************
// dev directory
//*******************************************
static char *dev_skip[] = {
	"/dev/stdin",
	"/dev/stdout",
	"/dev/stderr",
	"/dev/zero",
	"/dev/null",
	"/dev/full",
	"/dev/random",
	"/dev/srandom",
	"/dev/urandom",
	"/dev/sr0",
	"/dev/cdrom",
	"/dev/cdrw",
	"/dev/dvd",
	"/dev/dvdrw",
	"/dev/fd",
	"/dev/pts",
	"/dev/ptmx",
	"/dev/log",
	"/dev/shm",

	"/dev/aload",	// old ALSA devices, not covered in private-dev
	"/dev/dsp",		// old OSS device, deprecated

	"/dev/tty",
	"/dev/snd",
	"/dev/dri",
	"/dev/nvidia",
	"/dev/video",
	"/dev/dvb",
	"/dev/hidraw",
	"/dev/usb",
	"/dev/input",
	NULL
};

static FileDB *dev_out = NULL;
static void dev_callback(char *ptr) {
	// skip private-dev devices
	int i = 0;
	int found = 0;
	while (dev_skip[i]) {
		if (strncmp(ptr, dev_skip[i], strlen(dev_skip[i])) == 0) {
			found = 1;
			break;
		}
		i++;
	}
	if (!found)
		dev_out = filedb_add(dev_out, ptr);
}

void build_dev(const char *fname, FILE *fp) {
	assert(fname);

	process_files(fname, "/dev", dev_callback);

	if (dev_out == NULL)
		fprintf(fp, "private-dev\n");
	else {
		fprintf(fp, "#private-dev\n");
		fprintf(fp, "# This is the list of devices accessed on top of regular private-dev devices:\n");
		fprintf(fp, "# ");
		FileDB *ptr = dev_out;
		while (ptr) {
			fprintf(fp, "%s,", ptr->fname);
			ptr = ptr->next;
		}
		fprintf(fp, "\n");
	}
}

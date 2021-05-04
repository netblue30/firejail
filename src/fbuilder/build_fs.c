/*
 * Copyright (C) 2014-2021 Firejail Authors
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

	// add only top files and directories
	ptr += 5;	// skip "/etc/"
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
static FileDB *var_out = NULL;
static void var_callback(char *ptr) {
	if (strcmp(ptr, "/var/lib") == 0)
		;
	else if (strcmp(ptr, "/var/cache") == 0)
		;
	else if (strncmp(ptr, "/var/lib/menu-xdg", 17) == 0)
		var_out = filedb_add(var_out, "/var/lib/menu-xdg");
	else if (strncmp(ptr, "/var/cache/fontconfig", 21) == 0)
		var_out = filedb_add(var_out, "/var/cache/fontconfig");
	else
		var_out = filedb_add(var_out, ptr);
}

void build_var(const char *fname, FILE *fp) {
	assert(fname);

	process_files(fname, "/var", var_callback);

	if (var_out == NULL) {
		fprintf(fp, "blacklist /var\n");
	} else {
		filedb_print(var_out, "whitelist ", fp);
		fprintf(fp, "include whitelist-var-common.inc\n");
	}
}


//*******************************************
// usr/share directory
//*******************************************
// todo: load the list from whitelist-usr-share-common.inc
static char *share_skip[] = {
	"/usr/share/alsa",
	"/usr/share/applications",
	"/usr/share/ca-certificates",
	"/usr/share/crypto-policies",
	"/usr/share/cursors",
	"/usr/share/dconf",
	"/usr/share/distro-info",
	"/usr/share/drirc.d",
	"/usr/share/enchant",
	"/usr/share/enchant-2",
	"/usr/share/file",
	"/usr/share/fontconfig",
	"/usr/share/fonts",
	"/usr/share/fonts-config",
	"/usr/share/gir-1.0",
	"/usr/share/gjs-1.0",
	"/usr/share/glib-2.0",
	"/usr/share/glvnd",
	"/usr/share/gtk-2.0",
	"/usr/share/gtk-3.0",
	"/usr/share/gtk-engines",
	"/usr/share/gtksourceview-3.0",
	"/usr/share/gtksourceview-4",
	"/usr/share/hunspell",
	"/usr/share/hwdata",
	"/usr/share/icons",
	"/usr/share/icu",
	"/usr/share/knotifications5",
	"/usr/share/kservices5",
	"/usr/share/Kvantum",
	"/usr/share/kxmlgui5",
	"/usr/share/libdrm",
	"/usr/share/libthai",
	"/usr/share/locale",
	"/usr/share/mime",
	"/usr/share/misc",
	"/usr/share/Modules",
	"/usr/share/myspell",
	"/usr/share/p11-kit",
	"/usr/share/perl",
	"/usr/share/perl5",
	"/usr/share/pixmaps",
	"/usr/share/pki",
	"/usr/share/plasma",
	"/usr/share/publicsuffix",
	"/usr/share/qt",
	"/usr/share/qt4",
	"/usr/share/qt5",
	"/usr/share/qt5ct",
	"/usr/share/sounds",
	"/usr/share/tcl8.6",
	"/usr/share/tcltk",
	"/usr/share/terminfo",
	"/usr/share/texlive",
	"/usr/share/texmf",
	"/usr/share/themes",
	"/usr/share/thumbnail.so",
	"/usr/share/uim",
	"/usr/share/vulkan",
	"/usr/share/X11",
	"/usr/share/xml",
	"/usr/share/zenity",
	"/usr/share/zoneinfo",
	NULL
};

static FileDB *share_out = NULL;
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

	int i = 0;
	int found = 0;
	while (share_skip[i]) {
		if (strncmp(ptr, share_skip[i], strlen(share_skip[i])) == 0) {
			found = 1;
			break;
		}
		i++;
	}
	if (!found)
		share_out = filedb_add(share_out, ptr);
}

void build_share(const char *fname, FILE *fp) {
	assert(fname);

	process_files(fname, "/usr/share", share_callback);

	if (share_out == NULL) {
		fprintf(fp, "blacklist /usr/share\n");
	} else {
		filedb_print(share_out, "whitelist ", fp);
		fprintf(fp, "include whitelist-usr-share-common.inc\n");
	}
}

//*******************************************
// tmp directory
//*******************************************
static FileDB *tmp_out = NULL;
static void tmp_callback(char *ptr) {
	// skip strace file
	if (strncmp(ptr, "/tmp/firejail-strace", 20) == 0)
		return;
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

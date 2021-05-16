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

#include "firejail.h"
#include "../include/pid.h"
#define BUFLEN 4096

static void delete_x11_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_X11_DIR, pid) == -1)
		errExit("asprintf");
	int rv = unlink(fname);
	(void) rv;
	free(fname);
}

static void delete_profile_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_PROFILE_DIR, pid) == -1)
		errExit("asprintf");
	int rv = unlink(fname);
	(void) rv;
	free(fname);
}

static void delete_name_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_NAME_DIR, pid) == -1)
		errExit("asprintf");
	int rv = unlink(fname);
	(void) rv;
	free(fname);
}

void delete_bandwidth_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d-bandwidth", RUN_FIREJAIL_BANDWIDTH_DIR, (int) pid) == -1)
		errExit("asprintf");
	unlink(fname);
	free(fname);
}

static void delete_network_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d-netmap", RUN_FIREJAIL_NETWORK_DIR, (int) pid) == -1)
		errExit("asprintf");
	unlink(fname);
	free(fname);
}



void delete_run_files(pid_t pid) {
	delete_bandwidth_run_file(pid);
	delete_network_run_file(pid);
	delete_name_run_file(pid);
	delete_x11_run_file(pid);
	delete_profile_run_file(pid);
}

static char *newname(char *name) {
	char *rv = name;
	pid_t pid;

	if (checkcfg(CFG_NAME_CHANGE)) {
		// try the name
		if (name2pid(name, &pid))
			return name;

		// return name-pid
		if (asprintf(&rv, "%s-%d", name, getpid()) == -1)
			errExit("asprintf");
	}

	return rv;
}


void set_name_run_file(pid_t pid) {
	cfg.name = newname(cfg.name);

	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_NAME_DIR, pid) == -1)
		errExit("asprintf");

	// the file is deleted first
	FILE *fp = fopen(fname, "we");
	if (!fp) {
		fprintf(stderr, "Error: cannot create %s\n", fname);
		exit(1);
	}
	fprintf(fp, "%s\n", cfg.name);

	// mode and ownership
	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
}


void set_x11_run_file(pid_t pid, int display) {
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_X11_DIR, pid) == -1)
		errExit("asprintf");

	// the file is deleted first
	FILE *fp = fopen(fname, "we");
	if (!fp) {
		fprintf(stderr, "Error: cannot create %s\n", fname);
		exit(1);
	}
	fprintf(fp, "%d\n", display);

	// mode and ownership
	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
}

void set_profile_run_file(pid_t pid, const char *fname) {
	char *runfile;
	if (asprintf(&runfile, "%s/%d", RUN_FIREJAIL_PROFILE_DIR, pid) == -1)
		errExit("asprintf");

	EUID_ROOT();
	// the file is deleted first
	FILE *fp = fopen(runfile, "we");
	if (!fp) {
		fprintf(stderr, "Error: cannot create %s\n", runfile);
		exit(1);
	}
	fprintf(fp, "%s\n", fname);

	// mode and ownership
	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
	EUID_USER();
	free(runfile);
}

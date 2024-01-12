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
#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <net/if.h>
#include "firejail.h"

//***********************************
// interface bandwidth linked list
//***********************************
typedef struct ifbw_t {
	struct ifbw_t *next;
	char *txt;
} IFBW;
IFBW *ifbw = NULL;


#if 0
static void ifbw_print(void) {
	IFBW *ptr = ifbw;
	while (ptr) {
		printf("#%s#\n", ptr->txt);
		ptr = ptr->next;
	}
}
#endif

static void ifbw_add(IFBW *ptr) {
	assert(ptr);

	if (ifbw != NULL)
		ptr->next = ifbw;
	ifbw = ptr;
}


IFBW *ifbw_find(const char *dev) {
	assert(dev);
	int len = strlen(dev);
	assert(len);

	if (ifbw == NULL)
		return NULL;

	IFBW *ptr = ifbw;
	while (ptr) {
		if (strncmp(ptr->txt, dev, len) == 0 && ptr->txt[len] == ':')
			return ptr;
		ptr = ptr->next;
	}

	return NULL;
}

void ifbw_remove(IFBW *r) {
	if (ifbw == NULL)
		return;

	// remove the first element
	if (ifbw == r) {
		ifbw = ifbw->next;
		return;
	}

	// walk the list
	IFBW *ptr = ifbw->next;
	IFBW *prev = ifbw;
	while (ptr) {
		if (ptr == r) {
			prev->next = ptr->next;
			return;
		}

		prev = ptr;
		ptr = ptr->next;
	}

	return;
}

int fibw_count(void) {
	int rv = 0;
	IFBW *ptr = ifbw;

	while (ptr) {
		rv++;
		ptr = ptr->next;
	}

	return rv;
}


//***********************************
// run file handling
//***********************************
static void bandwidth_create_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d-bandwidth", RUN_FIREJAIL_BANDWIDTH_DIR, (int) pid) == -1)
		errExit("asprintf");

	// create an empty file and set mod and ownership
	// if the file already exists, do nothing
	FILE *fp = fopen(fname, "wxe");
	free(fname);
	if (!fp) {
		if (errno == EEXIST)
			return;
		fprintf(stderr, "Error: cannot create bandwidth file\n");
		exit(1);
	}

	SET_PERMS_STREAM(fp, 0, 0, 0644);
	fclose(fp);
}


void network_set_run_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "%s/%d-netmap", RUN_FIREJAIL_NETWORK_DIR, (int) pid) == -1)
		errExit("asprintf");

	// create an empty file and set mod and ownership
	FILE *fp = fopen(fname, "we");
	if (fp) {
		if (cfg.bridge0.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge0.dev, cfg.bridge0.devsandbox);
		if (cfg.bridge1.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge1.dev, cfg.bridge1.devsandbox);
		if (cfg.bridge2.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge2.dev, cfg.bridge2.devsandbox);
		if (cfg.bridge3.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge3.dev, cfg.bridge3.devsandbox);

		SET_PERMS_STREAM(fp, 0, 0, 0644);
		fclose(fp);
	}
	else {
		fprintf(stderr, "Error: cannot create network map file\n");
		exit(1);
	}

	free(fname);
}


static void read_bandwidth_file(pid_t pid) {
	assert(ifbw == NULL);

	char *fname;
	if (asprintf(&fname, "%s/%d-bandwidth", RUN_FIREJAIL_BANDWIDTH_DIR, (int) pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "re");
	if (fp) {
		char buf[1024];
		while (fgets(buf, 1024,fp)) {
			// remove '\n'
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			if (strlen(buf) == 0)
				continue;

			// create a new IFBW entry
			IFBW *ifbw_new = malloc(sizeof(IFBW));
			if (!ifbw_new)
				errExit("malloc");
			memset(ifbw_new, 0, sizeof(IFBW));
			ifbw_new->txt = strdup(buf);
			if (!ifbw_new->txt)
				errExit("strdup");

			// add it to the linked list
			ifbw_add(ifbw_new);
		}

		fclose(fp);
	}
}

static void write_bandwidth_file(pid_t pid) {
	if (ifbw == NULL)
		return; // nothing to do

	char *fname;
	if (asprintf(&fname, "%s/%d-bandwidth", RUN_FIREJAIL_BANDWIDTH_DIR, (int) pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "we");
	if (fp) {
		IFBW *ptr = ifbw;
		while (ptr) {
			if (fprintf(fp, "%s\n", ptr->txt) < 0)
				goto errout;
			ptr = ptr->next;
		}
		fclose(fp);
	}
	else
		goto errout;
	return;

errout:
	fprintf(stderr, "Error: cannot write bandwidth file %s\n", fname);
	exit(1);
}

//***********************************
// add or remove interfaces
//***********************************

// remove interface from run file
void bandwidth_remove(pid_t pid, const char *dev) {
	bandwidth_create_run_file(pid);

	// read bandwidth file
	read_bandwidth_file(pid);

	// find the element and remove it
	IFBW *elem = ifbw_find(dev);
	if (elem) {
		ifbw_remove(elem);
		write_bandwidth_file(pid) ;
	}

	// remove the file if there are no entries in the list
	if (ifbw == NULL)
		 delete_bandwidth_run_file(pid);
}

// add interface to run file
void bandwidth_set(pid_t pid, const char *dev, int down, int up) {
	// create bandwidth directory & file in case they are not in the filesystem yet
	bandwidth_create_run_file(pid);

	// create the new text entry
	char *txt;
	if (asprintf(&txt, "%s: RX %dKB/s, TX %dKB/s", dev, down, up) == -1)
		errExit("asprintf");

	// read bandwidth file
	read_bandwidth_file(pid);

	// look for an existing entry and replace the text
	IFBW *ptr = ifbw_find(dev);
	if (ptr) {
		assert(ptr->txt);
		free(ptr->txt);
		ptr->txt = txt;
	}
	// ... or add a new entry
	else {
		IFBW *ifbw_new = malloc(sizeof(IFBW));
		if (!ifbw_new)
			errExit("malloc");
		memset(ifbw_new, 0, sizeof(IFBW));
		ifbw_new->txt = txt;

		// add it to the linked list
		ifbw_add(ifbw_new);
	}
	write_bandwidth_file(pid) ;
}


//***********************************
// command execution
//***********************************
void bandwidth_pid(pid_t pid, const char *command, const char *dev, int down, int up) {
	EUID_ASSERT();
	enter_network_namespace(pid);

	//************************
	// build command
	//************************
	char *devname = NULL;
	if (dev) {
		// read network map file
		char *fname;
		if (asprintf(&fname, "%s/%d-netmap", RUN_FIREJAIL_NETWORK_DIR, (int) pid) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "re");
		if (!fp) {
			fprintf(stderr, "Error: cannot read network map file %s\n", fname);
			exit(1);
		}

		char buf[1024];
		int len = strlen(dev);
		while (fgets(buf, 1024, fp)) {
			// remove '\n'
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			if (*buf == '\0')
				break;

			if (strncmp(buf, dev, len) == 0  && buf[len] == ':') {
				devname = strdup(buf + len + 1);
				if (!devname)
					errExit("strdup");
				// double-check device name
				size_t i;
				for (i = 0; devname[i]; i++) {
					if (isalnum((unsigned char) devname[i]) == 0 &&
					    devname[i] != '-') {
						fprintf(stderr, "Error: name of network device is invalid\n");
						exit(1);
					}
				}
				// check device in namespace
				if (if_nametoindex(devname) == 0) {
					fprintf(stderr, "Error: cannot find network device %s\n", devname);
					exit(1);
				}
				break;
			}
		}
		free(fname);
		fclose(fp);
	}

	// set run file
	if (strcmp(command, "set") == 0) {
		if (devname == NULL) {
			fprintf(stderr, "Error: cannot find a %s interface inside the sandbox\n", dev);
			exit(1);
		}
		bandwidth_set(pid, devname, down, up);
	}
	else if (strcmp(command, "clear") == 0) {
		if (devname == NULL) {
			fprintf(stderr, "Error: cannot find a %s interface inside the sandbox\n", dev);
			exit(1);
		}
		bandwidth_remove(pid, devname);
	}
	else assert(strcmp(command, "status") == 0);

	// build fshaper.sh command
	char *cmd = NULL;
	if (devname) {
		if (strcmp(command, "set") == 0) {
			if (asprintf(&cmd, "%s/firejail/fshaper.sh --%s %s %d %d",
				LIBDIR, command, devname, down, up) == -1)
				errExit("asprintf");
		}
		else {
			if (asprintf(&cmd, "%s/firejail/fshaper.sh --%s %s",
				LIBDIR, command, devname) == -1)
				errExit("asprintf");
		}
	}
	else {
		if (asprintf(&cmd, "%s/firejail/fshaper.sh --%s", LIBDIR, command) == -1)
			errExit("asprintf");
	}
	assert(cmd);

	//************************
	// build command
	//************************
	char *arg[4];
	arg[0] = "/bin/sh";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	clearenv();
	sbox_exec_v(SBOX_ROOT | SBOX_CAPS_NETWORK | SBOX_SECCOMP, arg);

	// it will never get here!!
}

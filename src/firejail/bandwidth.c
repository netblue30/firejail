/*
 * Copyright (C) 2014, 2015 Firejail Authors
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
// shm file handling
//***********************************
void shm_create_firejail_dir(void) {
	struct stat s;
	if (stat("/dev/shm/firejail", &s) == -1) {
		/* coverity[toctou] */
		if (mkdir("/dev/shm/firejail", 0777) == -1)
			errExit("mkdir");
		if (chown("/dev/shm/firejail", 0, 0) == -1)
			errExit("chown");
	}
	else { // check /dev/shm/firejail directory belongs to root end exit if doesn't!
		if (s.st_uid != 0 || s.st_gid != 0) {
			fprintf(stderr, "Error: non-root %s directory, exiting...\n", "/dev/shm/firejail");
			exit(1);
		}
	}
}

static void shm_create_bandwidth_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-bandwidth", (int) pid) == -1)
		errExit("asprintf");
	
	// if the file already exists, do nothing
	struct stat s;
	if (stat(fname, &s) == 0) {
		free(fname);
		return;
	}

	// create an empty file and set mod and ownership
	/* coverity[toctou] */
	FILE *fp = fopen(fname, "w");
	if (fp) {
		fclose(fp);
	
		/* coverity[toctou] */
		if (chmod(fname, 0644) == -1)
			errExit("chmod");
		/* coverity[toctou] */
		if (chown(fname, 0, 0) == -1)
			errExit("chown");
	}
	else {
		fprintf(stderr, "Error: cannot create bandwidth file in /dev/shm/firejail directory\n");
		exit(1);
	}
	
	free(fname);
}

// delete shm bandwidth file
void bandwidth_shm_del_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-bandwidth", (int) pid) == -1)
		errExit("asprintf");
	unlink(fname);
	free(fname);
}

void network_shm_del_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-netmap", (int) pid) == -1)
		errExit("asprintf");
	unlink(fname);
	free(fname);
}

void network_shm_set_file(pid_t pid) {
	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-netmap", (int) pid) == -1)
		errExit("asprintf");
	
	// create an empty file and set mod and ownership
	FILE *fp = fopen(fname, "w");
	if (fp) {
		if (cfg.bridge0.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge0.dev, cfg.bridge0.devsandbox);
		if (cfg.bridge1.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge1.dev, cfg.bridge1.devsandbox);
		if (cfg.bridge2.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge2.dev, cfg.bridge2.devsandbox);
		if (cfg.bridge3.configured)
			fprintf(fp, "%s:%s\n", cfg.bridge3.dev, cfg.bridge3.devsandbox);
		fclose(fp);

		if (chmod(fname, 0644) == -1)
			errExit("chmod");
		if (chown(fname, 0, 0) == -1)
			errExit("chown");
	}
	else {
		fprintf(stderr, "Error: cannot create network map file in /dev/shm/firejail directory\n");
		exit(1);
	}
	
	free(fname);
}


void shm_read_bandwidth_file(pid_t pid) {
	assert(ifbw == NULL);

	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-bandwidth", (int) pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "r");
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

void shm_write_bandwidth_file(pid_t pid) {
	if (ifbw == NULL)
		return; // nothing to do

	char *fname;
	if (asprintf(&fname, "/dev/shm/firejail/%d-bandwidth", (int) pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(fname, "w");
	if (fp) {
		IFBW *ptr = ifbw;
		while (ptr) {
			fprintf(fp, "%s\n", ptr->txt);
			ptr = ptr->next;
		}
		fclose(fp);
	}
	else {
		fprintf(stderr, "Error: cannot write bandwidht file %s\n", fname);
		exit(1);
	}
}

//***********************************
// add or remove interfaces
//***********************************

// remove interface from shm file
void bandwidth_shm_remove(pid_t pid, const char *dev) {
	// create bandwidth directory & file in case they are not in the filesystem yet
	shm_create_firejail_dir();
	shm_create_bandwidth_file(pid);
	
	// read bandwidth file
	shm_read_bandwidth_file(pid);
	
	// find the element and remove it
	IFBW *elem = ifbw_find(dev);
	if (elem) {
		ifbw_remove(elem);
		shm_write_bandwidth_file(pid) ;
	}
	
	// remove the file if there are no entries in the list
	if (ifbw == NULL) {
		bandwidth_shm_del_file(pid);
	}
}

// add interface to shm file
void bandwidth_shm_set(pid_t pid, const char *dev, int down, int up) {
	// create bandwidth directory & file in case they are not in the filesystem yet
	shm_create_firejail_dir();
	shm_create_bandwidth_file(pid);

	// create the new text entry
	char *txt;
	if (asprintf(&txt, "%s: RX %dKB/s, TX %dKB/s", dev, down, up) == -1)
		errExit("asprintf");
	
	// read bandwidth file
	shm_read_bandwidth_file(pid);

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
	shm_write_bandwidth_file(pid) ;
}


//***********************************
// command execution
//***********************************
void bandwidth_name(const char *name, const char *command, const char *dev, int down, int up) {
	if (!name || strlen(name) == 0) {
		fprintf(stderr, "Error: invalid sandbox name\n");
		exit(1);
	}
	pid_t pid;
	if (name2pid(name, &pid)) {
		fprintf(stderr, "Error: cannot find sandbox %s\n", name);
		exit(1);
	}

	bandwidth_pid(pid, command, dev, down, up);
}

void bandwidth_pid(pid_t pid, const char *command, const char *dev, int down, int up) {
	//************************
	// verify sandbox
	//************************
	char *comm = pid_proc_comm(pid);
	if (!comm) {
		fprintf(stderr, "Error: cannot find sandbox\n");
		exit(1);
	}

	// remove \n and check for firejail sandbox
	char *ptr = strchr(comm, '\n');
	if (ptr)
		*ptr = '\0';
	if (strcmp(comm, "firejail") != 0) {
		fprintf(stderr, "Error: cannot find sandbox\n");
		exit(1);
	}
	free(comm);
	
	// check network namespace
	char *cmd = pid_proc_cmdline(pid);
	if (!cmd || strstr(cmd, "--net") == NULL) {
		fprintf(stderr, "Error: the sandbox doesn't use a new network namespace\n");
		exit(1);
	}
	free(cmd);


	//************************
	// join the network namespace
	//************************
	pid_t child;
	if (find_child(pid, &child) == -1) {
		fprintf(stderr, "Error: cannot join the network namespace\n");
		exit(1);
	}
	if (join_namespace(child, "net")) {
		fprintf(stderr, "Error: cannot join the network namespace\n");
		exit(1);
	}

	// set shm file
	if (strcmp(command, "set") == 0)
		bandwidth_shm_set(pid, dev, down, up);
	else if (strcmp(command, "clear") == 0)
		bandwidth_shm_remove(pid, dev);

	//************************
	// build command
	//************************
	char *devname = NULL;
	if (dev) {
		// read shm network map file
		char *fname;
		if (asprintf(&fname, "/dev/shm/firejail/%d-netmap", (int) pid) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Error: cannot read netowk map filel %s\n", fname);
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
	
	// build fshaper.sh command
	cmd = NULL;
	if (devname) {
		if (strcmp(command, "set") == 0) {
			if (asprintf(&cmd, "%s/lib/firejail/fshaper.sh --%s %s %d %d",
				PREFIX, command, devname, down, up) == -1)
				errExit("asprintf");
		}
		else {
			if (asprintf(&cmd, "%s/lib/firejail/fshaper.sh --%s %s", 
				PREFIX, command, devname) == -1)
				errExit("asprintf");
		}
	}
	else {
		if (asprintf(&cmd, "%s/lib/firejail/fshaper.sh --%s", PREFIX, command) == -1)
			errExit("asprintf");
	}
	assert(cmd);

	// wipe out environment variables
	environ = NULL;

	//************************
	// build command
	//************************
	// elevate privileges
	if (setreuid(0, 0))
		errExit("setreuid");
	if (setregid(0, 0))
		errExit("setregid");

	char *arg[4];
	arg[0] = "/bin/bash";
	arg[1] = "-c";
	arg[2] = cmd;
	arg[3] = NULL;
	execvp("/bin/bash", arg);
	
	// it will never get here
	exit(0);		
}

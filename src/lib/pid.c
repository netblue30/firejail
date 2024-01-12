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

#include "../include/common.h"
#include "../include/pid.h"
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <pwd.h>
#include <sys/ioctl.h>
#include <dirent.h>

#define PIDS_BUFLEN 4096
//Process pids[max_pids];
Process *pids = NULL;
int max_pids=32769; // recalculated for every read_pid() call

// get the memory associated with this pid
void pid_getmem(unsigned pid, unsigned *rss, unsigned *shared) {
	// open stat file
	char *file;
	if (asprintf(&file, "/proc/%u/statm", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		return;
	}
	free(file);

	unsigned a, b, c;
	if (3 != fscanf(fp, "%u %u %u", &a, &b, &c)) {
		fclose(fp);
		return;
	}
	*rss += b;
	*shared += c;
	fclose(fp);
}


void pid_get_cpu_time(unsigned pid, unsigned *utime, unsigned *stime) {
	// open stat file
	char *file;
	if (asprintf(&file, "/proc/%u/stat", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		return;
	}
	free(file);

	char line[PIDS_BUFLEN];
	if (fgets(line, PIDS_BUFLEN - 1, fp)) {
		char *ptr = line;
		// jump 13 fields

		// end of comm string
		ptr = strchr(ptr, ')');
		if (ptr == NULL)
			goto myexit;

		int i;
		for (i = 0; i < 11; i++) {
			while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0')
				ptr++;
			if (*ptr == '\0')
				goto myexit;
			ptr++;
		}
		if (2 != sscanf(ptr, "%u %u", utime, stime))
			goto myexit;
	}

myexit:
	fclose(fp);
}

unsigned long long pid_get_start_time(unsigned pid) {
	// open stat file
	char *file;
	if (asprintf(&file, "/proc/%u/stat", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		return 0;
	}
	free(file);

	char line[PIDS_BUFLEN];
	unsigned long long retval = 0;
	if (fgets(line, PIDS_BUFLEN - 1, fp)) {
		char *ptr = line;
		// jump 21 fields
		int i;
		for (i = 0; i < 21; i++) {
			while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0')
				ptr++;
			if (*ptr == '\0')
				goto myexit;
			ptr++;
		}
		if (1 != sscanf(ptr, "%llu", &retval))
			goto myexit;
	}

myexit:
	fclose(fp);
	return retval;
}

char *pid_get_user_name(uid_t uid) {
	struct passwd *pw = getpwuid(uid);
	if (pw)
		return strdup(pw->pw_name);
	return NULL;
}

uid_t pid_get_uid(pid_t pid) {
	uid_t rv = 0;

	// open status file
	char *file;
	if (asprintf(&file, "/proc/%u/status", pid) == -1)
		errExit("asprintf");

	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		return 0;
	}

	// extract uid
	char buf[PIDS_BUFLEN];
	while (fgets(buf, PIDS_BUFLEN - 1, fp)) {
		if (strncmp(buf, "Uid:", 4) == 0) {
			char *ptr = buf + 4;
			while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
				ptr++;
			}
			if (*ptr == '\0')
				goto doexit;

			rv = atoi(ptr);
			break; // break regardless!
		}
	}
doexit:
	fclose(fp);
	free(file);
	return rv;
}

// todo: RUN_FIREJAIL_NAME_DIR is borrowed from src/firejail/firejail.h
// move it in a common place
#define RUN_FIREJAIL_NAME_DIR	"/run/firejail/name"

static void print_elem(unsigned index, int nowrap) {
	// get terminal size
	struct winsize sz;
	int col = 0;
	if (isatty(STDIN_FILENO)) {
		if (!ioctl(0, TIOCGWINSZ, &sz))
			col  = sz.ws_col;
	}

	// indent
	char indent[(pids[index].level - 1) * 2 + 1];
	memset(indent, ' ', sizeof(indent));
	indent[(pids[index].level - 1) * 2] = '\0';

	// get data
	uid_t uid = pids[index].uid;
	char *cmd = pid_proc_cmdline(index);
	char *user = pid_get_user_name(uid);
	char *user_allocated = user;

	char *cmd_escaped = escape_cntrl_chars(cmd);
	if (cmd_escaped) {
		free(cmd);
		cmd = cmd_escaped;
	}

	// extract sandbox name - pid == index
	char *sandbox_name = "";
	char *sandbox_name_allocated = NULL;
	char *fname;
	if (asprintf(&fname, "%s/%d", RUN_FIREJAIL_NAME_DIR, index) == -1)
		errExit("asprintf");
	struct stat s;
	if (stat(fname, &s) == 0) {
		FILE *fp = fopen(fname, "r");
		if (fp) {
			sandbox_name = malloc(s.st_size + 1);
			if (!sandbox_name)
				errExit("malloc");
			sandbox_name_allocated = sandbox_name;
			char *rv = fgets(sandbox_name, s.st_size + 1, fp);
			if (!rv)
				*sandbox_name = '\0';
			else {
				char *ptr = strchr(sandbox_name, '\n');
				if (ptr)
					*ptr = '\0';
			}
			fclose(fp);
		}
	}
	free(fname);

	if (user == NULL)
		user = "";
	if (cmd) {
		if (col < 4 || nowrap)
			printf("%s%u:%s:%s:%s\n", indent, index, user, sandbox_name, cmd);
		else {
			char *out;
			if (asprintf(&out, "%s%u:%s:%s:%s\n", indent, index, user, sandbox_name, cmd) == -1)
				errExit("asprintf");
			int len = strlen(out);
			if (len > col) {
				out[col] = '\0';
				out[col - 1] = '\n';
			}
			printf("%s", out);
			free(out);
		}

		free(cmd);
	}
	else {
		if (pids[index].zombie)
			printf("%s%u: (zombie)\n", indent, index);
		else
			printf("%s%u:\n", indent, index);
	}
	if (user_allocated)
		free(user_allocated);
	if (sandbox_name_allocated)
		free(sandbox_name_allocated);
}

// recursivity!!!
void pid_print_tree(unsigned index, unsigned parent, int nowrap) {
	print_elem(index, nowrap);

	// Remove unused parameter warning
	(void)parent;

	unsigned i;
	for (i = index + 1; i < (unsigned)max_pids; i++) {
		if (pids[i].parent == (pid_t)index)
			pid_print_tree(i, index, nowrap);
	}

	for (i = 0; i < index; i++) {
		if (pids[i].parent == (pid_t)index)
			pid_print_tree(i, index, nowrap);
	}
}

void pid_print_list(unsigned index, int nowrap) {
	print_elem(index, nowrap);
}

// mon_pid: pid of sandbox to be monitored, 0 if all sandboxes are included
void pid_read(pid_t mon_pid) {
	unsigned old_max_pids = max_pids;
	FILE *fp = fopen("/proc/sys/kernel/pid_max", "r");
	if (fp) {
		int val;
		if (fscanf(fp, "%d", &val) == 1) {
			if (val >= max_pids)
				max_pids = val + 1;
		}
		fclose(fp);
	}

	if (pids == NULL) {
		old_max_pids = max_pids;
		pids = malloc(sizeof(Process) * max_pids);
		if (pids == NULL)
			errExit("malloc");
	}

	memset(pids, 0, sizeof(Process) * old_max_pids);
	pid_t mypid = getpid();

	DIR *dir;
	if (!(dir = opendir("/proc"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/proc"))) {
			fprintf(stderr, "Error: cannot open /proc directory\n");
			exit(1);
		}
	}

	struct dirent *entry;
	char *end;
	pid_t new_max_pids = 0;
	while ((entry = readdir(dir))) {
		pid_t pid = strtol(entry->d_name, &end, 10);
		pid %= max_pids;
		if (pid > new_max_pids)
			new_max_pids = pid;
		if (end == entry->d_name || *end)
			continue;
		if (pid == mypid)
			continue;

		// skip PID 1 just in case we run a sandbox-in-sandbox
		if (pid == 1)
			continue;

		// open stat file
		char *file;
		if (asprintf(&file, "/proc/%u/status", pid) == -1)
			errExit("asprintf");

		FILE *fp = fopen(file, "r");
		if (!fp) {
			free(file);
			continue;
		}

		// look for firejail executable name
		char buf[PIDS_BUFLEN];
		while (fgets(buf, PIDS_BUFLEN - 1, fp)) {
			if (strncmp(buf, "Name:", 5) == 0) {
				char *ptr = strchr(buf, '\n');
				if (ptr)
					*ptr = '\0';
				ptr = buf + 5;
				while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
					ptr++;
				}
				if (*ptr == '\0') {
					fprintf(stderr, "Error: cannot read /proc file\n");
					exit(1);
				}

				if ((strcmp(ptr, "firejail") == 0) && (mon_pid == 0 || mon_pid == pid)) {
					if (pid_proc_cmdline_x11_xpra_xephyr(pid))
						pids[pid].level = -1;
					else
						pids[pid].level = 1;
				}
				else
					pids[pid].level = -1;
			}
			if (strncmp(buf, "State:", 6) == 0) {
				if (strstr(buf, "(zombie)"))
					pids[pid].zombie = 1;
			}
			else if (strncmp(buf, "PPid:", 5) == 0) {
				char *ptr = buf + 5;
				while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
					ptr++;
				}
				if (*ptr == '\0') {
					fprintf(stderr, "Error: cannot read /proc file\n");
					exit(1);
				}
				unsigned parent = atoi(ptr);
				parent %= max_pids;
				if (pids[parent].level > 0) {
					pids[pid].level = pids[parent].level + 1;
				}
				pids[pid].parent = parent;
			}
			else if (strncmp(buf, "Uid:", 4) == 0) {
				char *ptr = buf + 4;
				while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
					ptr++;
				}
				if (*ptr == '\0') {
					fprintf(stderr, "Error: cannot read /proc file\n");
					exit(1);
				}
				pids[pid].uid = atoi(ptr);
				break;
			}
		}
		fclose(fp);
		free(file);
	}
	closedir(dir);

	// update max_pid
	max_pids = new_max_pids + 1;

	pid_t pid;
	for (pid = 0; pid < max_pids; pid++) {
		int parent = pids[pid].parent;
		if (pids[parent].level > 0) {
			pids[pid].level = pids[parent].level + 1;
		}
	}
}

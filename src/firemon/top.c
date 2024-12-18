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
#include "firemon.h"
#include "../include/gcov_wrapper.h"
#include <termios.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

static unsigned pgs_rss = 0;
static unsigned pgs_shared = 0;
static unsigned clocktick = 0;
static unsigned long long sysuptime = 0;
static int pgsz = 0;
static uid_t cached_uid = 0;
static char *cached_user_name = NULL;

static char *get_user_name(uid_t uid) {
	if (cached_user_name == NULL) {
		cached_uid = uid;
		cached_user_name = pid_get_user_name(uid);
		return strdup(cached_user_name);
	}
	else if (uid == cached_uid)
		return strdup(cached_user_name);
	else
		return pid_get_user_name(uid);
}

static char *get_header(void) {
	char *rv;
	if (asprintf(&rv, "%-7.7s %-9.9s %-8.8s %-8.8s %-5.5s %-4.4s %-9.9s %s",
		"PID", "User", "RES(KiB)", "SHR(KiB)", "CPU%", "Prcs", "Uptime", "Command") == -1)
		errExit("asprintf");

	return rv;
}


static char *firejail_exec = NULL;
static int firejail_exec_len = 0;
static int firejail_exec_prefix_len = 0;
// recursivity!!!
static char *print_top(unsigned index, unsigned parent, unsigned *utime, unsigned *stime, unsigned itv, float *cpu, int *cnt) {
	char *rv = NULL;

	// Remove unused parameter warning
	(void)parent;

	char procdir[20];
	snprintf(procdir, 20, "/proc/%u", index);
	struct stat s;
	if (stat(procdir, &s) == -1)
		return NULL;

	if (pids[index].level == 1) {
		pgs_rss = 0;
		pgs_shared = 0;
		*utime = 0;
		*stime = 0;
		*cnt = 0;
	}

	(*cnt)++;
	pid_getmem(index, &pgs_rss, &pgs_shared);
	unsigned utmp;
	unsigned stmp;
	pid_get_cpu_time(index, &utmp, &stmp);
	*utime += utmp;
	*stime += stmp;


	int i;
	for (i = index + 1; i < max_pids; i++) {
		if (pids[i].parent == (pid_t)index)
			print_top(i, index, utime, stime, itv, cpu, cnt);
	}

	if (!firejail_exec) {
		if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
			errExit("asprintf");
		firejail_exec_len = strlen(firejail_exec);
		firejail_exec_prefix_len = strlen(PREFIX) + 5;
	}

	if (pids[index].level == 1) {
		// pid
		char pidstr[10];
		snprintf(pidstr, 10, "%u", index);

		// command
		char *cmd = pid_proc_cmdline(index);
		char *ptrcmd;
		if (cmd == NULL) {
			if (pids[index].zombie)
				ptrcmd = "(zombie)";
			else
				ptrcmd = "";
		}
		else if (strncmp(cmd, firejail_exec, firejail_exec_len) == 0)
			ptrcmd = cmd + firejail_exec_prefix_len;
		else
			ptrcmd = cmd;

		// user
		char *user = get_user_name(pids[index].uid);
		char *ptruser;
		if (user)
			ptruser = user;
		else
			ptruser = "";

		// memory
		if (pgsz == 0)
			pgsz = getpagesize();
		char rss[10];
		snprintf(rss, 10, "%u", pgs_rss * pgsz / 1024);
		char shared[10];
		snprintf(shared, 10, "%u", pgs_shared * pgsz / 1024);

		// uptime
		unsigned long long uptime = pid_get_start_time(index);
		if (clocktick == 0)
			clocktick = sysconf(_SC_CLK_TCK);
		uptime /= clocktick;
		uptime = sysuptime - uptime;
		unsigned sec = uptime % 60;
		uptime -= sec;
		uptime /= 60;
		unsigned min = uptime % 60;
		uptime -= min;
		uptime /= 60;
		unsigned hour = uptime;
		char uptime_str[50];
		snprintf(uptime_str, 50, "%02u:%02u:%02u", hour, min, sec);

		// cpu
		itv *= clocktick;
		float ud = (float) (*utime - pids[index].option.top.utime) / itv * 100;
		float sd = (float) (*stime - pids[index].option.top.stime) / itv * 100;
		float cd = ud + sd;
		*cpu = cd;
		char cpu_str[10];
		snprintf(cpu_str, 10, "%2.1f", cd);

		// process count
		char prcs_str[10];
		snprintf(prcs_str, 10, "%d", *cnt);

		if (asprintf(&rv, "%-7.7s %-9.9s %-8.8s %-8.8s %-5.5s %-4.4s %-9.9s %s",
			     pidstr, ptruser, rss, shared, cpu_str, prcs_str,
			     uptime_str, ptrcmd) == -1)
			errExit("asprintf");

		if (cmd)
			free(cmd);
		if (user)
			free(user);

	}

	return rv;
}

// recursivity!!!
void pid_store_cpu(unsigned index, unsigned parent, unsigned *utime, unsigned *stime) {
	if (pids[index].level == 1) {
		*utime = 0;
		*stime = 0;
	}

	// Remove unused parameter warning
	(void)parent;

	unsigned utmp = 0;
	unsigned stmp = 0;
	pid_get_cpu_time(index, &utmp, &stmp);
	*utime += utmp;
	*stime += stmp;

	unsigned i;
	for (i = index + 1; i < (unsigned)max_pids; i++) {
		if (pids[i].parent == (pid_t)index)
			pid_store_cpu(i, index, utime, stime);
	}

	if (pids[index].level == 1) {
		pids[index].option.top.utime = *utime;
		pids[index].option.top.stime = *stime;
	}
}


typedef struct node_t {
	struct node_t *next;
	char *line;
	float cpu;
} Node;

static Node *head = NULL;

static void head_clear(void) {
	Node *ptr = head;
	while (ptr) {
		if (ptr->line)
			free(ptr->line);
		Node *next = ptr->next;
		free(ptr);
		ptr = next;
	}

	head = NULL;
}

static void head_add(float cpu, char *line) {
	// allocate a new node structure
	Node *node = malloc(sizeof(Node));
	if (!node)
		errExit("malloc");
	node->line = line;
	node->cpu = cpu;
	node->next = NULL;

	// insert in first list position
	if (head == NULL || head->cpu < cpu) {
		node->next = head;
		head = node;
		return;
	}

	// insert in the right place
	Node *ptr = head;
	while (1) {
		// last position
		Node *current = ptr->next;
		if (current == NULL) {
			ptr->next = node;
			return;
		}

		// current position
		if (current->cpu < cpu) {
			ptr->next = node;
			node->next = current;
			return;
		}

		ptr = current;
	}
}

void head_print(int col, int row) {
	Node *ptr = head;
	int current = 0;
	while (ptr) {
		if (current >= row)
			break;

		if (strlen(ptr->line) > (size_t)col)
			ptr->line[col] = '\0';

		if (ptr->next == NULL || current == (row - 1)) {
			printf("%s", ptr->line);
			fflush(0);
		}
		else
			printf("%s\n", ptr->line);

		ptr = ptr->next;
		current++;
	}
}

void top(void) {
	while (1) {
		// clear linked list
		head_clear();

		// set pid table
		int i;
		int itv = 3; // 3 second interval
		pid_read(0);

		// start cpu measurements
		unsigned utime = 0;
		unsigned stime = 0;
		for (i = 0; i < max_pids; i++) {
			if (i == skip_process)
				continue;
			if (pids[i].level == 1)
				pid_store_cpu(i, 0, &utime, &stime);
		}

		// wait 1 second
		firemon_sleep(itv);

		// grab screen size
		struct winsize sz;
		int row = 24;
		int col = 80;
		if (!ioctl(STDIN_FILENO, TIOCGWINSZ, &sz)) {
			if (sz.ws_col > 0 && sz.ws_row > 0) {
				col = sz.ws_col;
				row = sz.ws_row;
			}
		}

		// start printing
		firemon_clrscr();
		char *header = get_header();
		if (strlen(header) > (size_t)col)
			header[col] = '\0';
		printf("%s\n", header);
		if (row > 0)
			row--;
		free(header);

		// find system uptime
		FILE *fp = fopen("/proc/uptime", "r");
		if (fp) {
			float f;
			int rv = fscanf(fp, "%f", &f);
			(void) rv;
			sysuptime = (unsigned long long) f;
			fclose(fp);
		}

		// print processes
		for (i = 0; i < max_pids; i++) {
			if (i == skip_process)
				continue;
			if (pids[i].level == 1) {
				float cpu = 0;
				int cnt = 0; // process count
				char *line = print_top(i, 0, &utime, &stime, itv, &cpu, &cnt);
				if (line)
					head_add(cpu, line);
			}
		}
		head_print(col, row);

		__gcov_flush();
	}
}

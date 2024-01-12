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

#define MAXBUF 4096

// ip -s link: device stats
// ss -s: socket stats

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
	if (asprintf(&rv, "%-7.7s %-9.9s %-10.10s %-10.10s %s",
		"PID", "User", "RX(KB/s)", "TX(KB/s)", "Command") == -1)
		errExit("asprintf");

	return rv;
}

void get_stats(int parent) {
	// find the first child
	int child = -1;
	for (child = parent + 1; child < max_pids; child++) {
		if (pids[child].parent == parent)
			break;
	}

	if (child == -1)
		goto errexit;

	// open /proc/child/net/dev file and read rx and tx
	char *fname;
	if (asprintf(&fname, "/proc/%d/net/dev", child) == -1)
		errExit("asprintf");
	FILE *fp = fopen(fname, "r");
	if (!fp) {
		free(fname);
		goto errexit;
	}

	char buf[MAXBUF];
	long long unsigned rx = 0;
	long long unsigned tx = 0;
	while (fgets(buf, MAXBUF, fp)) {
		if (strncmp(buf, "Inter", 5) == 0)
			continue;
		if (strncmp(buf, " face", 5) == 0)
			continue;

		char *ptr = buf;
		while (*ptr != '\0' && *ptr != ':') {
			ptr++;
		}

		if (*ptr == '\0') {
			fclose(fp);
			free(fname);
			goto errexit;
		}
		ptr++;

		long long unsigned rxval;
		long long unsigned txval;
		unsigned a, b, c, d, e, f, g;
		sscanf(ptr, "%llu %u %u %u %u %u %u %u %llu",
			&rxval, &a, &b, &c, &d, &e, &f, &g, &txval);
		rx += rxval;
		tx += txval;
	}

	// store data
	pids[parent].option.netstats.rx = rx - pids[parent].option.netstats.rx;
	pids[parent].option.netstats.tx = tx - pids[parent].option.netstats.tx;


	free(fname);
	fclose(fp);
	return;

errexit:
	pids[parent].option.netstats.rx = 0;
	pids[parent].option.netstats.tx = 0;
}


static char *firejail_exec = NULL;
static int firejail_exec_len = 0;
static int firejail_exec_prefix_len = 0;
static void print_proc(int index, int itv, int col) {
	if (!firejail_exec) {
		if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
			errExit("asprintf");
		firejail_exec_len = strlen(firejail_exec);
		firejail_exec_prefix_len = strlen(PREFIX) + 5;
	}

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

	// check network namespace
	char *name;
	if (asprintf(&name, "/run/firejail/network/%d-netmap", index) == -1)
		errExit("asprintf");
	struct stat s;
	if (stat(name, &s) == -1) {
		// the sandbox doesn't have a --net= option, don't print
		if (cmd)
			free(cmd);
		return;
	}

	// pid
	char pidstr[11];
	snprintf(pidstr, 11, "%d", index);

	// user
	char *user = get_user_name(pids[index].uid);
	char *ptruser;
	if (user)
		ptruser = user;
	else
		ptruser = "";


	float rx_kbps = ((float) pids[index].option.netstats.rx / 1000) / itv;
	char ptrrx[15];
	sprintf(ptrrx, "%.03f", rx_kbps);

	float tx_kbps = ((float) pids[index].option.netstats.tx / 1000) / itv;
	char ptrtx[15];
	sprintf(ptrtx, "%.03f", tx_kbps);

	char buf[1024 + 1];
	snprintf(buf, 1024, "%-7.7s %-9.9s %-10.10s %-10.10s %s",
		pidstr, ptruser, ptrrx, ptrtx, ptrcmd);
	if (col < 1024)
		buf[col] = '\0';
	printf("%s\n", buf);

	if (cmd)
		free(cmd);
	if (user)
		free(user);

}

void netstats(void) {
	pid_read(0);	// include all processes

	printf("Displaying network statistics only for sandboxes using a new network namespace.\n");

	// print processes
	while (1) {
		// set pid table
		int i;
		int itv = 3; 	// 3 second interval
		pid_read(0);

		// start rx/tx measurements
		for (i = 0; i < max_pids; i++) {
			if (pids[i].level == 1)
				get_stats(i);
		}

		// wait 1 seconds
		firemon_sleep(itv);

		// grab screen size
		struct winsize sz;
		int row = 24;
		int col = 80;
		if (!ioctl(0, TIOCGWINSZ, &sz)) {
			col = sz.ws_col;
			row = sz.ws_row;
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

		// start rx/tx measurements
		for (i = 0; i < max_pids; i++) {
			if (pids[i].level == 1) {
				get_stats(i);
				print_proc(i, itv, col);
			}
		}

		__gcov_flush();
	}
}

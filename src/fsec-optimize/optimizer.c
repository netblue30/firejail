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
#include "fsec_optimize.h"

// From /usr/include/linux/filter.h
//struct sock_filter {	/* Filter block */
//	__u16	code;   /* Actual filter code */
//	__u8	jt;	/* Jump true */
//	__u8	jf;	/* Jump false */
//	__u32	k;      /* Generic multiuse field */
//};


#define LIMIT_BLACKLISTS 4	// we optimize blacklists only if we have more than

static inline int is_blacklist(struct sock_filter *bpf) {
	if (bpf->code == BPF_JMP + BPF_JEQ + BPF_K &&
	    (bpf + 1)->code == BPF_RET + BPF_K &&
	    (bpf + 1)->k == (__u32)arg_seccomp_error_action)
		return 1;
	return 0;
}

static int count_blacklists(struct sock_filter *filter, int entries) {
	int cnt = 0;
	int i;

	for (i = 0; i < (entries - 1); i++, filter++) { // is_blacklist works on two consecutive lines; using entries - 1
		if (is_blacklist(filter))
			cnt++;
	}

	return cnt;
}

typedef struct {
	int to_remove;
	int to_fix_jumps;
} Action;

static int optimize_blacklists(struct sock_filter *filter, int entries) {
	assert(entries);
	assert(filter);
	int i;
	int j;

	// step1: extract information
	Action action[entries];
	memset(&action[0], 0, sizeof(Action) * entries);
	int remove_cnt = 0;
	for (i = 0; i < (entries - 1); i++) { // is_blacklist works on two consecutive lines; using entries - 1
		if (is_blacklist(filter + i)) {
			action[i]. to_fix_jumps = 1;
			i++;
			action[i].to_remove = 1;
			remove_cnt++;
		}
	}

	// step2: remove lines
	struct sock_filter *filter_step2 = duplicate(filter, entries);
	Action action_step2[entries];
	memset(&action_step2[0], 0, sizeof(Action) * entries);
	for (i = 0, j = 0; i < entries; i++) {
		if (!action[i].to_remove) {
			memcpy(&filter_step2[j], &filter[i], sizeof(struct sock_filter));
			memcpy(&action_step2[j], &action[i], sizeof(Action));
			j++;
		}
		else {
			// do nothing, we are removing this line
		}
	}

	// step 3: add the new ret KILL/LOG/ERRNO, and recalculate entries
	filter_step2[j].code = BPF_RET + BPF_K;
	filter_step2[j].k = arg_seccomp_error_action;
	entries = j + 1;

	// step 4: recalculate jumps
	for (i = 0; i < entries; i++) {
		if (action_step2[i].to_fix_jumps) {
			filter_step2[i].jt = entries - i - 2;
			filter_step2[i].jf = 0;
		}
	}

	// update
	memcpy(filter, filter_step2, entries * sizeof(struct sock_filter));
	free(filter_step2);
	return entries;
}

int optimize(struct sock_filter *filter, int entries) {
	assert(filter);
	assert(entries);

	//**********************************
	// optimize blacklist statements
	//**********************************
	// count "ret KILL"
	int cnt = count_blacklists(filter, entries);
	if (cnt > LIMIT_BLACKLISTS)
		entries = optimize_blacklists(filter, entries);
	return entries;
}

struct sock_filter *duplicate(struct sock_filter *filter, int entries) {
	int len = sizeof(struct sock_filter) * entries;
	struct sock_filter *rv = malloc(len);
	if (!rv) {
		errExit("malloc");
		exit(1);
	}

	memcpy(rv, filter, len);
	return rv;
}

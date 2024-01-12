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
#include "fnettrace.h"

typedef struct event_t {
	struct event_t *next;
	char *record;
} Event;

static Event *event = NULL;
static Event *last_event = NULL;
int ev_cnt = 0;

void ev_clear(void) {
	ev_cnt = 0;
	Event *ev = event;
	while (ev) {
		Event *next = ev->next;
		free(ev->record);
		free(ev);
		ev = next;
	}
	event = NULL;
}

void ev_add(char *record) {
	assert(record);

	// braking recursivity
	if (*record == '\0')
		return;

	char *ptr = strchr(record, '\n');
	if (ptr)
		*ptr = '\0';

	// filter out duplicates
	if (event && strcmp(event->record, record) == 0)
		return;

	Event *ev = malloc(sizeof(Event));
	if (!ev)
		errExit("malloc");
	memset(ev, 0, sizeof(Event));

	ev->record = strdup(record);
	if (!ev->record)
		errExit("strdup");

	if (event == NULL) {
		event = ev;
		last_event = ev;
	}
	else {
		last_event->next = ev;
		last_event = ev;
	}
	ev_cnt++;

	// recursivity
	if (ptr)
		ev_add(++ptr);
}

void ev_print(FILE *fp) {
	assert(fp);

	Event *ev = event;
	while (ev) {
		fprintf(fp, "   ");
		if (strstr(ev->record, "NXDOMAIN")) {
			if (fp == stdout)
				ansi_red(ev->record);
			else
				fprintf(fp, "%s", ev->record);
		}
		else if (strstr(ev->record, "SSH connection")) {
			if (fp == stdout)
				ansi_red(ev->record);
			else
				fprintf(fp, "%s", ev->record);
		}
		else
			fprintf(fp, "%s", ev->record);
		fprintf(fp, "\n");
		ev = ev->next;
	}
}

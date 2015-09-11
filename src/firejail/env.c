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
#include "firejail.h"

typedef struct env_t {
	struct env_t *next;
	char *name;
	char *value;
} Env;
static Env *envlist = NULL;

static void env_add(Env *env) {
	env->next = envlist;
	envlist = env;
}

// parse and store the environment setting 
void env_store(const char *str) {
	assert(str);
	
	// some basic checking
	if (*str == '\0')
		goto errexit;
	char *ptr = strchr(str, '=');
	if (!ptr)
		goto errexit;
	ptr++;
	if (*ptr == '\0')
		goto errexit;

	// build list entry
	Env *env = malloc(sizeof(Env));
	if (!env)
		errExit("malloc");
	memset(env, 0, sizeof(Env));
	env->name = strdup(str);
	if (env->name == NULL)
		errExit("strdup");
	char *ptr2 = strchr(env->name, '=');
	assert(ptr2);
	*ptr2 = '\0';
	env->value = ptr2 + 1;
	
	// add entry to the list
	env_add(env);
	return;
	
errexit:
	fprintf(stderr, "Error: invalid --env setting\n");
	exit(1);
}

// set env variables in the new sandbox process
void env_apply(void) {
	Env *env = envlist;
	
	while (env) {
		if (setenv(env->name, env->value, 1) < 0)
			errExit("setenv");
		env = env->next;
	}
}

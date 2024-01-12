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
#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <dirent.h>
#include <limits.h>

typedef struct env_t {
	struct env_t *next;
	const char *name;
	const char *value;
	ENV_OP op;
} Env;
static Env *envlist = NULL;

static void env_add(Env *env) {
	env->next = NULL;

	// add the new entry at the end of the list
	if (envlist == NULL) {
		envlist = env;
		return;
	}

	Env *ptr = envlist;
	while (1) {
		if (ptr->next == NULL) {
			ptr->next = env;
			break;
		}
		ptr = ptr->next;
	}
}

// load IBUS env variables
void env_ibus_load(void) {
	EUID_ASSERT();

	// check ~/.config/ibus/bus directory
	char *dirname;
	if (asprintf(&dirname, "%s/.config/ibus/bus", cfg.homedir) == -1)
		errExit("asprintf");

	// find the file
	DIR *dir = opendir(dirname);
	if (!dir) {
		free(dirname);
		return;
	}

	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		// check the file name ends in "unix-0"
		char *ptr = strstr(entry->d_name, "unix-0");
		if (!ptr)
			continue;
		if (strlen(ptr) != 6)
			continue;

		// open the file
		char *fname;
		if (asprintf(&fname, "%s/%s", dirname, entry->d_name) == -1)
			errExit("asprintf");
		FILE *fp = fopen(fname, "re");
		free(fname);
		if (!fp)
			continue;

		// read the file
		const int maxline = 4096;
		char buf[maxline];
		while (fgets(buf, maxline, fp)) {
			if (strncmp(buf, "IBUS_", 5) != 0)
				continue;
			char *ptr = strchr(buf, '=');
			if (!ptr)
				continue;
			ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
			if (arg_debug)
				printf("%s\n", buf);
			env_store(buf, SETENV);
		}

		fclose(fp);
	}

	free(dirname);
	closedir(dir);
}


// default sandbox env variables
void env_defaults(void) {
	// Qt fixes
	env_store_name_val("QT_X11_NO_MITSHM", "1", SETENV);
	env_store_name_val("QML_DISABLE_DISK_CACHE", "1", SETENV);
//	env_store_name_val("QTWEBENGINE_DISABLE_SANDBOX", "1", SETENV);
//	env_store_name_val("MOZ_NO_REMOTE, "1", SETENV);
	env_store_name_val("container", "firejail", SETENV); // LXC sets container=lxc,
	env_store_name_val("SHELL", cfg.usershell, SETENV);

	// spawn KIO slaves inside the sandbox
	env_store_name_val("KDE_FORK_SLAVES", "1", SETENV);

	// set prompt color to green
	int set_prompt = 0;
	if (checkcfg(CFG_FIREJAIL_PROMPT))
		set_prompt = 1;
	else { // check FIREJAIL_PROMPT="yes" environment variable
		const char *prompt = env_get("FIREJAIL_PROMPT");
		if (prompt && strcmp(prompt, "yes") == 0)
			set_prompt = 1;
	}

	if (set_prompt)
		//export PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[0m\] '
		env_store_name_val("PROMPT_COMMAND", "export PS1=\"\\[\\e[1;32m\\][\\u@\\h \\W]\\$\\[\\e[0m\\] \"", SETENV);
	else
		// remove PROMPT_COMMAND
		env_store_name_val("PROMPT_COMMAND", ":", SETENV); // unsetenv() will not work here, bash still picks it up from somewhere

	// set the window title
	if (!arg_quiet && isatty(STDOUT_FILENO))
		printf("\033]0;firejail %s\007", cfg.window_title);

	// pass --quiet as an environment variable, in case the command calls further firejailed commands
	if (arg_quiet)
		env_store_name_val("FIREJAIL_QUIET", "yes", SETENV);

	fflush(0);
}

// parse and store the environment setting
void env_store(const char *str, ENV_OP op) {
	assert(str);

	// some basic checking
	if (*str == '\0')
		goto errexit;
	char *ptr = strchr(str, '=');
	if (op == SETENV) {
		if (!ptr)
			goto errexit;
		ptr++;
		op = SETENV;
	}

	// build list entry
	Env *env = malloc(sizeof(Env));
	if (!env)
		errExit("malloc");
	memset(env, 0, sizeof(Env));
	env->name = strdup(str);
	if (env->name == NULL)
		errExit("strdup");
	if (op == SETENV) {
		char *ptr2 = strchr(env->name, '=');
		assert(ptr2);
		*ptr2 = '\0';
		env->value = ptr2 + 1;
	}
	env->op = op;

	// add entry to the list
	env_add(env);
	return;

errexit:
	fprintf(stderr, "Error: invalid --env setting\n");
	exit(1);
}

void env_store_name_val(const char *name, const char *val, ENV_OP op) {
	assert(name);

	// some basic checking
	if (*name == '\0')
		goto errexit;

	// build list entry
	Env *env = calloc(1, sizeof(Env));
	if (!env)
		errExit("calloc");

	env->name = strdup(name);
	if (env->name == NULL)
		errExit("strdup");

	if (op == SETENV) {
		env->value = strdup(val);
		if (env->value == NULL)
			errExit("strdup");
	}
	env->op = op;

	// add entry to the list
	env_add(env);
	return;

errexit:
	fprintf(stderr, "Error: invalid --env setting\n");
	exit(1);
}

// set env variables in the new sandbox process
void env_apply_all(void) {
	Env *env = envlist;

	while (env) {
		if (env->op == SETENV) {
			if (setenv(env->name, env->value, 1) < 0)
				errExit("setenv");
		}
		else if (env->op == RMENV) {
			unsetenv(env->name);
		}
		env = env->next;
	}
}

// get env variable
const char *env_get(const char *name) {
	Env *env = envlist;
	const char *r = NULL;

	while (env) {
		if (strcmp(env->name, name) == 0) {
			if (env->op == SETENV)
				r = env->value;
			else if (env->op == RMENV)
				r = NULL;
		}
		env = env->next;
	}
	return r;
}

static const char * const env_whitelist[] = {
	"LANG",
	"LANGUAGE",
	"LC_MESSAGES",
	// "PATH",
	"DISPLAY"	// required by X11
};

static const char * const env_whitelist_sbox[] = {
	"FIREJAIL_DEBUG",
	"FIREJAIL_FILE_COPY_LIMIT",
	"FIREJAIL_PLUGIN",
	"FIREJAIL_QUIET",
	"FIREJAIL_SECCOMP_ERROR_ACTION",
	"FIREJAIL_TEST_ARGUMENTS",
	"FIREJAIL_TRACEFILE"
};

static void env_apply_list(const char * const *list, unsigned int num_items) {
	Env *env = envlist;

	while (env) {
		if (env->op == SETENV) {
			unsigned int i;
			for (i = 0; i < num_items; i++)
				if (strcmp(env->name, list[i]) == 0) {
					// sanity check for whitelisted environment variables
					if (strlen(env->name) + strlen(env->value) >= MAX_ENV_LEN) {
						fprintf(stderr, "Error: too long environment variable %s, please use --rmenv\n", env->name);
						exit(1);
					}

					//fprintf(stderr, "whitelisted env var %s=%s\n", env->name, env->value);
					if (setenv(env->name, env->value, 1) < 0)
						errExit("setenv");
					break;
				}
		} else if (env->op == RMENV)
			unsetenv(env->name);

		env = env->next;
	}
}

// Filter env variables in main firejail process. All variables will
// be reapplied for the sandboxed app by env_apply_all().
void env_apply_whitelist(void) {
	int r;

	r = clearenv();
	if (r != 0)
		errExit("clearenv");

	env_apply_list(env_whitelist, ARRAY_SIZE(env_whitelist));

	// hardcoding PATH
	if (setenv("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin", 1) < 0)
		errExit("setenv");
}

// Filter env variables for a sbox app
void env_apply_whitelist_sbox(void) {
	env_apply_whitelist();
	env_apply_list(env_whitelist_sbox, ARRAY_SIZE(env_whitelist_sbox));
}

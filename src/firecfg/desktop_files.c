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

#include "firecfg.h"
#include <ctype.h>

static int check_profile(const char *name, const char *homedir) {
	// build profile name
	char *profname1;
#ifndef HAVE_ONLY_SYSCFG_PROFILES
	char *profname2;
#endif
	if (asprintf(&profname1, "%s/%s.profile", SYSCONFDIR, name) == -1)
		errExit("asprintf");

#ifndef HAVE_ONLY_SYSCFG_PROFILES
	if (asprintf(&profname2, "%s/.config/firejail/%s.profile", homedir, name) == -1)
		errExit("asprintf");
#endif

	int rv = 0;
	if (access(profname1, R_OK) == 0) {
		if (arg_debug)
			printf("found %s\n", profname1);
		rv = 1;
	}
#ifndef HAVE_ONLY_SYSCFG_PROFILES
	else if (access(profname2, R_OK) == 0) {
		if (arg_debug)
			printf("found %s\n", profname2);
		rv = 1;
	}
#endif

	free(profname1);
#ifndef HAVE_ONLY_SYSCFG_PROFILES
	free(profname2);
#endif
	return rv;
}


// look for a profile file in /etc/firejail and ~/.config/firejail
static int have_profile(const char *filename, const char *homedir) {
	assert(filename);
	assert(homedir);

	if (arg_debug)
		printf("checking profile for %s\n", filename);

	// we get strange names here, such as .org.gnome.gedit.desktop, com.uploadedlobster.peek.desktop,
	// or io.github.Pithos.desktop; extract the word before .desktop
	// TODO: implement proper fix for #2624 (names like org.gnome.Logs.desktop fall thru
	// the 'last word' logic and don't get installed to ~/.local/share/applications

	char *tmpfname = strdup(filename);
	if (!tmpfname)
		errExit("strdup");

	// check .desktop extension
	int len = strlen(tmpfname);
	if (len <= 8) {
		free(tmpfname);
		return 0;
	}
	if (strcmp(tmpfname + len - 8, ".desktop")) {
		free(tmpfname);
		return 0;
	}
	tmpfname[len - 8] = '\0';

	// extract last word
	char *last_word = strrchr(tmpfname, '.');
	if (last_word)
		last_word++;
	else
		last_word = tmpfname;

	// try lowercase
	last_word[0] = tolower(last_word[0]);
	int rv = check_profile(last_word, homedir);
	if (rv) {
		free(tmpfname);
		return rv;
	}

	// try uppercase
	last_word[0] = toupper(last_word[0]);
	rv = check_profile(last_word, homedir);
	free(tmpfname);
	return rv;
}

void fix_desktop_files(const char *homedir) {
	assert(homedir);
	struct stat sb;

	// check user
	if (getuid() == 0) {
		fprintf(stderr, "Error: this option is not supported for root user; please run as a regular user.\n");
		exit(1);
	}

	// build ignorelist
	parse_config_all(0);

	// destination
	// create ~/.local/share/applications directory if necessary
	char *user_apps_dir;
	if (asprintf(&user_apps_dir, "%s/.local/share/applications", homedir) == -1)
		errExit("asprintf");
	printf("\nFixing desktop files in %s\n", user_apps_dir);
	if (stat(user_apps_dir, &sb) == -1) {
		char *tmp;
		if (asprintf(&tmp, "%s/.local", homedir) == -1)
			errExit("asprintf");
		int rv = mkdir(tmp, 0755);
		(void) rv;
		free(tmp);

		if (asprintf(&tmp, "%s/.local/share", homedir) == -1)
			errExit("asprintf");
		rv = mkdir(tmp, 0755);
		(void) rv;
		free(tmp);

		rv = mkdir(user_apps_dir, 0700);
		if (rv) {
			perror("mkdir");
			fprintf(stderr, "Warning: cannot create ~/.local/share/application directory, desktop files fixing skipped...\n");
			free(user_apps_dir);
			return;
		}
		rv = chmod(user_apps_dir, 0700);
		(void) rv;
	}

	// source
	DIR *dir = opendir("/usr/share/applications");
	if (!dir || chdir("/usr/share/applications")) {
		perror("opendir");
		fprintf(stderr, "Warning: cannot access /usr/share/applications directory, desktop files fixing skipped...\n");
		free(user_apps_dir);
		if (dir)
			closedir(dir);
		return;
	}

	// copy
	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		const char *filename = entry->d_name;
		if (strcmp(filename, ".") == 0 || strcmp(filename, "..") == 0)
			continue;

		// skip if not regular file or link
		// d_type is not available on some file systems
		if (entry->d_type != DT_REG && entry->d_type != DT_LNK && entry->d_type != DT_UNKNOWN)
			continue;

		// skip if not .desktop file
		char *exec = strdup(filename);
		if (!exec)
			errExit("strdup");
		char *ptr = strstr(exec, ".desktop");
		if (ptr == NULL || *(ptr + 8) != '\0') {
			printf("   %s skipped (not a .desktop file)\n", exec);
			free(exec);
			continue;
		}

		// skip if program is in ignorelist
		*ptr = '\0';
		if (in_ignorelist(exec)) {
			printf("   %s ignored\n", exec);
			free(exec);
			continue;
		}

		free(exec);

		// skip links - Discord on Arch #4235 seems to be a symlink to /opt directory
//		if (is_link(filename))
//			continue;

		// no profile in /etc/firejail, no desktop file fixing
		if (!have_profile(filename, homedir))
			continue;

		//****************************************************
		// load the file in memory and do some basic checking
		//****************************************************
		FILE *fp = fopen(filename, "r");
		if (!fp) {
			fprintf(stderr, "Warning: cannot open /usr/share/applications/%s\n", filename);
			continue;
		}

		fseek(fp, 0, SEEK_END);
		long size = ftell(fp);
		if (size == -1)
			errExit("ftell");
		fseek(fp, 0, SEEK_SET);
		char *buf = malloc(size + 1);
		if (!buf)
			errExit("malloc");

		size_t loaded = fread(buf, size, 1, fp);
		fclose(fp);
		if (loaded != 1) {
			fprintf(stderr, "Warning: cannot read /usr/share/applications/%s\n", filename);
			free(buf);
			continue;
		}
		buf[size] = '\0';

		// check format
		if (strstr(buf, "[Desktop Entry]\n") == NULL) {
			if (arg_debug)
				printf("   %s - skipped: wrong format?\n", filename);
			free(buf);
			continue;
		}

		// get executable name
		ptr = strstr(buf,"\nExec=");
		if (!ptr || strlen(ptr) < 7) {
			if (arg_debug)
				printf("   %s - skipped: wrong format?\n", filename);
			free(buf);
			continue;
		}

		char *execname = ptr + 6;
		// executable name can be quoted, this is rare and currently unsupported, TODO
		if (execname[0] == '"') {
			if (arg_debug)
				printf("   %s - skipped: path quoting unsupported\n", filename);
			free(buf);
			continue;
		}

		// try to decide if we need to convert this file
		char *change_exec = NULL;
		int change_dbus = 0;

		if (strstr(buf, "\nDBusActivatable=true"))
			change_dbus = 1;

		// https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
		// The executable program can either be specified with its full path
		// or with the name of the executable only
		if (execname[0] == '/') {
			// mark end of line
			char *end = strchr(execname, '\n');
			if (end)
				*end = '\0';
			end = strchr(execname, ' ');
			if (end)
				*end = '\0';
			char *start_name = strrchr(execname, '/');
			if (start_name) {
				start_name++;
				// check if we have the executable on the regular path
				if (which(start_name)) {
					change_exec = strdup(start_name);
					if (!change_exec)
						errExit("strdup");
				}
			}
		}

		free(buf);
		if (change_exec == NULL && change_dbus == 0)
			continue;

		//****************************************************
		// generate output file
		//****************************************************
		char *outname;
		if (asprintf(&outname ,"%s/%s", user_apps_dir, filename) == -1)
			errExit("asprintf");

		if (stat(outname, &sb) == 0) {
			printf("   %s skipped: file exists\n", filename);
			if (change_exec)
				free(change_exec);
			continue;
		}

		FILE *fpin = fopen(filename, "r");
		if (!fpin) {
			fprintf(stderr, "Warning: cannot open /usr/share/applications/%s\n", filename);
			if (change_exec)
				free(change_exec);
			continue;
		}

		FILE *fpout = fopen(outname, "w");
		if (!fpout) {
			fprintf(stderr, "Warning: cannot open ~/.local/share/applications/%s\n", outname);
			fclose(fpin);
			if (change_exec)
				free(change_exec);
			continue;
		}
		fprintf(fpout, "# converted by firecfg\n");
		free(outname);

		char fbuf[MAX_BUF];
		while (fgets(fbuf, MAX_BUF, fpin)) {
			if (change_dbus && strcmp(fbuf, "DBusActivatable=true\n") == 0)
				fprintf(fpout, "DBusActivatable=false\n");
			else if (change_exec && strncmp(fbuf, "Exec=", 5) == 0) {
				char *start_params = strchr(fbuf + 5, ' ');
				if (start_params) {
					start_params++;
					fprintf(fpout, "Exec=%s %s", change_exec, start_params);
				}
				else
					fprintf(fpout, "Exec=%s\n", change_exec);
			}
			else
				fprintf(fpout, "%s", fbuf);
		}

		if (change_exec)
			free(change_exec);
		fclose(fpin);
		fclose(fpout);
		printf("   %s created\n", filename);

	}

	closedir(dir);
	free(user_apps_dir);
}

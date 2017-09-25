/*
 * Copyright (C) 2014-2017 Firejail Authors
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

// look for a profile file in /etc/firejail diectory and in homedir/.config/firejail directory
static int have_profile(const char *filename, const char *homedir) {
	assert(filename);
	assert(homedir);

	if (arg_debug)
		printf("checking profile for %s\n", filename);

	// remove .desktop extension; if file name starts with org.gnome... remove it
	char *f1;
	if (strncmp(filename, "org.gnome.", 10) == 0)
		f1 = strdup(filename + 10);
	else
		f1 = strdup(filename);
	if (!f1)
		errExit("strdup");
	f1[strlen(f1) - 8] = '\0';
	if (arg_debug)
		printf("looking for a profile for %s - %s\n", filename, f1);

	// build profile name
	char *profname1;
	char *profname2;
	if (asprintf(&profname1, "%s/%s.profile", SYSCONFDIR, f1) == -1)
		errExit("asprintf");
	if (asprintf(&profname2, "%s/.config/firejail/%s.profile", homedir, f1) == -1)
		errExit("asprintf");

	int rv = 0;
	if (access(profname1, R_OK) == 0) {
		if (arg_debug)
			printf("found %s\n", profname1);
		rv = 1;
	}
	else if (access(profname2, R_OK) == 0) {
		if (arg_debug)
			printf("found %s\n", profname2);
		rv = 1;
	}
		
	if (arg_debug)
		printf("Profile for %s %s\n", f1, (rv)? "found": "not found");
	free(f1);
	free(profname1);
	free(profname2);
	return rv;
}

void fix_desktop_files(char *homedir) {
	assert(homedir);
	struct stat sb;

	// check user
	if (getuid() == 0) {
		fprintf(stderr, "Error: this option is not supported for root user; please run as a regular user.\n");
		exit(1);
	}

	// destination
	// create ~/.local/share/applications directory if necessary
	char *user_apps_dir;
	if (asprintf(&user_apps_dir, "%s/.local/share/applications", homedir) == -1)
		errExit("asprintf");
	if (stat(user_apps_dir, &sb) == -1) {
		int rv = mkdir(user_apps_dir, 0700);
		if (rv) {
			fprintf(stderr, "Error: cannot create ~/.local/application directory\n");
			perror("mkdir");
			exit(1);
		}
		rv = chmod(user_apps_dir, 0700);
		(void) rv;
	}

	// source
	DIR *dir = opendir("/usr/share/applications");
	if (!dir) {
		perror("Error: cannot open /usr/share/applications directory");
		exit(1);
	}
	if (chdir("/usr/share/applications")) {
		perror("Error: cannot chdir to /usr/share/applications");
		exit(1);
	}

	printf("\nFixing desktop files in %s\n", user_apps_dir);
	// copy
	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		// skip if not regular file or link
		// d_type is not available on some file systems
		if (entry->d_type != DT_REG && entry->d_type != DT_LNK && entry->d_type != DT_UNKNOWN)
			continue;

		// skip if not .desktop file
		if (strstr(entry->d_name,".desktop") != (entry->d_name+strlen(entry->d_name)-8))
			continue;

		char *filename = entry->d_name;

		// skip links
		if (is_link(filename))
			continue;
		if (stat(filename, &sb) == -1)
			errExit("stat");

		// no profile in /etc/firejail, no desktop file fixing
		if (!have_profile(filename, homedir))
			continue;

		//****************************************************
		// load the file in memory and do some basic checking
		//****************************************************
		/* coverity[toctou] */
		int fd = open(filename, O_RDONLY);
		if (fd == -1) {
			fprintf(stderr, "Error: cannot open /usr/share/applications/%s\n", filename);
			continue;
		}

		char *buf = mmap(NULL, sb.st_size + 1, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		if (buf == MAP_FAILED)
			errExit("mmap");
		close(fd);

		// check format
		if (strstr(buf, "[Desktop Entry]\n") == NULL) {
			if (arg_debug)
				printf("   %s - skipped: wrong format?\n", filename);
			munmap(buf, sb.st_size + 1);
			continue;
		}

		// get executable name
		char *ptr = strstr(buf,"\nExec=");
		if (!ptr || strlen(ptr) < 7) {
			if (arg_debug)
				printf("   %s - skipped: wrong format?\n", filename);
			munmap(buf, sb.st_size + 1);
			continue;
		}

		char *execname = ptr + 6;
		// executable name can be quoted, this is rare and currently unsupported, TODO
		if (execname[0] == '"') {
			if (arg_debug)
				printf("   %s - skipped: path quoting unsupported\n", filename);
			munmap(buf, sb.st_size + 1);
			continue;
		}


		// try to decide if we need to covert this file
		char *change_exec = NULL;
		int change_dbus = 0;

		// https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
		// The executable program can either be specified with its full path
		// or with the name of the executable only
		if (execname[0] == '/') {
			char *end_name = strchr(execname, ' ');
			if (end_name) {
				*end_name = '\0';
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
		}
		
		if (strstr(buf, "\nDBusActivatable=true"))
			change_dbus = 1;
		
		if (change_exec == NULL && change_dbus == 0) {
			munmap(buf, sb.st_size + 1);
			continue;
		}
		
		munmap(buf, sb.st_size + 1);

		//****************************************************
		// generate output file
		//****************************************************
		char *outname;
		if (asprintf(&outname ,"%s/%s", user_apps_dir, filename) == -1)
			errExit("asprintf");

		if (stat(outname, &sb) == 0) {
			printf("   %s skipped: file exists\n", filename);
			continue;
		}
		
		FILE *fpin = fopen(filename, "r");
		if (!fpin) {
			fprintf(stderr, "Error: cannot open /usr/share/applications/%s\n", filename);
			continue;
		}
		
		FILE *fpout = fopen(outname, "w");
		if (!fpout) {
			fprintf(stderr, "Error: cannot open ~/.local/share/applications/%s\n", outname);
			fclose(fpin);
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
				assert(start_params);
				start_params++;
				fprintf(fpout, "Exec=%s %s", change_exec, start_params);
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



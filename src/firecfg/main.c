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
int arg_debug = 0;

static void usage(void) {
	printf("firecfg - version %s\n\n", VERSION);
	printf("Firecfg is the desktop configuration utility for Firejail software. The utility\n");
	printf("creates several symbolic links to firejail executable. This allows the user to\n");
	printf("sandbox applications automatically, just by clicking on a regular desktop\n");
	printf("menus and icons.\n\n");
	printf("The symbolic links are placed in /usr/local/bin. For more information, see\n");
	printf("DESKTOP INTEGRATION section in man 1 firejail.\n\n");
	printf("Usage: firecfg [OPTIONS]\n\n");
	printf("   --clean - remove all firejail symbolic links.\n\n");
	printf("   --debug - print debug messages.\n\n");
	printf("   --fix - fix .desktop files.\n\n");
	printf("   --fix-sound - create ~/.config/pulse/client.conf file.\n\n");
	printf("   --help, -? - this help screen.\n\n");
	printf("   --list - list all firejail symbolic links.\n\n");
	printf("   --version - print program version and exit.\n\n");
	printf("Example:\n\n");
	printf("   $ sudo firecfg\n");
	printf("   /usr/local/bin/firefox created\n");
	printf("   /usr/local/bin/vlc created\n");
	printf("   [...]\n");
	printf("   $ firecfg --list\n");
	printf("   /usr/local/bin/firefox\n");
	printf("   /usr/local/bin/vlc\n");
	printf("   [...]\n");
	printf("   $ sudo firecfg --clean\n");
	printf("   /usr/local/bin/firefox removed\n");
	printf("   /usr/local/bin/vlc removed\n");
	printf("   [...]\n");
	printf("\n");
	printf("License GPL version 2 or later\n");
	printf("Homepage: http://firejail.wordpress.com\n\n");
}


static void list(void) {
	DIR *dir = opendir("/usr/local/bin");
	if (!dir) {
		fprintf(stderr, "Error: cannot open /usr/local/bin directory\n");
		exit(1);
	}

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		char *fullname;
		if (asprintf(&fullname, "/usr/local/bin/%s", entry->d_name) == -1)
			errExit("asprintf");

		if (is_link(fullname)) {
			char* fname = realpath(fullname, NULL);
			if (fname) {
				if (strcmp(fname, firejail_exec) == 0)
					printf("%s\n", fullname);
				free(fname);
			}
		}
		free(fullname);
	}

	closedir(dir);
	free(firejail_exec);
}

static void clean(void) {
	printf("Removing all firejail symlinks:\n");
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this command\n");
		exit(1);
	}

	DIR *dir = opendir("/usr/local/bin");
	if (!dir) {
		fprintf(stderr, "Error: cannot open /usr/local/bin directory\n");
		exit(1);
	}

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	struct dirent *entry;
	while ((entry = readdir(dir)) != NULL) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		char *fullname;
		if (asprintf(&fullname, "/usr/local/bin/%s", entry->d_name) == -1)
			errExit("asprintf");

		if (is_link(fullname)) {
			char* fname = realpath(fullname, NULL);
			if (fname) {
				if (strcmp(fname, firejail_exec) == 0) {
					char *ptr = strrchr(fullname, '/');
					assert(ptr);
					ptr++;
					unlink(fullname);
					printf("   %s removed\n", ptr);
				}
				free(fname);
			}
		}
		free(fullname);
	}

	closedir(dir);
	free(firejail_exec);
	printf("\n");
}

static void set_file(const char *name, const char *firejail_exec) {
	if (which(name) == 0)
		return;

	char *fname;
	if (asprintf(&fname, "/usr/local/bin/%s", name) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) != 0) {
		int rv = symlink(firejail_exec, fname);
		if (rv) {
			fprintf(stderr, "Error: cannot create %s symbolic link\n", fname);
			perror("symlink");
		}
		else
			printf("   %s created\n", name);
	}

	free(fname);
}

// parse /usr/lib/firejail/firecfg.cfg file
static void set_links_firecfg(void) {
	char *cfgfile;
	if (asprintf(&cfgfile, "%s/firejail/firecfg.config", LIBDIR) == -1)
		errExit("asprintf");

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	// parse /usr/lib/firejail/firecfg.cfg file
	FILE *fp = fopen(cfgfile, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", cfgfile);
		exit(1);
	}
	printf("Configuring symlinks in /usr/local/bin based on firecfg.config\n");

	char buf[MAX_BUF];
	int lineno = 0;
	while (fgets(buf, MAX_BUF,fp)) {
		lineno++;
		if (*buf == '#') // comments
			continue;

		// do not accept .. and/or / in file name
		if (strstr(buf, "..") || strchr(buf, '/')) {
			fprintf(stderr, "Error: invalid line %d in %s\n", lineno, cfgfile);
			exit(1);
		}

		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';

		// trim spaces
		ptr = buf;
		while (*ptr == ' ' || *ptr == '\t')
			ptr++;
		char *start = ptr;

		// empty line
		if (*start == '\0')
			continue;

		// set link
		set_file(start, firejail_exec);
	}

	fclose(fp);
	free(cfgfile);
	free(firejail_exec);
}

// parse ~/.config/firejail/ directory
static void set_links_homedir(const char *homedir) {
	assert(homedir);

	// check firejail config directory
	char *dirname;
	if (asprintf(&dirname, "%s/.config/firejail", homedir) == -1)
		errExit("asprintf");
	struct stat s;
	if (stat(dirname, &s) != 0) {
		free(dirname);
		return;
	}

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	// parse ~/.config/firejail/ directory
	printf("\nConfiguring symlinks in /usr/local/bin based on local firejail config directory\n");

	DIR *dir = opendir(dirname);
	if (!dir) {
		fprintf(stderr, "Error: cannot open ~/.config/firejail directory\n");
		free(dirname);
		return;
	}

	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		char *exec = strdup(entry->d_name);
		if (!exec)
			errExit("strdup");
		char *ptr = strrchr(exec, '.');
		if (!ptr) {
			free(exec);
			continue;
		}
		if (strcmp(ptr, ".profile") != 0) {
			free(exec);
			continue;
		}

		*ptr = '\0';
		set_file(exec, firejail_exec);
		free(exec);
	}
	closedir(dir);

	free(firejail_exec);
}


int main(int argc, char **argv) {
	int i;

	for (i = 1; i < argc; i++) {
		// default options
		if (strcmp(argv[i], "--help") == 0 ||
		    strcmp(argv[i], "-?") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strcmp(argv[i], "--version") == 0) {
			printf("firecfg version %s\n\n", VERSION);
			return 0;
		}
		else if (strcmp(argv[i], "--clean") == 0) {
			clean();
			return 0;
		}
		else if (strcmp(argv[i], "--fix") == 0) {
			// find home directory
			struct passwd *pw = getpwuid(getuid());
			if (!pw) {
				goto errexit;
			}
			char *home = pw->pw_dir;
			if (!home) {
				goto errexit;
			}
			fix_desktop_files(home);
			return 0;
		}
		else if (strcmp(argv[i], "--list") == 0) {
			list();
			return 0;
		}
		else if (strcmp(argv[i], "--fix-sound") == 0) {
			sound();
			return 0;
		}
		else {
			fprintf(stderr, "Error: invalid command line option\n");
			usage();
			return 1;
		}
	}

	// set symlinks in /usr/local/bin
	if (getuid() != 0) {
		fprintf(stderr, "Error: cannot set the symbolic links in /usr/local/bin\n");
		fprintf(stderr, "The proper way to run this command is \"sudo firecfg\".\n");
		return 1;
	}
	else {
		// create /usr/local directory if it doesn't exist (Solus distro)
		struct stat s;
		if (stat("/usr/local", &s) != 0) {
			printf("Creating /usr/local directory\n");
			int rv = mkdir("/usr/local", 0755);
			if (rv != 0) {
				fprintf(stderr, "Error: cannot create /usr/local directory\n");
				return 1;
			}
		}
		if (stat("/usr/local/bin", &s) != 0) {
			printf("Creating /usr/local directory\n");
			int rv = mkdir("/usr/local/bin", 0755);
			if (rv != 0) {
				fprintf(stderr, "Error: cannot create /usr/local/bin directory\n");
				return 1;
			}
		}
	}
	clean();
	set_links_firecfg();



	// switch to the local user, and fix desktop files
	char *user = getlogin();
	if (!user) {
		user = getenv("SUDO_USER");
		if (!user) {
			goto errexit;
		}
	}

	if (user) {
		// find home directory
		struct passwd *pw = getpwnam(user);
		if (!pw) {
			goto errexit;
		}
		char *home = pw->pw_dir;
		if (!home) {
			goto errexit;
		}

		// running as root
		set_links_homedir(home);

		// drop permissions
		if (setgroups(0, NULL) < 0)
			errExit("setgroups");
		// set uid/gid
		if (setgid(pw->pw_gid) < 0)
			errExit("setgid");
		if (setuid(pw->pw_uid) < 0)
			errExit("setuid");
		if (arg_debug)
			printf("%s %d %d %d %d\n", user, getuid(), getgid(), geteuid(), getegid());
		fix_desktop_files(home);
	}

	return 0;

errexit:
	fprintf(stderr, "Error: cannot detect login user in order to set desktop files in ~/.local/share/applications\n");
	return 1;
}

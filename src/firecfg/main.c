/*
 * Copyright (C) 2014-2022 Firejail Authors
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
#include "../include/firejail_user.h"
int arg_debug = 0;
char *arg_bindir = "/usr/local/bin";

static char *usage_str =
	"Firecfg is the desktop configuration utility for Firejail software. The utility\n"
	"creates several symbolic links to firejail executable. This allows the user to\n"
	"sandbox applications automatically, just by clicking on a regular desktop\n"
	"menus and icons.\n\n"
	"The symbolic links are placed in /usr/local/bin. For more information, see\n"
	"DESKTOP INTEGRATION section in man 1 firejail.\n\n"
	"Usage: firecfg [OPTIONS]\n\n"
	"   --add-users user [user] - add the users to Firejail user access database.\n\n"
	"   --bindir=directory - install in directory instead of /usr/local/bin.\n\n"
	"   --clean - remove all firejail symbolic links.\n\n"
	"   --debug - print debug messages.\n\n"
	"   --fix - fix .desktop files.\n\n"
	"   --fix-sound - create ~/.config/pulse/client.conf file.\n\n"
	"   --guide - guided configuration for new users.\n\n"
	"   --help, -? - this help screen.\n\n"
	"   --list - list all firejail symbolic links.\n\n"
	"   --version - print program version and exit.\n\n"
	"Example:\n\n"
	"   $ sudo firecfg\n"
	"   /usr/local/bin/firefox created\n"
	"   /usr/local/bin/vlc created\n"
	"   [...]\n"
	"   $ firecfg --list\n"
	"   /usr/local/bin/firefox\n"
	"   /usr/local/bin/vlc\n"
	"   [...]\n"
	"   $ sudo firecfg --clean\n"
	"   /usr/local/bin/firefox removed\n"
	"   /usr/local/bin/vlc removed\n"
	"   [...]\n"
	"\n"
	"License GPL version 2 or later\n"
	"Homepage: https://firejail.wordpress.com\n\n";

static void usage(void) {
	printf("firecfg - version %s\n\n", VERSION);
	puts(usage_str);
}


static void list(void) {
	DIR *dir = opendir(arg_bindir);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", arg_bindir);
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
		if (asprintf(&fullname, "%s/%s", arg_bindir, entry->d_name) == -1)
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

	DIR *dir = opendir(arg_bindir);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", arg_bindir);
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
		if (asprintf(&fullname, "%s/%s", arg_bindir, entry->d_name) == -1)
			errExit("asprintf");

		if (is_link(fullname)) {
			char* fname = realpath(fullname, NULL);
			if (fname) {
				if (strcmp(fname, firejail_exec) == 0) {
					char *ptr = strrchr(fullname, '/');
					assert(ptr);
					ptr++;
					int rv = unlink(fullname);
					if (rv)
						fprintf(stderr, "Warning: cannot remove %s\n", fullname);
					else
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
	if (asprintf(&fname, "%s/%s", arg_bindir, name) == -1)
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
	else {
	  fprintf(stderr, "Warning: cannot create %s - already exists! Skipping...\n", fname);
	}

	free(fname);
}

// parse /etc/firejail/firecfg.config file
static void set_links_firecfg(void) {
	char *cfgfile;
	if (asprintf(&cfgfile, "%s/firecfg.config", SYSCONFDIR) == -1)
		errExit("asprintf");

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	// parse /etc/firejail/firecfg.config file
	FILE *fp = fopen(cfgfile, "r");
	if (!fp) {
		perror("fopen");
		fprintf(stderr, "Error: cannot open %s\n", cfgfile);
		exit(1);
	}
	printf("Configuring symlinks in %s based on firecfg.config\n", arg_bindir);

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
	printf("\nConfiguring symlinks in %s based on local firejail config directory\n", arg_bindir);

	DIR *dir = opendir(dirname);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", dirname);
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

static char *get_user(void) {
	char *user = getenv("SUDO_USER");
	if (!user) {
		user = getpwuid(getuid())->pw_name;
		if (!user) {
			fprintf(stderr, "Error: cannot detect login user\n");
			exit(1);
		}
	}

	return user;
}

static char *get_homedir(const char *user, uid_t *uid, gid_t *gid) {
	// find home directory
	struct passwd *pw = getpwnam(user);
	if (!pw)
		goto errexit;

	char *home = pw->pw_dir;
	if (!home)
		goto errexit;

	*uid = pw->pw_uid;
	*gid = pw->pw_gid;

	return home;

errexit:
	fprintf(stderr, "Error: cannot find home directory for user %s\n", user);
	exit(1);
}

int main(int argc, char **argv) {
	int i;
	int bindir_set = 0;

	// user setup
	char *user = get_user();
	assert(user);
	uid_t uid;
	gid_t gid;
	char *home = get_homedir(user, &uid, &gid);


	// check for --bindir
	for (i = 1; i < argc; i++) {
		if (strncmp(argv[i], "--bindir=", 9) == 0) {
			if (strncmp(argv[i] + 9, "~/", 2) == 0) {
				if (asprintf(&arg_bindir, "%s/%s", home, argv[i] + 11) == -1)
					errExit("asprintf");
			}
			else
				arg_bindir = argv[i] + 9;
			bindir_set = 1;

			// exit if the directory does not exist, or if we don't have access to it
			if (access(arg_bindir, R_OK | W_OK | X_OK)) {
				if (errno == EACCES)
					fprintf(stderr, "Error: firecfg needs full permissions on directory %s\n", arg_bindir);
				else {
					perror("access");
					fprintf(stderr, "Error: cannot access directory %s\n", arg_bindir);
				}
				exit(1);
			}
		}
	}

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
			fix_desktop_files(home);
			return 0;
		}
		else if (strcmp(argv[i], "--guide") == 0) {
			return system(LIBDIR "/firejail/firejail-welcome.sh");
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
		else if (strcmp(argv[i], "--add-users") == 0) {
			int j;
			if (getuid() != 0) {
				fprintf(stderr, "Error: you need to be root to use this option\n");
				exit(1);
			}

			// set umask, access database must be world-readable
			umask(022);
			for (j = i + 1; j < argc; j++) {
				printf("Adding user %s to Firejail access database in %s/firejail.users\n", argv[j], SYSCONFDIR);
				firejail_user_add(argv[j]);
			}
			return 0;
		}
		else {
			if (strncmp(argv[i], "--bindir=", 9) != 0) { // already handled
				fprintf(stderr, "Error: invalid command line option\n");
				usage();
				return 1;
			}
		}
	}

	if (arg_debug)
		printf("%s %d %d %d %d\n", user, getuid(), getgid(), geteuid(), getegid());

	// set symlinks in /usr/local/bin
	if (bindir_set == 0 && getuid() != 0) {
		fprintf(stderr, "Error: cannot set the symbolic links in %s\n", arg_bindir);
		fprintf(stderr, "The proper way to run this command is \"sudo firecfg\".\n");
		return 1;
	}
	else if (bindir_set == 0) {
		// create /usr/local directory if it doesn't exist (Solus distro)
		mode_t orig_umask = umask(022); // temporarily set the umask
		struct stat s;
		if (stat("/usr/local", &s) != 0) {
			printf("Creating /usr/local directory\n");
			int rv = mkdir("/usr/local", 0755);
			if (rv != 0) {
				fprintf(stderr, "Error: cannot create /usr/local directory\n");
				return 1;
			}
		}
		if (stat(arg_bindir, &s) != 0) {
			printf("Creating %s directory\n", arg_bindir);
			int rv = mkdir(arg_bindir, 0755);
			if (rv != 0) {
				fprintf(stderr, "Error: cannot create %s directory\n", arg_bindir);
				return 1;
			}
		}
		umask(orig_umask);
	}

	// clear all symlinks
	clean();

	// set new symlinks based on /etc/firejail/firecfg.config
	set_links_firecfg();

	if (getuid() == 0) {
		// add user to firejail access database - only for root
		printf("\nAdding user %s to Firejail access database in %s/firejail.users\n", user, SYSCONFDIR);
		// temporarily set the umask, access database must be world-readable
		mode_t orig_umask = umask(022);
		firejail_user_add(user);
		umask(orig_umask);

#ifdef HAVE_APPARMOR
		// enable firejail apparmor profile
		struct stat s;
		if (stat("/sbin/apparmor_parser", &s) == 0) {
			char *cmd;

			// SYSCONFDIR points to /etc/firejail, we have to go on level up (..)
			printf("\nLoading AppArmor profile\n");
			if (asprintf(&cmd, "/sbin/apparmor_parser -r /etc/apparmor.d/firejail-default %s/../apparmor.d/firejail-default", SYSCONFDIR) == -1)
				errExit("asprintf");
			int rv = system(cmd);
			(void) rv;
			free(cmd);
		}
#endif
	}



	// set new symlinks based on ~/.config/firejail directory
	set_links_homedir(home);

	// drop permissions
	if (getuid() == 0) {
		if (setgroups(0, NULL) < 0)
			errExit("setgroups");
		if (setgid(gid) < 0)
			errExit("setgid");
		if (setuid(uid) < 0)
			errExit("setuid");
	}

	if (arg_debug)
		printf("%s %d %d %d %d\n", user, getuid(), getgid(), geteuid(), getegid());

	// if runs as regular user, fix .desktop files in ~/.local/share/applications directory
	if (getuid() != 0)
		fix_desktop_files(home);

	return 0;
}

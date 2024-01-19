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
#include "../include/firejail_user.h"
#include <glob.h>

int arg_debug = 0;
char *arg_bindir = "/usr/local/bin";
int arg_guide = 0;
int done_config = 0;

static const char *const usage_str =
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
	"Homepage: https://firejail.wordpress.com\n";

static void print_version(void) {
	printf("firecfg version %s\n\n", VERSION);
}

static void usage(void) {
	print_version();
	puts(usage_str);
}

static void list(void) {
	DIR *dir = opendir(arg_bindir);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", arg_bindir);
		exit(1);
	}

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
				if (strcmp(fname, FIREJAIL_EXEC) == 0)
					printf("%s\n", fullname);
				free(fname);
			}
		}
		free(fullname);
	}

	closedir(dir);
}

static void clean(void) {
	printf("Removing all firejail symlinks:\n");

	DIR *dir = opendir(arg_bindir);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", arg_bindir);
		exit(1);
	}

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
				if (strcmp(fname, FIREJAIL_EXEC) == 0) {
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
	printf("\n");
}

#define ignorelist_maxlen 2048
static const char *ignorelist[ignorelist_maxlen];
static int ignorelist_len = 0;

static int append_ignorelist(const char *const str) {
	assert(str);
	if (ignorelist_len >= ignorelist_maxlen) {
		fprintf(stderr, "Warning: Ignore list is full (%d/%d), skipping %s\n",
			ignorelist_len, ignorelist_maxlen, str);
		return 0;
	}

	printf("   ignoring '%s'\n", str);
	const char *const dup = strdup(str);
	if (!dup)
		errExit("strdup");

	ignorelist[ignorelist_len] = dup;
	ignorelist_len++;

	return 1;
}

int in_ignorelist(const char *const str) {
	assert(str);
	int i;
	for (i = 0; i < ignorelist_len; i++) {
		if (strcmp(str, ignorelist[i]) == 0)
			return 1;
	}

	return 0;
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
		} else {
			printf("   %s created\n", name);
		}
	} else {
		fprintf(stderr, "Warning: cannot create %s - already exists! Skipping...\n", fname);
	}

	free(fname);
}

// parse a single config file
static void parse_config_file(const char *cfgfile, int do_symlink) {
	if (do_symlink)
		printf("Configuring symlinks in %s\n", arg_bindir);

	printf("Parsing %s\n", cfgfile);

	FILE *fp = fopen(cfgfile, "r");
	if (!fp) {
		perror("fopen");
		fprintf(stderr, "Error: cannot open %s\n", cfgfile);
		exit(1);
	}

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

		// handle ignore command
		if (*start == '!') {
			append_ignorelist(start + 1);
			continue;
		}

		// skip ignored programs
		if (in_ignorelist(start)) {
			printf("   %s ignored\n", start);
			continue;
		}

		// set link
		if (do_symlink)
			set_file(start, FIREJAIL_EXEC);
	}

	fclose(fp);
	printf("\n");
}

// parse all config files matching pattern
static void parse_config_glob(const char *pattern, int do_symlink) {
	printf("Looking for config files in %s\n", pattern);

	glob_t globbuf;
	int globerr = glob(pattern, 0, NULL, &globbuf);
	if (globerr == GLOB_NOMATCH) {
		fprintf(stderr, "No matches for glob pattern %s\n", pattern);
		goto out;
	} else if (globerr != 0) {
		fprintf(stderr, "Warning: Failed to match glob pattern %s: %s\n",
		        pattern, strerror(errno));
		goto out;
	}

	size_t i;
	for (i = 0; i < globbuf.gl_pathc; i++)
		parse_config_file(globbuf.gl_pathv[i], do_symlink);
out:
	globfree(&globbuf);
}

// parse all config files
// do_symlink 0 just builds the ignorelist, 1 creates the symlinks
void parse_config_all(int do_symlink) {
	if (done_config)
		return;

	parse_config_glob(FIRECFG_CONF_GLOB, do_symlink);
	parse_config_file(FIRECFG_CFGFILE, do_symlink);

	done_config = 1;
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

	// parse ~/.config/firejail/ directory
	printf("\nConfiguring symlinks in %s based on local firejail config directory\n", arg_bindir);

	DIR *dir = opendir(dirname);
	if (!dir) {
		perror("opendir");
		fprintf(stderr, "Error: cannot open %s directory\n", dirname);
		free(dirname);
		return;
	}
	free(dirname);

	struct dirent *entry;
	while ((entry = readdir(dir))) {
		if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0)
			continue;

		char *exec = strdup(entry->d_name);
		if (!exec)
			errExit("strdup");
		char *ptr = strrchr(exec, '.');
		if (!ptr)
			goto next;
		if (strcmp(ptr, ".profile") != 0)
			goto next;

		*ptr = '\0';
		if (in_ignorelist(exec)) {
			printf("   %s ignored\n", exec);
			goto next;
		}

		set_file(exec, FIREJAIL_EXEC);
next:
		free(exec);
	}
	closedir(dir);
}

static const char *get_sudo_user(void) {
	const char *doas_user = getenv("DOAS_USER");
	const char *sudo_user = getenv("SUDO_USER");
	const char *user = doas_user ? doas_user : sudo_user;

	if (!user) {
		user = getpwuid(getuid())->pw_name;
		if (!user) {
			fprintf(stderr, "Error: cannot detect login user\n");
			exit(1);
		}
	}

	return user;
}

static const char *get_homedir(const char *user, uid_t *uid, gid_t *gid) {
	// find home directory
	struct passwd *pw = getpwnam(user);
	if (!pw)
		goto errexit;

	const char *home = pw->pw_dir;
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
	const char *user = get_sudo_user();
	assert(user);
	uid_t uid;
	gid_t gid;
	const char *home = get_homedir(user, &uid, &gid);

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
			print_version();
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
			arg_guide = 1;
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

	print_version();
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

	if (arg_guide) {
		const char *zenity_exec;
		if (arg_debug)
			zenity_exec = FZENITY_EXEC;
		else
			zenity_exec = ZENITY_EXEC;

		char *cmd;
		if (asprintf(&cmd, "%s %s %s %s %s",
			     SUDO_EXEC, FIREJAIL_WELCOME_SH, zenity_exec, SYSCONFDIR, user) == -1)
			errExit("asprintf");

		int status = system(cmd);
		if (status == -1) {
			fprintf(stderr, "Error: cannot run %s\n", FIREJAIL_WELCOME_SH);
			exit(1);
		}
		free(cmd);

		// the last 8 bits of the status is the return value of the command executed by system()
		// firejail-welcome.sh returns 55 if setting sysmlinks is required
		if (WEXITSTATUS(status)  != 55)
			return 0;
	}

	// clear all symlinks
	clean();

	// set new symlinks based on config files
	parse_config_all(1);

	if (getuid() == 0) {
		// add user to firejail access database - only for root
		printf("Adding user %s to Firejail access database in %s/firejail.users\n", user, SYSCONFDIR);
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

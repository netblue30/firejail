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

#define _GNU_SOURCE
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <grp.h>
#include <string.h>
#include <errno.h>
#include <sys/mman.h>
#include <pwd.h>

#include "../include/common.h"
static int arg_debug = 0;
#define MAX_BUF 1024

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

static void sound(void) {
	struct passwd *pw = getpwuid(getuid());
	if (!pw) {
		goto errexit;
	}
	char *home = pw->pw_dir;
	if (!home) {
		goto errexit;
	}

	// the input file is /etc/pulse/client.conf
	FILE *fpin = fopen("/etc/pulse/client.conf", "r");
	if (!fpin) {
		fprintf(stderr, "PulseAudio is not available on this platform, there is nothing to fix...\n");
		return;
	}

	// the dest is PulseAudio user config file
	char *fname;
	if (asprintf(&fname, "%s/.config/pulse/client.conf", home) == -1)
		errExit("asprintf");
	FILE *fpout = fopen(fname, "w");
	free(fname);
	if (!fpout)
		goto errexit;

	// copy default config
	char buf[MAX_BUF];
	while (fgets(buf, MAX_BUF, fpin))
		fputs(buf, fpout);

	// disable shm
	fprintf(fpout, "\nenable-shm = no\n");
	fclose(fpin);
	fclose(fpout);
	printf("PulseAudio configured, please logout and login back again\n");
	return;

errexit:
	fprintf(stderr, "Error: cannot configure sound file\n");
	exit(1);
}

// return 1 if the program is found
static int find(const char *program, const char *directory) {
	int retval = 0;

	char *fname;
	if (asprintf(&fname, "/%s/%s", directory, program) == -1)
		errExit("asprintf");

	struct stat s;
	if (stat(fname, &s) == 0) {
	     	if (arg_debug)
	     		printf("found %s in directory %s\n", program, directory);
		retval = 1;
	}

	free(fname);
	return retval;
}


// return 1 if program is installed on the system
static int which(const char *program) {
	// check some well-known paths
	if (find(program, "/bin") || find(program, "/usr/bin") ||
	     find(program, "/sbin") || find(program, "/usr/sbin") ||
	     find(program, "/usr/games"))
		return 1;

	// check environment
	char *path1 = getenv("PATH");
	if (path1) {
		char *path2 = strdup(path1);
		if (!path2)
			errExit("strdup");

		// use path2 to count the entries
		char *ptr = strtok(path2, ":");
		while (ptr) {
			if (find(program, ptr)) {
				free(path2);
				return 1;
			}
			ptr = strtok(NULL, ":");
		}
		free(path2);
	}

	return 0;
}

// return 1 if the file is a link
static int is_link(const char *fname) {
	assert(fname);
	if (*fname == '\0')
		return 0;

	struct stat s;
	if (lstat(fname, &s) == 0) {
		if (S_ISLNK(s.st_mode))
			return 1;
	}

	return 0;
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

static void clear(void) {
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
					printf("%s removed\n", fullname);
					unlink(fullname);
				}
				free(fname);
			}
		}
		free(fullname);
	}

	closedir(dir);
	free(firejail_exec);
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

static void set_links(void) {
	char *cfgfile;
	if (asprintf(&cfgfile, "%s/firejail/firecfg.config", LIBDIR) == -1)
		errExit("asprintf");

	char *firejail_exec;
	if (asprintf(&firejail_exec, "%s/bin/firejail", PREFIX) == -1)
		errExit("asprintf");

	FILE *fp = fopen(cfgfile, "r");
	if (!fp) {
		fprintf(stderr, "Error: cannot open %s\n", cfgfile);
		exit(1);
	}
	printf("Configuring symlinks in /usr/local/bin\n");

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

// look for a profile file in /etc/firejail diectory and in homedir/.config/firejail directory
static int have_profile(const char *filename, const char *homedir) {
	assert(filename);
	assert(homedir);
printf("test #%s# #%s#\n", filename, homedir);

	// remove .desktop extension
	char *f1 = strdup(filename);
	if (!f1)
		errExit("strdup");
	f1[strlen(filename) - 8] = '\0';
printf("#%s#\n", f1);

	// build profile name
	char *profname1;
	char *profname2;
	if (asprintf(&profname1, "%s/%s.profile", SYSCONFDIR, f1) == -1)
		errExit("asprintf");
	if (asprintf(&profname2, "%s/./configure/firejail/%s.profile", homedir, f1) == -1)
		errExit("asprintf");
printf("#%s#\n", profname1);
printf("#%s#\n", profname2);

	int rv = 0;
	if (access(profname1, R_OK) == 0)
		rv = 1;
	else if (access(profname2, R_OK) == 0)
		rv == 1;
		
	free(f1);
	free(profname1);
	free(profname2);
	return rv;
}

static void fix_desktop_files(char *homedir) {
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

		/* coverity[toctou] */
		int fd = open(filename, O_RDONLY);
		if (fd == -1)
			errExit("open");

		char *buf = mmap(NULL, sb.st_size + 1, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
		if (buf == MAP_FAILED)
			errExit("mmap");

		close(fd);

		// check format
		if (strstr(buf, "[Desktop Entry]\n") == NULL) {
			if (arg_debug)
				printf("   %s - SKIPPED: wrong format?\n", filename);
			munmap(buf, sb.st_size + 1);
			continue;
		}

		// get executable name
		char *ptr1 = strstr(buf,"\nExec=");
		if (!ptr1 || strlen(ptr1) < 7) {
			if (arg_debug)
				printf("   %s - SKIPPED: wrong format?\n", filename);
			munmap(buf, sb.st_size + 1);
			continue;
		}

		char *execname = ptr1 + 6;
		// https://specifications.freedesktop.org/desktop-entry-spec/latest/ar01s06.html
		// The executable program can either be specified with its full path
		// or with the name of the executable only
		if (execname[0] != '/') {
			if (arg_debug)
				printf("   %s - already OK\n", filename);
			continue;
		}
		// executable name can be quoted, this is rare and currently unsupported, TODO
		if (execname[0] == '"') {
			if (arg_debug)
				printf("   %s - skipped: path quoting unsupported\n", filename);
			continue;
		}

		// put '\0' at end of filename
		char *tail = NULL;
		char endchar = ' ';
		if (execname[0] == '/') {
			char *ptr2 = index(execname, ' ');
			char *ptr3 = index(execname, '\n');
			if (ptr2 && (!ptr3 || (ptr2 < ptr3))) {
				endchar = ptr2[0];
				ptr2[0] = '\0';
				tail = ptr2 + 1;
			} else if (ptr3 && (!ptr2 || (ptr3 < ptr2))) {
				endchar = ptr3[0];
				ptr3[0] = '\0';
				tail = ptr3 + 1;
			}
			ptr1[5] = '\0';
		}

		char *bname = basename(execname);
		assert(bname);

		// check if basename in PATH
		if (!which(bname)) {
			printf("   %s - skipped, %s not in PATH\n", filename, bname);
			continue;
		}

		char *outname;
		if (asprintf(&outname ,"%s/%s", user_apps_dir, filename) == -1)
			errExit("asprintf");

		int fd1 = open(outname, O_CREAT | O_WRONLY | O_EXCL, S_IRUSR | S_IWUSR);
		free(outname);

		if (fd1 == -1) {
			printf("   %s skipped: %s\n", filename, strerror(errno));
			munmap(buf, sb.st_size + 1);
			continue;
		}

		FILE *outfile = fdopen(fd1, "w");
		if (!outfile) {
			printf("   %s skipped: %s\n", filename, strerror(errno));
			munmap(buf, sb.st_size + 1);
			close(fd1);
			continue;
		}

		if (fprintf(outfile,\
		"# Converted by firecfg --fix from /usr/share/applications/%s\n\n%s=%s%c%s",\
		filename, buf, bname, endchar, tail) < 0) {
			fprintf(stderr, "Unable to write %s/%s: %s\n", user_apps_dir, filename, strerror(errno));
			munmap(buf, sb.st_size + 1);
			fclose(outfile);
			continue;
		}

		fclose(outfile);
		munmap(buf, sb.st_size + 1);

		printf("   %s created\n", filename);
	}

	closedir(dir);
	free(user_apps_dir);
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
			clear();
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
	set_links();



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

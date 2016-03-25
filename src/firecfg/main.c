/*
 * Copyright (C) 2014-2016 netblue30 (netblue30@yahoo.com)
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

#include <sys/types.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include "../include/common.h"

static void usage(void) {
	printf("firecfg - version %s\n\n", VERSION);
	printf("Firecfg is the desktop configuration utility for Firejail software. The utility\n");
	printf("creates several symbolic links to firejail executable. This allows the user to\n");
	printf("sandbox applications automatically, just by clicking on a regular desktop\n");
	printf("menues and icons.\n\n");
	printf("The symbolic links are placed in /usr/local/bin. For more information, see\n");
	printf("DESKTOP INTEGRATION section in man 1 firejail.\n\n");
	printf("Usage: firecfg [OPTIONS]\n\n");
	printf("   --clear - clear all firejail symbolic links\n\n");
	printf("   --help, -? - this help screen.\n\n");
	printf("   --list - list all firejail symbolic links\n\n");
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
	printf("   $ sudo firecfg --clear\n");
	printf("   /usr/local/bin/firefox removed\n");
	printf("   /usr/local/bin/vlc removed\n");
	printf("   [...]\n");
	printf("\n");
	printf("License GPL version 2 or later\n");
	printf("Homepage: http://firejail.wordpress.com\n\n");
}

// return 1 if the program is found
static int find(const char *program, const char *directory) {
	int retval = 0;
	
	char *fname;
	if (asprintf(&fname, "/%s/%s", directory, program) == -1)
		errExit("asprintf");
		
	struct stat s;
	if (stat(fname, &s) == 0)
		retval = 1;
	
	free(fname);
	return retval;
}


// return 1 if program is installed on the system
static int which(const char *program) {
	// check some well-known paths
	if (find(program, "/bin") || find(program, "/usr/bin") ||
	     find(program, "/sbin") || find(program, "/usr/sbin"))
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
	if (stat(fname, &s) == 0)
		; //printf("%s already present\n", fname);
	else {
		int rv = symlink(firejail_exec, fname);
		if (rv) {
			fprintf(stderr, "Error: cannot create %s symbolic link\n", fname);
			perror("symlink");
		}
		else
			printf("%s created\n", fname);
	}
	
	free(fname);
}

#define MAX_BUF 1024
static void set(void) {
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root to run this command\n");
		exit(1);
	}

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
	
	char buf[MAX_BUF];
	int lineno = 0;
	while (fgets(buf, MAX_BUF,fp)) {
		lineno++;
		if (*buf == '#') // comments
			continue;
		
		// remove \n
		char *ptr = strchr(buf, '\n');
		if (ptr)
			*ptr = '\0';
		
		// do not accept .. and/or / in file name
		if (strstr(buf, "..") || strchr(buf, '/')) {
			fprintf(stderr, "Error: invalid line %d in %s\n", lineno, cfgfile);
			exit(1);
		}
		
		set_file(buf, firejail_exec);
	}

	free(cfgfile);
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
		else if (strcmp(argv[i], "--version") == 0) {
			printf("firecfg version %s\n\n", VERSION);
			return 0;
		}
		else if (strcmp(argv[i], "--clear") == 0) {
			clear();
			return 0;
		}
		else if (strcmp(argv[i], "--list") == 0) {
			list();
			return 0;
		}
		else {
			fprintf(stderr, "Error: invalid command line option\n");
			usage();
			return 1;
		}
	}
	
	set();
	
	return 0;
}


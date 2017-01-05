/*
 * Copyright (C) 2014-2016 Firejail Authors
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
#define _XOPEN_SOURCE 500
#include "firejail.h"
#include <ftw.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <syslog.h>
#include <errno.h>
#include <dirent.h>
#include <grp.h>
#include <sys/ioctl.h>
#include <termios.h>

#define MAX_GROUPS 1024
// drop privileges
// - for root group or if nogroups is set, supplementary groups are not configured
void drop_privs(int nogroups) {
	EUID_ROOT();
	gid_t gid = getgid();

	// configure supplementary groups
	if (gid == 0 || nogroups) {
		if (setgroups(0, NULL) < 0)
			errExit("setgroups");
		if (arg_debug)
			printf("Username %s, no supplementary groups\n", cfg.username);
	}
	else {
		assert(cfg.username);
		gid_t groups[MAX_GROUPS];
		int ngroups = MAX_GROUPS;
		int rv = getgrouplist(cfg.username, gid, groups, &ngroups);

		if (arg_debug && rv) {
			printf("Username %s, groups ", cfg.username);
			int i;
			for (i = 0; i < ngroups; i++)
				printf("%u, ", groups[i]);
			printf("\n");
		}

		if (rv == -1) {
			fprintf(stderr, "Warning: cannot extract supplementary group list, dropping them\n");
			if (setgroups(0, NULL) < 0)
				errExit("setgroups");
		}
		else {
			rv = setgroups(ngroups, groups);
			if (rv) {
				fprintf(stderr, "Warning: cannot set supplementary group list, dropping them\n");
				if (setgroups(0, NULL) < 0)
					errExit("setgroups");
			}
		}
	}

	// set uid/gid
	if (setgid(getgid()) < 0)
		errExit("setgid/getgid");
	if (setuid(getuid()) < 0)
		errExit("setuid/getuid");
}


int mkpath_as_root(const char* path) {
	assert(path && *path);

	// work on a copy of the path
	char *file_path = strdup(path);
	if (!file_path)
		errExit("strdup");

	char* p;
	int done = 0;
	for (p=strchr(file_path+1, '/'); p; p=strchr(p+1, '/')) {
		*p='\0';
		if (mkdir(file_path, 0755)==-1) {
			if (errno != EEXIST) {
				*p='/';
				free(file_path);
				return -1;
			}
		}
		else {
			if (chmod(file_path, 0755) == -1)
				errExit("chmod");
			if (chown(file_path, 0, 0) == -1)
				errExit("chown");
			done = 1;
		}

		*p='/';
	}
	if (done)
		fs_logger2("mkpath", path);

	free(file_path);
	return 0;
}


void logsignal(int s) {
	if (!arg_debug)
		return;

	openlog("firejail", LOG_NDELAY | LOG_PID, LOG_USER);
	syslog(LOG_INFO, "Signal %d caught", s);
	closelog();
}


void logmsg(const char *msg) {
	if (!arg_debug)
		return;

	openlog("firejail", LOG_NDELAY | LOG_PID, LOG_USER);
	syslog(LOG_INFO, "%s\n", msg);
	closelog();
}


void logargs(int argc, char **argv) {
	if (!arg_debug)
		return;

	int i;
	int len = 0;

	// calculate message length
	for (i = 0; i < argc; i++)
		len += strlen(argv[i]) + 1;	  // + ' '

	// build message
	char msg[len + 1];
	char *ptr = msg;
	for (i = 0; i < argc; i++) {
		sprintf(ptr, "%s ", argv[i]);
		ptr += strlen(ptr);
	}

	// log message
	logmsg(msg);
}


void logerr(const char *msg) {
	if (!arg_debug)
		return;

	openlog("firejail", LOG_NDELAY | LOG_PID, LOG_USER);
	syslog(LOG_ERR, "%s\n", msg);
	closelog();
}


// return -1 if error, 0 if no error
int copy_file(const char *srcname, const char *destname, uid_t uid, gid_t gid, mode_t mode) {
	assert(srcname);
	assert(destname);

	// open source
	int src = open(srcname, O_RDONLY);
	if (src < 0) {
		fprintf(stderr, "Warning: cannot open %s, file not copied\n", srcname);
		return -1;
	}

	// open destination
	int dst = open(destname, O_CREAT|O_WRONLY|O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
	if (dst < 0) {
		fprintf(stderr, "Warning: cannot open %s, file not copied\n", destname);
		close(src);
		return -1;
	}

	// copy
	ssize_t len;
	static const int BUFLEN = 1024;
	unsigned char buf[BUFLEN];
	while ((len = read(src, buf, BUFLEN)) > 0) {
		int done = 0;
		while (done != len) {
			int rv = write(dst, buf + done, len - done);
			if (rv == -1) {
				close(src);
				close(dst);
				return -1;
			}

			done += rv;
		}
	}

	if (fchown(dst, uid, gid) == -1)
		errExit("fchown");
	if (fchmod(dst, mode) == -1)
		errExit("fchmod");

	close(src);
	close(dst);
	return 0;
}


// return 1 if the file is a directory
int is_dir(const char *fname) {
	assert(fname);
	if (*fname == '\0')
		return 0;

	// if fname doesn't end in '/', add one
	int rv;
	struct stat s;
	if (fname[strlen(fname) - 1] == '/')
		rv = stat(fname, &s);
	else {
		char *tmp;
		if (asprintf(&tmp, "%s/", fname) == -1) {
			fprintf(stderr, "Error: cannot allocate memory, %s:%d\n", __FILE__, __LINE__);
			errExit("asprintf");
		}
		rv = stat(tmp, &s);
		free(tmp);
	}

	if (rv == -1)
		return 0;

	if (S_ISDIR(s.st_mode))
		return 1;

	return 0;
}


// return 1 if the file is a link
int is_link(const char *fname) {
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


// remove multiple spaces and return allocated memory
char *line_remove_spaces(const char *buf) {
	EUID_ASSERT();
	assert(buf);
	if (strlen(buf) == 0)
		return NULL;

	// allocate memory for the new string
	char *rv = malloc(strlen(buf) + 1);
	if (rv == NULL)
		errExit("malloc");

	// remove space at start of line
	const char *ptr1 = buf;
	while (*ptr1 == ' ' || *ptr1 == '\t')
		ptr1++;

	// copy data and remove additional spaces
	char *ptr2 = rv;
	int state = 0;
	while (*ptr1 != '\0') {
		if (*ptr1 == '\n' || *ptr1 == '\r')
			break;

		if (state == 0) {
			if (*ptr1 != ' ' && *ptr1 != '\t')
				*ptr2++ = *ptr1++;
			else {
				*ptr2++ = ' ';
				ptr1++;
				state = 1;
			}
		}
		else {				  // state == 1
			while (*ptr1 == ' ' || *ptr1 == '\t')
				ptr1++;
			state = 0;
		}
	}

	// strip last blank character if any
	if (ptr2 > rv && *(ptr2 - 1) == ' ')
		--ptr2;
	*ptr2 = '\0';
	//	if (arg_debug)
	//		printf("Processing line #%s#\n", rv);

	return rv;
}


char *split_comma(char *str) {
	EUID_ASSERT();
	if (str == NULL || *str == '\0')
		return NULL;
	char *ptr = strchr(str, ',');
	if (!ptr)
		return NULL;
	*ptr = '\0';
	ptr++;
	if (*ptr == '\0')
		return NULL;
	return ptr;
}


int not_unsigned(const char *str) {
	EUID_ASSERT();

	int rv = 0;
	const char *ptr = str;
	while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0') {
		if (!isdigit(*ptr)) {
			rv = 1;
			break;
		}
		ptr++;
	}

	return rv;
}


#define BUFLEN 4096
// find the first child for this parent; return 1 if error
int find_child(pid_t parent, pid_t *child) {
	EUID_ASSERT();
	*child = 0;				  // use it to flag a found child

	DIR *dir;
	EUID_ROOT();				  // grsecurity fix
	if (!(dir = opendir("/proc"))) {
		// sleep 2 seconds and try again
		sleep(2);
		if (!(dir = opendir("/proc"))) {
			fprintf(stderr, "Error: cannot open /proc directory\n");
			exit(1);
		}
	}

	struct dirent *entry;
	char *end;
	while (*child == 0 && (entry = readdir(dir))) {
		pid_t pid = strtol(entry->d_name, &end, 10);
		if (end == entry->d_name || *end)
			continue;
		if (pid == parent)
			continue;

		// open stat file
		char *file;
		if (asprintf(&file, "/proc/%u/status", pid) == -1) {
			perror("asprintf");
			exit(1);
		}
		FILE *fp = fopen(file, "r");
		if (!fp) {
			free(file);
			continue;
		}

		// look for firejail executable name
		char buf[BUFLEN];
		while (fgets(buf, BUFLEN - 1, fp)) {
			if (strncmp(buf, "PPid:", 5) == 0) {
				char *ptr = buf + 5;
				while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
					ptr++;
				}
				if (*ptr == '\0') {
					fprintf(stderr, "Error: cannot read /proc file\n");
					exit(1);
				}
				if (parent == atoi(ptr))
					*child = pid;
				break;		  // stop reading the file
			}
		}
		fclose(fp);
		free(file);
	}
	closedir(dir);
	EUID_USER();
	return (*child)? 0:1;			  // 0 = found, 1 = not found
}


void extract_command_name(int index, char **argv) {
	EUID_ASSERT();
	assert(argv);
	assert(argv[index]);

	// configure command index
	cfg.original_program_index = index;

	char *str = strdup(argv[index]);
	if (!str)
		errExit("strdup");

	// if we have a symbolic link, use the real path to extract the name
//	if (is_link(argv[index])) {
//		char*newname = realpath(argv[index], NULL);
//		if (newname) {
//			free(str);
//			str = newname;
//		}
//	}

	// configure command name
	cfg.command_name = str;
	if (!cfg.command_name)
		errExit("strdup");

	// restrict the command name to the first word
	char *ptr = cfg.command_name;
	while (*ptr != ' ' && *ptr != '\t' && *ptr != '\0')
		ptr++;
	*ptr = '\0';

	// remove the path: /usr/bin/firefox becomes firefox
	ptr = strrchr(cfg.command_name, '/');
	if (ptr) {
		ptr++;
		if (*ptr == '\0') {
			fprintf(stderr, "Error: invalid command name\n");
			exit(1);
		}

		char *tmp = strdup(ptr);
		if (!tmp)
			errExit("strdup");

		// limit the command to the first '.'
		char *ptr2 = tmp;
		while (*ptr2 != '.' && *ptr2 != '\0')
			ptr2++;
		*ptr2 = '\0';

		free(cfg.command_name);
		cfg.command_name = tmp;
	}
}


void update_map(char *mapping, char *map_file) {
	int fd;
	size_t j;
	size_t map_len;				  /* Length of 'mapping' */

	/* Replace commas in mapping string with newlines */

	map_len = strlen(mapping);
	for (j = 0; j < map_len; j++)
		if (mapping[j] == ',')
			mapping[j] = '\n';

	fd = open(map_file, O_RDWR);
	if (fd == -1) {
		fprintf(stderr, "Error: cannot open %s: %s\n", map_file, strerror(errno));
		exit(EXIT_FAILURE);
	}

	if (write(fd, mapping, map_len) != (ssize_t)map_len) {
		fprintf(stderr, "Error: cannot write to %s: %s\n", map_file, strerror(errno));
		exit(EXIT_FAILURE);
	}

	close(fd);
}


void wait_for_other(int fd) {
	//****************************
	// wait for the parent to be initialized
	//****************************
	char childstr[BUFLEN + 1];
	int newfd = dup(fd);
	if (newfd == -1)
		errExit("dup");
	FILE* stream;
	stream = fdopen(newfd, "r");
	*childstr = '\0';
	if (fgets(childstr, BUFLEN, stream)) {
		// remove \n)
		char *ptr = childstr;
		while(*ptr !='\0' && *ptr != '\n')
			ptr++;
		if (*ptr == '\0')
			errExit("fgets");
		*ptr = '\0';
	}
	else {
		fprintf(stderr, "Error: cannot establish communication with the parent, exiting...\n");
		exit(1);
	}
	if (strcmp(childstr, "arg_noroot=0") == 0)
		arg_noroot = 0;

	fclose(stream);
}


void notify_other(int fd) {
	FILE* stream;
	int newfd = dup(fd);
	if (newfd == -1)
		errExit("dup");
	stream = fdopen(newfd, "w");
	fprintf(stream, "arg_noroot=%d\n", arg_noroot);
	fflush(stream);
	fclose(stream);
}


// This function takes a pathname supplied by the user and expands '~' and
// '${HOME}' at the start, to refer to a path relative to the user's home
// directory (supplied).
// The return value is allocated using malloc and must be freed by the caller.
// The function returns NULL if there are any errors.
char *expand_home(const char *path, const char* homedir) {
	assert(path);
	assert(homedir);

	// Replace home macro
	char *new_name = NULL;
	if (strncmp(path, "${HOME}", 7) == 0) {
		if (asprintf(&new_name, "%s%s", homedir, path + 7) == -1)
			errExit("asprintf");
		return new_name;
	}
	else if (*path == '~') {
		if (asprintf(&new_name, "%s%s", homedir, path + 1) == -1)
			errExit("asprintf");
		return new_name;
	}

	return strdup(path);
}


// Equivalent to the GNU version of basename, which is incompatible with
// the POSIX basename. A few lines of code saves any portability pain.
// https://www.gnu.org/software/libc/manual/html_node/Finding-Tokens-in-a-String.html#index-basename
const char *gnu_basename(const char *path) {
	const char *last_slash = strrchr(path, '/');
	if (!last_slash)
		return path;
	return last_slash+1;
}


uid_t pid_get_uid(pid_t pid) {
	EUID_ASSERT();
	uid_t rv = 0;

	// open status file
	char *file;
	if (asprintf(&file, "/proc/%u/status", pid) == -1) {
		perror("asprintf");
		exit(1);
	}
	EUID_ROOT();				  // grsecurity fix
	FILE *fp = fopen(file, "r");
	if (!fp) {
		free(file);
		fprintf(stderr, "Error: cannot open /proc file\n");
		exit(1);
	}

	// extract uid
	static const int PIDS_BUFLEN = 1024;
	char buf[PIDS_BUFLEN];
	while (fgets(buf, PIDS_BUFLEN - 1, fp)) {
		if (strncmp(buf, "Uid:", 4) == 0) {
			char *ptr = buf + 5;
			while (*ptr != '\0' && (*ptr == ' ' || *ptr == '\t')) {
				ptr++;
			}
			if (*ptr == '\0')
				break;

			rv = atoi(ptr);
			break;			  // break regardless!
		}
	}

	fclose(fp);
	free(file);
	EUID_USER();				  // grsecurity fix

	if (rv == 0) {
		fprintf(stderr, "Error: cannot read /proc file\n");
		exit(1);
	}
	return rv;
}


void invalid_filename(const char *fname) {
	EUID_ASSERT();
	assert(fname);
	const char *ptr = fname;

	if (arg_debug_check_filename)
		printf("Checking filename %s\n", fname);

	if (strncmp(ptr, "${HOME}", 7) == 0)
		ptr = fname + 7;
	else if (strncmp(ptr, "${PATH}", 7) == 0)
		ptr = fname + 7;
	else if (strcmp(fname, "${DOWNLOADS}") == 0)
		return;

	int len = strlen(ptr);
	// file globbing ('*') is allowed
	if (strcspn(ptr, "\\&!?\"'<>%^(){}[];,") != (size_t)len) {
		fprintf(stderr, "Error: \"%s\" is an invalid filename\n", ptr);
		exit(1);
	}
}


uid_t get_group_id(const char *group) {
	// find tty group id
	gid_t gid = 0;
	struct group *g = getgrnam(group);
	if (g)
		gid = g->gr_gid;

	return gid;
}


static int remove_callback(const char *fpath, const struct stat *sb, int typeflag, struct FTW *ftwbuf) {
	(void) sb;
	(void) typeflag;
	(void) ftwbuf;
	
	int rv = remove(fpath);
	if (rv)
		perror(fpath);

	return rv;
}


int remove_directory(const char *path) {
	// FTW_PHYS - do not follow symbolic links
	return nftw(path, remove_callback, 64, FTW_DEPTH | FTW_PHYS);
}

void flush_stdin(void) {
	if (isatty(STDIN_FILENO)) {
		int cnt = 0;
		ioctl(STDIN_FILENO, FIONREAD, &cnt);
		if (cnt) {
			if (!arg_quiet)
				printf("Warning: removing %d bytes from stdin\n", cnt);
			ioctl(STDIN_FILENO, TCFLSH, TCIFLUSH);
		}
	}
}
// return 1 if error
int set_perms(const char *fname, uid_t uid, gid_t gid, mode_t mode) {
	assert(fname);
	if (chmod(fname, mode) == -1)
		return 1;
	if (chown(fname, uid, gid) == -1)
		return 1;
	return 0;
}



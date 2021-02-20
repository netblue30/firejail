#include "jailtest.h"
#include <errno.h>
#include <pwd.h>
#include <dirent.h>

#define BUFLEN 4096

char *get_sudo_user(void) {
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

char *get_homedir(const char *user, uid_t *uid, gid_t *gid) {
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

int find_child(pid_t parent, pid_t *child) {
	*child = 0;				  // use it to flag a found child

	DIR *dir;
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
				if (parent == atoi(ptr)) {
					// we don't want /usr/bin/xdg-dbus-proxy!
					char *cmdline = pid_proc_cmdline(pid);
					if (strncmp(cmdline, XDG_DBUS_PROXY_PATH, strlen(XDG_DBUS_PROXY_PATH)) != 0)
						*child = pid;
					free(cmdline);
				}
				break;		  // stop reading the file
			}
		}
		fclose(fp);
		free(file);
	}
	closedir(dir);
	return (*child)? 0:1;			  // 0 = found, 1 = not found
}

pid_t switch_to_child(pid_t pid) {
	pid_t rv = pid;
	errno = 0;
	char *comm = pid_proc_comm(pid);
	if (!comm) {
		if (errno == ENOENT)
			fprintf(stderr, "Error: cannot find process with pid %d\n", pid);
		else
			fprintf(stderr, "Error: cannot read /proc file\n");
		exit(1);
	}

	if (strcmp(comm, "firejail") == 0) {
		if (find_child(pid, &rv) == 1) {
			fprintf(stderr, "Error: no valid sandbox\n");
			exit(1);
		}
	}
	free(comm);
	return rv;
}

#include "jailtest.h"
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>

static unsigned char *execfile = NULL;
static int execfile_len = 0;

void noexec_setup(void) {
	// grab a copy of myself
	char *self = realpath("/proc/self/exe", NULL);
	if (self) {
		struct stat s;
		if (access(self, X_OK) == 0 && stat(self, &s) == 0) {
			assert(s.st_size);
			execfile = malloc(s.st_size);

			int fd = open(self, O_RDONLY);
			if (fd == -1)
				errExit("open");
			int len = 0;
			do {
				int rv = read(fd, execfile + len, s.st_size - len);
				if (rv == -1)
					errExit("read");
				if (rv == 0) {
					// something went wrong!
					free(execfile);
					execfile = NULL;
					printf("Warning: I cannot grab a copy of myself, skipping noexec test...\n");
					break;
				}
				len += rv;
			}
			while (len < s.st_size);
			execfile_len = s.st_size;
			close(fd);
		}
	}
}


void noexec_test(const char *path) {
	assert(user_uid);

	// I am root in sandbox mount namespace
	if (!execfile)
		return;

	char *fname;
	if (asprintf(&fname, "%s/jailtest-noexec-%d", path, getpid()) == -1)
		errExit("asprintf");

	pid_t child = fork();
	if (child == -1)
		errExit("fork");

	if (child == 0) { // child
		// drop privileges
 		if (setgid(user_gid) != 0)
			errExit("setgid");
		if (setuid(user_uid) != 0)
			errExit("setuid");
		int fd = open(fname, O_CREAT | O_TRUNC | O_WRONLY, 0700);
		if (fd == -1) {
			printf("   I cannot create files in %s, skipping noexec...\n", path);
			exit(1);
		}

		int len = 0;
		while (len < execfile_len) {
			int rv = write(fd, execfile + len, execfile_len - len);
			if (rv == -1 || rv == 0) {
				printf("   I cannot create files in %s, skipping noexec....\n", path);
				exit(1);
			}
			len += rv;
		}
		fchmod(fd, 0700);
		close(fd);

		char *arg;
		if (asprintf(&arg, "--hello=%s", path) == -1)
			errExit("asprintf");
		int rv = execl(fname, fname, arg, NULL);
		(void) rv; // if we get here execl failed
		exit(0);
	}

	int status;
	wait(&status);
	int rv = unlink(fname);
	(void) rv;
}
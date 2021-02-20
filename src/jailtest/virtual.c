#include "jailtest.h"
#include <dirent.h>
#include <sys/wait.h>


#define MAX_TEST_FILES 16
static char *dirs[MAX_TEST_FILES];
static char *files[MAX_TEST_FILES];
static int files_cnt = 0;

void virtual_setup(const char *directory) {
	// I am root!
	assert(directory);
	assert(*directory == '/');
	assert(files_cnt < MAX_TEST_FILES);

	// try to open the dir as root
	DIR *dir = opendir(directory);
	if (!dir) {
		fprintf(stderr, "Warning: directory %s not found, skipping\n", directory);
		return;
	}
	closedir(dir);

	// create a test file
	char *test_file;
	if (asprintf(&test_file, "%s/jailtest-private-%d", directory, getpid()) == -1)
		errExit("asprintf");

	FILE *fp = fopen(test_file, "w");
	if (!fp) {
		printf("Warning: I cannot create test file in directory %s, skipping...\n", directory);
		return;
	}
	fprintf(fp, "this file was created by firetest utility, you can safely delete it\n");
	fclose(fp);
	if (strcmp(directory, user_home_dir) == 0) {
		int rv = chown(test_file, user_uid, user_gid);
		if (rv)
			errExit("chown");
	}

	char *dname = strdup(directory);
	if (!dname)
		errExit("strdup");
	dirs[files_cnt] = dname;
	files[files_cnt] = test_file;
	files_cnt++;
}

void virtual_destroy(void) {
	// remove test files
	int i;

	for (i = 0; i < files_cnt; i++) {
		int rv = unlink(files[i]);
		(void) rv;
	}
	files_cnt = 0;
}

void virtual_test(void) {
	// I am root in sandbox mount namespace
	assert(user_uid);
	int i;

	printf("   Virtual dirs: "); fflush(0);

	for (i = 0; i < files_cnt; i++) {
		assert(files[i]);

		// I am root!
		pid_t child = fork();
		if (child == -1)
			errExit("fork");

		if (child == 0) { // child
			// drop privileges
			if (setgid(user_gid) != 0)
				errExit("setgid");
			if (setuid(user_uid) != 0)
				errExit("setuid");

			// try to open the file for reading
			FILE *fp = fopen(files[i], "r");
			if (fp)
				fclose(fp);
			else
				printf("%s, ", dirs[i]);
			fflush(0);
			exit(0);
		}

		// wait for the child to finish
		int status;
		wait(&status);
	}
	printf("\n");
}

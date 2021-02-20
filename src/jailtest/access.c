#include "jailtest.h"
#include <dirent.h>
#include <sys/wait.h>

typedef struct {
	char *tfile;
	char *tdir;
} TestDir;

#define MAX_TEST_FILES 16
TestDir td[MAX_TEST_FILES];
static int files_cnt = 0;

void access_setup(const char *directory) {
	// I am root!
	assert(directory);
	assert(user_home_dir);

	if (files_cnt >= MAX_TEST_FILES) {
		fprintf(stderr, "Error: maximum number of test directories exceded\n");
		exit(1);
	}

	char *fname = strdup(directory);
	if (!fname)
		errExit("strdup");
	if (strncmp(fname, "~/", 2) == 0) {
		free(fname);
		if (asprintf(&fname, "%s/%s", user_home_dir, directory + 2) == -1)
			errExit("asprintf");
	}

	char *path = realpath(fname, NULL);
	free(fname);
	if (path == NULL) {
		fprintf(stderr, "Warning: invalid directory %s, skipping...\n", directory);
		return;
	}

	// file in home directory
	if (strncmp(path, user_home_dir, strlen(user_home_dir)) != 0) {
		fprintf(stderr, "Warning: file %s is not in user home directory, skipping...\n", directory);
		free(path);
		return;
	}

	// try to open the dir as root
	DIR *dir = opendir(path);
	if (!dir) {
		fprintf(stderr, "Warning: directory %s not found, skipping\n", directory);
		free(path);
		return;
	}
	closedir(dir);

	// create a test file
	char *test_file;
	if (asprintf(&test_file, "%s/jailtest-access-%d", path, getpid()) == -1)
		errExit("asprintf");

	FILE *fp = fopen(test_file, "w");
	if (!fp) {
		printf("Warning: I cannot create test file in directory %s, skipping...\n", directory);
		return;
	}
	fprintf(fp, "this file was created by firetest utility, you can safely delete it\n");
	fclose(fp);
	int rv = chown(test_file, user_uid, user_gid);
	if (rv)
		errExit("chown");

	char *dname = strdup(directory);
	if (!dname)
		errExit("strdup");
	td[files_cnt].tdir = dname;
	td[files_cnt].tfile = test_file;
	files_cnt++;
}

void access_destroy(void) {
	// remove test files
	int i;

	for (i = 0; i < files_cnt; i++) {
		int rv = unlink(td[i].tfile);
		(void) rv;
	}
	files_cnt = 0;
}

void access_test(void) {
	// I am root in sandbox mount namespace
	assert(user_uid);
	int i;

	pid_t child = fork();
	if (child == -1)
		errExit("fork");

	if (child == 0) { // child
		// drop privileges
		if (setgid(user_gid) != 0)
			errExit("setgid");
		if (setuid(user_uid) != 0)
			errExit("setuid");

		for (i = 0; i < files_cnt; i++) {
			assert(td[i].tfile);

			// try to open the file for reading
			FILE *fp = fopen(td[i].tfile, "r");
			if (fp) {

				printf("   Warning: I can read %s\n", td[i].tdir);
				fclose(fp);
			}
		}
		exit(0);
	}

	// wait for the child to finish
	int status;
	wait(&status);
}

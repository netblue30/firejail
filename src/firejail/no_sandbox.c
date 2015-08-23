#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

// check process space for kernel processes
// return 1 if found, 0 if not found
int check_kernel_procs(void) {
	char *kern_proc[] = {
		"kthreadd",
		"ksoftirqd",
		"kworker",
		"rcu_sched",
		"rcu_bh",
		NULL	// NULL terminated list
	};
	int i;

	// look at the first 10 processes
	// if a kernel process is found, return 1
	for (i = 1; i <= 10; i++) { 
		struct stat s;
		char *fname;
		if (asprintf(&fname, "/proc/%d/comm", i) == -1)
			errExit("asprintf");
		if (stat(fname, &s) == -1) {
			free(fname);
			continue;
		}
		
		// open file
		FILE *fp = fopen(fname, "r");
		if (!fp) {
			fprintf(stderr, "Warning: cannot open %s\n", fname);
			free(fname);
			continue;
		}
		
		// read file
		char buf[100];
		if (fgets(buf, 10, fp) == NULL) {
			fprintf(stderr, "Warning: cannot read %s\n", fname);
			fclose(fp);
			free(fname);
			continue;
		}
		// clean /n
		char *ptr;
		if ((ptr = strchr(buf, '\n')) != NULL)
			*ptr = '\0';
		
		// check process name against the kernel list
		int j = 0;
		while (kern_proc[j] != NULL) {
			if (strncmp(buf, kern_proc[j], strlen(kern_proc[j])) == 0) {
				fclose(fp);
				free(fname);
				return 1;
			}
			j++;
		}
		
		fclose(fp);
		free(fname);
	}

	return 0;
}

void run_no_sandbox(int argc, char **argv) {
	// drop privileges
	int rv = setgroups(0, NULL); // this could fail
	(void) rv;
	if (setgid(getgid()) < 0)
		errExit("setgid/getgid");
	if (setuid(getuid()) < 0)
		errExit("setuid/getuid");


	// build command
	char *command = NULL;
	int allocated = 0;
	if (argc == 1)
		command = "/bin/bash";
	else {
		// calculate length
		int len = 0;
		int i;
		for (i = 1; i < argc; i++) {
			if (*argv[i] == '-')
				continue;
			break;
		}
		int start_index = i;
		for (i = start_index; i < argc; i++)
			len += strlen(argv[i]) + 1;
		
		// allocate
		command = malloc(len + 1);
		if (!command)
			errExit("malloc");
		memset(command, 0, len + 1);
		allocated = 1;
		
		// copy
		for (i = start_index; i < argc; i++) {
			strcat(command, argv[i]);
			strcat(command, " ");
		}
	}
	
	// start the program in /bin/sh
	fprintf(stderr, "Warning: an existing sandbox was detected. "
		"%s will run without any additional sandboxing features in a /bin/sh shell\n", command);
	system(command);
	if (allocated)
		free(command);
	exit(1);
}

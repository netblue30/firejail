#include "jailtest.h"
#include "../include/firejail_user.h"
#include "../include/pid.h"
#include <sys/wait.h>

uid_t user_uid = 0;
gid_t user_gid = 0;
char *user_name = NULL;
char *user_home_dir = NULL;
int arg_debug = 0;

static char *usage_str =
	"Usage: jailtest [options] directory [directory]\n\n"
	"Options:\n"
	"   --debug - print debug messages.\n"
	"   --help, -? - this help screen.\n"
	"   --version - print program version and exit.\n";


static void usage(void) {
	printf("firetest - version %s\n\n", VERSION);
	puts(usage_str);
}

static void cleanup(void) {
	// running only as root
	if (getuid() == 0) {
		if (arg_debug)
			printf("cleaning up!\n");
		access_destroy();
		virtual_destroy();
	}
}

int main(int argc, char **argv) {
	int i;
	int findex = 0;

	for (i = 1; i < argc; i++) {
		if (strcmp(argv[i], "-?") == 0 || strcmp(argv[i], "--help") == 0) {
			usage();
			return 0;
		}
		else if (strcmp(argv[i], "--version") == 0) {
			printf("firetest version %s\n\n", VERSION);
			return 0;
		}
		else if (strncmp(argv[i], "--hello=", 8) == 0) { // used by noexec test
			printf("   Warning: I can run programs in %s\n", argv[i] + 8);
			return 0;
		}
		else if (strcmp(argv[i], "--debug") == 0)
			arg_debug = 1;
		else if (strncmp(argv[i], "--", 2) == 0) {
			fprintf(stderr, "Error: invalid option\n");
			return 1;
		}
		else {
			findex = i;
			break;
		}
	}

	// user setup
	if (getuid() != 0) {
		fprintf(stderr, "Error: you need to be root (via sudo) to run this program\n");
		exit(1);
	}
	user_name = get_sudo_user();
	assert(user_name);
	user_home_dir = get_homedir(user_name, &user_uid, &user_gid);
	if (user_uid == 0) {
		fprintf(stderr, "Error: root user not supported\n");
		exit(1);
	}

	// test setup
	atexit(cleanup);
	if (findex > 0) {
		for (i = findex; i < argc; i++)
			access_setup(argv[i]);
	}

	noexec_setup();
	virtual_setup(user_home_dir);
	virtual_setup("/tmp");
	virtual_setup("/var/tmp");
	virtual_setup("/dev");
	virtual_setup("/etc");
	virtual_setup("/bin");

	// print processes
	pid_read(0);
	for (i = 0; i < max_pids; i++) {
		if (pids[i].level == 1) {
			uid_t uid = pid_get_uid(i);
			if (uid != user_uid) // not interested in other user sandboxes
				continue;

			// in case the pid is that of a firejail process, use the pid of the first child process
			uid_t pid = switch_to_child(i);
			pid_print_list(i, 0); //  no wrapping

			pid_t child = fork();
			if (child == -1)
				errExit("fork");
			if (child == 0) {
				int rv = join_namespace(pid, "mnt");
				if (rv == 0) {
					virtual_test();
					noexec_test(user_home_dir);
					noexec_test("/tmp");
					noexec_test("/var/tmp");
					access_test();
				}
				else {
					printf("   Error: I cannot join the process mount space\n");
					exit(1);
				}

				// drop privileges in order not to trigger cleanup()
				if (setgid(user_gid) != 0)
					errExit("setgid");
				if (setuid(user_uid) != 0)
					errExit("setuid");
				return 0;
			}
			int status;
			wait(&status);
		}
	}

	return 0;
}

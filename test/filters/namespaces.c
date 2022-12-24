#define _GNU_SOURCE
#include <errno.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#ifndef CLONE_NEWTIME
#define CLONE_NEWTIME 0x00000080
#endif

#define STACK_SIZE 1024 * 1024

static int usage() {
    fprintf(stderr, "Usage: namespaces <system call>[clone,unshare] <list of namespaces>[cgroup,ipc,mnt,net,pid,time,user,uts]\n");
    exit(1);
}

static void die(const char *msg) {
    fprintf(stderr, "Error: %s: %s\n", msg, strerror(errno));
    exit(1);
}

static int ns_flags(const char *list) {
    int flags = 0;

    char *dup = strdup(list);
    if (!dup)
        die("cannot allocate memory");

    char *token = strtok(dup, ",");
    while (token) {
        if (strcmp(token, "cgroup") == 0)
            flags |= CLONE_NEWCGROUP;
        else if (strcmp(token, "ipc") == 0)
            flags |= CLONE_NEWIPC;
        else if (strcmp(token, "net") == 0)
            flags |= CLONE_NEWNET;
        else if (strcmp(token, "mnt") == 0)
            flags |= CLONE_NEWNS;
        else if (strcmp(token, "pid") == 0)
            flags |= CLONE_NEWPID;
        else if (strcmp(token, "time") == 0)
            flags |= CLONE_NEWTIME;
        else if (strcmp(token, "user") == 0)
            flags |= CLONE_NEWUSER;
        else if (strcmp(token, "uts") == 0)
            flags |= CLONE_NEWUTS;
        else
            usage();

        token = strtok(NULL, ",");
    }

    free(dup);
    return flags;
}

static int child(void *arg) {
    (void) arg;

    fprintf(stderr, "clone successful\n");
    return 0;
}

int main (int argc, char **argv) {
    if (argc != 3)
        usage();

    int flags = ns_flags(argv[2]);
    if (getuid() != 0)
        flags |= CLONE_NEWUSER;

    if (strcmp(argv[1], "clone") == 0) {
        void *stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (stack == MAP_FAILED)
            die("mmap");

        if (clone(child, stack + STACK_SIZE, flags | SIGCHLD, NULL) < 0)
            die("clone");
    }
    else if (strcmp(argv[1], "unshare") == 0) {
        if (unshare(flags))
            die("unshare");

        fprintf(stderr, "unshare successful\n");
    }
    else
        usage();

    return 0;
}

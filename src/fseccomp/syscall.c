#include "fseccomp.h"
#include <sys/syscall.h>

typedef struct {
	char *name;
	int nr;
} SyscallEntry;

static SyscallEntry syslist[] = {
//
// code generated using tools/extract-syscall
//
#include "../include/syscall.h"
//
// end of generated code
//
}; // end of syslist

void syscall_print(void) {
	int i;
	int elems = sizeof(syslist) / sizeof(syslist[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", syslist[i].nr, syslist[i].name);
	}
	printf("\n");
}

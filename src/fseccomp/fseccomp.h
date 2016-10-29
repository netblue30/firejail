#ifndef FSECCOMP_H
#define FSECCOMP_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "../include/common.h"

// syscall.c
void syscall_print(void);

// errno.c
void errno_print(void);

// protocol.c
void protocol_print(void);
void protocol_build_filter(const char *prlist, const char *fname);
#endif

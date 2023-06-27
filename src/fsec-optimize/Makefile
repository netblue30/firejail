.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

PROG = fsec-optimize
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/seccomp.h ../include/syscall.h
EXTRA_OBJS = ../lib/common.o ../lib/errno.o

include $(ROOT)/src/prog.mk

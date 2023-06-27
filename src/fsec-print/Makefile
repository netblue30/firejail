.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

PROG = fsec-print
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/seccomp.h ../include/syscall.h
EXTRA_OBJS = ../lib/common.o ../lib/errno.o ../lib/syscall.o

include $(ROOT)/src/prog.mk

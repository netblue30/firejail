.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/fseccomp
PROG = fseccomp
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/syscall.h
EXTRA_OBJS = ../lib/common.o ../lib/errno.o ../lib/syscall.o

include $(ROOT)/src/prog.mk

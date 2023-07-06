.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/fldd
PROG = fldd
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/syscall.h ../include/ldd_utils.h
EXTRA_OBJS = ../lib/common.o ../lib/ldd_utils.o

include $(ROOT)/src/prog.mk

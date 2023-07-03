.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = fldd
MOD_DIR = $(ROOT)/src/$(MOD)
PROG = $(MOD_DIR)/$(MOD)
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/syscall.h ../include/ldd_utils.h
EXTRA_OBJS = ../lib/common.o ../lib/ldd_utils.o

include $(ROOT)/src/prog.mk

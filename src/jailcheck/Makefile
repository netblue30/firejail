.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/jailcheck
PROG = jailcheck
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/pid.h
EXTRA_OBJS = ../lib/common.o ../lib/pid.o

include $(ROOT)/src/prog.mk

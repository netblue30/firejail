.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = fsec-print
MOD_DIR = $(ROOT)/src/$(MOD)
PROG = $(MOD_DIR)/$(MOD)
TARGET = $(PROG)

EXTRA_OBJS = ../lib/common.o ../lib/errno.o ../lib/syscall.o

include $(ROOT)/src/prog.mk

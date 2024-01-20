.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = fbuilder
MOD_DIR = $(ROOT)/src/$(MOD)
PROG = $(MOD_DIR)/$(MOD)
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/syscall.h

include $(ROOT)/src/prog.mk

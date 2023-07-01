.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/firecfg
PROG = firecfg
TARGET = $(PROG)

EXTRA_HDRS = \
../include/common.h \
../include/euid_common.h \
../include/libnetlink.h \
../include/firejail_user.h \
../include/pid.h

EXTRA_OBJS = ../lib/common.o ../lib/firejail_user.o

include $(ROOT)/src/prog.mk

.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

PROG = firecfg
TARGET = $(PROG)

MOD_HDRS = \
../include/common.h \
../include/euid_common.h \
../include/libnetlink.h \
../include/firejail_user.h \
../include/pid.h

MOD_OBJS = ../lib/common.o ../lib/firejail_user.o

include $(ROOT)/src/prog.mk

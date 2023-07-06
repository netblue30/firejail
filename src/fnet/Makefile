.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/fnet
PROG = fnet
TARGET = $(PROG)

EXTRA_HDRS = ../include/common.h ../include/libnetlink.h
EXTRA_OBJS = ../lib/common.o ../lib/libnetlink.o

include $(ROOT)/src/prog.mk

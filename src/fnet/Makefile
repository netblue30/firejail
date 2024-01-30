.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = fnet
MOD_DIR = $(ROOT)/src/$(MOD)
PROG = $(MOD_DIR)/$(MOD)
TARGET = $(PROG)

EXTRA_OBJS = ../lib/common.o ../lib/libnetlink.o

include $(ROOT)/src/prog.mk

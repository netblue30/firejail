.SUFFIXES:
MAKEFLAGS += -r

ROOT = ../..
-include $(ROOT)/config.mk

TARGET = lib

include $(ROOT)/src/prog.mk

.PHONY: lib
lib: $(OBJS)

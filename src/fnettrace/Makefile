.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD_DIR = src/fnettrace
PROG = fnettrace
TARGET = $(PROG)

include $(ROOT)/src/prog.mk

all: $(TARGET) static-ip-map
static-ip-map: static-ip-map.txt fnettrace
	./fnettrace --squash-map=static-ip-map.txt > static-ip-map

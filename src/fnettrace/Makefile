.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = fnettrace
MOD_DIR = $(ROOT)/src/$(MOD)
PROG = $(MOD_DIR)/$(MOD)
TARGET = $(PROG)

include $(ROOT)/src/prog.mk

all: $(TARGET) static-ip-map
static-ip-map: static-ip-map.txt $(PROG)
	./$(PROG) --squash-map=static-ip-map.txt > static-ip-map

.SUFFIXES:
ROOT = ../..
-include $(ROOT)/config.mk

MOD = libpostexecseccomp
MOD_DIR = $(ROOT)/src/$(MOD)
SO = $(MOD_DIR)/$(MOD).so
TARGET = $(SO)

EXTRA_HDRS = ../include/seccomp.h ../include/rundefs.h

include $(ROOT)/src/so.mk

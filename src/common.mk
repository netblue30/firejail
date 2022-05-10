# Common definitions for building C programs and non-shared objects.
#
# Note: "ROOT" must be defined before including this file.

include $(ROOT)/config.mk

H_FILE_LIST       = $(sort $(wildcard *.h))
C_FILE_LIST       = $(sort $(wildcard *.c))
OBJS = $(C_FILE_LIST:.c=.o)
BINOBJS =  $(foreach file, $(OBJS), $file)

CFLAGS += -ggdb $(HAVE_FATAL_WARNINGS) -O2 -DVERSION='"$(VERSION)"' $(HAVE_GCOV)
CFLAGS += -DPREFIX='"$(prefix)"' -DSYSCONFDIR='"$(sysconfdir)/firejail"' -DLIBDIR='"$(libdir)"' -DBINDIR='"$(bindir)"'   -DVARDIR='"/var/lib/firejail"'
CFLAGS += $(MANFLAGS)
CFLAGS += -fstack-protector-all -D_FORTIFY_SOURCE=2 -fPIE -Wformat -Wformat-security
LDFLAGS += -pie -fPIE -Wl,-z,relro -Wl,-z,now

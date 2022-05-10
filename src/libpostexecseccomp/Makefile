ROOT = ../..
include $(ROOT)/config.mk

H_FILE_LIST       = $(sort $(wildcard *.h))
C_FILE_LIST       = $(sort $(wildcard *.c))
OBJS = $(C_FILE_LIST:.c=.o)
BINOBJS =  $(foreach file, $(OBJS), $file)
CFLAGS += -ggdb $(HAVE_FATAL_WARNINGS) -O2 -DVERSION='"$(VERSION)"' -fstack-protector-all -D_FORTIFY_SOURCE=2 -fPIC -Wformat -Wformat-security
LDFLAGS += -pie -fPIE -Wl,-z,relro -Wl,-z,now

.PHONY: all
all: libpostexecseccomp.so

%.o : %.c $(H_FILE_LIST) ../include/seccomp.h ../include/rundefs.h
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

libpostexecseccomp.so: $(OBJS)
	$(CC) $(LDFLAGS) -shared -fPIC -z relro -o $@ $(OBJS) -ldl

.PHONY: clean
clean:; rm -fr $(OBJS) libpostexecseccomp.so *.plist

.PHONY: distclean
distclean: clean

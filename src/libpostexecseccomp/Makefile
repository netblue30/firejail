ROOT = ../..
-include $(ROOT)/config.mk

HDRS := $(sort $(wildcard *.h))
SRCS := $(sort $(wildcard *.c))
OBJS := $(SRCS:.c=.o)
CFLAGS += -ggdb $(HAVE_FATAL_WARNINGS) -O2 -DVERSION='"$(VERSION)"' -fstack-protector-all -D_FORTIFY_SOURCE=2 -fPIC -Wformat -Wformat-security
LDFLAGS += -pie -fPIE -Wl,-z,relro -Wl,-z,now

.PHONY: all
all: libpostexecseccomp.so

%.o : %.c $(HDRS) ../include/seccomp.h ../include/rundefs.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

libpostexecseccomp.so: $(OBJS) $(ROOT)/config.mk
	$(CC) $(LDFLAGS) -shared -fPIC -z relro -o $@ $(OBJS) -ldl

.PHONY: clean
clean:; rm -fr $(OBJS) libpostexecseccomp.so *.plist

.PHONY: distclean
distclean: clean

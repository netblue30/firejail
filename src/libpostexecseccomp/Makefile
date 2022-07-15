ROOT = ../..
-include $(ROOT)/config.mk

SO = libpostexecseccomp.so
TARGET = $(SO)

MOD_HDRS = ../include/seccomp.h ../include/rundefs.h

HDRS := $(sort $(wildcard *.h)) $(MOD_HDRS)
SRCS := $(sort $(wildcard *.c)) $(MOD_SRCS)
OBJS := $(SRCS:.c=.o) $(MOD_OBJS)
CFLAGS += -ggdb $(HAVE_FATAL_WARNINGS) -O2 -DVERSION='"$(VERSION)"' -fstack-protector-all -D_FORTIFY_SOURCE=2 -fPIC -Wformat -Wformat-security
LDFLAGS += -pie -fPIE -Wl,-z,relro -Wl,-z,now

.PHONY: all
all: $(TARGET)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(SO): $(OBJS) $(ROOT)/config.mk
	$(CC) $(LDFLAGS) -shared -fPIC -z relro -o $@ $(OBJS) -ldl

.PHONY: clean
clean:; rm -fr $(OBJS) $(SO) *.plist

.PHONY: distclean
distclean: clean

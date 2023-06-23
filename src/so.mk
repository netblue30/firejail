# Common definitions for making shared objects.
#
# Note: $(ROOT)/config.mk must be included before this file.
#
# The includer should probably define SO and TARGET and may also want to define
# EXTRA_HDRS and EXTRA_OBJS and extend CLEANFILES.

HDRS := $(sort $(wildcard *.h)) $(EXTRA_HDRS)
SRCS := $(sort $(wildcard *.c))
OBJS := $(SRCS:.c=.o) $(EXTRA_OBJS)

SO_CFLAGS = \
	-ggdb -O2 -DVERSION='"$(VERSION)"' \
	-Wall -Wextra $(HAVE_FATAL_WARNINGS) \
	-Wformat -Wformat-security \
	-fstack-protector-all -D_FORTIFY_SOURCE=2 \
	-fPIC

SO_LDFLAGS = -Wl,-z,relro -Wl,-z,now -fPIC

.PHONY: all
all: $(TARGET)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(SO_CFLAGS) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(SO): $(OBJS) $(ROOT)/config.mk
	$(CC) $(SO_LDFLAGS) -shared $(LDFLAGS) -o $@ $(OBJS) -ldl

.PHONY: clean
clean:; rm -fr $(SO) $(CLEANFILES)

.PHONY: distclean
distclean: clean

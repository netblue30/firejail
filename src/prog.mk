# Common definitions for building C programs and non-shared objects.
#
# Note: $(ROOT)/config.mk must be included before this file.
#
# The includer should probably define PROG and TARGET and may also want to
# define EXTRA_HDRS and EXTRA_OBJS and extend CLEANFILES.

HDRS := $(sort $(wildcard *.h)) $(EXTRA_HDRS)
SRCS := $(sort $(wildcard *.c))
OBJS := $(SRCS:.c=.o) $(EXTRA_OBJS)

PROG_CFLAGS = \
	-ggdb -O2 -DVERSION='"$(VERSION)"' \
	-Wall -Wextra $(HAVE_FATAL_WARNINGS) \
	-Wformat -Wformat-security \
	-fstack-protector-all -D_FORTIFY_SOURCE=2 \
	-DPREFIX='"$(prefix)"' -DSYSCONFDIR='"$(sysconfdir)/firejail"' \
	-DLIBDIR='"$(libdir)"' -DBINDIR='"$(bindir)"' \
	-DVARDIR='"/var/lib/firejail"' \
	$(HAVE_GCOV) $(MANFLAGS) \
	$(EXTRA_CFLAGS) \
	-fPIE

PROG_LDFLAGS = -Wl,-z,relro -Wl,-z,now -fPIE -pie $(EXTRA_LDFLAGS)

.PHONY: all
all: $(TARGET)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(PROG_CFLAGS) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(PROG): $(OBJS) $(ROOT)/config.mk
	$(CC) $(PROG_LDFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

.PHONY: clean
clean:; rm -fr $(PROG) $(CLEANFILES)

.PHONY: distclean
distclean: clean

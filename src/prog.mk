# Common definitions for building C programs and non-shared objects.
#
# Note: $(ROOT)/config.mk must be included before this file.
#
# The includer should probably define PROG and TARGET and may also want to
# define MOD_HDRS, MOD_SRCS, MOD_OBJS, TOCLEAN and TODISTCLEAN.

HDRS := $(sort $(wildcard *.h)) $(MOD_HDRS)
SRCS := $(sort $(wildcard *.c)) $(MOD_SRCS)
OBJS := $(SRCS:.c=.o) $(MOD_OBJS)

CFLAGS += \
	-ggdb $(HAVE_FATAL_WARNINGS) -O2 -DVERSION='"$(VERSION)"' \
	-fstack-protector-all -D_FORTIFY_SOURCE=2 -Wformat -Wformat-security \
	-fPIE \
	-DPREFIX='"$(prefix)"' -DSYSCONFDIR='"$(sysconfdir)/firejail"' \
	-DLIBDIR='"$(libdir)"' -DBINDIR='"$(bindir)"' \
	-DVARDIR='"/var/lib/firejail"' \
	$(HAVE_GCOV) $(MANFLAGS)

LDFLAGS += -pie -fPIE -Wl,-z,relro -Wl,-z,now

.PHONY: all
all: $(TARGET)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

$(PROG): $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o $(PROG) *.gcov *.gcda *.gcno *.plist $(TOCLEAN)

.PHONY: distclean
distclean: clean; rm -fr $(TODISTCLEAN)

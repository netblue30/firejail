# Common definitions for building C programs and non-shared objects.
#
# Note: $(ROOT)/config.mk must be included before this file.
#
# The includer should probably define PROG and TARGET and may also want to
# define EXTRA_HDRS and EXTRA_OBJS and extend CLEANFILES.

HDRS := $(sort $(wildcard $(MOD_DIR)/*.h)) $(EXTRA_HDRS)
SRCS := $(sort $(wildcard $(MOD_DIR)/*.c))
OBJS := $(SRCS:.c=.o) $(EXTRA_OBJS)

.PHONY: all
all: $(TARGET)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(PROG_CFLAGS) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(PROG): $(OBJS) $(ROOT)/config.mk
	$(CC) $(PROG_LDFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

.PHONY: clean
clean:; rm -fr $(PROG) $(CLEANFILES)

# Common definitions for making shared objects.
#
# Note: $(ROOT)/config.mk must be included before this file.
#
# The includer should probably define SO and TARGET and may also want to define
# EXTRA_OBJS and extend CLEANFILES.

HDRS :=
SRCS := $(sort $(wildcard $(MOD_DIR)/*.c))
OBJS := $(SRCS:.c=.o)
DEPS := $(sort $(wildcard $(OBJS:.o=.d)))

ifeq ($(DEPS),)
HDRS := $(sort $(wildcard $(MOD_DIR)/*.h $(ROOT)/src/include/*.h))
endif

.PHONY: all
all: $(TARGET)
-include $(DEPS)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(SO_CFLAGS) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(SO): $(OBJS) $(EXTRA_OBJS) $(ROOT)/config.mk
	$(CC) $(SO_LDFLAGS) -shared $(LDFLAGS) -o $@ $(OBJS) $(EXTRA_OBJS) -ldl

.PHONY: clean
clean:; rm -fr $(SO) $(CLEANFILES)

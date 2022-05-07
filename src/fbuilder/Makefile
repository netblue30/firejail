ROOT = ../..
-include $(ROOT)/config.mk

PROG = fbuilder
TARGET = $(PROG)

MOD_HDRS = ../include/common.h ../include/syscall.h

.PHONY: all
all: $(TARGET)

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

$(PROG): $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o $(PROG) *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

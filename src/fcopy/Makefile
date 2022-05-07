ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/syscall.h
MOD_OBJS = ../lib/common.o

.PHONY: all
all: fcopy

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fcopy: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fcopy *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

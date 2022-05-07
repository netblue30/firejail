ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/syscall.h ../include/ldd_utils.h
MOD_OBJS = ../lib/common.o ../lib/ldd_utils.o

.PHONY: all
all: fldd

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fldd: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fldd *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

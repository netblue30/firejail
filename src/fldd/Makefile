ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: fldd

include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/syscall.h ../include/ldd_utils.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fldd: $(OBJS) ../lib/common.o ../lib/ldd_utils.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/ldd_utils.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fldd *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

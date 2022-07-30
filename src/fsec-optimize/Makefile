ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: fsec-optimize

include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/seccomp.h ../include/syscall.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fsec-optimize: $(OBJS) ../lib/common.o ../lib/libnetlink.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/errno.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fsec-optimize *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

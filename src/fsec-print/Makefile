ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/seccomp.h ../include/syscall.h
MOD_OBJS = ../lib/common.o ../lib/errno.o ../lib/syscall.o

.PHONY: all
all: fsec-print

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fsec-print: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fsec-print *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/seccomp.h ../include/syscall.h
MOD_OBJS = ../lib/common.o ../lib/errno.o

.PHONY: all
all: fsec-optimize

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fsec-optimize: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fsec-optimize *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

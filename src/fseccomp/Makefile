ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/syscall.h
MOD_OBJS = ../lib/common.o ../lib/errno.o ../lib/syscall.o

.PHONY: all
all: fseccomp

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fseccomp: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fseccomp *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: fseccomp

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) ../include/common.h ../include/syscall.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fseccomp: $(OBJS) ../lib/common.o ../lib/errno.o ../lib/syscall.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/errno.o ../lib/syscall.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fseccomp *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

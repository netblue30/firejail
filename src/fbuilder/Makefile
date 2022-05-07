ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h ../include/syscall.h

.PHONY: all
all: fbuilder

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fbuilder: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fbuilder *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

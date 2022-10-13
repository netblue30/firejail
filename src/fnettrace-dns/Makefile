ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: fnettrace-dns

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fnettrace-dns: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fnettrace-dns *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

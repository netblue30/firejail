ROOT = ../..
-include $(ROOT)/config.mk

MOD_HDRS = ../include/common.h

.PHONY: all
all: fzenity

include $(ROOT)/src/common.mk

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fzenity: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fzenity *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

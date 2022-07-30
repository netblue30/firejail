ROOT = ../..
-include $(ROOT)/config.mk

.PHONY: all
all: fids

include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fids: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fids *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

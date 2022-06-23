.PHONY: all
all: fbuilder

ROOT = ../..
include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/syscall.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fbuilder: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fbuilder *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

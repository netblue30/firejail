.PHONY: all
all: fnetfilter

ROOT = ../..
include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/syscall.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fnetfilter: $(OBJS) ../lib/common.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fnetfilter *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

.PHONY: all
all: fcopy

ROOT = ../..
include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/syscall.h
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fcopy: $(OBJS) ../lib/common.o
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fcopy *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

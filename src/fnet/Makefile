.PHONY: all
all: fnet

ROOT = ../..
include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) ../include/common.h ../include/libnetlink.h $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

fnet: $(OBJS) ../lib/common.o ../lib/libnetlink.o $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) ../lib/common.o ../lib/libnetlink.o $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o fnet *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

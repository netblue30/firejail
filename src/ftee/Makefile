.PHONY: all
all: ftee

ROOT = ../..
include $(ROOT)/src/common.mk

%.o : %.c $(H_FILE_LIST) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

ftee: $(OBJS) $(ROOT)/config.mk
	$(CC)  $(LDFLAGS) -o $@ $(OBJS) $(LIBS) $(EXTRA_LDFLAGS)

.PHONY: clean
clean:; rm -fr *.o ftee *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

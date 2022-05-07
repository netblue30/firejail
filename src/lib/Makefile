ROOT = ../..
-include $(ROOT)/config.mk

TARGET = lib

.PHONY: all
all: $(TARGET)

include $(ROOT)/src/common.mk

.PHONY: lib
lib: $(OBJS)

%.o : %.c $(HDRS) $(ROOT)/config.mk
	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDE) -c $< -o $@

.PHONY: clean
clean:; rm -fr $(OBJS) *.gcov *.gcda *.gcno *.plist

.PHONY: distclean
distclean: clean

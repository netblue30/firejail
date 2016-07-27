all: argtest

argtest: main.c
	gcc -o argtest main.c

clean:; rm -f argtest; rm -fr symtest; rm -f out out.*

install:;install -c -m 0755 argtest /usr/local/bin/argtest

uninstall:; rm -f /usr/local/bin/argtest


test:; ./arguments.sh | grep TESTING

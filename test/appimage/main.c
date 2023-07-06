// This is a simple hello program compiled on Debian 11 (glibc 2.31)
// and packaged as an appimage using appimagetool from
// https://github.com/AppImage/AppImageKit. The tool in installed
// in the current directory.
//
// Building the appimage:
//	mkdir -p AppDir/usr/bin
//	gcc -o AppDir/usr/bin/hello main.c && strip AppDir/usr/bin/hello
//	./appimagetool AppDir


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
	// test args
	int i;
	for (i = 1; i < argc; i++)
		printf("%d - %s\n", i, argv[i]);

	printf("Hello, World!\n");

	// elevate privileges - firejail should block it
	system("ping -c 3 127.0.0.1\n");

	printf("Hello, again!\n");
	sleep(30);

	return 0;
}


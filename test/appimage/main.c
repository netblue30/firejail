/*
 * Copyright (C) 2014-2025 Firejail Authors
 *
 * This file is part of firejail project
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

/* How to build an appimage type 2 based on this program (Debian 13 stable):
   
   $ wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
   $ mv appimagetool-x86_64.AppImage ~/tmp/.
   $ cd ~/tmp
   $ sudo apt-get install zsync
   $ mkdir -p AppDir/usr/bin

   create a hello-world.png in AppDir/.

   $ cat AppDir/AppRun
   #!/bin/bash
   exec $APPDIR/usr/bin/hello-world $@
   $ chmod +x AppDir/AppRun
 
   $ gcc -o hello-world main.c
   $ cp hello-world AppDir/usr/bin/.
   $ ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir HelloWorld.AppImage
   $ firejail --appimage HelloWorld.AppImage arg1 arg2 arg3
   [...]
   Mounting appimage type 2
   Base filesystem installed in 32.00 ms
   Child process initialized in 74.17 ms
   Hello, Firejail!
   1 - arg1
   2 - arg2
   3 - arg3

   *** container firejail ***
   *** NoNewPrivs 1 ***
   *** Seccomp 2 ***

   Parent is shutting down, bye...
   AppImage detached
   $
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define MAXBUF 1024

int main(int argc, char **argv) {
	printf("Hello, Firejail!\n");
	
	// test args
	int i;
	for (i = 1; i < argc; i++)
		printf("%d - %s\n", i, argv[i]);


    
	char *cont = getenv("container");
	if (cont)
		printf("\n*** container %s ***\n", cont);
	else
		printf("\n*** container none ***\n");
	sleep(1);

	FILE *fp = fopen("/proc/self/status", "r");
	if (!fp)
		printf("Cannot open proc self status\n");
	else {
		char buf[MAXBUF];
		while (fgets(buf, MAXBUF, fp)) {
			char *ptr = strchr(buf, '\n');
			if (ptr)
				*ptr = '\0';
		    
			if (strncmp(buf, "NoNewPrivs:", 11) == 0) {
				ptr = buf + 11;
				while (*ptr == ' ' || *ptr == '\t')
					ptr++;
				printf("*** NoNewPrivs %s ***\n", ptr);
				sleep(1);
			}
			
			if (strncmp(buf, "Seccomp:", 8) == 0) {
				ptr = buf + 8;
				while (*ptr == ' ' || *ptr == '\t')
					ptr++;
				printf("*** Seccomp %s ***\n", ptr);
			}
		}
		fclose(fp);
	}
	    
	return 0;
}

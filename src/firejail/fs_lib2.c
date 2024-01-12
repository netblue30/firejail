/*
 * Copyright (C) 2014-2024 Firejail Authors
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
#include "firejail.h"
#include <dirent.h>
#include <sys/stat.h>

extern void fslib_mount_libs(const char *full_path, unsigned user);
extern void fslib_mount(const char *full_path);

//***************************************************************
// Standard C library
//***************************************************************
// standard libc libraries based on Debian's libc6 package
// selinux seems to be linked in most command line utilities
// libpcre2 is a dependency of selinux
// locale (/usr/lib/locale) - without it, the program will default to "C" locale
typedef struct liblist_t {
	const char *name;
	int len;
} LibList;

#ifdef HAVE_PRIVATE_LIB
static LibList libc_list[] = {
	{ "libselinux.so.", 0 },
	{ "libpcre2-8.so.", 0 },
	{ "libapparmor.so.", 0},
	{ "ld-linux-x86-64.so.", 0 },
	{ "libanl.so.", 0 },
	{ "libc.so.", 0 },
	{ "libcidn.so.", 0 },
	{ "libcrypt.so.", 0 },
	{ "libdl.so.", 0 },
	{ "libm.so.", 0 },
	{ "libmemusage.so", 0 },
	{ "libmvec.so.", 0 },
	{ "libnsl.so.", 0 },
	{ "libnss_compat.so.", 0 },
	{ "libnss_dns.so.", 0 },
	{ "libnss_files.so.", 0 },
	{ "libnss_hesiod.so.", 0 },
	{ "libnss_nisplus.so.", 0 },
	{ "libnss_nis.so.", 0 },
	{ "libpthread.so.", 0 },
	{ "libresolv.so.", 0 },
	{ "librt.so.", 0 },
	{ "libthread_db.so.", 0 },
	{ "libutil.so.", 0 },
	{ NULL, 0}
};

static int find_libc_list(const char *name) {
	assert(name);

	int i = 0;
	while (libc_list[i].name) {
		if (libc_list[i].len == 0)
			libc_list[i].len = strlen(libc_list[i].name);
		if (strncmp(name, libc_list[i].name, libc_list[i].len) == 0)
			return 1;
		i++;
	}
	return 0;
}

// compare the files in dirname against liblist above
static void stdc(const char *dirname) {
	assert(dirname);

	DIR *dir = opendir(dirname);
	if (dir) {
		struct dirent *entry;
		while ((entry = readdir(dir)) != NULL) {
			if (strcmp(entry->d_name, ".") == 0)
				continue;
			if (strcmp(entry->d_name, "..") == 0)
				continue;

			if (find_libc_list(entry->d_name)) {
				char *fname;
				if (asprintf(&fname, "%s/%s", dirname, entry->d_name) == -1)
					errExit("asprintf");

				fslib_mount(fname);
				free(fname);
			}
		}
		closedir(dir);
	}
}

void fslib_install_stdc(void) {
	// install standard C libraries
	timetrace_start();
	struct stat s;
	if (stat("/lib/x86_64-linux-gnu", &s) == 0) {	// Debian & friends
		mkdir_attr(RUN_LIB_DIR "/x86_64-linux-gnu", 0755, 0, 0);
		selinux_relabel_path(RUN_LIB_DIR "/x86_64-linux-gnu", "/lib/x86_64-linux-gnu");
		stdc("/lib/x86_64-linux-gnu");
	}

	stdc("/lib64"); // CentOS, Fedora, Arch, ld-linux.so in Debian & friends

	// install locale
	if (stat("/usr/lib/locale", &s) == 0)
		fslib_mount("/usr/lib/locale");

	fmessage("Standard C library installed in %0.2f ms\n", timetrace_end());
}

//***************************************************************
// Firejail libraries
//***************************************************************

static void fdir(void) {
	// firejail directory itself
	fslib_mount(LIBDIR "/firejail");

	// executables and libraries from firejail directory
	static const char * const fbin[] = {
		PATH_FCOPY, // currently sufficient to find all needed libraries
		// PATH_FSECCOMP,
		// PATH_FSEC_OPTIMIZE,
		// PATH_FSEC_PRINT,
		// RUN_FIREJAIL_LIB_DIR "/libtrace.so",
		// RUN_FIREJAIL_LIB_DIR "/libtracelog.so",
		// RUN_FIREJAIL_LIB_DIR "/libpostexecseccomp.so",
		NULL,
	};

	// need to parse as root user, unprivileged users have no read permission on some of these binaries
	int i;
	for (i = 0; fbin[i]; i++)
		fslib_mount_libs(fbin[i], 0);
}

void fslib_install_firejail(void) {
	timetrace_start();
	// bring in firejail executable libraries, in case we are redirected here
	// by a firejail symlink from /usr/local/bin/firejail
	// fldd might have no read permission on the firejail executable
	// parse as root in order to support these setups
	fslib_mount_libs(PATH_FIREJAIL, 0);

	// bring in firejail directory
	fdir();

	// bring in dhclient libraries
	if (any_dhcp())
		fslib_mount_libs(RUN_MNT_DIR "/dhclient", 1); // parse as user

	// bring in xauth libraries
	if (arg_x11_xorg)
		fslib_mount_libs("/usr/bin/xauth", 1); // parse as user

	fmessage("Firejail libraries installed in %0.2f ms\n", timetrace_end());
}

//***************************************************************
// various system libraries
//***************************************************************

// look for library in the new filesystem, and install one or two more directories, dir1 and dir2
typedef struct syslib_t {
	const char *library;	// look in the system for this library
	int len;			// length of library string, 0 by default
	int found;		// library found, 0 by default
	const char *dir1;		// directory to install
	const char *dir2;		// directory to install
	const char *message;	// message to print on the screen
} SysLib;

SysLib syslibs[] = {
#if 0
	{
		"",	// library
		0, 0,	// len and found flag
		"",	// dir1
		"",	// dir2
		""	// message
	},
#endif
	{ // pixmaps - libraries used by GTK to display application menu icons
		"libgdk_pixbuf-2.0",	// library
		0, 0,	// len and found flag
		"gdk-pixbuf-2.0",	// dir1
		"",	// dir2
		"GdkPixbuf"	// message
	},
	{ // GTK2
		"libgtk-x11-2.0",	// library
		0, 0,	// len and found flag
		"gtk-2.0",	// dir1
		"libgtk2.0-0",	// dir2
		"GTK2"	// message
	},
	{ // GTK3
		"libgtk-3",	// library
		0, 0,	// len and found flag
		"gtk-3.0",	// dir1
		"libgtk-3-0",	// dir2
		"GTK3"	// message
	},
	{ // Pango - text internationalization, found on older GTK2-based systems
		"libpango",	// library
		0, 0,	// len and found flag
		"pango",	// dir1
		"",	// dir2
		"Pango"	// message
	},
	{ // Library for handling GObject introspection data on GTK systems
		"libgirepository-1.0",	// library
		0, 0,	// len and found flag
		"girepository-1.0",	// dir1
		"",	// dir2
		"GIRepository"	// message
	},
	{ // GIO
		"libgio",	// library
		0, 0,	// len and found flag
		"gio",	// dir1
		"",	// dir2
		"GIO"	// message
	},
	{ // Enchant speller
		"libenchant.so.",	// library
		0, 0,	// len and found flag
		"enchant",	// dir1
		"",	// dir2
		"Enchant (speller)"	// message
	},
	{ // Qt5 - lots of problems on Arch Linux, Qt5 version 5.9.1 - disabled in all apps profiles
		"libQt5",	// library
		0, 0,	// len and found flag
		"qt5",	// dir1
		"gdk-pixbuf-2.0",	// dir2
		"Qt5, GdkPixbuf"	// message
	},
	{ // Qt4
		"libQtCore",	// library
		0, 0,	// len and found flag
		"qt4",	// dir1
		"gdk-pixbuf-2.0",	// dir2
		"Qt4"	// message
	},

	{ // NULL terminated list
		NULL,	// library
		0, 0,	// len and found flag
		"",	// dir1
		"",	// dir2
		""	// message
	}
};

void fslib_install_system(void) {
	// look for installed libraries
	DIR *dir = opendir(RUN_LIB_DIR "/x86_64-linux-gnu");
	if (!dir)
		dir = opendir(RUN_LIB_DIR);

	if (dir) {
		struct dirent *entry;
		while ((entry = readdir(dir)) != NULL) {
			if (strcmp(entry->d_name, ".") == 0)
				continue;
			if (strcmp(entry->d_name, "..") == 0)
				continue;

			SysLib *ptr = &syslibs[0];
			while (ptr->library) {
				if (ptr->len == 0)
					ptr->len = strlen(ptr->library);

				if (strncmp(entry->d_name, ptr->library, ptr->len) == 0) {
					ptr->found = 1;
					break;
				}

				ptr++;
			}

		}
		closedir(dir);
	}
	else
		assert(0);

	// install required directories
	SysLib *ptr = &syslibs[0];
	while (ptr->library) {
		if (ptr->found) {
			assert(*ptr->message != '\0');
			timetrace_start();

			// bring in all libraries
			assert(ptr->dir1);
			char *name;
			// Debian & friends
			if (asprintf(&name, "/usr/lib/x86_64-linux-gnu/%s", ptr->dir1) == -1)
				errExit("asprintf");
			if (access(name, R_OK) == 0) {
				fslib_mount_libs(name, 1); // parse as user
				fslib_mount(name);
			}
			else {
				free(name);
				// CentOS, Fedora, Arch
				if (asprintf(&name, "/usr/lib64/%s", ptr->dir1) == -1)
					errExit("asprintf");
				if (access(name, R_OK) == 0) {
					fslib_mount_libs(name, 1); // parse as user
					fslib_mount(name);
				}
			}
			free(name);

			if (*ptr->dir2 != '\0') {
				// Debian & friends
				if (asprintf(&name, "/usr/lib/x86_64-linux-gnu/%s", ptr->dir2) == -1)
					errExit("asprintf");
				if (access(name, R_OK) == 0) {
					fslib_mount_libs(name, 1); // parse as user
					fslib_mount(name);
				}
				else {
					free(name);
					// CentOS, Fedora, Arch
					if (asprintf(&name, "/usr/lib64/%s", ptr->dir2) == -1)
						errExit("asprintf");
					if (access(name, R_OK) == 0) {
						fslib_mount_libs(name, 1); // parse as user
						fslib_mount(name);
					}
				}
				free(name);
			}

			fmessage("%s installed in %0.2f ms\n", ptr->message, timetrace_end());
		}
		ptr++;
	}
}
#endif

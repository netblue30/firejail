/*
 * Copyright (C) 2020-2023 Firejail and systemd authors
 *
 * This file is part of firejail project, from systemd selinux-util.c
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
#if HAVE_SELINUX
#include "firejail.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>

#include <fcntl.h>
#ifndef O_PATH
#define O_PATH 010000000
#endif

#include <selinux/context.h>
#include <selinux/label.h>
#include <selinux/selinux.h>

static struct selabel_handle *label_hnd = NULL;
static int selinux_enabled = -1;
#endif

void selinux_relabel_path(const char *path, const char *inside_path)
{
#if HAVE_SELINUX
	char procfs_path[64];
	char *fcon = NULL;
	int fd;
	struct stat st;

	if (selinux_enabled == -1)
		selinux_enabled = is_selinux_enabled();

	if (!selinux_enabled)
		return;

	if (!label_hnd)
		label_hnd = selabel_open(SELABEL_CTX_FILE, NULL, 0);

	if (!label_hnd)
		errExit("selabel_open");

	/* Open the file as O_PATH, to pin it while we determine and adjust the label
	 * Defeat symlink races by not allowing symbolic links */
	int called_as_root = 0;
	if (geteuid() == 0)
		called_as_root = 1;
	if (called_as_root)
		EUID_USER();

	fd = safer_openat(-1, path, O_NOFOLLOW|O_CLOEXEC|O_PATH);

	if (called_as_root)
		EUID_ROOT();

	if (fd < 0)
		return;
	if (fstat(fd, &st) < 0)
		goto close;

	if (selabel_lookup_raw(label_hnd, &fcon, inside_path, st.st_mode)  == 0) {
		sprintf(procfs_path, "/proc/self/fd/%i", fd);
		if (arg_debug)
			printf("Relabeling %s as %s (%s)\n", path, inside_path, fcon);

		if (!called_as_root)
			EUID_ROOT();

		if (setfilecon_raw(procfs_path, fcon) != 0 && arg_debug)
			printf("Cannot relabel %s: %s\n", path, strerror(errno));

		if (!called_as_root)
			EUID_USER();
	}

	freecon(fcon);
 close:
	close(fd);
#else
	(void) path;
	(void) inside_path;
#endif
}

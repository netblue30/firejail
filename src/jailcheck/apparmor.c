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
#include "jailcheck.h"

#ifdef HAVE_APPARMOR
#include <sys/apparmor.h>

void apparmor_test(pid_t pid) {
	char *label = NULL;
	char *mode = NULL;
	int rv = aa_gettaskcon(pid, &label, &mode);
	if (rv == -1 || mode == NULL)
		printf("   Warning: AppArmor not enabled\n");
}


#else
void apparmor_test(pid_t pid) {
	(void) pid;
	return;
}
#endif

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

#ifndef GCOV_WRAPPER_H
#define GCOV_WRAPPER_H

#ifdef HAVE_GCOV
#include <gcov.h>

/*
 * __gcov_flush was removed on gcc 11.1.0 (as it's no longer needed), but it
 * appears to be the safe/"correct" way to do things on previous versions (as
 * it ensured proper locking, which is now done elsewhere).  Thus, keep using
 * it in the code and ensure that it exists, in order to support gcc <11.1.0
 * and gcc >=11.1.0, respectively.
 */
#if __GNUC__ > 11 || (__GNUC__ == 11 && __GNUC_MINOR__ >= 1)
static void __gcov_flush(void) {
	__gcov_dump();
	__gcov_reset();
}
#endif
#else
#define __gcov_dump() ((void)0)
#define __gcov_reset() ((void)0)
#define __gcov_flush() ((void)0)
#endif /* HAVE_GCOV */

#endif /* GCOV_WRAPPER_H */

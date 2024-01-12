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
#include "../include/syscall.h"

#include <errno.h>
#include <stdio.h>
#include <string.h>
//#include <attr/xattr.h>

typedef struct {
	char *name;
	int nr;
} ErrnoEntry;

static ErrnoEntry errnolist[] = {
//
// code generated using ../tools/extract_errnos.sh
//
	{"EPERM", EPERM},
	{"ENOENT", ENOENT},
	{"ESRCH", ESRCH},
	{"EINTR", EINTR},
	{"EIO", EIO},
	{"ENXIO", ENXIO},
	{"E2BIG", E2BIG},
	{"ENOEXEC", ENOEXEC},
	{"EBADF", EBADF},
	{"ECHILD", ECHILD},
	{"EAGAIN", EAGAIN},
	{"ENOMEM", ENOMEM},
	{"EACCES", EACCES},
	{"EFAULT", EFAULT},
	{"ENOTBLK", ENOTBLK},
	{"EBUSY", EBUSY},
	{"EEXIST", EEXIST},
	{"EXDEV", EXDEV},
	{"ENODEV", ENODEV},
	{"ENOTDIR", ENOTDIR},
	{"EISDIR", EISDIR},
	{"EINVAL", EINVAL},
	{"ENFILE", ENFILE},
	{"EMFILE", EMFILE},
	{"ENOTTY", ENOTTY},
	{"ETXTBSY", ETXTBSY},
	{"EFBIG", EFBIG},
	{"ENOSPC", ENOSPC},
	{"ESPIPE", ESPIPE},
	{"EROFS", EROFS},
	{"EMLINK", EMLINK},
	{"EPIPE", EPIPE},
	{"EDOM", EDOM},
	{"ERANGE", ERANGE},
	{"EDEADLK", EDEADLK},
	{"ENAMETOOLONG", ENAMETOOLONG},
	{"ENOLCK", ENOLCK},
	{"ENOSYS", ENOSYS},
	{"ENOTEMPTY", ENOTEMPTY},
	{"ELOOP", ELOOP},
	{"EWOULDBLOCK", EWOULDBLOCK},
	{"ENOMSG", ENOMSG},
	{"EIDRM", EIDRM},
	{"ECHRNG", ECHRNG},
	{"EL2NSYNC", EL2NSYNC},
	{"EL3HLT", EL3HLT},
	{"EL3RST", EL3RST},
	{"ELNRNG", ELNRNG},
	{"EUNATCH", EUNATCH},
	{"ENOCSI", ENOCSI},
	{"EL2HLT", EL2HLT},
	{"EBADE", EBADE},
	{"EBADR", EBADR},
	{"EXFULL", EXFULL},
	{"ENOANO", ENOANO},
	{"EBADRQC", EBADRQC},
	{"EBADSLT", EBADSLT},
	{"EDEADLOCK", EDEADLOCK},
	{"EBFONT", EBFONT},
	{"ENOSTR", ENOSTR},
	{"ENODATA", ENODATA},
	{"ETIME", ETIME},
	{"ENOSR", ENOSR},
	{"ENONET", ENONET},
	{"ENOPKG", ENOPKG},
	{"EREMOTE", EREMOTE},
	{"ENOLINK", ENOLINK},
	{"EADV", EADV},
	{"ESRMNT", ESRMNT},
	{"ECOMM", ECOMM},
	{"EPROTO", EPROTO},
	{"EMULTIHOP", EMULTIHOP},
	{"EDOTDOT", EDOTDOT},
	{"EBADMSG", EBADMSG},
	{"EOVERFLOW", EOVERFLOW},
	{"ENOTUNIQ", ENOTUNIQ},
	{"EBADFD", EBADFD},
	{"EREMCHG", EREMCHG},
	{"ELIBACC", ELIBACC},
	{"ELIBBAD", ELIBBAD},
	{"ELIBSCN", ELIBSCN},
	{"ELIBMAX", ELIBMAX},
	{"ELIBEXEC", ELIBEXEC},
	{"EILSEQ", EILSEQ},
	{"ERESTART", ERESTART},
	{"ESTRPIPE", ESTRPIPE},
	{"EUSERS", EUSERS},
	{"ENOTSOCK", ENOTSOCK},
	{"EDESTADDRREQ", EDESTADDRREQ},
	{"EMSGSIZE", EMSGSIZE},
	{"EPROTOTYPE", EPROTOTYPE},
	{"ENOPROTOOPT", ENOPROTOOPT},
	{"EPROTONOSUPPORT", EPROTONOSUPPORT},
	{"ESOCKTNOSUPPORT", ESOCKTNOSUPPORT},
	{"EOPNOTSUPP", EOPNOTSUPP},
	{"EPFNOSUPPORT", EPFNOSUPPORT},
	{"EAFNOSUPPORT", EAFNOSUPPORT},
	{"EADDRINUSE", EADDRINUSE},
	{"EADDRNOTAVAIL", EADDRNOTAVAIL},
	{"ENETDOWN", ENETDOWN},
	{"ENETUNREACH", ENETUNREACH},
	{"ENETRESET", ENETRESET},
	{"ECONNABORTED", ECONNABORTED},
	{"ECONNRESET", ECONNRESET},
	{"ENOBUFS", ENOBUFS},
	{"EISCONN", EISCONN},
	{"ENOTCONN", ENOTCONN},
	{"ESHUTDOWN", ESHUTDOWN},
	{"ETOOMANYREFS", ETOOMANYREFS},
	{"ETIMEDOUT", ETIMEDOUT},
	{"ECONNREFUSED", ECONNREFUSED},
	{"EHOSTDOWN", EHOSTDOWN},
	{"EHOSTUNREACH", EHOSTUNREACH},
	{"EALREADY", EALREADY},
	{"EINPROGRESS", EINPROGRESS},
	{"ESTALE", ESTALE},
	{"EUCLEAN", EUCLEAN},
	{"ENOTNAM", ENOTNAM},
	{"ENAVAIL", ENAVAIL},
	{"EISNAM", EISNAM},
	{"EREMOTEIO", EREMOTEIO},
	{"EDQUOT", EDQUOT},
	{"ENOMEDIUM", ENOMEDIUM},
	{"EMEDIUMTYPE", EMEDIUMTYPE},
	{"ECANCELED", ECANCELED},
	{"ENOKEY", ENOKEY},
	{"EKEYEXPIRED", EKEYEXPIRED},
	{"EKEYREVOKED", EKEYREVOKED},
	{"EKEYREJECTED", EKEYREJECTED},
	{"EOWNERDEAD", EOWNERDEAD},
	{"ENOTRECOVERABLE", ENOTRECOVERABLE},
	{"ERFKILL", ERFKILL},
	{"EHWPOISON", EHWPOISON},
	{"ENOTSUP", ENOTSUP},
#ifdef 	ENOATTR
	{"ENOATTR", ENOATTR},
#endif
};

int errno_find_name(const char *name) {
	int i;
	int elems = sizeof(errnolist) / sizeof(errnolist[0]);
	for (i = 0; i < elems; i++) {
		if (strcasecmp(name, errnolist[i].name) == 0)
			return errnolist[i].nr;
	}

	return -1;
}

const char *errno_find_nr(int nr) {
	int i;
	int elems = sizeof(errnolist) / sizeof(errnolist[0]);
	for (i = 0; i < elems; i++) {
		if (nr == errnolist[i].nr)
			return errnolist[i].name;
	}

	return "unknown";
}



void errno_print(void) {
	int i;
	int elems = sizeof(errnolist) / sizeof(errnolist[0]);
	for (i = 0; i < elems; i++) {
		printf("%d\t- %s\n", errnolist[i].nr, errnolist[i].name);
	}
	printf("\n");
}

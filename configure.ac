AC_PREREQ([2.68])
AC_INIT(firejail, 0.9.39, netblue30@yahoo.com, , http://firejail.wordpress.com)
AC_CONFIG_SRCDIR([src/firejail/main.c])
#AC_CONFIG_HEADERS([config.h])


AC_PROG_CC
#AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_RANLIB

HAVE_SECCOMP=""
AC_ARG_ENABLE([seccomp],
    AS_HELP_STRING([--disable-seccomp], [disable seccomp]))
AS_IF([test "x$enable_seccomp" != "xno"], [
	HAVE_SECCOMP="-DHAVE_SECCOMP"
	AC_SUBST(HAVE_SECCOMP)
])

HAVE_CHROOT=""
AC_ARG_ENABLE([chroot],
    AS_HELP_STRING([--disable-chroot], [disable chroot]))
AS_IF([test "x$enable_chroot" != "xno"], [
	HAVE_CHROOT="-DHAVE_CHROOT"
	AC_SUBST(HAVE_CHROOT)
])

HAVE_BIND=""
AC_ARG_ENABLE([bind],
    AS_HELP_STRING([--disable-bind], [disable bind]))
AS_IF([test "x$enable_bind" != "xno"], [
	HAVE_BIND="-DHAVE_BIND"
	AC_SUBST(HAVE_BIND)
])

HAVE_NETWORK=""
AC_ARG_ENABLE([network],
    AS_HELP_STRING([--disable-network], [disable network]))
AC_ARG_ENABLE([network],
    AS_HELP_STRING([--enable-network=restricted], [ restrict --net= to root only]))
AS_IF([test "x$enable_network" != "xno"], [
	HAVE_NETWORK="-DHAVE_NETWORK"
	AS_IF([test "x$enable_network" = "xrestricted"], [
	       HAVE_NETWORK="$HAVE_NETWORK -DHAVE_NETWORK_RESTRICTED"
	])
	AC_SUBST(HAVE_NETWORK)
])

HAVE_USERNS=""
AC_ARG_ENABLE([userns],
    AS_HELP_STRING([--disable-userns], [disable user namespace]))
AS_IF([test "x$enable_userns" != "xno"], [
	HAVE_USERNS="-DHAVE_USERNS"
	AC_SUBST(HAVE_USERNS)
])

HAVE_X11=""
AC_ARG_ENABLE([x11],
    AS_HELP_STRING([--disable-x11], [disable X11 sandboxing support]))
AS_IF([test "x$enable_x11" != "xno"], [
	HAVE_X11="-DHAVE_X11"
	AC_SUBST(HAVE_X11)
])

HAVE_FILE_TRANSFER=""
AC_ARG_ENABLE([file-transfer],
    AS_HELP_STRING([--disable-file-transfer], [disable file transfer]))
AS_IF([test "x$enable_file_transfer" != "xno"], [
	HAVE_FILE_TRANSFER="-DHAVE_FILE_TRANSFER"
	AC_SUBST(HAVE_FILE_TRANSFER)
])

HAVE_FATAL_WARNINGS=""
AC_ARG_ENABLE([fatal_warnings],
    AS_HELP_STRING([--enable-fatal-warnings], [-W -Wall -Werror]))
AS_IF([test "x$enable_fatal_warnings" = "xyes"], [
	HAVE_FATAL_WARNINGS="-W -Wall -Werror"
	AC_SUBST(HAVE_FATAL_WARNINGS)
])


# checking pthread library
AC_CHECK_LIB([pthread], [main], [], AC_MSG_ERROR([*** POSIX thread support not installed ***]))
AC_CHECK_HEADER(pthread.h,,AC_MSG_ERROR([*** POSIX thread support not installed ***]))
AC_CHECK_HEADER([linux/seccomp.h], HAVE_SECCOMP_H="-DHAVE_SECCOMP_H", HAVE_SECCOMP_H="")
AC_SUBST(HAVE_SECCOMP_H)

# set sysconfdir
if test "$prefix" = /usr; then
	sysconfdir="/etc"
fi

AC_OUTPUT(Makefile src/lib/Makefile src/firejail/Makefile src/firemon/Makefile src/libtrace/Makefile src/libtracelog/Makefile src/ftee/Makefile)

echo
echo "Configuration options:"
echo "   prefix: $prefix"
echo "   sysconfdir: $sysconfdir"
echo "   seccomp: $HAVE_SECCOMP"
echo "   <linux/seccomp.h>: $HAVE_SECCOMP_H"
echo "   chroot: $HAVE_CHROOT"
echo "   bind: $HAVE_BIND"
echo "   network: $HAVE_NETWORK"
echo "   user namespace: $HAVE_USERNS"
echo "   X11 sandboxing support: $HAVE_X11"
echo "   file transfer support: $HAVE_FILE_TRANSFER"
echo "   fatal warnings: $HAVE_FATAL_WARNINGS"
echo



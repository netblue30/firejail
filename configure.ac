AC_PREREQ([2.68])
AC_INIT(firejail, 0.9.29-github, netblue30@yahoo.com, , http://firejail.sourceforge.net)
AC_CONFIG_SRCDIR([src/firejail/main.c])
#AC_CONFIG_HEADERS([config.h])


AC_PROG_CC
#AC_PROG_CXX
AC_PROG_INSTALL
AC_PROG_RANLIB

HAVE_SECCOMP=""
AC_ARG_ENABLE([seccomp],
    AS_HELP_STRING([--disable-seccomp], [Disable seccomp]))
AS_IF([test "x$enable_seccomp" != "xno"], [
	HAVE_SECCOMP="-DHAVE_SECCOMP"
	AC_SUBST(HAVE_SECCOMP)
])

HAVE_CHROOT=""
AC_ARG_ENABLE([chroot],
    AS_HELP_STRING([--disable-chroot], [Disable chroot]))
AS_IF([test "x$enable_chroot" != "xno"], [
	HAVE_CHROOT="-DHAVE_CHROOT"
	AC_SUBST(HAVE_CHROOT)
])

HAVE_BIND=""
AC_ARG_ENABLE([bind],
    AS_HELP_STRING([--disable-bind], [Disable bind]))
AS_IF([test "x$enable_bind" != "xno"], [
	HAVE_BIND="-DHAVE_BIND"
	AC_SUBST(HAVE_BIND)
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

AC_OUTPUT(Makefile src/lib/Makefile src/firejail/Makefile src/firemon/Makefile src/libtrace/Makefile src/ftee/Makefile)

echo
echo "Configuration options:"
echo "   prefix: $prefix"
echo "   seccomp: $HAVE_SECCOMP"
echo "   <linux/seccomp.h>: $HAVE_SECCOMP_H"
echo "   chroot: $HAVE_CHROOT"
echo "   bind: $HAVE_BIND"
echo "   fatal warnings: $HAVE_FATAL_WARNINGS"
echo

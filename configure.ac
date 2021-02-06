#
# Note:
#
# If for any reason autoconf fails, run "autoreconf -i --install " and try again.
# This is how the error looks like on Arch Linux:
#        ./configure: line 3064: syntax error near unexpected token `newline'
#        ./configure: line 3064: `AX_CHECK_COMPILE_FLAG('
#
# We rely solely on autoconf, without automake. Apparently, in this case
# the macros from m4 directory are not picked up by default by automake.
# "autoreconf -i --install" seems to fix the problem.
#

AC_PREREQ([2.68])
AC_INIT(firejail, 0.9.65, netblue30@protonmail.com, , https://firejail.wordpress.com)
AC_CONFIG_SRCDIR([src/firejail/main.c])

AC_CONFIG_MACRO_DIR([m4])

AC_PROG_CC
AC_PROG_INSTALL
AC_PROG_RANLIB

HAVE_SPECTRE="no"
AX_CHECK_COMPILE_FLAG(
    [-mindirect-branch=thunk],
    [HAVE_SPECTRE="yes" && EXTRA_CFLAGS+=" -mindirect-branch=thunk"]
)
AX_CHECK_COMPILE_FLAG(
    [-mretpoline],
    [HAVE_SPECTRE="yes" && EXTRA_CFLAGS+=" -mretpoline"]
)
AX_CHECK_COMPILE_FLAG(
    [-fstack-clash-protection],
    [HAVE_SPECTRE="yes" && EXTRA_CFLAGS+=" -fstack-clash-protection"]
)
AX_CHECK_COMPILE_FLAG(
    [-fstack-protector-strong],
    [HAVE_SPECTRE="yes" && EXTRA_CFLAGS+=" -fstack-protector-strong"]
)

AC_ARG_ENABLE([analyzer],
    AS_HELP_STRING([--enable-analyzer], [enable GCC 10 static analyzer]))
AS_IF([test "x$enable_analyzer" = "xyes"], [
	EXTRA_CFLAGS+=" -fanalyzer"
])

HAVE_APPARMOR=""
AC_ARG_ENABLE([apparmor],
    AS_HELP_STRING([--enable-apparmor], [enable apparmor]))
AS_IF([test "x$enable_apparmor" = "xyes"], [
	HAVE_APPARMOR="-DHAVE_APPARMOR"
	PKG_CHECK_MODULES([AA], libapparmor, [EXTRA_CFLAGS+=" $AA_CFLAGS" && EXTRA_LDFLAGS+=" $AA_LIBS"])
	AC_SUBST(HAVE_APPARMOR)
])

AC_SUBST([EXTRA_CFLAGS])
AC_SUBST([EXTRA_LDFLAGS])


HAVE_DBUSPROXY=""
AC_ARG_ENABLE([dbusproxy],
    AS_HELP_STRING([--disable-dbusproxy], [disable dbus proxy]))
AS_IF([test "x$enable_dbusproxy" != "xno"], [
	HAVE_DBUSPROXY="-DHAVE_DBUSPROXY"
	AC_SUBST(HAVE_DBUSPROXY)
])

# overlayfs features temporarely disabled pending fixes
HAVE_OVERLAYFS=""
AC_SUBST(HAVE_OVERLAYFS)
#
#AC_ARG_ENABLE([overlayfs],
#    AS_HELP_STRING([--disable-overlayfs], [disable overlayfs]))
#AS_IF([test "x$enable_overlayfs" != "xno"], [
#	HAVE_OVERLAYFS="-DHAVE_OVERLAYFS"
#	AC_SUBST(HAVE_OVERLAYFS)
#])

HAVE_USERTMPS=""
AC_ARG_ENABLE([usertmpfs],
    AS_HELP_STRING([--disable-usertmpfs], [disable tmpfs as regular user]))
AS_IF([test "x$enable_usertmpfs" != "xno"], [
	HAVE_USERTMPFS="-DHAVE_USERTMPFS"
	AC_SUBST(HAVE_USERTMPFS)
])

HAVE_MAN="no"
AC_ARG_ENABLE([man],
    AS_HELP_STRING([--disable-man], [disable man pages]))
AS_IF([test "x$enable_man" != "xno"], [
	HAVE_MAN="-DHAVE_MAN"
	AC_SUBST(HAVE_MAN)
	AC_CHECK_PROG([HAVE_GAWK], [gawk], [yes], [no])
	AS_IF([test "x$HAVE_GAWK" != "xyes"], [AC_MSG_ERROR("*** gawk not found ***")])
])

HAVE_FIRETUNNEL=""
AC_ARG_ENABLE([firetunnel],
    AS_HELP_STRING([--disable-firetunnel], [disable firetunnel]))
AS_IF([test "x$enable_firetunnel" != "xno"], [
	HAVE_FIRETUNNEL="-DHAVE_FIRETUNNEL"
	AC_SUBST(HAVE_FIRETUNNEL)
])

HAVE_PRIVATEHOME=""
AC_ARG_ENABLE([private-home],
    AS_HELP_STRING([--disable-private-home], [disable private home feature]))
AS_IF([test "x$enable_private_home" != "xno"], [
	HAVE_PRIVATE_HOME="-DHAVE_PRIVATE_HOME"
	AC_SUBST(HAVE_PRIVATE_HOME)
])

HAVE_CHROOT=""
AC_ARG_ENABLE([chroot],
    AS_HELP_STRING([--disable-chroot], [disable chroot]))
AS_IF([test "x$enable_chroot" != "xno"], [
	HAVE_CHROOT="-DHAVE_CHROOT"
	AC_SUBST(HAVE_CHROOT)
])

HAVE_GLOBALCFG=""
AC_ARG_ENABLE([globalcfg],
    AS_HELP_STRING([--disable-globalcfg], [if the global config file firejail.cfg is not present, continue the program using defaults]))
AS_IF([test "x$enable_globalcfg" != "xno"], [
	HAVE_GLOBALCFG="-DHAVE_GLOBALCFG"
	AC_SUBST(HAVE_GLOBALCFG)
])

HAVE_NETWORK=""
AC_ARG_ENABLE([network],
    AS_HELP_STRING([--disable-network], [disable network]))
AS_IF([test "x$enable_network" != "xno"], [
	HAVE_NETWORK="-DHAVE_NETWORK"
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

HAVE_WHITELIST=""
AC_ARG_ENABLE([whitelist],
    AS_HELP_STRING([--disable-whitelist], [disable whitelist]))
AS_IF([test "x$enable_whitelist" != "xno"], [
	HAVE_WHITELIST="-DHAVE_WHITELIST"
	AC_SUBST(HAVE_WHITELIST)
])

HAVE_SUID=""
AC_ARG_ENABLE([suid],
    AS_HELP_STRING([--disable-suid], [install as a non-SUID executable]))
AS_IF([test "x$enable_suid" = "xno"],
	[HAVE_SUID="no"],
	[HAVE_SUID="yes"]
)
AC_SUBST(HAVE_SUID)

HAVE_FATAL_WARNINGS=""
AC_ARG_ENABLE([fatal_warnings],
    AS_HELP_STRING([--enable-fatal-warnings], [-W -Wall -Werror]))
AS_IF([test "x$enable_fatal_warnings" = "xyes"], [
	HAVE_FATAL_WARNINGS="-W -Wall -Werror"
	AC_SUBST(HAVE_FATAL_WARNINGS)
])

BUSYBOX_WORKAROUND="no"
AC_ARG_ENABLE([busybox-workaround],
    AS_HELP_STRING([--enable-busybox-workaround], [enable busybox workaround]))
AS_IF([test "x$enable_busybox_workaround" = "xyes"], [
	BUSYBOX_WORKAROUND="yes"
	AC_SUBST(BUSYBOX_WORKAROUND)
])


HAVE_GCOV=""
AC_ARG_ENABLE([gcov],
    AS_HELP_STRING([--enable-gcov], [Gcov instrumentation]))
AS_IF([test "x$enable_gcov" = "xyes"], [
	HAVE_GCOV="--coverage -DHAVE_GCOV "
	EXTRA_LDFLAGS+=" -lgcov --coverage "
	AC_SUBST(HAVE_GCOV)
])

HAVE_CONTRIB_INSTALL="yes"
AC_ARG_ENABLE([contrib-install],
    AS_HELP_STRING([--enable-contrib-install], [install contrib scripts]))
AS_IF([test "x$enable_contrib_install" = "xno"],
	[HAVE_CONTRIB_INSTALL="no"],
	[HAVE_CONTRIB_INSTALL="yes"]
)
AC_SUBST(HAVE_CONTRIB_INSTALL)

HAVE_SELINUX=""
AC_ARG_ENABLE([selinux],
    AS_HELP_STRING([--enable-selinux], [SELinux labeling support]))
AS_IF([test "x$enable_selinux" = "xyes"], [
	HAVE_SELINUX="-DHAVE_SELINUX"
	EXTRA_LDFLAGS+=" -lselinux "
	AC_SUBST(HAVE_SELINUX)
])

# checking pthread library
AC_CHECK_LIB([pthread], [main], [], AC_MSG_ERROR([*** POSIX thread support not installed ***]))
AC_CHECK_HEADER(pthread.h,,AC_MSG_ERROR([*** POSIX thread support not installed ***]))
AC_CHECK_HEADER([linux/seccomp.h],,AC_MSG_ERROR([*** SECCOMP support is not installed (/usr/include/linux/seccomp.h missing) ***]))

# set sysconfdir
if test "$prefix" = /usr; then
	test "$sysconfdir" = '${prefix}/etc' && sysconfdir="/etc"
fi

AC_CONFIG_FILES([mkdeb.sh], [chmod +x mkdeb.sh])
AC_OUTPUT(Makefile src/common.mk src/lib/Makefile src/fcopy/Makefile src/fnet/Makefile src/firejail/Makefile src/fnetfilter/Makefile \
src/firemon/Makefile src/libtrace/Makefile src/libtracelog/Makefile src/firecfg/Makefile src/fbuilder/Makefile src/fsec-print/Makefile \
src/ftee/Makefile src/faudit/Makefile src/fseccomp/Makefile src/fldd/Makefile src/libpostexecseccomp/Makefile src/fsec-optimize/Makefile \
src/profstats/Makefile src/man/Makefile test/Makefile)

echo
echo "Configuration options:"
echo "   prefix: $prefix"
echo "   sysconfdir: $sysconfdir"
echo "   apparmor: $HAVE_APPARMOR"
echo "   global config: $HAVE_GLOBALCFG"
echo "   chroot: $HAVE_CHROOT"
echo "   network: $HAVE_NETWORK"
echo "   user namespace: $HAVE_USERNS"
echo "   X11 sandboxing support: $HAVE_X11"
echo "   whitelisting: $HAVE_WHITELIST"
echo "   private home support: $HAVE_PRIVATE_HOME"
echo "   file transfer support: $HAVE_FILE_TRANSFER"
echo "   overlayfs support: $HAVE_OVERLAYFS"
echo "   DBUS proxy support: $HAVE_DBUSPROXY"
echo "   allow tmpfs as regular user: $HAVE_USERTMPFS"
echo "   Manpage support: $HAVE_MAN"
echo "   firetunnel support: $HAVE_FIRETUNNEL"
echo "   busybox workaround: $BUSYBOX_WORKAROUND"
echo "   Spectre compiler patch: $HAVE_SPECTRE"
echo "   EXTRA_LDFLAGS: $EXTRA_LDFLAGS"
echo "   EXTRA_CFLAGS: $EXTRA_CFLAGS"
echo "   fatal warnings: $HAVE_FATAL_WARNINGS"
echo "   Gcov instrumentation: $HAVE_GCOV"
echo "   Install contrib scripts: $HAVE_CONTRIB_INSTALL"
echo "   SELinux labeling support: $HAVE_SELINUX"
echo "   Install as a SUID executable: $HAVE_SUID"
echo

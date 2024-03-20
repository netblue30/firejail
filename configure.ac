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
AC_INIT([firejail], [0.9.73], [netblue30@protonmail.com], [],
    [https://firejail.wordpress.com])

AC_CONFIG_SRCDIR([src/firejail/main.c])
AC_CONFIG_MACRO_DIR([m4])

AC_PROG_CC
AC_CHECK_PROGS([CODESPELL], [codespell])
AC_CHECK_PROGS([CPPCHECK], [cppcheck])
AC_CHECK_PROGS([GAWK], [gawk])
AC_CHECK_PROGS([SCAN_BUILD], [scan-build])

DEPS_CFLAGS=""
AC_SUBST([DEPS_CFLAGS])
AX_CHECK_COMPILE_FLAG([-MMD -MP], [
	DEPS_CFLAGS="$DEPS_CFLAGS -MMD -MP"
])

AX_CHECK_COMPILE_FLAG([-D_FORTIFY_SOURCE=2], [
	EXTRA_CFLAGS="$EXTRA_CFLAGS -D_FORTIFY_SOURCE=2"
], [], [$CFLAGS $CPPFLAGS -Werror])

HAVE_SPECTRE="no"
AX_CHECK_COMPILE_FLAG([-mindirect-branch=thunk], [
	HAVE_SPECTRE="yes"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -mindirect-branch=thunk"
])
AX_CHECK_COMPILE_FLAG([-fstack-clash-protection], [
	HAVE_SPECTRE="yes"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fstack-clash-protection"
])
AX_CHECK_COMPILE_FLAG([-fstack-protector-strong], [
	HAVE_SPECTRE="yes"
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fstack-protector-strong"
])

AC_ARG_ENABLE([analyzer],
    [AS_HELP_STRING([--enable-analyzer], [enable GCC static analyzer])])
AS_IF([test "x$enable_analyzer" = "xyes"], [
	EXTRA_CFLAGS="$EXTRA_CFLAGS -fanalyzer -Wno-analyzer-malloc-leak"
])

AC_ARG_ENABLE([sanitizer],
    [AS_HELP_STRING([--enable-sanitizer=@<:@address | memory | undefined@:>@],
        [enable a compiler-based sanitizer (debug)])],
    [],
    [enable_sanitizer=no])
AS_IF([test "x$enable_sanitizer" != "xno" ], [
	AX_CHECK_COMPILE_FLAG([-fsanitize=$enable_sanitizer], [
		EXTRA_CFLAGS="$EXTRA_CFLAGS -fsanitize=$enable_sanitizer -fno-omit-frame-pointer"
		EXTRA_LDFLAGS="$EXTRA_LDFLAGS -fsanitize=$enable_sanitizer"
	], [AC_MSG_ERROR([sanitizer not supported: $enable_sanitizer])])
])

HAVE_IDS=""
AC_SUBST([HAVE_IDS])
AC_ARG_ENABLE([ids],
    [AS_HELP_STRING([--enable-ids], [enable ids])])
AS_IF([test "x$enable_ids" = "xyes"], [
	HAVE_IDS="-DHAVE_IDS"
])

HAVE_APPARMOR=""
AC_SUBST([HAVE_APPARMOR])
AC_ARG_ENABLE([apparmor],
    [AS_HELP_STRING([--enable-apparmor], [enable apparmor])])
AS_IF([test "x$enable_apparmor" = "xyes"], [
	HAVE_APPARMOR="-DHAVE_APPARMOR"
	PKG_CHECK_MODULES([AA], [libapparmor], [
		EXTRA_CFLAGS="$EXTRA_CFLAGS $AA_CFLAGS"
		LIBS="$LIBS $AA_LIBS"
	])
])

HAVE_SELINUX=""
AC_SUBST([HAVE_SELINUX])
AC_ARG_ENABLE([selinux],
    [AS_HELP_STRING([--enable-selinux], [SELinux labeling support])])
AS_IF([test "x$enable_selinux" = "xyes"], [
	HAVE_SELINUX="-DHAVE_SELINUX"
	LIBS="$LIBS -lselinux"
])

HAVE_LANDLOCK=""
AC_SUBST([HAVE_LANDLOCK])
AC_ARG_ENABLE([landlock],
    [AS_HELP_STRING([--enable-landlock], [Landlock self-restriction support])])
AS_IF([test "x$enable_landlock" != "xno"], [
	AC_CHECK_HEADER([linux/landlock.h],
	    [HAVE_LANDLOCK="-DHAVE_LANDLOCK"],
	    [AC_MSG_WARN([header not found: linux/landlock.h, building without Landlock support])])
])

AC_SUBST([EXTRA_CFLAGS])
AC_SUBST([EXTRA_LDFLAGS])

HAVE_DBUSPROXY=""
AC_SUBST([HAVE_DBUSPROXY])
AC_ARG_ENABLE([dbusproxy],
    [AS_HELP_STRING([--disable-dbusproxy], [disable dbus proxy])])
AS_IF([test "x$enable_dbusproxy" != "xno"], [
	HAVE_DBUSPROXY="-DHAVE_DBUSPROXY"
])

# overlayfs features temporarily disabled pending fixes
HAVE_OVERLAYFS=""
AC_SUBST([HAVE_OVERLAYFS])
#AC_ARG_ENABLE([overlayfs],
#    [AS_HELP_STRING([--disable-overlayfs], [disable overlayfs])])
#AS_IF([test "x$enable_overlayfs" != "xno"], [
#	HAVE_OVERLAYFS="-DHAVE_OVERLAYFS"
#])

HAVE_OUTPUT=""
AC_SUBST([HAVE_OUTPUT])
AC_ARG_ENABLE([output],
    [AS_HELP_STRING([--disable-output], [disable --output logging])])
AS_IF([test "x$enable_output" != "xno"], [
	HAVE_OUTPUT="-DHAVE_OUTPUT"
])

HAVE_USERTMPFS=""
AC_SUBST([HAVE_USERTMPFS])
AC_ARG_ENABLE([usertmpfs],
    [AS_HELP_STRING([--disable-usertmpfs], [disable tmpfs as regular user])])
AS_IF([test "x$enable_usertmpfs" != "xno"], [
	HAVE_USERTMPFS="-DHAVE_USERTMPFS"
])

HAVE_MAN="no"
AC_SUBST([HAVE_MAN])
AC_ARG_ENABLE([man],
    [AS_HELP_STRING([--disable-man], [disable man pages])])
AS_IF([test "x$enable_man" != "xno"], [
	HAVE_MAN="-DHAVE_MAN"
	AS_IF([test "x$GAWK" = "x"], [AC_MSG_ERROR([*** gawk not found ***])])
])

HAVE_PRIVATE_HOME=""
AC_SUBST([HAVE_PRIVATE_HOME])
AC_ARG_ENABLE([private-home],
    [AS_HELP_STRING([--disable-private-home], [disable private home feature])])
AS_IF([test "x$enable_private_home" != "xno"], [
	HAVE_PRIVATE_HOME="-DHAVE_PRIVATE_HOME"
])

HAVE_PRIVATE_LIB=""
AC_SUBST([HAVE_PRIVATE_LIB])
AC_ARG_ENABLE([private-lib],
    [AS_HELP_STRING([--disable-private-lib], [disable private lib feature])])
AS_IF([test "x$enable_private_lib" = "xyes"], [
	HAVE_PRIVATE_LIB="-DHAVE_PRIVATE_LIB"
])

HAVE_CHROOT=""
AC_SUBST([HAVE_CHROOT])
AC_ARG_ENABLE([chroot],
    [AS_HELP_STRING([--disable-chroot], [disable chroot])])
AS_IF([test "x$enable_chroot" != "xno"], [
	HAVE_CHROOT="-DHAVE_CHROOT"
])

HAVE_GLOBALCFG=""
AC_SUBST([HAVE_GLOBALCFG])
AC_ARG_ENABLE([globalcfg],
    [AS_HELP_STRING([--disable-globalcfg],
        [if the global config file firejail.config is not present, continue the program using defaults])])
AS_IF([test "x$enable_globalcfg" != "xno"], [
	HAVE_GLOBALCFG="-DHAVE_GLOBALCFG"
])

HAVE_NETWORK=""
AC_SUBST([HAVE_NETWORK])
AC_ARG_ENABLE([network],
    [AS_HELP_STRING([--disable-network], [disable network])])
AS_IF([test "x$enable_network" != "xno"], [
	HAVE_NETWORK="-DHAVE_NETWORK"
])

HAVE_USERNS=""
AC_SUBST([HAVE_USERNS])
AC_ARG_ENABLE([userns],
    [AS_HELP_STRING([--disable-userns], [disable user namespace])])
AS_IF([test "x$enable_userns" != "xno"], [
	HAVE_USERNS="-DHAVE_USERNS"
])

HAVE_X11=""
AC_SUBST([HAVE_X11])
AC_ARG_ENABLE([x11],
    [AS_HELP_STRING([--disable-x11], [disable X11 sandboxing support])])
AS_IF([test "x$enable_x11" != "xno"], [
	HAVE_X11="-DHAVE_X11"
])

HAVE_FILE_TRANSFER=""
AC_SUBST([HAVE_FILE_TRANSFER])
AC_ARG_ENABLE([file-transfer],
    [AS_HELP_STRING([--disable-file-transfer], [disable file transfer])])
AS_IF([test "x$enable_file_transfer" != "xno"], [
	HAVE_FILE_TRANSFER="-DHAVE_FILE_TRANSFER"
])

HAVE_SUID=""
AC_SUBST([HAVE_SUID])
AC_ARG_ENABLE([suid],
    [AS_HELP_STRING([--disable-suid], [install as a non-SUID executable])])
AS_IF([test "x$enable_suid" != "xno"], [
	HAVE_SUID="-DHAVE_SUID"
])

HAVE_FATAL_WARNINGS=""
AC_SUBST([HAVE_FATAL_WARNINGS])
AC_ARG_ENABLE([fatal_warnings],
    [AS_HELP_STRING([--enable-fatal-warnings], [-W -Werror])])
AS_IF([test "x$enable_fatal_warnings" = "xyes"], [
	HAVE_FATAL_WARNINGS="-W -Werror"
])

BUSYBOX_WORKAROUND="no"
AC_SUBST([BUSYBOX_WORKAROUND])
AC_ARG_ENABLE([busybox-workaround],
    [AS_HELP_STRING([--enable-busybox-workaround], [enable busybox workaround])])
AS_IF([test "x$enable_busybox_workaround" = "xyes"], [
	BUSYBOX_WORKAROUND="yes"
])

HAVE_GCOV=""
AC_SUBST([HAVE_GCOV])
AC_ARG_ENABLE([gcov],
    [AS_HELP_STRING([--enable-gcov], [Gcov instrumentation])])
AS_IF([test "x$enable_gcov" = "xyes"], [
	HAVE_GCOV="--coverage -DHAVE_GCOV"
	EXTRA_LDFLAGS="$EXTRA_LDFLAGS --coverage"
	LIBS="$LIBS -lgcov"
])

HAVE_CONTRIB_INSTALL="yes"
AC_SUBST([HAVE_CONTRIB_INSTALL])
AC_ARG_ENABLE([contrib-install],
    [AS_HELP_STRING([--enable-contrib-install], [install contrib scripts])])
AS_IF([test "x$enable_contrib_install" = "xno"], [
	HAVE_CONTRIB_INSTALL="no"
])

HAVE_FORCE_NONEWPRIVS=""
AC_SUBST([HAVE_FORCE_NONEWPRIVS])
AC_ARG_ENABLE([force-nonewprivs],
    [AS_HELP_STRING([--enable-force-nonewprivs], [enable force nonewprivs])])
AS_IF([test "x$enable_force_nonewprivs" = "xyes"], [
	HAVE_FORCE_NONEWPRIVS="-DHAVE_FORCE_NONEWPRIVS"
])

HAVE_ONLY_SYSCFG_PROFILES=""
AC_SUBST([HAVE_ONLY_SYSCFG_PROFILES])
AC_ARG_ENABLE([only-syscfg-profiles],
    [AS_HELP_STRING([--enable-only-syscfg-profiles], [disable profiles in $HOME/.config/firejail])])
AS_IF([test "x$enable_only_syscfg_profiles" = "xyes"], [
	HAVE_ONLY_SYSCFG_PROFILES="-DHAVE_ONLY_SYSCFG_PROFILES"
])

AC_CHECK_HEADER([linux/seccomp.h], [],
    [AC_MSG_ERROR([*** SECCOMP support is not installed (/usr/include/linux/seccomp.h missing) ***])])

# set sysconfdir
if test "$prefix" = /usr; then
	test "$sysconfdir" = '${prefix}/etc' && sysconfdir="/etc"
fi

AC_CONFIG_FILES([config.mk config.sh])
AC_OUTPUT

cat <<EOF

Compile options:
   CC: $CC
   CFLAGS: $CFLAGS
   CPPFLAGS: $CPPFLAGS
   LDFLAGS: $LDFLAGS
   EXTRA_CFLAGS: $EXTRA_CFLAGS
   DEPS_CFLAGS: $DEPS_CFLAGS
   EXTRA_LDFLAGS: $EXTRA_LDFLAGS
   LIBS: $LIBS
   fatal warnings: $HAVE_FATAL_WARNINGS
   gcov instrumentation: $HAVE_GCOV
   install as a SUID executable: $HAVE_SUID
   install contrib scripts: $HAVE_CONTRIB_INSTALL
   prefix: $prefix
   sysconfdir: $sysconfdir
   Spectre compiler patch: $HAVE_SPECTRE

Features:
   allow tmpfs as regular user: $HAVE_USERTMPFS
   always enforce filters: $HAVE_FORCE_NONEWPRIVS
   apparmor: $HAVE_APPARMOR
   busybox workaround: $BUSYBOX_WORKAROUND
   chroot: $HAVE_CHROOT
   DBUS proxy support: $HAVE_DBUSPROXY
   disable user profiles: $HAVE_ONLY_SYSCFG_PROFILES
   enable --output logging: $HAVE_OUTPUT
   file transfer support: $HAVE_FILE_TRANSFER
   global config: $HAVE_GLOBALCFG
   IDS support: $HAVE_IDS
   Landlock support: $HAVE_LANDLOCK
   manpage support: $HAVE_MAN
   network: $HAVE_NETWORK
   overlayfs support: $HAVE_OVERLAYFS
   private home support: $HAVE_PRIVATE_HOME
   private lib support: $HAVE_PRIVATE_LIB
   SELinux labeling support: $HAVE_SELINUX
   user namespace: $HAVE_USERNS
   X11 sandboxing support: $HAVE_X11

EOF

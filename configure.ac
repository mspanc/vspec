dnl ***************************************************************************
dnl Version
dnl ***************************************************************************

m4_define([libvspec_major_version], [0])
m4_define([libvspec_minor_version], [9])
m4_define([libvspec_micro_version], [0])

m4_define([libvspec_version], [libvspec_major_version.libvspec_minor_version.libvspec_micro_version])


dnl ***************************************************************************
dnl Initialization
dnl ***************************************************************************

AC_INIT([libvspec-1.0],
  [libvspec_version],
  [https://github.com/mspanc/vspec/issues],
  [libvspec-1.0],
  [https://github.com/mspanc/vspec])
AM_SILENT_RULES([yes])
AC_CONFIG_HEADERS([config.h])
AM_INIT_AUTOMAKE([1.11 subdir-objects -Wno-portability no-define no-dist-gzip dist-xz])
AC_PROG_CC
AM_PROG_AR
AM_PROG_VALAC([0.26.1])
LT_INIT([win32-dll])
AC_CONFIG_MACRO_DIR([m4])
AM_MAINTAINER_MODE([enable])
AC_PROG_INSTALL
PKG_PROG_PKG_CONFIG(0.16)

ACLOCAL="$ACLOCAL $ACLOCAL_FLAGS"


dnl ***************************************************************************
dnl Check for OS
dnl ***************************************************************************
AC_CANONICAL_HOST

case $host_os in
  *mingw*)
    platform_win32=yes
    native_win32=yes
    platform_darwin=no
    platform_linux=no
    ;;
  *darwin*)
    platform_win32=no
    native_win32=no
    platform_darwin=yes
    platform_linux=no
    ;;
  *linux*)
    platform_win32=no
    native_win32=no
    platform_darwin=no
    platform_linux=yes
    ;;
  pw32* | *cygwin*)
    platform_win32=yes
    native_win32=no
    platform_darwin=no
    platform_linux=no
    ;;
  *)
    AC_MSG_ERROR([OS $host_os is currently not supported])
    ;;
esac
AM_CONDITIONAL(PLATFORM_WIN32, test x"$platform_win32" = "xyes")
AM_CONDITIONAL(NATIVE_WIN32, test x"$native_win32" = "xyes")
AM_CONDITIONAL(PLATFORM_DARWIN, test x"$platform_darwin" = "xyes")
AM_CONDITIONAL(PLATFORM_LINUX, test x"$platform_linux" = "xyes")

dnl ***************************************************************************
dnl Dependencies
dnl ***************************************************************************

GLIB_REQUIRED=2.40.2

pkg_modules="glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED"
AC_SUBST(pkg_modules)
PKG_CHECK_MODULES(LIBVSPEC, [$pkg_modules])


dnl ***************************************************************************
dnl Linking
dnl ***************************************************************************

# Increment on interface add, remove, or change.
LIBVSPEC_LT_CURRENT=1

# Increment on source change. Reset when CURRENT changes.
LIBVSPEC_LT_REVISION=0

# Increment on interface addition. Reset on removal.
LIBVSPEC_LT_AGE=0

LIBVSPEC_LT_VERSION="$LIBVSPEC_LT_CURRENT:$LIBVSPEC_LT_REVISION:$LIBVSPEC_LT_AGE"
LIBVSPEC_LT_LDFLAGS="-version-info $LIBVSPEC_LT_VERSION"

# Check for -Bsymbolic-functions to avoid intra-library PLT jumps
AC_ARG_ENABLE([Bsymbolic],
              [AS_HELP_STRING([--disable-Bsymbolic],
                              [Avoid linking with -Bsymbolic])],
              [],
              [
                saved_LDFLAGS="${LDFLAGS}"
                AC_MSG_CHECKING([for -Bsymbolic-functions linker flag])
                LDFLAGS=-Wl,-Bsymbolic-functions
                AC_TRY_LINK([], [int main (void) { return 0; }],
                            [
                              AC_MSG_RESULT([yes])
                              enable_Bsymbolic=yes
                            ],
                            [
                              AC_MSG_RESULT([no])
                              enable_Bsymbolic=no
                            ])
                LDFLAGS="${saved_LDFLAGS}"
              ])

AS_IF([test "x$enable_Bsymbolic" = "xyes"], [LIBVSPEC_LINK_FLAGS=-Wl[,]-Bsymbolic-functions])
LIBVSPEC_LT_LDFLAGS="$LIBVSPEC_LT_LDFLAGS $LIBVSPEC_LINK_FLAGS"

AC_SUBST(LIBVSPEC_LT_LDFLAGS)


dnl ***************************************************************************
dnl Output
dnl ***************************************************************************

AC_OUTPUT([
Makefile
src/Makefile
src/libvspec-1.0.pc])


dnl ***************************************************************************
dnl Summary
dnl ***************************************************************************

echo ""
echo " libvspec - $VERSION"
echo ""
echo " • Prefix: ${prefix}"
echo ""
echo " • Compiler flags: ${CFLAGS} ${MAINTAINER_CFLAGS}"
echo ""

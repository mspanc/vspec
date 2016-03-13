AC_INIT([libvspec-1.0], [0.9.0], [marcin@saepia.net])
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
dnl ABI versioning
dnl https://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
dnl ***************************************************************************


# Increment on interface add, remove, or change.
LIBVSPEC_CURRENT=1

# Increment on source change. Reset when CURRENT changes.
LIBVSPEC_REVISION=0

# Increment on interface addition. Reset on removal.
LIBVSPEC_AGE=0

AC_SUBST(LIBVSPEC_CURRENT)
AC_SUBST(LIBVSPEC_REVISION)
AC_SUBST(LIBVSPEC_AGE)

dnl ***************************************************************************
dnl Output
dnl ***************************************************************************

AC_OUTPUT([
Makefile
src/Makefile
src/libvspec-1.0.pc])

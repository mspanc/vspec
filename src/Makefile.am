AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(LIBVSPEC_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

lib_LTLIBRARIES = libvspec-1.0.la

libvspec_1_0_la_SOURCES = \
  vspec.vala \
  vspec/spec.vala \
  vspec/report.vala \
  vspec/logger.vala \
	vspec/scope.vala \
	vspec/expectation.vala \
	vspec/match.vala \
	vspec/matcher.vala \
	vspec/matchers/eq.vala \
	vspec/matchers/be.vala \
	vspec/matchers/be_null.vala \
	vspec/matchers/be_true.vala \
	vspec/matchers/be_false.vala \
	vspec/matchers/be_instance_of.vala

libvspec_1_0_la_VALAFLAGS = --library libvspec-1.0 --vapi libvspec-1.0.vapi -H libvspec.h --pkg=glib-2.0 --pkg=gobject-2.0 --enable-experimental --enable-experimental-non-null
libvspec_1_0_la_CFLAGS = $(LIBVSPEC_CFLAGS)
libvspec_1_0_la_LDFLAGS =
libvspec_1_0_la_LIBADD = $(LIBVSPEC_LIBS)


# Library config
if PLATFORM_WIN32
libvspec_1_0_la_LDFLAGS += -no-undefined
endif

if NATIVE_WIN32
libvspec_1_0_la_LDFLAGS += -export-dynamic
endif



# Includes & other dev files
libvspec_1_0includedir = $(includedir)/libvspec-1.0
libvspec_1_0include_HEADERS = \
	libvspec.h

vapidir = $(datadir)/vala/vapi
dist_vapi_DATA = \
	libvspec-1.0.vapi \
	libvspec-1.0.deps

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = \
	libvspec-1.0.pc

EXTRA_DIST = \
	libvspec-1.0.pc.in

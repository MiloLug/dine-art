# this Makefile is not supposed to be edited, but our use for it is somewhat different from google's use for it
# we only care about compiling art and it's dependencies, while the build system is meant to compile the whole AOSP

# we use four underscores for things only used by this Makefile,
# and two underscores for configuration variables we added and which
# we are defining here
# no underscores are used by preexising configuration variables which
# we set here as well

____TOPDIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# override this as appropriate for packaging
____PREFIX ?= /usr/local# sane default
____BINDIR ?= bin# probably fine for most distros
____LIBDIR ?= lib64# arbitrary, definitely should be overridden (though might be correct for 64bit build on some distros)
# dx.jar and it's wrapper script should arguably be in a separate package
# TODO: split into a separate repo and use it from system?
____PREFIX_DX ?= $(____PREFIX)
# bionic translation should probably be in a separate package
# TODO: use weak functions to not have hard dependency on libdl_bio.so in art
____PREFIX_BIO ?= $(____PREFIX)

____INSTALL_BINDIR = $(____PREFIX)/$(____BINDIR)
____INSTALL_LIBDIR = $(____PREFIX)/$(____LIBDIR)

____INSTALL_BINDIR_DX = $(____PREFIX_DX)/$(____BINDIR)
____INSTALL_LIBDIR_DX = $(____PREFIX_DX)/$(____LIBDIR)

____dalvikvm_bin_32 := $(____TOPDIR)/out/host/linux-x86/bin/dalvikvm
____dalvikvm_bin_64 := $(____TOPDIR)/out/host/linux-x86/bin/dalvikvm64

# since the bionic_translation project is currently bundled in the same repo,
# we can't count on it being installed when we're compiling libart.so
# this tells the build system where to look for libdl_bio.so
__BIONIC_TRANSLATION_PATH ?= $(____TOPDIR)/out/bio_build/

# while this *looks* portable, do note that ____LIBDIR is still distro specific
__RPATH_BIN := \$${ORIGIN}/../$(____LIBDIR)/art/
__RPATH_LIB := \$${ORIGIN}

# FIXME: make the build system use javac from here as well
# NOTE: java 1.8 is known to work, latest java is known to *not* work
ANDROID_JAVA_HOME ?= /usr/lib64/jvm/java-1.8.0/
# Jack compiler was google's first attempt at a solution for desugaring Java 8 and newer bytecode into bytecode compatible with older dex file formats.
# Thankfully, google realized that this was a bad idea, and in a typical google fashion, axed the project.
# They experimented with other approaches, but currently (2022) the way to do this is to use d8/r8 instead of dx;
# d8/r8 is technically supposed to build standalone, unlike most of google's stuff, but it requires depot tools,
# and would be a PITA to convert to something sane that can be packaged
#
# The libcore we're currently using is still Java 7, so we luckily don't need to worry about any of this (yet?)
ANDROID_COMPILE_WITH_JACK := false
# build only for one architecture at a time, like any sane build system does
# note that this is localy overwritten in some places, but in all the places where they seemed to do something the overrides were removed
LOCAL_MULTILIB := none
# only the gcc build was cleaned up and tested to work; if you want to build with clang,
# rather than just setting this to false you should probably make the gcc path generic to both
# compilers (bonus points for pruning dead Makefile code)
WITHOUT_CLANG := true
# no idea what this is, but it's not present in our somewhat lean source tree and it's clearly not needed
WITHOUT_LIBCOMPILER_RT := true

default: ____art_all

# arguably this should be split into a separate repo at some point
# we can provide weakly linked versions of symbols from libdl_bio which just call system versions
# this way when libdl_bio is not installed, art will still work as long as no bionic-linked libs
# need to be loaded
____bionic_translation_all:
	cd bionic_translation && \
	mkdir -p ../out/bio_build || true  && \
	meson --prefix=${____PREFIX_BIO} ../out/bio_build && \
	ninja -C ../out/bio_build

# libart links against libdl_bio.so
art: ____bionic_translation_all

____art_all: dalvikvm art dex2oat libjavacore libcore core-libart-hostdex apachehttp-hostdex apache-xml-hostdex hamcrest-hostdex core-junit-hostdex bouncycastle-hostdex wolfssljni-hostdex okhttp-hostdex

____bionic_translation_install:
	cd out/bio_build && \
	meson install

install: ____bionic_translation_install
# this is a JNI library, so it belongs next to it's java counterpart
# TODO: libwolfssljni.so from distro wolfssl package should presumably work, so assuming it's packaged for use with OpenJDK, we could just symlink it here
	install -Dt $(____INSTALL_LIBDIR)/java/dex/art/natives/ $(____TOPDIR)/out/host/linux-x86/lib64/libjavacore.so \
	                                                        $(____TOPDIR)/out/host/linux-x86/lib64/libwolfssljni.so
#
# these are mostly internal libs which there's no point in versioning because they don't have any kind of stable ABI - so we just shove them in art/ namespace
# even the libunwind is actually a fork of libunwind 1.1 with added stuff that will likely never be upstreamed, especially since google stopped using libunwind
# TODO: an exception to this is libvixl, which absolutely should be packaged by your distribution, but it's most likely not, so we didn't yeet the bundled one yet
# (fingers crossed that when we do yeet it, we don't find out that it has tons of ugly patches like libunwind)
	install -Dt $(____INSTALL_LIBDIR)/art/ $(____TOPDIR)/out/host/linux-x86/lib64/libjavacore.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libart-compiler.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libart.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libbacktrace.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libbase.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libcutils.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/liblog.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libnativebridge.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libnativehelper.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libsigchain.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libunwind.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libutils.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libvixl.so \
	                                       $(____TOPDIR)/out/host/linux-x86/lib64/libziparchive-host.so
#
# self-explanatory; it's possible that we might want to ship (an edited version of) the wrapper shell script as well, although the translation layer doesn't even need the dalvikvm(64) elf
# note: `test -f` should install the 32bit binary when it's not a symlink to the 64 bit one
	test -f $(____dalvikvm_bin_32) && install -Dt $(____INSTALL_BINDIR) $(____dalvikvm_bin_32) || true
	test -f $(____dalvikvm_bin_64) && install -Dt $(____INSTALL_BINDIR) $(____dalvikvm_bin_64) || true
	install -Dt $(____INSTALL_BINDIR) $(____TOPDIR)/out/host/linux-x86/bin/dex2oat
# packaging note: this should arguably be it's own package (together with out/host/linux-x86/framework/dx.jar)
	install -Dt $(____INSTALL_BINDIR_DX) $(____TOPDIR)/out/host/linux-x86/bin/dx
#
# the dexed libraries (TODO: install the core library in non-dexed format as well, instead of carrying it in translation layer just to link against it?)
# packaging note: these are architecture-independent
	install -Dt $(____INSTALL_LIBDIR)/java/dex/art/ $(____TOPDIR)/out/host/linux-x86/framework/apachehttp-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/apache-xml-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/bouncycastle-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/core-junit-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/core-libart-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/hamcrest-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/okhttp-hostdex.jar \
	                                                $(____TOPDIR)/out/host/linux-x86/framework/wolfssljni-hostdex.jar
#
# packaging note: this should arguably be it's own package (together with out/host/linux-x86/bin/dx)
	install -Dt $(____INSTALL_LIBDIR_DX)/java/ $(____TOPDIR)/out/host/linux-x86/framework/dx.jar

### DO NOT EDIT THIS FILE ###
include build/core/main.mk
### DO NOT EDIT THIS FILE ###

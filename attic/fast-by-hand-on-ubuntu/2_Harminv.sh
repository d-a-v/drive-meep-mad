#!/bin/bash
git clone https://github.com/NanoComp/harminv.git
cd harminv/

./autogen.sh --with-blas=openblas --prefix=$INSTALL_DIR --enable-shared LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}"

make

make install

###Libraries have been installed in:
###   /mnt/c/WSL/Homebrew/lib
###
###If you ever happen to want to link against installed libraries
###in a given directory, LIBDIR, you must either use libtool, and
###specify the full pathname of the library, or use the '-LLIBDIR'
###flag during linking and do at least one of the following:
###   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
###     during execution
###   - add LIBDIR to the 'LD_RUN_PATH' environment variable
###     during linking
###   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
###   - have your system administrator add LIBDIR to '/etc/ld.so.conf'
###
###See any operating system documentation about shared libraries for
###more information, such as the ld(1) and ld.so(8) manual pages.
###
#libtool --finish /usr/local/lib  


#./configure --help
#######OUTPUT  :
##`configure' configures harminv 1.4.1 to adapt to many kinds of systems.
##
##Usage: ./configure [OPTION]... [VAR=VALUE]...
##
##To assign environment variables (e.g., CC, CFLAGS...), specify them as
##VAR=VALUE.  See below for descriptions of some of the useful variables.
##
##Defaults for the options are specified in brackets.
##
##Configuration:
##  -h, --help              display this help and exit
##      --help=short        display options specific to this package
##      --help=recursive    display the short help of all the included packages
##  -V, --version           display version information and exit
##  -q, --quiet, --silent   do not print `checking ...' messages
##      --cache-file=FILE   cache test results in FILE [disabled]
##  -C, --config-cache      alias for `--cache-file=config.cache'
##  -n, --no-create         do not create output files
##      --srcdir=DIR        find the sources in DIR [configure dir or `..']
##
##Installation directories:
##  --prefix=PREFIX         install architecture-independent files in PREFIX
##                          [/usr/local]
##  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
##                          [PREFIX]
##
##By default, `make install' will install all the files in
##`/usr/local/bin', `/usr/local/lib' etc.  You can specify
##an installation prefix other than `/usr/local' using `--prefix',
##for instance `--prefix=$HOME'.
##
##For better control, use the options below.
##
##Fine tuning of the installation directories:
##  --bindir=DIR            user executables [EPREFIX/bin]
##  --sbindir=DIR           system admin executables [EPREFIX/sbin]
##  --libexecdir=DIR        program executables [EPREFIX/libexec]
##  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
##  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
##  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
##  --runstatedir=DIR       modifiable per-process data [LOCALSTATEDIR/run]
##  --libdir=DIR            object code libraries [EPREFIX/lib]
##  --includedir=DIR        C header files [PREFIX/include]
##  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
##  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
##  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
##  --infodir=DIR           info documentation [DATAROOTDIR/info]
##  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
##  --mandir=DIR            man documentation [DATAROOTDIR/man]
##  --docdir=DIR            documentation root [DATAROOTDIR/doc/harminv]
##  --htmldir=DIR           html documentation [DOCDIR]
##  --dvidir=DIR            dvi documentation [DOCDIR]
##  --pdfdir=DIR            pdf documentation [DOCDIR]
##  --psdir=DIR             ps documentation [DOCDIR]
##
##Program names:
##  --program-prefix=PREFIX            prepend PREFIX to installed program names
##  --program-suffix=SUFFIX            append SUFFIX to installed program names
##  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names
##
##System types:
##  --build=BUILD     configure for building on BUILD [guessed]
##  --host=HOST       cross-compile to build programs to run on HOST [BUILD]
##
##Optional Features:
##  --disable-option-checking  ignore unrecognized --enable/--with options
##  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
##  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
##  --enable-silent-rules   less verbose build output (undo: "make V=1")
##  --disable-silent-rules  verbose build output (undo: "make V=0")
##  --enable-maintainer-mode
##                          enable make rules and dependencies not useful (and
##                          sometimes confusing) to the casual installer
##  --enable-shared[=PKGS]  build shared libraries [default=no]
##  --enable-debug,compile for debugging
##
##  --enable-dependency-tracking
##                          do not reject slow dependency extractors
##  --disable-dependency-tracking
##                          speeds up one-time build
##  --enable-static[=PKGS]  build static libraries [default=yes]
##  --enable-fast-install[=PKGS]
##                          optimize for fast installation [default=yes]
##  --disable-libtool-lock  avoid locking (might break parallel builds)
##
##Optional Packages:
##  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
##  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
##  --with-cxx=<dir>        force use of C++ and complex<double>
##  --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
##                          both]
##  --with-aix-soname=aix|svr4|both
##                          shared library versioning (aka "SONAME") variant to
##                          provide on AIX, [default=aix].
##  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
##  --with-sysroot[=DIR]    Search for dependent libraries within DIR (or the
##                          compiler's sysroot if not specified).
##  --with-blas=<lib>       use BLAS library <lib>
##  --with-lapack=<lib>     use LAPACK library <lib>
##
##Some influential environment variables:
##  CC          C compiler command
##  CFLAGS      C compiler flags
##  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
##              nonstandard directory <lib dir>
##  LIBS        libraries to pass to the linker, e.g. -l<library>
##  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
##              you have headers in a nonstandard directory <include dir>
##  F77         Fortran 77 compiler command
##  FFLAGS      Fortran 77 compiler flags
##  CPP         C preprocessor
##  CXX         C++ compiler command
##  CXXFLAGS    C++ compiler flags
##  LT_SYS_LIBRARY_PATH
##              User-defined run-time library search path.
##  CXXCPP      C++ preprocessor
##
##Use these variables to override the choices made by `configure' or to help
##it to find libraries and programs with nonstandard names/locations.
##
##Report bugs to <stevenj@alum.mit.edu>.


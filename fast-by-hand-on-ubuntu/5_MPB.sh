#!/bin/bash

git clone https://github.com/NanoComp/mpb.git

set -e # scipt stops on error

cd mpb/
sh autogen.sh \
	--enable-shared\
	--with-hermitian-eps \
	--with-blas=openblas \
	--with-libctl=$INSTALL_DIR/share/libctl \
	--prefix=$INSTALL_DIR \
	--enable-shared \
	CC=mpicc LDFLAGS="${MY_LDFLAGS}" \
	LDFLAGS="${MY_LDFLAGS}" \
	CPPFLAGS="${MY_CPPFLAGS}"

make 
make install

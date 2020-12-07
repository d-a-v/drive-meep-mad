#!/bin/bash

git clone https://github.com/NanoComp/meep.git
cd meep/
sh autogen.sh \
	--enable-shared \
	--with-mpi \
	--with-openmp \
	--with-blas=openblas \
	--with-libctl=$INSTALL_DIR/share/libctl \
	--prefix=$INSTALL_DIR\
	CC=mpicc \
	PYTHON=python3 \
	LDFLAGS="${MY_LDFLAGS}" \
	CPPFLAGS="${MY_CPPFLAGS}"


make
make install

 
## Entering directory '/mnt/c/WSL/meep/python'
##mv /mnt/c/WSL/Homebrew/lib/python3.6/site-packages/meep/mpb/mpb.py /mnt/c/WSL/Homebrew/lib/python3.6/site-packages/meep/mpb/__init__.py
##
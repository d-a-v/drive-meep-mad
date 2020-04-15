#!/bin/bash

git clone https://github.com/NanoComp/h5utils.git
cd h5utils/
sh autogen.sh CC=mpicc LDFLAGS="${MY_LDFLAGS}" CPPFLAGS="${MY_CPPFLAGS}" --prefix=$INSTALL_DIR
make
make install

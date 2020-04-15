#!/bin/bash
export BASE_DIR=/opt/fastmeep
export INSTALL_DIR=$BASE_DIR/softs/
export RPATH_FLAGS="-Wl,-rpath,/usr/local/lib:/usr/lib/x86_64-linux-gnu/hdf5/openmpi"
export MY_LDFLAGS="-L/$INSTALL_DIR/lib -L/usr/lib/x86_64-linux-gnu/hdf5/openmpi $RPATH_FLAGS"
export MY_CPPFLAGS="-I/$INSTALL_DIR/include -I/usr/include/hdf5/openmpi"
export PATH="$INSTALL_DIR/bin:$PATH"
export HDF5_MPI="ON"

#### seront à ajouter dans le .bashrc ou le .login
export LD_LIBRARY_PATH=$INSTALL_DIR/lib
export PYTHONPATH=$INSTALL_DIR/lib/python3.6/site-packages/


echo "exports done"


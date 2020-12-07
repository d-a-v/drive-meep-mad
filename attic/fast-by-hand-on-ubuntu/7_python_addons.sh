#!/bin/bash
cd $COMPILE_DIR


pip3 install --user --no-cache-dir mpi4py
#pip3 install --user --no-binary=h5py h5py
pip3 install --user h5py
pip3 install --user matplotlib>3.0.0

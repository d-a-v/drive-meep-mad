#!/bin/bash

apt list --installed > installed_packages.txt

function is_lib_installed {
	test=`grep "$1/" installed_packages.txt`
	if [ -n "$test" ]; then
			echo "installed $1"
		else
			echo "$(tput setaf 1) missing $1 $(tput sgr0)"
	fi
}

is_lib_installed build-essential
is_lib_installed  gfortran              
is_lib_installed  libgmp-dev            
is_lib_installed  swig                  
is_lib_installed  libgsl-dev            
is_lib_installed  autoconf              
is_lib_installed  pkg-config            
is_lib_installed  libpng-dev          
is_lib_installed  git                   
is_lib_installed  guile-2.0-dev         
is_lib_installed  libfftw3-dev          
is_lib_installed  libhdf5-openmpi-dev   
is_lib_installed  hdf5-tools            
is_lib_installed  libpython3-dev      
is_lib_installed  python3-numpy         
is_lib_installed  python3-scipy         
is_lib_installed  python3-pip           
is_lib_installed  ffmpeg                
#is_lib_installed libblas-dev
#is_lib_installed liblapack-dev

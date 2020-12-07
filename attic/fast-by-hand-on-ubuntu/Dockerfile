FROM ubuntu:18.04
RUN apt-get update && apt-get -y install apt-utils sudo build-essential gfortran libgmp-dev swig libgsl-dev autoconf pkg-config libpng-dev git guile-2.0-dev libfftw3-dev libhdf5-openmpi-dev hdf5-tools libpython3-dev python3-numpy python3-scipy python3-pip ffmpeg libopenblas-dev

ADD 00_usefull_env.sh ./

ADD 1_get_missing_packages.sh ./
RUN . ./00_usefull_env.sh; ./1_get_missing_packages.sh
ADD 2_Harminv.sh ./
RUN . ./00_usefull_env.sh; ./2_Harminv.sh
ADD 3_guile.sh ./
RUN . ./00_usefull_env.sh; ./3_guile.sh
ADD 4_h5utils.sh ./
RUN . ./00_usefull_env.sh; ./4_h5utils.sh
ADD 5_MPB.sh ./
RUN . ./00_usefull_env.sh; ./5_MPB.sh
ADD 6_libGDSII.sh ./
RUN . ./00_usefull_env.sh; ./6_libGDSII.sh
ADD 7_python_addons.sh ./
RUN . ./00_usefull_env.sh; ./7_python_addons.sh
ADD 8_MEEP.sh ./
RUN . ./00_usefull_env.sh; ./8_MEEP.sh

RUN echo "source /MEEP_setup_env.sh" >> /root/.bashrc
ADD MPB_test.py *.sh ./

CMD bash

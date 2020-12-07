#!/bin/bash -x

pythonmainv=3.9
pythonsubv=0

#module purge

##module load hdf5/1.10.2-intelmpi
module load hdf5/1.10.2-seq
module load fftw/3.3.8

#NO module load python/3.6.3  # 3.6.8: libfabric.so issue

export MKL_DYNAMIC=FALSE

# included LD_PRELOAD for CentOS is needed otherwise
# this error message is displayed when starting python:
#   python3 /tmp/test-meep.py
#   ** failed to load python MPI module (mpi4py)
#   ** /usr/local/lib64/python3.6/site-packages/mpi4py/MPI.cpython-36m-x86_64-linux-gnu.so: undefined symbol: ompi_mpi_logical8

help ()
{
    cat << EOF

$1: Download MEEP sources and dependencies, build, and install

Usage: $1 [options]
EOF
    sed -ne 's,^[ \t]*\(-[^ \t]*\))[^#]*#[ \t]*\(.*\),    \1 \2,p' "$1"
    echo ""
    echo "After installation, environment file 'meep-env.sh' is created in destination path."
    echo ""
    exit 1
}

gitclone ()
{
    repo=${1##*/}
    name=${repo%%.*}
    echo $repo $name
    if [ -d $name ]; then
        ( cd $name; git pull; )
    else
        [ -z "$2" ] || branch="-b $2"
        git clone --depth=100 $1 $branch
    fi
}


autogensh ()
{
    #LIB64="${DESTDIR}/lib"
    LIB64="${DESTDIR}/usr/lib64"
    #LLP="${LD_LIBRARY_PATH}:${LIB64}"

    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${LIB64}"
    export F77="${FC}"
    export FC
    export CC
    export CXX
    export LDFLAGS
    export CFLAGS
    export CPPFLAGS
    
    set -x
    sh autogen.sh PKG_CONFIG_PATH="${PKG_CONFIG_PATH}" RPATH_FLAGS="${RPATH_FLAGS}" \
        PYTHON=${python} \
        --enable-shared --prefix="${DESTDIR}/usr" --libdir=${LIB64} \
        --with-libctl=${DESTDIR}/usr/share/libctl \
        "$@"
    set -x
}

showenv()
{
    echo module load hdf5/1.10.2-seq \;
    echo module load fftw/3.3.8 \;
    echo export MKL_DYNAMIC=FALSE \;
    echo export LD_PRELOAD+=:${MKLROOT}/../../../itac/2018.2.020/intel64/bin/rtlib/libintlc.so.5:${MKLROOT}/../../../compilers_and_libraries_2018.2.199/linux/compiler/lib/intel64_lin/libirc.so \;

    echo export PATH=${DESTDIR}/usr/bin:\${PATH} \;
    echo export LD_LIBRARY_PATH=${DESTDIR}/usr/lib:\${LD_LIBRARY_PATH} \;
    echo export PYTHONPATH=${DESTDIR}/usr/lib/${python}/site-packages:\${PYTHONPATH} \;
    echo export LD_LIBRARY_PATH=${DESTDIR}/usr/lib64:${DESTDIR}/usr/lib:\${LD_LIBRARY_PATH} \;
    echo export HDF5_USE_FILE_LOCKING=FALSE \;
}

showenv2run()
{
    echo pip install numpy mpi4py h5py \;
}

yumInstallLocal() # args: prefix pkg [pkg [...]]
{
(
    root=${1}
    shift
    cd ${root}

    mkdir -p rpm

    while [ ! -z "$1" ]; do
        $(which yumdownloader) --destdir rpm --resolve "$1"
        rpm2cpio rpm/${1}*x86_64.rpm | cpio -id

        for i in usr/lib64/pkgconfig/*.pc; do
            if [ -r "${i}.RPM" ]; then
                echo "'$i' already converted"
            elif [ -r "$i" ]; then
                sed -i.RPM "s,=/usr,=${root}/usr,g" "$i"
            fi
        done
        shift
    done
)
}

installPythonFromSources() # args: major.minor release root
{
(
    mainv=$1
    subv=$2
    root=$(cd $3; pwd)
    shift 3

    v=${mainv}.${subv}
    mkdir -p ${root}/usr/src
    cd ${root}/usr/src

    #export CC=icc
    #export CXX=icpc

    if [ "$1" = "-f" ] || [ ! -f Python-${v}/python ]; then
    (
        yumInstallLocal ${root} openssl openssl-devel bzip2 bzip2-devel libffi libffi-devel
        [ ! -f Python-${v}.tgz ] && curl -O https://www.python.org/ftp/python/${v}/Python-${v}.tgz
        tar xfz Python-${v}.tgz
        cd Python-${v}
        export PATH="${root}/bin:${PATH}"
        export CFLAGS="-I${root}/include"
        export LDFLAGS="-L${root}/lib -L${root}/lib64"
        ./configure --enable-optimizations --prefix=${root}/usr
    )
    else
        echo "python-${v} already built"
    fi

    if [ "$1" = "-f" ] || [ ! -f ${root}/usr/bin/python${mainv} ]; then
    (
        cd Python-${v}
        make altinstall
    )
    else
        echo "python-${v} already installed in ${root}"
    fi

    ln -sf python$mainv ${root}/usr/bin/python
    ln -sf pip$mainv ${root}/usr/bin/pip
)
}


buildinstall=true
bashrc=false
BLAS="mkl"
unset DESTDIR
#PYSUDO="sudo -E -H"
python=python${pythonmainv}
PYINSTALL="${python} -m pip install --user"
LDFLAGS="${LDFLAGS} -L$(pwd)/tweaks "

while [ ! -z "$1" ]; do
    case "$1" in
        -h)         # help
            help "$0"
            ;;
        -d)         # <installdir>  (mandatory)
            DESTDIR="$2"
            shift
            ;;
        -s)         # use 'sudo' for 'make install'
            SUDO=sudo
            ;;
        -S)         # source directory (default: <installdir>/src)
            SRCDIR="$2"
            shift
            ;;
        -c)         # skip build+install
            buildinstall=false
            ;;
        --bashrc)
            bashrc=true;; # undocumented internal to store env in ~/.bashrc
        *)
            echo "'$1' ?"
            help "$0"
            ;;
    esac
    shift
done

$buildinstall && [ -z "${DESTDIR}" ] && { echo "-d option is missing" ; help "$0"; }
$buildinstall && [ -z "${BLAS}" ] && { echo "blas taste is missing" ; help "$0"; }

[ -z "$SRCDIR" ] && SRCDIR=${DESTDIR}/usr/src

set -e

echo PATH=${PATH}

#[ -z "$CFLAGS" ] && CFLAGS="-O3 -mtune=native"

eval $(showenv)

export PKG_CONFIG_PATH="${DESTDIR}/usr/lib64/pkgconfig"
export LDFLAGS="${LDFLAGS} -L${MKLROOT}/lib/intel64 -lmkl_rt"
export LDFLAGS="${LDFLAGS} -L${DESTDIR}/usr/lib -L${DESTDIR}/usr/lib64"
export CFLAGS="${CFLAGS} -I${DESTDIR}/usr/include"
export CPPFLAGS="${CFLAGS}"
export PATH=${DESTDIR}/usr/bin:${PATH}

if $buildinstall; then

    mkdir -p ${SRCDIR} ${DESTDIR}
    showenv > ${DESTDIR}/meep-env.sh
    showenv2run >> ${DESTDIR}/meep-env.sh

    mkdir -p ${DESTDIR}/usr/lib64
    ln -s lib64 ${DESTDIR}/usr/lib

    (
        yumInstallLocal ${DESTDIR} guile guile-devel gc gc-devel
        installPythonFromSources ${pythonmainv} ${pythonsubv} ${DESTDIR}
    )

    export  CC="icc"
    export CXX="icpc"
    export  FC="ifort"

if true; then

    cd ${SRCDIR}
    gitclone https://github.com/NanoComp/libctl.git
    cd libctl/
    autogensh --with-blas=${BLAS}
    make V=1 && $SUDO make install

    cd ${SRCDIR}
    gitclone https://github.com/NanoComp/harminv.git
    cd harminv/
    autogensh --with-blas=${BLAS}
    make V=1 && $SUDO make install

    cd ${SRCDIR}
    gitclone https://github.com/NanoComp/h5utils.git
    cd h5utils/
    autogensh
    make V=1 && $SUDO make install

    cd ${SRCDIR}
    gitclone https://github.com/NanoComp/mpb.git
    cd mpb/
    autogensh --with-hermitian-eps --with-blas=${BLAS}
    make V=1 && $SUDO make install


    cd ${SRCDIR}
    gitclone https://github.com/HomerReid/libGDSII.git
    cd libGDSII/
    autogensh
    make V=1 && $SUDO make install

fi

    export  CC="$(which mpicc)  -cc=icc"
    export CXX="$(which mpicxx) -cxx=icpc"
    export  FC="$(which mpifc)  -fc=ifort"
    export LDFLAGS="${LDFLAGS} -lmkl_blacs_intelmpi_ilp64"

    ${PYSUDO} ${PYINSTALL} --no-cache-dir mpi4py
    #${PYSUDO} ${PYINSTALL} --no-binary=h5py h5py
    ${PYSUDO} ${PYINSTALL} h5py
    ${PYSUDO} ${PYINSTALL} matplotlib>3.0.0

    cd ${SRCDIR}
    gitclone https://github.com/NanoComp/meep.git
    cd meep/
    #git checkout ed440099c4b5392d325cb6537129f2b160049498 # 1.16
    #git checkout 1.16.1
    autogensh --with-mpi --with-openmp --with-blas=${BLAS}
    make V=1 && $SUDO make install

    # all done

fi # buildinstall

########
# test

test=/tmp/test-meep.py

cat << EOF > $test
import meep as mp
cell = mp.Vector3(16,8,0)
print(cell)
exit()
EOF

echo "------------ ENV (commands)"
$bashrc && { showenv >> ~/.bashrc; }
echo "------------ ENV (result)"
echo export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}
echo export PYTHONPATH=${PYTHONPATH}
echo export LD_PRELOAD=${LD_PRELOAD}
echo "------------ $test"
cat $test
echo "------------ EXEC ${python} $test"
. ${DESTDIR}/meep-env.sh
${python} $test

#!/bin/sh

version=$1
origdir=`dirname $0`

if [ $# -lt 2 ] ; then
  CLHEP="-DGEANT4_USE_SYSTEM_CLHEP=OFF"
else
  CLHEP="-DGEANT4_USE_SYSTEM_CLHEP=ON -DCLHEP_LIBRARIES=/usr/local/clhep/clhep-$2/lib -DCLHEP_INCLUDE_DIRS=/usr/local/clhep/clhep-$2/include/CLHEP"
fi

echo "Downloading geant4-v${version}.tar.gz..."
until test -f geant4-v${version}.tar.gz
do wget https://gitlab.cern.ch/geant4/geant4/-/archive/v${version}/geant4-v${version}.tar.gz
done

echo "Unpacking geant4-v${version}.tar.gz..."
until test -d geant4-v${version}
do tar -zxvf geant4-v${version}.tar.gz
done

mkdir -p geant4-v${version}-build
cd geant4-v${version}-build

echo "Configuring geant4-v${version}..."
prefix=/usr/local/geant4/geant4-v${version}
cmake \
 -DCMAKE_INSTALL_PREFIX=${prefix} \
 -DCMAKE_BUILD_TYPE=RelWithDebInfo \
 -DBUILD_SHARED_LIBS=ON \
 -DBUILD_STATIC_LIBS=OFF \
 -DGEANT4_BUILD_EXAMPLES=OFF \
 -DGEANT4_BUILD_MULTITHREADED=ON \
 -DGEANT4_INSTALL_DATA=ON \
 -DGEANT4_USE_G3TOG4=ON \
 -DGEANT4_USE_GDML=ON \
 -DGEANT4_USE_QT=ON \
 -DGEANT4_USE_XM=ON \
 -DGEANT4_USE_OPENGL_X11=ON \
 -DGEANT4_USE_RAYTRACER_X11=ON \
 -DGEANT4_USE_SYSTEM_EXPAT=ON \
 -DGEANT4_USE_SYSTEM_ZLIB=OFF \
 "$CLHEP" \
 ../geant4-v${version}

j=`cat /proc/cpuinfo | grep processor | wc -l`
echo "Make will use $j parallel jobs."

echo "Building geant${version}..."
make -j $j -k

echo "Installing geant${version}..."
make -j $j install

cd "${origdir}"

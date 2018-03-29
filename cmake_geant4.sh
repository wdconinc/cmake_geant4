#!/bin/sh

version=$1
origdir=`dirname $0`

if [ $# -lt 2 ] ; then
  CLHEP="-DGEANT4_USE_SYSTEM_CLHEP=OFF"
else
  CLHEP="-DGEANT4_USE_SYSTEM_CLHEP=ON -DCLHEP_LIBRARIES=/usr/local/clhep/clhep-$2/lib -DCLHEP_INCLUDE_DIRS=/usr/local/clhep/clhep-$2/include/CLHEP"
fi

echo "Downloading geant${version}.tar.gz..."
until test -f geant${version}.tar.gz
do wget http://geant4.cern.ch/support/source/geant${version}.tar.gz
done

echo "Unpacking geant${version}.tar.gz..."
until test -d geant${version}
do tar -zxvf geant${version}.tar.gz
done

mkdir -p geant${version}-build
cd geant${version}-build

echo "Configuring geant${version}..."
prefix=/usr/local/geant4/geant${version}
cmake \
 -DCMAKE_INSTALL_PREFIX=${prefix} \
 -DCMAKE_BUILD_TYPE=RelWithDebInfo \
 -DBUILD_SHARED_LIBS=ON \
 -DBUILD_STATIC_LIBS=ON \
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
 ../geant${version}

j=`cat /proc/cpuinfo | grep processor | wc -l`
echo "Make will use $j parallel jobs."

echo "Building geant${version}..."
make -j $j -k

echo "Installing geant${version}..."
make -j $j install

cd "${origdir}"

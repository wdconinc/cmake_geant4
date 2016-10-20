#!/bin/sh

version=$1
origdir=`dirname $0`

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
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
 -DCMAKE_INSTALL_PREFIX=/usr/local/geant4/geant${version} \
 -DGEANT4_USE_GDML=ON \
 -DGEANT4_INSTALL_DATA=ON \
 -DGEANT4_USE_QT=ON \
 -DGEANT4_USE_RAYTRACER_X11=ON \
 -DGEANT4_BUILD_MULTITHREADED=OFF \
 -DXERCESC_LIBRARY=/usr/lib/x86_64-linux-gnu/libxerces-c.so \
 ../geant${version}

j=`cat /proc/cpuinfo | grep processor | wc -l`
echo "Make will use $j parallel jobs."

echo "Building geant${version}..."
make -j $j -k

echo "Installing geant${version}..."
make -j $j install

cd "${origdir}"

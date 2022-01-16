#! /bin/bash

set -e

cd /root

CMAKE_VERSION="3.22.1"
main_name=cmake-${CMAKE_VERSION}

wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${main_name}.tar.gz
tar -zxvf ${main_name}.tar.gz

cd ${main_name}

./bootstrap
make -j8
make install

cd /root

rm -rf ${main_name} ${main_name}.tar.gz

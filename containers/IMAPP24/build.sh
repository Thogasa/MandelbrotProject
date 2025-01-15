#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )


mkdir "${parent_path}/MandelbrotProject/build"
cmake -S "${parent_path}/MandelbrotProject/" -B "${parent_path}/MandelbrotProject/build" -DCMAKE_BUILD_TYPE=Release
cd "${parent_path}/MandelbrotProject/build"
make


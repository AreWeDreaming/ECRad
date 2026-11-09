#!/bin/bash
# F90/FC/F77 come from the conda compiler activation
export COMPILER=GNU
make clean # Just for good measure
cd fitpack
make clean
make
cd ../odepack
make clean
make
cd ../
make lib F2PY_wrapper DEBUG=True COMPILER=GNU
make lib F2PY_wrapper COMPILER=GNU
make lib F2PY_wrapper OPEN_MP=True COMPILER=GNU
make lib F2PY_wrapper OPEN_MP=True DEBUG=True COMPILER=GNU
$PYTHON -m pip install --no-deps --no-build-isolation .

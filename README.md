# ECRad
Toolkit for the forward modeling of electron cyclotron emission measurements. Comes with three modules: ECRad_core, the Fortran90 radiation transport model, ECRad_GUI a graphical interfance for the model and ECRad_PyLib which provides an API to call ECRad from other codes.
## Installation
This repository must be cloned with the --recurse-submodules flag,
Make sure you have added your computers public ssh key to your github account.
git clone --recurse-submodules git@github.com:AreWeDreaming/ECRad.git
Note that the --recurse-submodules flag also needs to be used when pulling
git pull --recurse-submodules origin master

Please execute `build.sh` for bash or `build.tcsh` for tcsh in the `ECRad_core` subfolder.
## Running ECRad
A detailed documentation is still a work in progress. To run ECRad please execute `.launch_ECRad_GUI.sh` for bash or `.launch_ECRad_GUI.tcsh` for tcsh to start the GUI.
## License
[MIT](https://choosealicense.com/licenses/mit/)

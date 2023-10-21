# ECRad
Toolkit for the forward modeling of electron cyclotron emission measurements. Comes with three modules: ECRad_core, the Fortran90 radiation transport model, ECRad_GUI a graphical interfance for the model and ECRad_PyLib which provides an API to call ECRad from other codes.

1. [ECRad](#ecrad)
   1. [Installation](#installation)
      1. [IMAS support](#imas-support)
   2. [Using ECRad](#using-ecrad)
      1. [Starting the GUI](#starting-the-gui)
      2. [Loading data](#loading-data)
      3. [Configuring ECRad](#configuring-ecrad)
      4. [Running ECRad](#running-ecrad)
      5. [Inspecting the outputs](#inspecting-the-outputs)
   3. [License](#license)


## Installation
ECRad is distributed through `conda/mamba`. Please check [these instructions](https://github.com/conda-forge/miniforge) on how to install `miniforge`.

It is recommended to install through `mamba` over `conda` because `mamba` has much improved environment solving. ECRad is available for `python 3.10` and `python 3.11`.

With `mamba` installing `ECRad` is as simple as:

For `python 3.10`
```
mamba create -n ECRad python=3.10 ecrad_gui
```
For `python 3.11`
```
mamba create -n ECRad python=3.11 ecrad_gui
```
and then activate the environment via:
```
conda activate ECRad
```

### IMAS support
Even when installed through `mamba` `ECRad` can use a system `IMAS` installation. To do so load `IMAS` first then activate the `ECRad` `cpmda` environment. If the `IMAS` python library directory is in your `$PYTHONPATH` and you have matched the major version of `python` between the two environments (i.e. both use `python 3.10`) then it should work.

## Using ECRad
Unfortunately there is no detailed user-guide at the moment. Below there is a rough sketch of a typical workflow. Some information can also be found in [this article](https://www.sciencedirect.com/science/article/abs/pii/S0010465520300291). If you don't have access to it please contact me and I will send you a pre-print.

The easiest way to use ECRad is through its GUI. It also has APIs for `python`, `Fortran` and `Muscle3` applications/workflows. These are more difficult to use, and they need to be treated on a use-case basis.

### Starting the GUI
Once the `conda/mamba` environment has been activated (see [Installation](#installation)) simply type
```
ecrad_gui
```
into your shell. The GUI should show up.

### Loading data
ECRad supports `IMAS` and `OMAS` for IO. You can also manually prepare data, [please check out this example code for more info](https://github.com/AreWeDreaming/ECRad_GUI/blob/master/src/ecrad_gui/ECRad_GUI_Scenario_Maker.py).

The following fields in the `IMAS` schema are mandatory:
```
equilibrium:
  - equilibrium.time_slice.:.profiles_2d.grid.0.dim1
  - equilibrium.time_slice.:.profiles_2d.grid.0.dim2
  - equilibrium.time_slice.:.profiles_2d.grid.0.psi
  - equilibrium.time_slice.:.profiles_2d.grid.0.Br
  - equilibrium.time_slice.:.profiles_2d.grid.0.Bt
  - equilibrium.time_slice.:.profiles_2d.grid.0.Bz
  - equilibrium.time_slice.:.global_quantities.psi_axis
  - equilibrium.time_slice.:.global_quantities.psi_boundary

wall:
  - wall.description_2d.0.limiter.unit.0.outline.R
  - wall.description_2d.0.limiter.unit.0.outline.z

ece:
  - ece.channel.:.frequency.time
  - ece.channel.:.frequency.data
  - ece.channel.:.if_bandwidth
  - ece.line_of_sight.first_point.r
  - ece.line_of_sight.first_point.phi
  - ece.line_of_sight.first_point.z
  - ece.line_of_sight.second_point.r
  - ece.line_of_sight.second_point.phi
  - ece.line_of_sight.second_point.z
```

If all of this data is present in the form of an `ODS` or `IDS` you can load it by going to through the corresponding `Load from IMAS database` and `Load from OMAS` buttons. You can also load scenarios from previous `ECRad` runs via the `Load ECRadScenario` button.

Note that for `OMAS` loading from the machines database is only supported for `DIII-D`.

Once you load from either `OMAS` or `IMAS` you must pick whether the time base from `equilibrium` or `core_profiles` is to be used. Ideally these time bases should be identical, otherwise nearest neighbor interpolation will be used.

Once the scenario data has been loaded, the diagnostic data has to be loaded by selecting the `diagnostic configuration` tab. Here you can either manually enter diagnostic data, or again load from `IMAS` or `OMAS`. Again you can also load previous results via the `Load launch from ECrad result/scenario` button.

Once both plasma scenario and launch configuration is set you need to move on to the `ECRad` configuration tab.

### Configuring ECRad
Please refer to the [CPC article for details on the options]((https://www.sciencedirect.com/science/article/abs/pii/S0010465520300291)). 
It is not 
In principle there is only few options you will need to touch:
- `Working dir` This is where any results will be stored
- `Scratch dir` Set this to the same folder as `Working dir`. It is intended to be used in conjunction with `SLURM` submission but this feature is not maintained at the moment.
- For most cases you want `Extra output` is checked.
- For most cases you want to check `Parallel` and uncheck `debug` and `Batch`
- For number of cores please pick a number appropriate for your machine. It should be at most the number of physical number of cores.
- Neither `walltime` nor `memory` matter if batch submission is not used.

### Running ECRad
Once everything is set simply press the `Run ECRad` button up top and ECRad should start. Note that the output from ECRad is not parsed to the log box due to technical limitations, and the ECRad output will appear in the shell you used to start the GUI.

### Inspecting the outputs
The GUI will save all outputs to a `NetCDF` file for further processing. You can inspect the entire content of this file in the `Misc. Plot` tab. 

To plot something you first select what should be plotted on the `y` axis of the plot. For this first you select a group of quantities:
- `Trad` refers to quantities that are line integrated such as the radiation Temperatures or the optical depth.
- `resonance` This field is usually used for `x` axis quantities. It includes cold/warm resonances in various coordinates
- `ray` These are quantities that are used somewhere in the calculation of `Trad`. Of particular interest are `R` and `z` for plotting the line of sight.
- `BPD` This tab is the birthplace distribution. It breaks down how each point on the line of sight contributes to the measurement.
- `weights` The only quantity of general interest here is `mode_frac` which indicates the `X-mode` content of the measurement.

Once a `y group` has been selected the `x-group` and `y quantity` can be chosen. One of the most classic combinations would be:
- `y group`
  - `Trad`
- `y quantity`
  - `Trad`
- `x group`
  - `resonance`
- `x quantity`
  - `rhop_cold`

In addition it is also possible to plot some of the scenario information using the box `Add scenario quantity to plot`. It uses both y-axes and combines radiation and electron temperatures. So for the above selections it is possible to select 
- `Te`
- `ne`
by clicking the corresponding fields while holding the shift key.

For `R-z` plots it can be useful to select `rhop` from this box, which then shows the flux surfaces as contours. In this case it is worthwhile to also check the `Equal aspect ratio` box.

## License
[MIT](https://choosealicense.com/licenses/mit/)

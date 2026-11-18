# Notes for Claude

## Releasing
The release procedure is documented in `README.md` ("Releasing"); follow it. Practical details:

- Tags are bare version numbers (`1.0.32`), placed on the "Release x.y.z" commit that bumps `__version__`
  in `src/<package>/__init__.py` of the submodule (the file has no trailing newline). Push `master` and the tag together.
- `conda` is not on `PATH`; use `$HOME/miniforge3/bin/conda run -n ECRad ...`. The `ECRad` env has `rattler-build`.
- The recipe pulls the source from the GitHub tag, so push the tag before building.
- Delete stale `output/linux-64/<package>-*.conda` before building, otherwise the upload glob picks up old versions.
- A build is good when the log shows `all tests passed!` for every python variant (see `variants.yaml`).
  The overlinking warnings for libgomp/openblas are expected.
- `rattler-build upload anaconda` needs an anaconda.org API key, which isn't available to Claude.
  Hand the upload command to the user rather than looking for credentials.
- `recipes/update_pins.sh` only raises lower bounds (`>=`). Run it (and rebuild the dependents) only when
  ecrad_pylib/ecrad_gui actually need the new core; otherwise a core-only release leaves the dependents alone.
- After the release, commit the recipe change and the submodule pointer together in this repo and push.

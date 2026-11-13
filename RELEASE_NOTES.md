# RELEASE NOTES

### Version 2.0.0 (Nov 17, 2026)

**Breaking changes**
- Basilisk updated from release v2.10.2 (`87cb4116`) to release
  [v2.12.2](https://github.com/AVSLab/basilisk/releases/tag/v2.12.2)
  (`dad700e8af0c0219c5cf0f46666f792c0e7af8a0`).
- Base image updated from Ubuntu 22.04 to Ubuntu 26.04 LTS.
- Python updated from 3.10 to 3.14.
- Python dependencies are now installed from a pinned `requirements.txt`
  by default.

> To reproduce the results in the companion paper, use
> [v1.0.0](https://github.com/abruan-aerospace/basilisk-docker/releases/tag/v1.0.0).
> Numerical results from v2.0.0 may differ from the published figures.

**Added**
- Pinned `requirements.txt` for a reproducible Python environment.
- `DEPS` build argument: `pinned` (default) installs exact versions;
  `ranges` installs Basilisk's own version ranges for the pinned commit.
- Build-time check that `BASILISK_COMMIT` matches `BASILISK_TAG`.
- Post-build validation: `pip check`, Basilisk import test, and
  build-tool version checks.
- OCI image labels recording the image version, Basilisk tag, Basilisk
  commit, and dependency mode.
- CI workflow: Dockerfile linting (hadolint), shell script linting
  (ShellCheck), Compose validation, and a full image build with a smoke
  test that runs Basilisk's `scenarioBasicOrbit.py` example.
- README badges: CI status, release, license, project status, Basilisk
  version, Python version, arXiv, software DOI, and workshop DOI.
- Vizard visualization of the Earth-orbit scenario in the README.

**Changed**
- Dockerfile: system packages pinned to exact versions; `apt` replaced
  with `apt-get` and `--no-install-recommends`; Python environment
  isolated in a virtual environment at `/opt/venv`; OCI label keys
  follow standard conventions.
- README restructured: version and reproducibility table, mapping of
  scenarios to paper sections, dependency and CI documentation,
  separate software and paper citations, and conference workshop
  reference in Development History.
- Scenario scripts: header comments updated; simulation code is
  unchanged from v1.0.0.

**Removed**
- Repository structure tree from the README.


### Version 1.0.0 (May 11, 2026)

Initial release, accompanying the paper
[*Basilisk and Docker for Reproducible GN&C Simulation: A Workflow Reference*](https://arxiv.org/abs/2605.12443).
This is the reference environment for reproducing the paper's results
(DOI [10.5281/zenodo.20132421](https://doi.org/10.5281/zenodo.20132421)).

**Environment**
- Basilisk v2.10.2 (`87cb4116e09694ddf6587f61a7f4196d2e720c43`)
- Ubuntu 22.04, Python 3.10

**Scripts**

| Script | Paper |
|---|---|
| `module_variable_lifecycle.py` | §4.3 |
| `message_connection_recording.py` | §4.4 |
| `scenario_spacecraft.py` | §5.2 |
| `scenario_earth_orbit.py` | §5.3, §5.5 |
| `scenario_sun_earth.py` | §5.4 |
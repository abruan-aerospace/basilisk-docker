# RELEASE NOTES

### Version 2.0.0 (Nov 17, 2026)

**Breaking changes**
- Basilisk updated from commit `87cb4116` to release
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
  (ShellCheck), and <DESCRIBE_TESTS>.
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
- Scenario scripts are unchanged from v1.0.0.

**Removed**
- Repository structure tree from the README.


### Version 1.0.0 (May 11, 2026)
- Initial release of the Basilisk-Docker infrastructure.
- Initial release accompanying the paper: "Basilisk and Docker for Reproducible GN&C Simulation: A Workflow Reference"
- Docker environment pinned to Basilisk commit 87cb4116
- Scripts included:
    - module_variable_lifecycle.py — Section 4.3
    - message_connection_recording.py — Section 4.4
    - scenario_spacecraft.py — Section 5.2
    - scenario_earth_orbit.py — Section 5.3 + 5.5
    - scenario_sun_earth.py — Section 5.4
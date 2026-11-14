# Basilisk Docker

**A reproducible, version-pinned build environment for Basilisk GN&C simulation.**

[![CI](https://img.shields.io/github/actions/workflow/status/abruan-aerospace/basilisk-docker/ci.yml?branch=main&label=CI&logo=githubactions&logoColor=white)](https://github.com/abruan-aerospace/basilisk-docker/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/abruan-aerospace/basilisk-docker?sort=semver&logo=github)](https://github.com/abruan-aerospace/basilisk-docker/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://www.repostatus.org/#active)

[![Basilisk](https://img.shields.io/badge/Basilisk-v2.12.2-orange)](https://github.com/AVSLab/basilisk/releases/tag/v2.12.2)
[![Python](https://img.shields.io/badge/Python-3.14-3776AB?logo=python&logoColor=white)](https://www.python.org/)

[![arXiv](https://img.shields.io/badge/arXiv-2605.12443-b31b1b?logo=arxiv&logoColor=white)](https://arxiv.org/abs/2605.12443)
[![Software](https://img.shields.io/badge/Software-10.5281%2Fzenodo.20132420-blue?logo=zenodo&logoColor=white)](https://doi.org/10.5281/zenodo.20132420)
[![Workshop](https://img.shields.io/badge/Workshop-10.5281%2Fzenodo.15008785-blue?logo=zenodo&logoColor=white)](https://doi.org/10.5281/zenodo.15008785)

A containerized, version-pinned build environment for the [Basilisk](https://hanspeterschaub.info/basilisk) astrodynamics simulation framework. The image captures the complete toolchain (OS, compilers, Python dependencies, and a fixed Basilisk commit), so GN&C simulations run in a consistent, version-controlled environment on any host that runs Docker.

<p align="center">
  <img src="docs/images/viz-earth-orbit.png" alt="Vizard visualization of the Earth-orbit scenario" width="720">
</p>

## Contents

- [Why This Exists](#why-this-exists)
- [Versions and Reproducibility](#versions-and-reproducibility)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Example Scenarios](#example-scenarios)
- [Python Dependencies](#python-dependencies)
- [Continuous Integration](#continuous-integration)
- [Operational Notes](#operational-notes)
- [Development History](#development-history)
- [Citation](#citation)
- [Acknowledgments](#acknowledgments)

---

## Why This Exists

Building Basilisk from source depends on the host: compiler versions, SWIG, CMake, Python ABI, and transitive package versions all affect whether a build succeeds, and occasionally whether simulation output matches. On a team, that drift appears as results that differ from machine to machine and as onboarding that takes days.

This repository removes that variable. Every collaborator, CI runner, and reviewer works in the same image, built from the same Basilisk commit with the same pinned dependencies.

## Versions and Reproducibility

| Release | Basilisk | Purpose |
|---|---|---|
| **v2.0.0** (current) | v2.12.2 ([`dad700e`](https://github.com/AVSLab/basilisk/commit/dad700e8af0c0219c5cf0f46666f792c0e7af8a0)) | Current Basilisk, pinned dependencies, CI-tested build |
| [v1.0.0](https://github.com/abruan-aerospace/basilisk-docker/releases/tag/v1.0.0) | v2.10.2 ([`87cb411`](https://github.com/AVSLab/basilisk/commit/87cb4116e09694ddf6587f61a7f4196d2e720c43)) | Exact environment used for the companion paper |

> **Reproducing the paper:** check out `v1.0.0`
> (DOI [10.5281/zenodo.20132421](https://doi.org/10.5281/zenodo.20132421)).
> Later releases track newer Basilisk versions, and their numerical results may
> differ from the published figures.
>
> ```bash
> git clone --branch v1.0.0 https://github.com/abruan-aerospace/basilisk-docker.git
> ```

Release history and change details are in [RELEASE_NOTES.md](RELEASE_NOTES.md).

## Requirements

| Component | Notes |
|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop) or Docker Engine with Compose v2 | Required |
| [VS Code](https://code.visualstudio.com/) with the Dev Containers extension | Recommended for in-container development |
| [Vizard](https://hanspeterschaub.info/basilisk/Vizard/Vizard.html) | Optional, for 3D playback of scenario output |
| ~30 GB free disk space | ~13 GB image plus build cache during the first build |

## Quick Start

```bash
git clone https://github.com/abruan-aerospace/basilisk-docker.git
cd basilisk-docker
./docker/build-basilisk.sh
```

Or, equivalently, with Docker Compose:

```bash
docker compose -f docker/docker-compose.yml up -d --build
```

Open a shell in the running container:

```bash
docker exec -it basilisk_gnc bash
```

The first build compiles Basilisk from source and takes approximately 15–20 minutes. Subsequent builds reuse cached layers and are much faster.

## Example Scenarios

The included scripts demonstrate core Basilisk workflow concepts. Each one maps to a section of the [companion paper](https://arxiv.org/abs/2605.12443).

| Script | Demonstrates | Paper |
|---|---|---|
| `module_variable_lifecycle.py` | Module variable initialization, update, and reset behavior | §4.3 |
| `message_connection_recording.py` | Message connection and data recording | §4.4 |
| `scenario_spacecraft.py` | Spacecraft dynamics setup | §5.2 |
| `scenario_earth_orbit.py` | Earth-orbit propagation | §5.3, §5.5 |
| `scenario_sun_earth.py` | Sun–Earth multi-body environment | §5.4 |

Run a scenario from inside the container:

```bash
cd examples
python scenario_earth_orbit.py
```

Scenarios with Vizard support write a `.bin` file to a `_VizFiles/` folder next to the script. Open that file in Vizard for 3D visualization.

> Scenarios that use planetary ephemerides need the `de430.bsp` SPICE kernel.
> It is not distributed with this repository because of its size. Section 3 of
> the companion paper gives retrieval instructions.

## Python Dependencies

By default, the image installs the exact versions in `requirements.txt`, so every build resolves the same Python environment.

To install Basilisk's own version ranges for the pinned commit instead:

```bash
docker compose -f docker/docker-compose.yml build --build-arg DEPS=ranges
```

Use this mode to test against newer compatible packages. Results may differ from the pinned environment.

**Outside Docker:** `pip install -r requirements.txt` recreates the environment in a virtual environment on Python `3.14`. For other Python versions, use the requirements files from the Basilisk repository at the matching commit. In both cases, Basilisk itself must still be built from source.

## Continuous Integration

Every push and pull request runs:

- **Dockerfile lint:** [hadolint](https://github.com/hadolint/hadolint)
- **Shell script lint:** [ShellCheck](https://www.shellcheck.net/)
- **Compose validation:** `docker compose config`
- **Build and smoke test:** builds the full image on `linux/amd64` and runs
  Basilisk's `scenarioBasicOrbit.py` example

See [`.github/workflows/ci.yml`](.github/workflows/ci.yml) for details.

## Operational Notes

- **Base image:** Ubuntu 26.04 LTS, Python 3.14
- **Dockerfile:** [`docker/Dockerfile`](docker/Dockerfile)
- **Container name:** `basilisk_gnc`
- **Platform:** Builds natively on `linux/amd64` and `linux/arm64` (including Apple Silicon). Vizard runs on the host, not in the container.

## Development History

The Docker configuration originated in simulation environment work begun in 2021. The workflow was formalized and presented as a workshop at the 46th Rocky Mountain AAS GN&C Conference in February 2024 ([10.5281/zenodo.15008785](https://doi.org/10.5281/zenodo.15008785)), and is documented in the companion paper.

## Citation

If you use this software, please cite the paper below. To reference a specific software version, also cite the Zenodo DOI.

**Paper:**

```bibtex
@article{gupta2026basiliskpaper,
  author        = {Gupta, Anubhav},
  title         = {Basilisk and Docker for Reproducible {GN\&C} Simulation: A Workflow Reference},
  journal       = {arXiv preprint},
  year          = {2026},
  eprint        = {2605.12443},
  archivePrefix = {arXiv},
  primaryClass  = {eess.SY},
  doi           = {10.48550/arXiv.2605.12443}
}
```

**Software:**

```bibtex
@software{gupta2026basilisk,
  author    = {Gupta, Anubhav},
  title     = {Basilisk and Docker for Reproducible {GN\&C} Simulation},
  year      = {2026},
  version   = {2.0.0},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.20132420},
  url       = {https://github.com/abruan-aerospace/basilisk-docker}
}
```

## Acknowledgments

The author thanks Dr. Hanspeter Schaub and the Autonomous Vehicle Systems (AVS) Laboratory at the University of Colorado Boulder for developing and maintaining Basilisk.

## License

Released under the [MIT License](LICENSE).
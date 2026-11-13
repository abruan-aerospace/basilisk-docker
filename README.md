# basilisk-docker

[![CI Build](https://github.com/abruan-aerospace/basilisk-docker/actions/workflows/ci.yml/badge.svg)](https://github.com/abruan-aerospace/basilisk-docker/actions/workflows/ci.yml)
[![GitHub release](https://img.shields.io/github/v/release/abruan-aerospace/basilisk-docker?include_prereleases&sort=semver)](https://github.com/abruan-aerospace/basilisk-docker/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](https://www.repostatus.org/#active)

[![Basilisk](https://img.shields.io/badge/Basilisk-v2.12.2-orange)](https://github.com/AVSLab/basilisk/releases/tag/v2.12.2)
[![Python](https://img.shields.io/badge/Python-3.14%2B-3776AB?logo=python&logoColor=white)](https://www.python.org/)

[![arXiv](https://img.shields.io/badge/arXiv-2605.12443-b31b1b.svg)](https://arxiv.org/abs/2605.12443)
[![Software DOI](https://img.shields.io/badge/Software_DOI-10.5281%2Fzenodo.20132420-blue)](https://doi.org/10.5281/zenodo.20132420)
[![Workshop DOI](https://img.shields.io/badge/Workshop_DOI-10.5281%2Fzenodo.15008785-blue)](https://doi.org/10.5281/zenodo.15008785)

A containerized, version-pinned build environment for the
[Basilisk](https://hanspeterschaub.info/basilisk) astrodynamics simulation
framework. The image captures the complete toolchain (OS, compilers, Python
dependencies, and a fixed Basilisk commit), so GN&C simulations produce the
same results on any host that runs Docker.

<p align="center">
  <img src="docs/images/viz-earth-orbit.png" alt="Vizard visualization of the Earth-orbit scenario" width="720">
</p>

## Contents

- [Why This Exists](#why-this-exists)
- [Versions and Reproducibility](#versions-and-reproducibility)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Python Dependencies](#python-dependencies)
- [Operational Notes](#operational-notes)
- [Development History](#development-history)
- [Citation](#citation)
- [Acknowledgments](#acknowledgments)

---

## Why This Exists

Building Basilisk from source depends on the host: compiler versions, SWIG,
CMake, Python ABI, and transitive package versions all affect whether a build
succeeds, and occasionally whether simulation output matches. On a team, that
drift appears as results that differ from machine to machine and as onboarding
that takes days.

This repository removes that variable. Every collaborator, CI runner, and
reviewer works in the same image, built from the same Basilisk commit with the
same pinned dependencies.

## Versions and Reproducibility

| Release | Basilisk | Purpose |
|---|---|---|
| **v2.0.0** (current) | v2.12.2 ([`dad700e`](https://github.com/AVSLab/basilisk/commit/dad700e8af0c0219c5cf0f46666f792c0e7af8a0)) | Current Basilisk, pinned dependencies, CI-tested scenarios |
| [v1.0.0](https://github.com/abruan-aerospace/basilisk-docker/releases/tag/v1.0.0) | [`87cb4116`](https://github.com/AVSLab/basilisk/commit/87cb4116) | Exact environment used for the companion paper |

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
./build-basilisk.sh
```

Or manually:

```bash
docker compose up -d --build
```

To open a terminal inside the running container:

```bash
docker exec -it basilisk_gnc bash
```

## Python Dependencies

By default the image installs the exact package versions listed in
`requirements.txt`, so every build gets the same Python environment.

To use Basilisk's own version ranges for the pinned `BASILISK_COMMIT` instead:

```bash
docker compose build --build-arg DEPS=ranges
```

Outside Docker, `pip install -r requirements.txt` recreates the same
environment in a virtual environment (tested with Python 3.14). For other
Python versions, use the requirements files in the Basilisk repository at
the matching commit. Basilisk itself must still be built from source.


## Notes
- The Dockerfile is located at `docker/Dockerfile`
- Compatible with Ubuntu 26.04 and Python 3.14
- First-time build takes approximately 15-20 minutes
- Subsequent rebuilds use Docker layer caching 
  and are significantly faster
- The `de430.bsp` SPICE ephemeris file is not included 
  due to size; see Section 3 of the companion paper 
  for retrieval instructions
- Running each scenario generates a .bin file in the same
  directory, which can be opened in Vizard for 3D visualization.

## Development History
The Docker configuration in this repository originated from simulation environment work begun in 2021. The workflow was formalized and presented as a workshop at the 46th Rocky Mountain AAS GN&C Conference in February 2024 (Zenodo: 10.5281/zenodo.15008785), and is documented in the companion paper listed above.

## Citation
If you use this software infrastructure or workflow in your research, please cite the appropriate reference:

**Software:**
```bibtex
@software{gupta2026basilisk,
  author       = {Gupta, Anubhav},
  title        = {Basilisk and Docker for Reproducible {GN\&C} Simulation},
  year         = {2026},
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.20132421},
  url          = {https://github.com/abruan-aerospace/basilisk-docker}
}
```

**Paper:**
```bibtex
@article{gupta2026basiliskpaper,
  author       = {Gupta, Anubhav},
  title        = {Basilisk and Docker for Reproducible {GN\&C} Simulation: A Workflow Reference},
  journal      = {arXiv preprint},
  year         = {2026},
  eprint       = {2605.12443},
  archivePrefix = {arXiv},
  primaryClass = {eess.SY},
  doi          = {10.48550/arXiv.2605.12443}
}
```

## Acknowledgments

The author thanks Dr. Hanspeter Schaub and the AVS 
Laboratory at the University of Colorado Boulder for 
developing Basilisk.

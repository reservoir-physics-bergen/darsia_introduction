# darsia_introduction
Introduction module to interactive DarSIA analysis

Example data:
https://filesender.sikt.no/?s=download&token=167043a9-4078-40ca-8568-b3ab9cb3b8e3

## Prerequisites

- **git** (with submodule support), e.g. [Git for Windows](https://git-scm.com/downloads).
- **uv** (Python package and project manager), see the [uv installation guide](https://docs.astral.sh/uv/getting-started/installation/):
  - Windows: `winget install --id astral-sh.uv`
  - macOS / Linux: `curl -LsSf https://astral.sh/uv/install.sh | sh`
- Internet access (to fetch the repository, submodule, Python and dependencies).
- A desktop environment (the DarSIA GUI is based on Qt/PySide6).
- Disk space for the example data (download via the link above and unpack locally).

A system Python is *not* required; uv installs Python 3.13 itself.

## Setup with uv (Python 3.13)

1. Clone the repository and initialize submodules:

   ```bash
   git clone https://github.com/reservoir-physics-bergen/darsia_introduction.git
   cd darsia_introduction
   git submodule update --init --recursive
   ```

2. Install and use Python 3.13 with uv:

   ```bash
   uv python install 3.13
   uv sync
   ```

   `darsia` is sourced from the local git submodule at `external/darsia` and installed
   by uv during `uv sync`, including its GUI. Optionally, add a desktop / Start-menu
   launcher for the GUI:

   ```bash
   uv run darsia-install-desktop
   ```

3. Launch the DarSIA GUI:

   ```bash
   uv run darsia
   ```

   For more information on the GUI, see the [DarSIA README](external/darsia/README.md#gui).

## Updating DarSIA

```bash
git submodule update --remote external/darsia
uv sync
```

## Example data

Download the example data from the link above and unpack it into a local folder, e.g.
`data/`. The data is not version controlled.

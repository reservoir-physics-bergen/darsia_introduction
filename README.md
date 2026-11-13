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
   git clone --recurse-submodules https://github.com/reservoir-physics-bergen/darsia_introduction.git
   cd darsia_introduction
   ```

   If you cloned without `--recurse-submodules`, run
   `git submodule update --init --recursive` afterwards.

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

## Updating

To get the newest version of this repository together with the DarSIA version it is
set up for, run the update script from the repository folder:

- Windows (PowerShell): `.\update.ps1`
- macOS / Linux: `./update.sh`

It pulls this repository, checks out the matching `darsia` submodule, refreshes the
Python environment and prints the DarSIA version in use. Afterwards, `uv run darsia`
starts the updated GUI. The script never changes or commits anything you wrote yourself.

The script is equivalent to:

```bash
git pull
git submodule update --init --recursive
uv sync
```

### Troubleshooting

- **PowerShell refuses to run the script:** run
  `powershell -ExecutionPolicy Bypass -File .\update.ps1`.
- **`external/darsia` is empty after cloning:** run the update script, or
  `git submodule update --init --recursive`.
- **`git pull` fails because of local changes:** commit or stash your changes, then run
  the script again.
- **`git status` shows `modified: external/darsia`:** the submodule is not at the
  version this repository pins. Run the update script to reset it.

### For maintainers: bump the pinned DarSIA version

```bash
.\update.ps1 -Latest      # Windows; on macOS / Linux: ./update.sh --latest
uv run darsia             # check that everything still works
git add external/darsia uv.lock
git commit -m "Update darsia submodule"
git push
```

Users then receive the new DarSIA version the next time they run the update script.

## Example data

Download the example data from the link above and unpack it into a local folder, e.g.
`data/`. The data is not version controlled.

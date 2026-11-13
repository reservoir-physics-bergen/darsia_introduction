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

## Example data and getting started

### What is in this repository

Two example experiments are included. Each folder holds the DarSIA config (a `.toml`
file) and a `meta/` folder with the small metadata files DarSIA needs. The raw images
are **not** part of this repository; they come from the download link at the top.

| Folder    | Experiment       | Config            | `meta/` contents |
|-----------|------------------|-------------------|------------------|
| `co2/`    | CO2 injection (b049) | `co2/b049.toml`   | `imaging.csv`, `injection.csv`, `pt.csv`, `depth.csv`, `facies.csv`, `segmentation.png` |
| `tracer/` | Tracer experiment (pt) | `tracer/pt.toml` | same as above |

The `meta/` files are the imaging, injection, pressure/temperature, depth and facies
protocols plus the labeled segmentation image of the rig.

### 1. Get the images

Download the images from the link at the top and unpack them somewhere on your machine,
for example:

```
<some folder>/data/
├── co2/      <- images of the CO2 experiment
└── tracer/   <- images of the tracer experiment
```

The location is up to you. `data/` inside this repository is ignored by git, so it is a
fine choice if you want to keep everything together.

### 2. Start the GUI and open a config

```bash
uv run darsia
```

In the GUI, open the config file of the experiment you want to explore:
`co2/b049.toml` or `tracer/pt.toml`. If DarSIA reports missing files, the paths in the
config still need to be adapted (next step).

### 3. Adapt the paths to your machine

The shipped configs contain absolute paths from the original author's computer
(`C:/Users/.../data/ff/...`), which will not exist on yours. Either edit the `.toml` file
in a text editor, or change the fields in the GUI's settings panel. Update these entries
(in the `.toml` file they appear in the sections shown):

| Section / key | Set it to |
|---|---|
| `[data]` `folders` | the folder with your copy of the images |
| `[data]` `baseline` | the baseline image (first image) inside that folder |
| `[data]` `results` | an output folder of your choice (created by the Setup step) |
| `[labeling]` `colored_image` | `meta/segmentation.png` of this experiment |
| `[depth]` `measurements` | `meta/depth.csv` of this experiment |
| `[facies]` `props` | `meta/facies.csv` of this experiment |
| `[protocols]` `injection` | `meta/injection.csv` of this experiment |
| `[protocols]` `pressure_temperature` | `meta/pt.csv` of this experiment |
| `[protocols.imaging]` (key *and* value) | key: the image folder, value: `meta/imaging.csv` |
| `[protocols.imaging_interval_seconds]` (`co2` only) | key: the image folder |

Tips:
- Use forward slashes (`C:/Users/me/data/co2`) or doubled backslashes in the `.toml`.
- Absolute paths are safest. The `meta/` files live in this repository, e.g.
  `<path to this repo>/co2/meta/imaging.csv`.
- Keep the same image folder in `[data] folders` and in `[protocols.imaging]`.
- Keep your edited config private if you do not want to commit machine-specific paths
  (for example, work on a copy such as `co2/b049_local.toml`).

### 4. Run the workflow

With the paths adapted, follow the Setup → Calibration → Analysis steps in the GUI tabs
(see the
[DarSIA workflow docs](external/darsia/src/darsia/presets/workflows/doc/quickstart.md)).
The same steps are available from the command line, e.g.:

```bash
uv run python -m darsia.presets.workflows.user_interface_setup --all --config co2/b049.toml
```

# Pebble Dev Windows Docker Image

A special Docker image for working with the Pebble SDK (for Pebble watches) on Windows.  
Includes Pebble SDK + emulator + debugging tools + Chromium + helper scripts.


## Features

* Runs the Pebble SDK in a container on Windows via WSL2.
* **No need to install a full Linux distribution on WSL** — you can skip adding Ubuntu/Debian/etc.
* Ability to use `pebble` command just like on Linux
* **Working graphical emulator** (`pebble install --emulator ...` command)
* **Working configuration pages via emulator**  (`pebble emu-app-config ...` command), thanks to the built-in Chromium browser.
* **Smart URL handling** — automatic tweaks for proper handling of configuration pages with `data:text/html...` URLs.
* **Debugging support** — includes `gdb-multiarch`, so `pebble gdb ...` command works like a charm.


## How it works

The `pebble.cmd` script provides seamless container management, so you don't need to worry about Docker commands.

When you run `pebble.cmd`, it automatically:
  * Makes up a container name based on the current directory path (your project path), so it's unique for each project, even if you use a single `pebble.cmd` file
  * Creates a new container if one doesn't exist for the current directory, mounts the current directory (project directory) into the container
  * Starts the container if it exists but is stopped
  * Uses the running container to execute `pebble` command, automatically passes all command line arguments to the Pebble SDK inside the container
  * Automatically stops the container if `pebble` command is not used for some time (30 minutes by default)

It also has additional command line arguments:
  * `pebble docker-stop` — stops the container
  * `pebble docker-rm` — removes the container

This design ensures containers don't consume resources when idle, while keeping them ready for immediate use when you're actively developing. Multiple `pebble` command instances can communicate with each other inside the container, so you can run `pebble install --emulator ...` and then `pebble emu-app-config ...` or `pebble gdb ...`.


## 🔧 Prerequisites

Before using this image, please ensure you have the following set up:

### 1. Update WSL to the latest version (must use WSL2)

1. Open PowerShell as Administrator.
2. Run:

   ```powershell
   wsl --update
   wsl --set-default-version 2
   ```

   This updates WSL kernel and sets default version to 2.
3. **Important**: You do *not* need to install any additional Linux distribution if you don’t want to — since for our container usage the Docker Desktop’s internal WSL2 backend is sufficient. ([Docker Documentation][1])

### 2. Install Docker Desktop for Windows and configure it to use WSL2

1. Download and install Docker Desktop from Docker’s official site.
2. During installation or afterwards, open **Settings → General** and enable **“Use the WSL 2 based engine”**. ([Docker Documentation][2])
3. In **Settings → Resources → WSL Integration**, make sure integration is enabled (for the default distro if you have one).
4. Restart Docker Desktop if required.


## Usage

Download a file named `pebble.cmd` on the [GitHub Releases page](https://github.com/ClusterM/pebble-dev-windows/releases).

Place this file either:
* In your project directory (so you can run it locally) or
* In a folder included in your `PATH` (so you can invoke `pebble.cmd` from anywhere).

### Use the `pebble` CLI exactly like on Linux

Examples:
* `pebble build` – compiles your project.
* `pebble install --emulator basalt` – installs the built app into the emulator.
* `pebble install --phone 10.13.14.15` – installs the app to a real Pebble watch connected via phone (use your phone IP).
* `pebble new-project MyWatchApp` – creates new project.


## Support the Developer and the Project

* [GitHub Sponsors](https://github.com/sponsors/ClusterM)
* [Buy Me A Coffee](https://www.buymeacoffee.com/cluster)
* [Sber](https://messenger.online.sberbank.ru/sl/Lnb2OLE4JsyiEhQgC)
* [Donation Alerts](https://www.donationalerts.com/r/clustermeerkat)
* [Boosty](https://boosty.to/cluster)

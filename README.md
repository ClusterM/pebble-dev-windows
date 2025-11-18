# Pebble Dev Windows Docker Image

A special Docker image for working with the Pebble SDK (for Pebble watches) on Windows.  
Includes Pebble SDK + emulator + debugging tools + Chromium + helper scripts.

## ✅ Features

* Runs the Pebble SDK in a container on Windows via WSL2.
* **No need to install a full Linux distribution on WSL** — you can skip adding Ubuntu/Debian/etc. (Docker Desktop handles it) 🐾
* Supports building watch-apps and watch-faces.
* Includes graphical emulator support (via X11/WSLg) and Chromium for the config app.
* Clean volume mount so you work in your project directory.

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

## 🏁 Usage

Once WSL2 + Docker Desktop are ready, you can get started:

### Create a helper script

Download a file named `pebble.cmd`: https://raw.githubusercontent.com/ClusterM/pebble-dev-windows/refs/heads/master/pebble.cmd

Place this file either:

* In your project directory (so you can run it locally) or
* In a folder included in your `PATH` (so you can invoke `pebble.cmd` from anywhere).

### Use the `pebble` CLI exactly like on Linux

Examples:
* `pebble build` – compiles your project.
* `pebble install --emulator basalt` – installs the built app into the emulator.
* `pebble install --phone 10.13.14.15` – installs the app to a real Pebble watch connected via phone (use your phone IP).
* `pebble new-project MyWatchApp` – creates new project.

## 📂 Notes & Tips

* The `-v ./:/app` mount ensures your host project folder is shared into the container at `/app`. All commands are executed inside the container in `/app`.
* The `-v /run/desktop/mnt/host/wslg/.X11-unix:/tmp/.X11-unix` mount allows the GUI emulator (and Chromium) to display via WSLg/X11 on Windows.
* The fact that you **don’t need to install a separate Linux distro** is a big plus — faster, less setup, fewer moving parts.

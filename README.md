# dpkg-BUT-arch (apt-wrapper)

**dpkg-BUT-arch** is a comprehensive Bash-based command-line utility and wrapper layer designed to provide the familiar Debian/Ubuntu `apt` syntax for Arch Linux users. By acting as a logic-driven bridge, it translates standardized `apt` commands into their corresponding `pacman` and `yay` operations, allowing for a seamless transition for developers and system administrators migrating from the Debian ecosystem.

---

## ⚠️ CRITICAL DISCLAIMER & OPERATIONAL SAFETY

### 1. The Learning Curve for New Arch Users
While this tool provides convenience, it is **STRONGLY ADVISED** that beginners do not use this as their primary method of package management. Arch Linux is a rolling-release distribution that requires a fundamental understanding of its native tools. Relying solely on an `apt` wrapper may prevent you from learning how to properly maintain your system, handle `.pacnew` files, or troubleshoot dependency cycles. We recommend using `pacman` and `yay` directly for at least a few weeks before adopting this wrapper.

### 2. Command Severity and Risk Assessment
Users must exercise extreme caution when using this tool, as certain commands are mapped to "aggressive" Arch Linux flags to remain consistent with expected `apt` behavior:
*   **The Purge Command:** When you execute `sudo apt purge [package]`, the wrapper executes `sudo pacman -Rcns [package]`. 
    *   This operation is significantly more powerful than a standard removal. It will recursively remove the target package, its global configuration files, and all dependencies that are not explicitly required by other installed software. 
    *   **Potential Danger:** If you do not carefully review the transaction list before hitting 'Y', you might accidentally remove essential shared libraries or desktop environment components.

---

## 🛠️ IN-DEPTH COMMAND EXPLANATIONS & LOGIC

This wrapper does not simply rename commands; it includes internal logic to determine the best source for your software needs, spanning across Official Repositories and the Arch User Repository (AUR).

### A. Advanced Package Management
*   **`apt install [package_name]`**: 
    The script utilizes a fallback logic system. It first attempts to locate and install the package from the Official Arch Repositories using `pacman`. If the package is not found (exit code non-zero), it immediately initiates a search and build process via `yay` for the **AUR**. This allows you to install software like `google-chrome` or `visual-studio-code-bin` as if they were native packages.
*   **`apt remove [package_name]`**: 
    This command uninstalls specified software. The wrapper is designed to identify whether the package was installed via the official repos or the AUR and handles the removal process accordingly.
*   **`apt purge [package_name]`**: 
    As mentioned in the warning, this is the "Deep Clean" mode. It is designed to leave no trace of the software, removing everything from binaries to system-wide configuration files.
*   **`apt autoremove`**: 
    A maintenance essential. It runs `pacman -Qdtq` to identify "orphans"—packages that were once needed as dependencies but are now useless. It then purges them to keep your disk space optimized.

### B. System Maintenance & Synchronization
*   **`apt update`**: 
    Synchronizes the local package database with the remote mirrors. It ensures your system knows about the latest versions available without actually performing an upgrade.
*   **`apt full-upgrade` / `apt dist-upgrade`**: 
    The most critical commands for a rolling release. These trigger a full system synchronization (`-Syu`). If `yay` is detected on the system, it will prioritize it to ensure that both your official system packages and your AUR-installed software are updated simultaneously.
*   **`apt clean` / `apt autoclean`**: 
    These commands target the `/var/cache/pacman/pkg/` directory. They remove cached `.tar.zst` files to reclaim gigabytes of storage space, especially useful after long periods of system updates.

### C. Information & Diagnostic Tools
*   **`apt search [query]`**: 
    Provides a unified search experience. It queries both the official repositories and the AUR, presenting a combined list of results so you can choose the best version of the software you are looking for.
*   **`apt show [package]`**: 
    Displays verbose metadata. This includes the version number, build date, total install size, and a full list of required dependencies and optional dependencies.
*   **`apt depends` / `rdepends`**: 
    Technical tools for troubleshooting. `depends` shows what a package needs to run, while `rdepends` (Reverse Dependencies) shows which other installed packages will break if you remove the target package.

---

## 📥 INSTALLATION PROCEDURES

### Method 1: The Automated Installer (Recommended)
We provide a streamlined `install.sh` script that handles all technical requirements, including pathing and binary permissions.
```bash
curl -O [https://raw.githubusercontent.com/plopletoyay/dpkg-BUT-arch/main/install.sh](https://raw.githubusercontent.com/plopletoyay/dpkg-BUT-arch/main/install.sh)
sudo bash install.sh

Method 2: Manual Installation (Step-by-Step)

For users who prefer full control over their /usr/local/bin/ directory, you can install the wrapper manually. Please follow these steps precisely:

    Navigate to the apt file within this GitHub repository.

    Copy the entire source code found inside the apt wrapper file.

    Open your terminal and create a new file: nano apt.

    Paste the copied code into this file and save it (Ctrl+O, Enter, Ctrl+X).

    Move the newly created binary to your system's executable path:
    Bash

    sudo mv apt /usr/local/bin/

    Set the mandatory execution permissions to allow the shell to run the script:
    Bash

    sudo chmod +x /usr/local/bin/apt


---

## ⚙️ CUSTOMIZATION & CONFIGURATION

The power of this wrapper lies in its simplicity. Once installed, the primary logic file is located at `/usr/local/bin/apt`. Advanced users are encouraged to open this file to modify specific flags according to their personal preference (for instance, changing the default behavior of the `remove` command).

> [!IMPORTANT]
> **Configuration Documentation:** 
> Please be advised that the internal logic of the script is written for high performance and minimal overhead. Consequently, **there are no descriptive comments within the code** explaining individual functions or variables. You should possess a stable understanding of Bash scripting and `pacman` flags before attempting to modify the core logic.

---

## 🚀 POST-INSTALLATION & USAGE

Once the installation is finalized, you can verify that the wrapper is correctly recognized by your shell environment by invoking the help menu. You can use any of the following commands to view the manual and usage tips:

*   `apt`
*   `apt help`
*   `apt --help`

### Final Technical Note
This project is an **alias and logic wrapper system**. It does not modify your core system****

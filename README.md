# OrcaSlicer Profiles

Custom **filament**, **machine** and **process** profiles for [OrcaSlicer](https://github.com/SoftFever/OrcaSlicer).

## Directory Structure

```
OrcaSlicer-profiles/
├── filament/      # Filament profiles (.json)
├── machine/       # Machine/printer profiles (.json)
├── process/       # Process/print profiles (.json)
├── .gitattributes # Git line-ending normalization
├── setup.ps1      # Windows symlink setup script
└── setup.sh       # Linux/WSL symlink setup script
```

## Usage

Profiles go inside OrcaSlicer's user configuration folder. The easiest way to keep them in sync is to symlink the entire repo as the `default` folder — this way any new subdirectories added to the repo are automatically picked up.

### OrcaSlicer Config Location

| Platform | Path |
|----------|------|
| **Windows** | `%APPDATA%\OrcaSlicer\user\default\` |
| **Linux** | `~/.config/OrcaSlicer/user/default/` |
| **macOS** | `~/Library/Application Support/OrcaSlicer/user/default/` |

### Setup

#### Windows (PowerShell)

Run as Administrator:

```powershell
.\setup.ps1
```

Or manually:

```powershell
# Backup existing default folder first if needed
Move-Item "$env:APPDATA\OrcaSlicer\user\default" "$env:APPDATA\OrcaSlicer\user\default.bak"
New-Item -ItemType SymbolicLink -Path "$env:APPDATA\OrcaSlicer\user\default" -Target "C:\path\to\OrcaSlicer-profiles"
```

> **Note:** Creating symbolic links on Windows requires Administrator privileges (unless Developer Mode is enabled).

#### WSL (Windows Subsystem for Linux)

If using WSL, place the repo in a Windows directory (e.g. `C:\Users\You\OrcaSlicer-profiles\`) and run from WSL:

```bash
./setup.sh
```

Or use the PowerShell script from WSL:

```bash
powershell.exe -File setup.ps1
```

#### Linux / macOS

```bash
./setup.sh
```

### Teardown

To remove the symlinks and revert to normal directories:

**Windows:**
```powershell
.\setup.ps1 --remove
```
Or manually:
```powershell
Remove-Item "$env:APPDATA\OrcaSlicer\user\default"
# Restore backup if you made one:
Move-Item "$env:APPDATA\OrcaSlicer\user\default.bak" "$env:APPDATA\OrcaSlicer\user\default"
```

**Linux / macOS / WSL:**
```bash
./setup.sh --remove
```

## Adding Profiles

1. Create or edit `.json` files in the appropriate directory.
2. Restart OrcaSlicer (or refresh profiles from the UI).

## License

MIT

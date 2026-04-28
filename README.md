# MAC Vendor - PopClip Extension

A PopClip extension that displays vendor (manufacturer) information for MAC addresses.

## Features

- **Vendor name**: Manufacturer company of the MAC address
- **OUI**: MAC prefix (first 3 bytes)
- **Country**: Manufacturer country
- **Address**: Manufacturer address (optional)
- **Block type**: MA-L / MA-M / MA-S (optional)
- **Private flag**: Locally administered address detection (optional)

## Supported MAC formats

- `AA:BB:CC:DD:EE:FF` (colon-separated)
- `AA-BB-CC-DD-EE-FF` (hyphen-separated)
- `AABB.CCDD.EEFF` (Cisco dot notation)

## Installation

### Release (recommended)

Download `MACVendor.popclipextz` from [Releases](https://github.com/scaltinov/popclip-macvendor/releases) and double-click. PopClip will prompt to install.

### From source

```bash
git clone git@github.com:scaltinov/popclip-macvendor.git
cd popclip-macvendor
make install
```

`make install` generates `MACVendor.popclipext` next to the source directory and runs `open` to launch PopClip's install dialog.

## Usage

1. Select a MAC address in any application
2. Click the **MAC** button in the PopClip menu
3. View vendor information in the dialog or PopClip popup

## Options

- **Show MAC address** — default: ON
- **Show vendor name** — default: ON
- **Show OUI (MAC prefix)** — default: ON
- **Show country** — default: ON
- **Show address** — default: OFF
- **Show block type (MA-L/M/S)** — default: OFF
- **Show private/local flag** — default: OFF
- **Copy to clipboard** — default: ON
- **Show dialog** — default: ON

## Requirements

- macOS
- PopClip
- Internet connection ([api.maclookup.app](https://maclookup.app))
- `python3` (bundled with macOS Command Line Tools)

## License

MIT

## Author

Created with [Claude Code](https://claude.com/claude-code)

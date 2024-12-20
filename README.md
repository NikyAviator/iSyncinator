# iOS Device Backup Script

This script allows you to mount an iOS device, copy all photos and videos to a specified folder, and convert images to `.jpg` format using **ImageMagick**.

---

## Features

- Mounts an iOS device (via `ifuse`).
- Copies all photos and videos to a designated folder (default: `~/Pictures/iOS`).
- Converts `.HEIC`/`.HEIF` images to `.jpg` format for compatibility.
- Automatically cleans up original `.HEIC`/`.HEIF` files after conversion.
- When everything is done - unmounts your device again.

---

## Requirements

### Dependencies

1. **ifuse**: For mounting the iOS device.
2. **rsync**: For file synchronization.
3. **ImageMagick**: For image format conversion.

### Install on Arch Linux

Use the following command to install the required dependencies:

```bash
sudo pacman -S ifuse rsync imagemagick
```

---

## Usage

1. Clone the repository:

```bash
git clone https://github.com/NikyAviator/iSyncinator
```

2. Make the script executable:

```bash
chmod +x iSync.sh
```

3. Run the script:

```bash
./iSync.sh
```

4. By default you will find your Pics/Videos in: `~/Pictures/iOS `

---

## Customization

You can change the target directory (where the data will be saved)
by modifying the `TARGET_DIR` variable in the script:

```bash
TARGET_DIR="$HOME/YourCustomDirectory"
```

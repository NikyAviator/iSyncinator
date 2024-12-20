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

3. Run the script as test first:

```bash
./iSync.sh --dry-run
```

4. Then finally run the script:

```bash
./iSync.sh --run
```

5. By default you will find your Pics/Videos in: `~/Pictures/iOS `

---

## Customization

You can change the target directory (where the data will be saved)
by modifying the `TARGET_DIR` variable in the script:

```bash
TARGET_DIR="$HOME/YourCustomDirectory"
```

---

## How `rsync` Works

The **`rsync`** command is a powerful tool for file synchronization. It ensures only new or changed files are copied, saving time and bandwidth.

### Flags Used in This Script

- **`-a` (archive)**: Ensures recursive copying, preserving file attributes such as permissions and timestamps.
- **`-v` (verbose)**: Displays detailed output of the operations being performed.
- **`--progress`**: Shows the progress of each file being copied.
- **`--dry-run`**: Simulates the operation without making changes. This is the default mode in this script to ensure safe syncing.

### Why Use `--dry-run`?

Running `--dry-run` first allows you to review the files that will be copied without actually modifying any data. This helps avoid mistakes or unnecessary transfers.

To perform the actual sync, use the `--run` flag:

```bash
./iSync.sh --run
```

---

## How `rsync` Handles File Synchronization

`rsync` is an incremental synchronization tool. This means it will only transfer new or modified files from the source directory to the destination directory. Here’s how it works in practice:

1. **First Run**:

   - If the destination folder is empty, `rsync` will copy all files from the source to the destination.
   - Example: If there are 1000 photos and videos on your device, all 1000 files will be copied.

2. **Subsequent Runs**:
   - `rsync` will compare the source and destination directories.
   - Only new or updated files will be copied.
   - Example: If you’ve taken 3 new photos (now 1003 files on the phone), `rsync` will copy only the 3 new files.

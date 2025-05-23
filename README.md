# iOS Device Backup Script for Linux

## Table of Contents

1. [Features](#features)
2. [Requirements](#requirements)
   - [Dependencies](#dependencies)
   - [Install on Linux](#install-on-linux)
3. [Usage](#usage)
4. [Customization](#customization)
5. [How `rsync` Works](#how-rsync-works)
6. [How `rsync` Handles File Synchronization](#how-rsync-handles-file-synchronization)
7. [Important Note on Sync Behavior](#important-note-on-sync-behavior)
8. [Troubleshooting](#troubleshooting)
9. [Optional File Renaming Script](#optional-file-renaming-script)

## Features:

- Mounts an iOS device (via `ifuse`).
- Copies all photos and videos to a designated folder (default: `~/Pictures/iOS`).
- Converts `.HEIC`/`.HEIF` images to `.jpg` format for compatibility.
- Automatically cleans up original `.HEIC`/`.HEIF` files after conversion.
- When everything is done - unmounts your device.

---

## Requirements:

### Dependencies

1. **ifuse**: For mounting the iOS device.
2. **rsync**: For file synchronization.
3. **ImageMagick**: For image format conversion.

### Install on Linux

Use the following command to install the required dependencies:

**For Arch based systems:**

```bash
sudo pacman -S ifuse rsync libheif imagemagick
```

**For Debian based systems:**

```bash
sudo apt update
sudo apt install ifuse rsync imagemagick
```

#### Note: If you're using another Linux distribution, consult your package manager's documentation to install these dependencies.

## Usage:

1. Clone the repository:

```bash
git clone https://github.com/NikyAviator/iSyncinator
```

2. Make the script executable:

```bash
chmod +x iSync.sh
```

3. Run the script as a test first:

```bash
./iSync.sh --dry-run
```

4. Then finally run the script:

```bash
./iSync.sh --run
```

5. By default you will find your Pics/Videos in: `~/Pictures/iOS `

---

## Customization:

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
- **`--backup`**: Creates a backup of existing files in the destination before overwriting.
- **`--suffix=_$(date +%Y%m%d%H%M%S)`**: Appends the current timestamp to the backup file, ensuring uniqueness.
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

---

## Important Note on Sync Behavior

The script is designed to **only add files** to the destination folder. It does not delete or modify existing files in the destination, even if files are removed from the iPhone. This ensures that the destination folder acts as a permanent archive of your photos and videos.

If you want to enable deletion of files in the destination that are no longer on the phone, you can manually add the `--delete` flag to the `rsync` command, but **this is not recommended**.

## Troubleshooting:

Sometimes things go wrong and not working, this is why we will hopefully fix the problem now:

1. **Create the Mount Point**

Ensure the mount point `/mnt/iphone` exists, as the script relies on it to mount your iOS device. To create it, run:

```bash
sudo mkdir -p /mnt/iphone
```

2. **Give yourself ownership of the Mount Point**

```bash
sudo chown $USER:$USER /mnt/iphone
```

3. **Restart USBmuxd**
   If the script still fails to mount the iOS device, restart the `usbmuxd` service:

```bash
sudo systemctl restart usbmuxd
```

4. **Trust Your Computer (Your Stuff)**

If you are not prompted to "Trust This Computer" on your iPhone:

1. Disconnect your iPhone.
2. Unlock your iPhone and reconnect it.
3. Look for the "Trust This Computer?" prompt and tap Trust.

You can also revalidate the pairing with:

```bash
idevicepair validate
```

If it fails, unpair and re-pair:

```bash
idevicepair unpair
idevicepair pair
```

5. **Check the Mounting Process**

Manually test the mounting process to verify everything works:

1. Mount the iPhone:

```bash
ifuse /mnt/iphone
```

2. Verify the files:

```bash
ls /mnt/iphone
```

## Optional File Renaming Script:

After syncing, the script renames all files in the destination folder to ensure uniqueness and better organization. The new naming format includes the current date as a prefix:

This ensures files are easy to identify and avoid duplication issues.

### Usage:

1. Make the script executable:
   ```bash
   chmod +x renameYourFiles.sh
   ```
2. Run the script:

```bash
./renameYourFiles.sh
```

3. After running, the files in the destination folder will be renamed as follows:

- Original: `IMG_0001.JPG`
- Renamed: `2024-12-23_IMG_0001.JPG`

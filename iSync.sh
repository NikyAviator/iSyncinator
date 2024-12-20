#!/bin/bash

# Set target directory for copied files
TARGET_DIR="$HOME/Pictures/iOS"
mkdir -p "$TARGET_DIR"

# Mount the iOS device
echo "Mounting iOS device..."
if ! ifuse /mnt/iphone; then
    echo "Failed to mount iOS device. Ensure ifuse is installed and the device is unlocked."
    exit 1
fi

echo "iOS device mounted successfully."

# Dry-run mode by default
DRYRUN="--dry-run"
if [[ "$1" == "--run" ]]; then
    DRYRUN=""
    echo "Dry-run disabled. Syncing files for real!"
else
    echo "Running in dry-run mode. No files will be copied yet."
    echo "To perform the actual sync, run the script with the '--run' flag."
fi

# Copy photos and videos with rsync
echo "Syncing photos and videos to $TARGET_DIR..."
rsync -av $DRYRUN --progress /mnt/iphone/DCIM/ "$TARGET_DIR/"

# Count newly copied files
if [[ -z "$DRYRUN" ]]; then
    NEW_FILES=$(rsync -av --stats --progress /mnt/iphone/DCIM/ "$TARGET_DIR/" | grep "Number of created files" | awk '{print $5}')
    echo "$NEW_FILES new files copied to $TARGET_DIR."
else
    echo "Dry-run complete. No files were copied. Review the above output for details."
fi

# Convert HEIC/HEIF images to JPG
echo "Converting images to JPG..."
find "$TARGET_DIR" -type f \( -iname '*.heic' -o -iname '*.heif' \) -exec mogrify -format jpg {} \;

# Cleanup: remove original HEIC/HEIF files after conversion
find "$TARGET_DIR" -type f \( -iname '*.heic' -o -iname '*.heif' \) -delete

# Unmount the device
echo "Unmounting iOS device..."
umount /mnt/iphone

echo "All photos and videos have been copied and converted to JPG format at $TARGET_DIR."

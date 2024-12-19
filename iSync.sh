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

# Copy photos and videos
echo "Copying photos and videos to $TARGET_DIR..."
rsync -av --progress /mnt/iphone/DCIM/ "$TARGET_DIR/"

# Convert HEIC/HEIF images to JPG (or PNG)
echo "Converting images to JPG..."
find "$TARGET_DIR" -type f \( -iname '*.heic' -o -iname '*.heif' \) -exec mogrify -format jpg {} \;

# Cleanup: remove original HEIC/HEIF files after conversion
find "$TARGET_DIR" -type f \( -iname '*.heic' -o -iname '*.heif' \) -delete

# Unmount the device
echo "Unmounting iOS device..."
umount /mnt/iphone

echo "All photos and videos have been copied and converted to JPG format at $TARGET_DIR."

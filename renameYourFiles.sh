#!/bin/bash

# Directory where files are stored
DEST_DIR="$HOME/Pictures/iOS"

# Rename files in the destination directory and its subdirectories
echo "Renaming files in $DEST_DIR and its subdirectories..."
find "$DEST_DIR" -type f | while read -r file; do
    # Get current date in YYYY-MM-DD format
    DATE=$(date +%Y-%m-%d)

    # Extract file extension and base name
    EXT="${file##*.}"
    BASENAME="${file%.*}"

    # Create new name with date prefix
    NEW_NAME="${BASENAME%/*}/${DATE}_${BASENAME##*/}.${EXT}"

    # Rename the file
    mv "$file" "$NEW_NAME"
done

echo "File renaming complete!"

#!/bin/bash

# Directory where files are stored
DEST_DIR="$HOME/Pictures/iOS"

# Rename files in the destination directory
echo "Renaming files in $DEST_DIR..."
for file in "$DEST_DIR"/*; do
    if [[ -f "$file" ]]; then
        # Get current date in YYYY-MM-DD format
        DATE=$(date +%Y-%m-%d)

        # Extract file extension and base name
        EXT="${file##*.}"
        BASENAME="${file%.*}"

        # Create new name with date prefix
        NEW_NAME="${DEST_DIR}/${DATE}_${BASENAME##*/}.${EXT}"

        # Rename the file
        mv "$file" "$NEW_NAME"
    fi
done

echo "File renaming complete!"

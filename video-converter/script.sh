#!/bin/sh -e

# Directory where the volume with PIBAdb video and image data is expected to be mounted
readonly DIR="/input-files"

readonly BACKEND_UID=1000
readonly BACKEND_GID=1000

cd $DIR

convert_files()
{
    for f in *.mp4; do
        ffmpeg -hide_banner -y -i "$f" -q:v 6 "${f%.*}.ogg"
    done

    echo "Conversion finished"
}

if [ -d "$DIR" ]; then
    convert_files

    # Ensure that the backend application container has permission to manipulate files here
    chown -R $BACKEND_UID:$BACKEND_GID .
else
    echo "Error: $DIR not found"
    exit 1
fi

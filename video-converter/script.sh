#!/bin/sh -e

# Directory where the volume with Local data is expected to be mounted
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
    printf "Local(L) or remote(R)? "
    read -r origin

    if [ "$origin" = "L" ] || [ "$origin" = "l" ]; then
        echo "- Local"

        convert_files
    elif [ "$origin" = "R" ] || [ "$origin" = "r" ]; then
        echo "- Remote"

        printf "Bundle UUID: "
        read -r uuid

        printf "Bundle password: "
        stty -echo
        trap 'stty echo' EXIT INT TERM
        read -r password
        stty echo
        trap - EXIT INT TERM
        echo

        if wget -O /tmp/media.zip "https://static.sing-group.org/pibadb-requests/$uuid/media.zip" && \
            unzip -o -P "$password" /tmp/media.zip
        then
            convert_files
        else
            echo "Download error"
            exit 1
        fi
    else
        echo "Unknown action"
        exit 1
    fi

    # Ensure that the backend application container has permission to manipulate files here
    chown -R $BACKEND_UID:$BACKEND_GID .
else
    echo "Error: $DIR not found"
    exit 1
fi

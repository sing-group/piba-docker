#!/bin/sh -e

# Directory where the volume with Local data is expected to be mounted
DIR="/input-files"


convert_files()
{
    cd $DIR
    for f in *.mp4; do
        ffmpeg -hide_banner -y -i "$f" -q:v 6 "${f%.*}.ogg"
    done

    echo "Conversion finished"
}

if [ -d "$DIR" ]; then
    echo "Local(L) or remote(R)?"
    read origin
    if [[ ($origin == "L" || $origin == "l") ]]; then
        echo "Local"
        convert_files

    elif [[ ($origin == "R" || $origin == "r") ]]; then
        echo "Remote"
        echo "User:"
        read user
        echo "Password:"
        read -s password

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

            convert_files
        else
            echo "Download error"
            exit 1
        fi
    else
        echo "Unknown action"
        exit 1
    fi
else
    echo "Error: $DIR not found"
    exit 1
fi

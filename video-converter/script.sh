#!/bin/bash

# Directory where the volume with Local data is expected to be mounted
DIR="/input-files"


convert_files()
{
    cd $DIR
    for f in *.mp4
    do 
        name=$(echo "$f" | cut -f 1 -d '.')
        echo "$f file"
        ffmpeg -i $name.mp4 -q:v 6 $name.ogg
    done
    
    echo "Conversion finnished"
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

        wget -qO- https://$user:$password@static.sing-group.org/piba/media/$user/sample.tar.gz --no-check-certificate | tar xvz - -C $DIR
        if ! [ "$(ls -A $DIR)" ]; then
            convert_files
        else
            echo "Error during download, not found files"
            exit 1
        fi

    else
        echo "Unknown action"
    fi
else
    echo "Error: ${DIR} not found"
    exit 1
fi

echo "Exiting..."


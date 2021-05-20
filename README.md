PIBA Distribution
=================

A Docker distribution of the PIBA repository.

## How to install and use PIBA

### Prerequisites

To use this tool, you need to have installed on your computer both Docker and Docker Compose. The instructions needed for installing this could be reached on the official website.

[Install Docker](https://docs.docker.com/engine/install/ubuntu/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

[Install Docker]: (https://docs.docker.com/engine/install/ubuntu/)
[Install Docker Compose]: https://docs.docker.com/compose/install/	"Install Docker Compose"

### Creating volumes

There are two ways of working with this tool. You can setup PIBA to work with your own image and video files, or download then. This ways are basically differenced by the way of creating the volume.

If you want to download the files from PIBA's repository, create the volume using the next instruction:

```bash
docker volume create piba-files
```

Otherwise, if you have your files in some local directory, use this instruction:

```bash
docker volume create --driver=local --opt type=none --opt o=bind --opt device=/absolute/path/to/directory piba-files

```

### Using video converter / downloader

PIBA needs to have video files both in `.mp4` and `.ogg` formats. To achieve this, there is an auxiliary tool that helps you converting your `.mp4` files to `.ogg` without losing quality. This is also used to download and covert the files if you want to use PIBA's data.

To use this utility, go to video-converter folder, and build and launch it with the next instructions:

```bash
cd video-converter
docker build -t video-converter .
docker run -it -v piba-files:/input-files video-converter
```

This will prompt `Local(L) or Remote(R)?` expecting your answer. If you select Local mode, it will do the conversion of your local files without downloading anything. If you select Remote mode, it will ask you for your credentials to download the files, and then it will convert them.

### Using PIBA

Once you have your files downloaded and converted to correct format, you are ready to use PIBA.

Before starting the application, you must go to the root folder and modify `.env` file, introducing your credentials on `DOWNLOAD_USER` and `DOWNLOAD_PASSWORD` fields. This is needed to download the `.sql` file for the database.

The you are ready to build and start PIBA using the next instructions.

```bash
docker-compose build
docker-compose up
```


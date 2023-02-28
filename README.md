**PIBA Distribution**
=====================

A Docker distribution of the PIBA repository.

## **How to install and use PIBA**

### **Prerequisites**

To use this tool, you need to have installed on your computer both Docker and Docker Compose. The instructions needed for installing this could be reached on the official website.

[Install Docker](https://docs.docker.com/engine/install/ubuntu/)

[Install Docker Compose](https://docs.docker.com/compose/install/)

### **Getting the PIBAdb data**

In order to use PIBA, you first need to download the following two files from our servers:

- `piba.sql.zip`: a password-protected ZIP file containing a MySQL 8 dump of the PIBA database.
- `media.zip`: a password-protected ZIP file which contains the full set of images and videos of PIBAdb.

To proceed with this step, please refer to the e-mail that should have been sent to you with the applicable download instructions and password.

Once these files are downloaded, start by extracting the `piba.sql` file from `piba.sql.zip` into the directory where this `README.md` file is located. PIBA needs such a database dump to function properly.

Then extract the contents of `media.zip` to a directory of your choice. Take note of its absolute path, which will be assumed to be `/absolute/path/to/media` in the following sections.

### **Creating the PIBAdb data volume**

The PIBA backend expects the existence of a Docker volume with the name `piba-files`, which must contain the videos and images for the PIBAdb.

There are two main ways to create and populate this volume, which are described below:

- By bind-mounting `/absolute/path/to/media` to the volume. In other words, the volume will act as an alias to the `/absolute/path/to/media` directory, so that its contents and any changes to it will be shared between the host and the backend container.
- By copying the contents of `/absolute/path/to/media` to the volume, so that the backend container has its own copy of the data, and any changes to the volume data are not visible to the host. This approach is slower and requires additional disk space.

If in doubt, we suggest that you resort to the bind-mounting approach.

#### **Bind-mounting the PIBAdb data volume**

Just run the next command, replacing `/absolute/path/to/media` accordingly:

```bash
docker volume create --driver=local --opt type=none --opt o=bind --opt device="/absolute/path/to/media" piba-files
```

Note that the `piba-files` volume can be deleted without affecting the contents of `/absolute/path/to/media`, even if it is bind-mounted.

#### **Copying the media data to the PIBAdb data volume**

Run the following commands, replacing `/absolute/path/to/media` accordingly:

```bash
docker volume create piba-files
docker run --rm -v "/absolute/path/to/media":/media -v piba-files:/piba-files -w /media alpine /bin/sh -c 'cp * /piba-files'
```

### **Transconding PIBAdb videos**

PIBA needs to have video files both in `.mp4` and `.ogg` formats. To achieve this, there is an auxiliary tool that helps you converting the `.mp4` files in your `piba-files` volume to `.ogg` without losing quality.

To use this utility, go to video-converter folder, and build and launch it with the next instructions:

```bash
cd video-converter
docker build -t video-converter .
docker run -it --rm -v piba-files:/input-files video-converter
cd ..
```

### **Using PIBA**

Once you have completed the previous sections, you are ready to run PIBA by executing the following commands:

```bash
docker-compose build
docker-compose up
```

If all goes well, PIBAdb will be available at either `http://172.30.0.30/piba` or `http://localhost/piba`. You can log in as one of the default users, such as `admin` (password: `adminpass`).


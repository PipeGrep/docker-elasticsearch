# Dockerfile : Elasticsearch

## Features
* Elasticsearch
* [JDBC / Postgresql rivers](https://github.com/jprante/elasticsearch-jdbc/)
* Reverse proxy (Nginx)
* HTTP Basic auth
* Elasticsearch plugins (monitoring / GUIs) :
  * [head](http://mobz.github.io/elasticsearch-head/)
  * [HQ](https://github.com/royrusso/elasticsearch-HQ)
* cron task to flush logs
* index in a volume

## Settings

To update settings, just create a Dockerfile with the following base image :
```
FROM pipegrep/docker-elasticsearch
```

Then add you custom configuration file. Ex :
```
ADD my-nginx.conf /etc/nginx/nginx.conf
```

## Basic authentification
You can update the basic auth passwords by overriding default passwords :
```
printf "readonly:`openssl passwd -crypt mySearchPassword`\n"   > readonly.passwd
printf "admin:`openssl passwd -crypt myAdminPassword`\n"   > admin.passwd
```

With the following Dockerfile :
```
FROM pipegrep/docker-elasticsearch

ADD readonly.passwd /app
ADD admin.passwd /app
```

## Usage

### Get the image from the hub
```
docker pull pipegrep/docker-elasticsearch
```

### Build a custom image
```
docker build -t myproject/elasticsearch .
```

### Run the container
```
# Without persistance
docker run -d -p 80:80 -p 8080:8080 pipegrep/docker-elasticsearch
# With persistance
docker run -d -p 80:80 -p 8080:8080 -v /your/home/directory:/data pipegrep/docker-elasticsearch
```



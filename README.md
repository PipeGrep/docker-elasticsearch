# Dockerfile : Elasticsearch

## Features
* Elasticsearch
* Reverse proxy (Nginx)
* HTTP Basic auth
* Elasticsearch plugins (monitoring / GUIs) :
  * head
  * HQ
* cron task to flush logs
* index in a volume

## Settings

To update settings, just create a Dockerfile with the following base image :
```
FROM samber/elasticsearch
```

Then add you custom configuration file. Ex :
```
ADD             my-nginx.conf /etc/nginx/nginx.conf
```

## Run

### Get the image from the hub
```
docker pull samber/elasticsearch
```

### Build a custom image
```
docker build -t myproject/elasticsearch .
```

### Run the container
```
# Without persistance
docker run -d -p 80:80 -p 8080:8080 samber/elasticsearch
# With persistance
docker run -d -p 80:80 -p 8080:8080 -v /your/home/directory:/data samber/elasticsearch
```



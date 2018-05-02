# Essential-project-docker

Unofficial Docker for https://enterprise-architecture.org

This is an example how to run EAS inside docker in server mode

**This project is not production ready!!!**

**PR are welcome**

## Prerequisite
- Latest docker
- Protege 3.5 EAM Client see https://enterprise-architecture.org/documentation/doc-installation/65-multiuser-install-guide (Section *Client Installation* )


## Steps

### Build

```
docker build -t local/eam .
```

### Run
```
docker run -d -p 8080:8080 --rm  -p5200:5200 -p5100:5100 -h eam local/eam
````

### Connect

#### Viewer
http://localhost:8080/essential_viewer

#### Protege Client

- Open Server
  - Host Maschine Name: locahost:5100
  - Username: Admin
  - Password : 12345


# symfony-docker-stack
A simple repository containing all docker files to mount a symfony simple stack.

This reprository aims to have a simple docker environment for PHP Symfony project.
It will contain :

* Nginx - latest
* PHP-FPM - 7.latest
* MySQL - 5.7.27
* Redis - latest
* Redis insight - latest *(for dev purpose only)*

## Prerequisite
You need to have installed on your linux machine :
* docker : https://docs.docker.com/engine/install/ubuntu/
* git : https://git-scm.com/book/fr/v2/D%C3%A9marrage-rapide-Installation-de-Git
* make : https://www.gnu.org/software/make/

*Note :* This works well with a virtualized Linux on WSL2 Windows Ubuntu 20.04 image.

## Installation

First you need to clone this repository.

```bash
git clone https://github.com/XSlender/symfony-docker-stack.git
cd symfony-docker-stack
```
Now you just need to initialize your project with :
```bash
make init
```

This process will :
1. Get sudo permissions
2. Gather some infos to build the project
3. Generate the docker environment file
4. Create the folder tree for running apps
5. Build docker containers
6. Launch (compose up) all the containers
7. Create the `symfony` user on the database

> **Note :** This process will erase previous iteration of the **same** project *(aka in the same folder)* in the `run` folder, meaning you will lose all your database related data (mysql & redis). You may want to backup those data before re-typing `make init` on an existing project.

> You can read the complete manual of the makefile in the [makefile documentation](./docs/makefile.md).

Now you can take all data you need from the console (or from `make connect-help`) and complete your Symfony dotenv and start to code \o/.

## common commands
| Goal | Command | arguments |
|---|---|-----|
| Initialize the project | `make init` | |
| Start the stack | `make up` | |
| Stop the stack | `make down` | |
| Get connection helper | `make connect-help` | |
| Get logs of container | `make log CONTAINER` | CONTAINER : `nginx,php,mysql` |
| Connect to a container | `make exec CONTAINER` | CONTAINER : `nginx,php,mysql` |

## Next steps
* limit RAM
* get health check for each service
* add an ELK stack
* automatic building of Symfony dotenv file

## Thanks
Thanks to Maxime Gottie for his work.


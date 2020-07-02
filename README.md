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
Now you need to edit the environment file.

```bash
cp .env.dist .env
vi .env
```

Follow the instructions and you will be good to go.
> If you need more details about environment details, please check the [environment variable documentation](./docs/environment-variables.md).

Now that your environment is configured, you will need to initialize your project.

```bash
make init
```

This will :
* compose and build the project.
* initialize the database with a default user.

> You can read the complete manual of the makefile in the [makefile documentation](./docs/makefile.md).

## common commands
| Goal | Command | arguments |
|---|---|-----|
| Start the stack | `make up` | |
| Stop the stack | `make down` | |
| Get logs of container | `make log CONTAINER` | CONTAINER : `nginx,php,mysql` |
| Connect to a container | `make exec CONTAINER` | CONTAINER : `nginx,php,mysql` |

## Next steps
* add an ELK stack
* make environment files creation interactive
* automatic building of Symfony dotenv file

## Thanks
Thanks to Maxime Gottie for his work.


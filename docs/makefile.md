# Makefile documentation

### make help
Displays help for this makefile.

### make up
Launches (aka compose up) all the containers.

### make down
Shuts down (aka compose down) all the containers.

### make build
Rebuild all the containers.

### make log CONTAINER
Displays the log of the container designed by `CONTAINER`

### make exec CONTAINER
Logins you into a shell (bash) on the given `CONTAINER`

### make init
Initialize the project.

In order, this will :
1. Get sudo permissions
2. Gather some infos to build the project
3. Generate the docker environment file
4. Create the folder tree for running apps
5. Build docker containers
6. Launch (compose up) all the containers
7. Create the `symfony` user on the database

> **Note :** This process will erase previous iteration of the **same** project *(aka in the same folder)* in the `run` folder, meaning you will lose all your database related data (mysql & redis). You may want to backup those data before re-typing `make init` on an existing project.

### make connect-help
Displays all the connection data (aka project url, mysql DSN, redis DSN) for this project.
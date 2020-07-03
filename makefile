###################################################
#
# Makefile to ease the stack managment
#
###################################################

-include .env
include ./make.d/colors.make
include ./make.d/strings.make

.DEFAULT_GOAL := help

THIS_FILE := $(lastword $(MAKEFILE_LIST))

ifeq (log,$(firstword $(MAKECMDGOALS)))
  LOGS_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
ifeq (exec,$(firstword $(MAKECMDGOALS)))
  EXEC_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif


help:
	@printf "\n${LIGHTPURPLE}RTFM NOOB${RESET}\n\n"

up:
	@printf "${GREEN}Waking ${PROJECT_NAME}...${RESET}\n"
	@printf "${GREEN}${DOTTED_LINE}${RESET}\n"
	@docker-compose up -d
	@printf "\n"
	@$(MAKE) -s connect-help

down:
	@printf "${YELLOW}shutting down ${PROJECT_NAME}...${RESET}\n"
	@printf "${YELLOW}${DOTTED_LINE}${RESET}\n"
	@docker-compose down

build:
	@printf "${GREEN}Building ${PROJECT_NAME}...${RESET}\n"
	@printf "${GREEN}${DOTTED_LINE}${RESET}\n"
	@docker-compose build

log:
	@docker logs -f ${ENV}_${PROJECT_NAME}_${LOGS_ARGS}

exec:
	@docker exec -ti ${ENV}_${PROJECT_NAME}_${EXEC_ARGS} bash

.ONESHELL:
init:
	@clear
	@printf "Welcome tho the symfony docker stack initialisation. \\o/\n"
	@printf "\n"
	@printf "This will guide you through the first launch of the stack, asking you some\n"
	@printf "questions andbuilding for you all the mandatory stuff.\n"
	@printf "\n"
	@printf "${BLUE}Stay calm, get a cup of coffee, and let start.${RESET}\n"
	@printf "\n"
	## interactive variables definitinon
	@COMPOSE_PROJECT_NAME=""
	@PROJECT_SOURCE_DIR=""
	@APP_ENV=""
	## calculated variables definition
	@CURRENT_DIR=""
	@PROJECT_NAME=""
	@APP_SECRET=""
	@DB_HOST=""
	@DB_PORT=""
	@DB_NAME=""
	@DB_USER=""
	@DB_PASSWD=""
	@REDIS_HOST=""
	@REDIS_PORT=""
	## interactive
	@read -p "${YELLOW}What is the project name: ${RESET}" COMPOSE_PROJECT_NAME
	@read -p "${YELLOW}Where will the sources be located: ${RESET}" PROJECT_SOURCE_DIR
	@read -p "${YELLOW}What is the applicative environment (dev or prod): ${RESET}" APP_ENV
	## time to calculate some variables
	@CURRENT_DIR=$$PWD
	@PROJECT_NAME=$$COMPOSE_PROJECT_NAME
	@APP_SECRET=$$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 48 | head -n 1)
	@DB_HOST="$${APP_ENV}_$${PROJECT_NAME}_mysql"
	@DB_PORT="3306"
	@DB_NAME=$$PROJECT_NAME
	@DB_USER="symfony"
	@DB_PASSWD=$$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
	@REDIS_HOST="$${APP_ENV}_$${PROJECT_NAME}_redis"
	@REDIS_PORT="6379"
	## env file creation
	@printf "\n"
	@printf "Generating environment file..."
	@rm .env
	@cp -f env/.env.dist .env
	## replacing vars in environment file
	@sed -i "s~CURRENT_DIR=~CURRENT_DIR=$${CURRENT_DIR}~g" .env
	@sed -i "s/PROJECT_NAME=/PROJECT_NAME=$${PROJECT_NAME}/g" .env
	@sed -i "s~PROJECT_SOURCE_DIR=~PROJECT_SOURCE_DIR=$${PROJECT_SOURCE_DIR}~g" .env
	@sed -i "s/APP_SECRET=/APP_SECRET=$${APP_SECRET}/g" .env
	@sed -i "s/ENV=dev/ENV=$${APP_ENV}/g" .env
	@sed -i "s/DB_HOST=/DB_HOST=$${DB_HOST}/g" .env
	@sed -i "s/DB_PORT=/DB_PORT=$${DB_PORT}/g" .env
	@sed -i "s/DB_NAME=/DB_NAME=$${DB_NAME}/g" .env
	@sed -i "s/DB_USER=/DB_USER=$${DB_USER}/g" .env
	@sed -i "s/DB_PASSWD=/DB_PASSWD=$${DB_PASSWD}/g" .env
	@sed -i "s/REDIS_HOST=/REDIS_HOST=$${REDIS_HOST}/g" .env
	@sed -i "s/REDIS_PORT=/REDIS_PORT=$${REDIS_PORT}/g" .env
	## done like this because a bug in sed, wtf
	@echo "\n" >> .env
	@echo "\n" >> .env
	@echo "\n# docker compose project name" >> .env
	@echo "\nCOMPOSE_PROJECT_NAME=$${PROJECT_NAME}" >> .env
	@printf "\t${GREEN}done${RESET}\n"
	## create run folders
	@printf "Generating run folders..."
	@rm -rf run/mysql
	@rm -rf run/redis
	@rm -rf run/redis-insight
	@mkdir run/mysql
	@mkdir run/redis
	@mkdir run/redis-insight
	@printf "\t${GREEN}done${RESET}\n"
	## building machines
	@printf "\n"
	@printf "${BLUE}Now let's build some containers.${RESET}\n"
	@printf "\n"
	@docker-compose build
	## launching containers
	@printf "\n"
	@printf "${BLUE}Let's rev it up !${RESET}\n"
	@printf "\n"
	@docker-compose up -d
	## launching containers
	@printf "\n"
	@printf "${BLUE}Finally, let's configure some database${RESET}\n"
	@printf "\n"
	@printf "Waiting for database to fully start..."
	@sleep 10
	@printf "\t${GREEN}done${RESET}\n"
	@printf "Inserting $${PROJECT_NAME} user..."
	@docker exec $${APP_ENV}_$${PROJECT_NAME}_mysql mysql -e "CREATE USER '$${DB_USER}'@'localhost' IDENTIFIED BY '$${DB_PASSWD}';" 2>&1 | grep -vi "warning" 
	@docker exec $${APP_ENV}_$${PROJECT_NAME}_mysql mysql -e "GRANT ALL PRIVILEGES ON * . * TO '$${DB_USER}'@'localhost';" 2>&1 | grep -vi "warning" 
	@docker exec $${APP_ENV}_$${PROJECT_NAME}_mysql mysql -e "CREATE USER '$${DB_USER}'@'%' IDENTIFIED BY '$${DB_PASSWD}';" 2>&1 | grep -vi "warning" 
	@docker exec $${APP_ENV}_$${PROJECT_NAME}_mysql mysql -e "GRANT ALL PRIVILEGES ON * . * TO '$${DB_USER}'@'%';" 2>&1 | grep -vi "warning" 
	@docker exec $${APP_ENV}_$${PROJECT_NAME}_mysql mysql -e "FLUSH PRIVILEGES;" 2>&1 | grep -vi "warning" 
	@printf "\t${GREEN}done${RESET}\n"
	@printf "\n"
	@printf "\t${GREEN}--- Yay ! $${PROJECT_NAME} is started and ready ! ---${RESET}\n"
	@printf "\n"
	@printf "${BLUE}Symfony application :${RESET} http://localhost\n"
	@printf "${BLUE}MySQL database :${RESET} mysql://${DB_USER}:${DB_PASSWD}@${DB_HOST}:${DB_PORT}/${DB_NAME}\n"
	@printf "${BLUE}Redis database :${RESET} redis://${ENV}_${PROJECT_NAME}_redis:${REDIS_PORT}\n"
	@printf "${BLUE}Redis insight :${RESET} http://localhost:8001 (to configure the database, use the same host and port as the redis database)\n"
	@printf "${YELLOW}You can find back this list with 'make connect-help'${RESET}\n"
	@printf "\n"
	@printf "If you need to connect some tools to database or other services, check the .env file.\n"
	@printf "\n"

connect-help:
	@printf "${BLUE}Listing access for ${PROJECT_NAME}...${RESET}\n"
	@printf "${BLUE}${DOTTED_LINE}${RESET}\n"
	@printf "${BLUE}Symfony application :${RESET} http://localhost\n"
	@printf "${BLUE}MySQL database :${RESET} mysql://${DB_USER}:${DB_PASSWD}@${DB_HOST}:${DB_PORT}/${DB_NAME}\n"
	@printf "${BLUE}Redis database :${RESET} redis://${ENV}_${PROJECT_NAME}_redis:${REDIS_PORT}\n"
	@printf "${BLUE}Redis insight :${RESET} http://localhost:8001 (to configure the database, use the same host and port as the redis database)\n"
	@printf "\n"

## next step
## stack ELK

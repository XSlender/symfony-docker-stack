###################################################
#
# Makefile to ease the stack managment
#
###################################################

include .env
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

init: build

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
## interactive build for env generation -> use .ONESHELL for multiline realdline etc
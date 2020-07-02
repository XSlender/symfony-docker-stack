###################################################
#
# Makefile to ease the stack managment
#
###################################################

include .env
include ./make.d/colors.make
include ./make.d/strings.make

.DEFAULT_GOAL := help

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

###################################################
#
# Makefile to ease the stack managment
#
###################################################

include .env
include ./make.d/colors.make

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
	@printf "${GREEN}Waking and building ${PROJECT_NAME}...${RESET}\n"
	@docker-compose up -d --build

down:
	@printf "${YELLOW}shutting down ${PROJECT_NAME}...${RESET}\n"
	@docker-compose down

log:
	@docker logs -f ${ENV}_${PROJECT_NAME}_${LOGS_ARGS}

exec:
	@docker exec -ti ${ENV}_${PROJECT_NAME}_${EXEC_ARGS} bash
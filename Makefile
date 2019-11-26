GREP ?=.
#check if xvfb is running
XVFB_RUNNING = $(shell pgrep "Xvfb" > /dev/null; echo $$?)
#set the circle project name if not set
CIRCLE_PROJECT_REPONAME ?= 1
#set headless if not set
HEADLESS ?= 1

test: node_modules lint
	@rm -rf /tmp/nightmare
#if this build is not on circle, is not headless, and xvfb is not already running,
#run mocha as usual
#otherwise, run mocha under the xvfb wrapper
ifeq ($(CIRCLE_PROJECT_REPONAME)$(HEADLESS)$(XVFB_RUNNING), 111)
	@node_modules/.bin/mocha -b --timeout 100000 --grep "$(GREP)"
	#@node_modules/.bin/mocha --grep "$(GREP)"
else
	@./test/bb-xvfb node_modules/.bin/mocha --grep "$(GREP)"
endif

lint: node_modules
	@./node_modules/.bin/eslint --fix lib/*.js test/*.js

node_modules: package.json
	@npm install

.PHONY: test lint

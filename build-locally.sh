#!/bin/bash
#This script build the monolithic image locally, for cases like the raspberry pi, which operates on arm64 architecture, which isn't officially supported.

PURPLEBOLD="$(tput setf 5 bold)"

printf "${PURPLEBOLD}Building Monolithic image:\n"
docker build -t lancachenet/monolithic:latest --progress tty .

printf "${PURPLEBOLD}Completed local build. Image now available as lancachenet/monolithic:latest\n"
docker image ls lancachenet/monolithic:latest
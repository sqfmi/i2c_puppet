#!/usr/bin/env bash

ORIGINAL_PWD="$(pwd)" # Store the current working directory
DIR="$(realpath "$( dirname "${BASH_SOURCE[0]}" )")"

if [[ "${#}" -gt 0 ]]; then
 printf "%s\n" "Arguments passed to \`build-with-docker.sh\`."
 printf "%s\n" "\"Clean Run\" triggered."
 if [[ "${EUID}" -ne 0 ]]; then
   printf "%s\n" "Triggered behavior requires root access."
   printf "%s\n" "Please re-execute using \`sudo\` command."
   printf "%s\n" "Example: sudo !!"
   printf "%s\n" "Example: sudo $0 $@"
   exit 1
 fi
 printf "%s\n" "Executing: \`rm -rf \"${DIR}/build\"\`"
 rm -rf "${DIR}/build"
 printf "%s\n" "Build directory deleted for \"Clean Run\"."
fi

"${DIR}/initialize-submodules.sh"

docker run --rm -it \
 -v "${DIR}/3rdparty/pico-sdk:/pico-sdk" \
 -v "${DIR}:/project" \
 "djflix/rpi-pico-builder:latest" \
 bash -c 'mkdir -p build && cd build && cmake -DPICO_BOARD=beepy .. && make clean && make'

cd "${ORIGINAL_PWD}" || exit 1

# DOCKER IMAGE DETAILS:
# https://github.com/DJFliX/rpi-pico-builder (fork of original, smaller size, newer ubuntu version, available on docker hub)
# https://github.com/xingrz/rpi-pico-builder (original, public archive repo, available on docker hub)
#
# Here is the entire Dockerfile as of 2023-08-25:
#
# BEGIN of DJFliX/rpi-pico-builder Dockerfile
# FROM ubuntu:22.04
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update
# RUN apt-get install -y build-essential
# RUN apt-get install -y python3
# RUN apt-get install -y cmake
# RUN apt-get install -y gcc-arm-none-eabi libnewlib-arm-none-eabi \
#   && rm -rf /usr/lib/arm-none-eabi/newlib/thumb/v8* \
#   /usr/lib/arm-none-eabi/newlib/thumb/v7e* \
#   /usr/lib/arm-none-eabi/newlib/thumb/v7ve+simd \
#   /usr/lib/arm-none-eabi/newlib/thumb/v7-a* \
#   /usr/lib/arm-none-eabi/newlib/thumb/v7-r+fp.sp \
#   /usr/lib/gcc/arm-none-eabi/10.3.1/thumb/v7e* \
#   /usr/lib/gcc/arm-none-eabi/10.3.1/thumb/v7-a* \
#   /usr/lib/gcc/arm-none-eabi/10.3.1/thumb/v7+fp* \
#   /usr/lib/gcc/arm-none-eabi/10.3.1/thumb/v8*
#
# VOLUME [ "/pico-sdk", "/project" ]
#
# ENV PICO_SDK_PATH=/pico-sdk
#
# WORKDIR /project
# END of DJFliX/rpi-pico-builder Dockerfile
#

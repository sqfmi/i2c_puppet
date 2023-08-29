#!/usr/bin/env bash

ORIGINAL_PWD="$(pwd)" # Store the current working directory
DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

cd "${DIR}" || exit 1

git submodule foreach git submodule foreach git submodule foreach git reset --hard
git submodule foreach git submodule foreach git reset --hard
git submodule foreach git reset --hard

git submodule update -- "3rdparty/pico-sdk"
cd "3rdparty/pico-sdk" || exit 1
git ls-files --others --exclude-standard | xargs rm -rf

git submodule update -- "lib/tinyusb"
cd "lib/tinyusb" || exit 1
git ls-files --others --exclude-standard | xargs rm -rf

cd "${ORIGINAL_PWD}" || exit 1

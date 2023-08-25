#!/usr/bin/env bash

ORIGINAL_PWD="$(pwd)" # Store the current working directory
DIR="$(realpath "$( dirname "${BASH_SOURCE[0]}" )")"

get_submodule_status() {
  submodule_path="$1"
  submodule_status="$(git submodule status "${submodule_path}")"

  # Check the first character of the output to determine the status
  case "${submodule_status:0:1}" in
    '-')
      return 0
      ;;
    ' ')
      return 1
      ;;
    '+')
      return 2
      ;;
    *)
      return 3
      ;;
  esac
}

echo_submodule_status() {
  submodule_path="$1"
  status_code="$2"

  case ${status_code} in
    0)
      echo "The submodule at ${submodule_path} is not initialized."
      ;;
    1)
      echo "The submodule at ${submodule_path} is initialized and in-sync with superproject."
      ;;
    2)
      echo "The submodule at ${submodule_path} is initialized and has changes."
      ;;
    *)
      echo "Unknown status for the submodule at ${submodule_path}."
      ;;
  esac
}

submodule_status() {
  submodule_path="${1}"
  get_submodule_status "${submodule_path}"
  status_code="${?}"
  echo_submodule_status "${submodule_path}" "${status_code}"
  return "${status_code}"
}

initialize_submodule_if_not_initialized() {
  submodule_path="${1}"
  original_pwd="$(pwd)" # Store the current working directory

  # Navigate to the submodule's directory
  cd "${submodule_path}" || return 1

  # Run the submodule_status function to get the status
  submodule_status "${submodule_path}"
  status_code="${?}"

  # If the status code is 0 (uninitialized), initialize the submodule
  if [[ "${status_code}" -eq 0 ]]; then
    git submodule update --init
    echo "The submodule at ${submodule_path} has been initialized."
  fi

  # Return to the original working directory
  cd "${original_pwd}" || return 1

  return 0
}

initialize_submodule_if_not_initialized "${DIR}"
initialize_submodule_if_not_initialized "${DIR}/3rdparty/pico-sdk"

cd "${ORIGINAL_PWD}" || exit 1

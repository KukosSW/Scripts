#!/bin/bash

set -Eu

# Get the directory of the current script
test_settings_main_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the git config script
test_git_config_path="${test_settings_main_dir}/../test/test_git_config_mkukowski.sh"
if [[ -f "${test_git_config_path}" ]]; then
    # shellcheck source=/dev/null
    source "${test_git_config_path}"
else
    echo "Error: Could not find test_git_config_mkukowski.sh at ${test_git_config_path}"
    exit 1
fi

test_suite_git_config_mkukowski

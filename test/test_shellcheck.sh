#!/bin/bash

set -Eu

# Get the directory of the current script
test_shellcheck_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function shellcheck_check()
{
    local script="${1}"
    if shellcheck --shell=bash --enable=all --external-sources "${script}"; then
        echo "Shellcheck: ${script}: PASSED"
    else
        echo "Shellcheck: ${script}: FAILED"
        exit 1
    fi
}

shellcheck_check "${test_shellcheck_dir}/../src/utils/trap_manager.sh"
shellcheck_check "${test_shellcheck_dir}/../src/utils/trapper.sh"
shellcheck_check "${test_shellcheck_dir}/../src/logger/logger.sh"
shellcheck_check "${test_shellcheck_dir}/../src/settings/git/git_config_mkukowski.sh"

shellcheck_check "${test_shellcheck_dir}/../test/test_trap_manager.sh"
shellcheck_check "${test_shellcheck_dir}/../test/test_trapper.sh"
shellcheck_check "${test_shellcheck_dir}/../test/test_logger.sh"
shellcheck_check "${test_shellcheck_dir}/../test/test_git_config_mkukowski.sh"


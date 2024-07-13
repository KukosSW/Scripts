#!/bin/bash

set -Eu

function test_suite_run()
{
    local test_suite_name="${1}"

    if ! eval "${test_suite_name}"; then
        echo "TEST: ${test_suite_name}: FAILED"
        exit 1
    else
        echo "TEST: ${test_suite_name}: PASSED"
    fi
}

# Get the directory of the current script
test_main_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Run ShellCheck first
if ! "${test_main_dir}"/../test/test_shellcheck.sh; then
    echo "Error: ShellCheck failed"
    exit 1
fi

# Source the trap manager script
test_trap_manager_path="${test_main_dir}/../test/test_trap_manager.sh"
if [[ -f "${test_trap_manager_path}" ]]; then
    # shellcheck source=/dev/null
    source "${test_trap_manager_path}"
else
    echo "Error: Could not find test_trap_manager.sh at ${test_trap_manager_path}"
    exit 1
fi

# Source the trapper script
test_trapper_path="${test_main_dir}/../test/test_trapper.sh"
if [[ -f "${test_trapper_path}" ]]; then
    # shellcheck source=/dev/null
    source "${test_trapper_path}"
else
    echo "Error: Could not find test_trapper.sh at ${test_trapper_path}"
    exit 1
fi

# Source the logger script
test_logger_path="${test_main_dir}/../test/test_logger.sh"
if [[ -f "${test_logger_path}" ]]; then
    # shellcheck source=/dev/null
    source "${test_logger_path}"
else
    echo "Error: Could not find test_logger.sh at ${test_logger_path}"
    exit 1
fi

test_suite_run "test_suite_trap_manager"
test_suite_run "test_suite_trapper"
test_suite_run "test_suite_logger"

# Tests settings using docker
if ! docker build -t docker_test_settings -f "${test_main_dir}/docker/Dockerfile_check_settings_ubuntu" .; then
    echo "Error: Docker build: docker_test_settings failed"
    exit 1
fi


if ! docker run --rm docker_test_settings; then
    echo "Error: Docker run: docker_test_settings failed"
    exit 1
fi
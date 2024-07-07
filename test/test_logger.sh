#!/bin/bash

set -euoE pipefail

# Get the directory of the current script
test_logger_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the logger script
logger_path="${test_logger_dir}/../src/logger/logger.sh"
if [[ -f "${logger_path}" ]]; then
    # shellcheck source=/dev/null
    source "${logger_path}"
else
    echo "Error: Could not find logger.sh at ${logger_path}"
    exit 1
fi

function test_logger_log_info()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_info "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*INFO[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_info: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_info: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_error()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_error "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*ERROR[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_error: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_error: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_warning()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_warning "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*WARNING[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_warning: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_warning: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_debug()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_debug "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*DEBUG[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_debug: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_debug: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_critical()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_critical "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*CRITICAL[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_critical: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_critical: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_trace()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_trace "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*TRACE[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_trace: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_trace: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_fatal()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_fatal "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FATAL[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_fatal: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_fatal: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_success()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_success "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*SUCCESS[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_success: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_success: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log_failure()
{
    local temp_output
    temp_output=$(mktemp -u)

    log_failure "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FAILURE[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log_failure: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log_failure: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_log()
{
    local temp_output
    temp_output=$(mktemp -u)

    log "My message" > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*LOG[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}"; then
        echo "TEST: test_logger_log: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_logger_log: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_logger_file_log_info()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_info "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*INFO[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*INFO[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_info: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_info: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_error()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_error "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*ERROR[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*ERROR[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_error: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_error: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_warning()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_warning "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*WARNING[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*WARNING[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_warning: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_warning: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_debug()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_debug "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*DEBUG[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*DEBUG[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_debug: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_debug: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_critical()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_critical "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*CRITICAL[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*CRITICAL[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_critical: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_critical: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_trace()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_trace "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*TRACE[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*TRACE[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_trace: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_trace: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_fatal()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_fatal "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FATAL[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FATAL[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_fatal: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_fatal: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_success()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_success "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*SUCCESS[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*SUCCESS[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_success: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_success: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log_failure()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log_failure "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FAILURE[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*FAILURE[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log_failure: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log_failure: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_logger_file_log()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        rm -f logger_*
        logger_enable_file_logger
        log "My message" 
    ) > "${temp_output}" 2>&1

    if grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*LOG[[:space:]]*.*\] \[[^]]+\] My message' "${temp_output}" && grep -qE '\[[0-9]{2}:[0-9]{2}:[0-9]{2}\] \[.*LOG[[:space:]]*.*\] \[[^]]+\] My message' logger_*; then
        echo "TEST: test_logger_file_log: PASSED"
        rm -f "${temp_output}"
        rm -f logger_*
    else
        echo "TEST: test_logger_file_log: FAILED"
        rm -f "${temp_output}"
        rm -f logger_*
        exit 1
    fi
}

function test_suite_logger()
{
    test_logger_log_info
    test_logger_log_error
    test_logger_log_warning
    test_logger_log_debug
    test_logger_log_critical
    test_logger_log_trace
    test_logger_log_fatal
    test_logger_log_success
    test_logger_log_failure
    test_logger_log

    test_logger_file_log_info
    test_logger_file_log_error
    test_logger_file_log_warning
    test_logger_file_log_debug
    test_logger_file_log_critical
    test_logger_file_log_trace
    test_logger_file_log_fatal
    test_logger_file_log_success
    test_logger_file_log_failure
    test_logger_file_log
}
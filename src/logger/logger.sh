#!/bin/bash

set -Eu

# Prevent double sourcing
if [[ -n "${LOGGER_SOURCED:-}" ]]; then
    return 0
fi

export LOGGER_SOURCED=1

log_file=""

# Get the directory of the current script
logger_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the trap manager script
trap_manager_path="${logger_dir}/../utils/trap_manager.sh"
if [[ -f "${trap_manager_path}" ]]; then
    # shellcheck source=/dev/null
    source "${trap_manager_path}"
else
    echo "Error: Could not find trap_manager.sh at ${trap_manager_path}"
    exit 1
fi

# Function to set up the logger its create a log file with the name logger_<timestamp>.log
# USAGE:
#   logger_enable_file_logger
# OUTPUT:
#   NO OUTPUT
function logger_enable_file_logger()
{
    local timestamp
    timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    
    log_file="./logger_${timestamp}.log"

    # Redirect stdout and stderr to the log file
    local log_pipe
    log_pipe=$(mktemp -u)
    mkfifo "${log_pipe}"

    tm_trap_add EXIT "rm -f ${log_pipe} && echo \"[ADDED by logger]: Removed temporary log pipe: ${log_pipe}\""

    tee -i "${log_file}" < "${log_pipe}" &
    exec > "${log_pipe}"
    exec 2>&1
}

# Private function to log messages
# USAGE:
#   __log_message "INFO" "\033[0;34m" "This is an info message"
# OUTPUT:
#   [18:32:50] [INFO    ] [logger.sh:72] This is an info message
function __log_message()
{
    local log_level="${1}"
    local color="${2}"
    local message="${3}"
    local timestamp
    local caller
    local file_name
    local line_number
    local color_reset="\033[0m"

    timestamp=$(date +"%H:%M:%S")
    caller=$(caller 1)
    file_name=${caller##*/}
    line_number=${caller%% *}

    local aligned_log_level
    local aligned_timestamp

    aligned_log_level=$(printf "%-8s" "${log_level}")
    aligned_timestamp=$(printf "%-8s" "${timestamp}")

    echo -e "[${aligned_timestamp}] [${color}${aligned_log_level}${color_reset}] [${file_name}:${line_number}] ${message}" 
}

function log_info()
{
    __log_message "INFO" "\033[0;34m" "${1}"
}

function log_error()
{
    __log_message "ERROR" "\033[0;31m"  "${1}"
}

function log_warning()
{
    __log_message "WARNING" "\033[0;33m" "${1}"
}

function log_debug()
{
    __log_message "DEBUG" "\033[0;36m" "${1}"
}

function log_critical()
{
    __log_message "CRITICAL" "\033[0;31m" "${1}"
}

function log_trace()
{
    __log_message "TRACE" "\033[0;36m" "${1}"
}

function log_fatal()
{
    __log_message "FATAL" "\033[0;31m" "${1}"
}

function log_success()
{
    __log_message "SUCCESS" "\033[0;32m" "${1}"
}

function log_failure()
{
    __log_message "FAILURE" "\033[0;31m" "${1}"
}

function log()
{
    __log_message "LOG" "\033[0;36m" "${1}"
}


# USAGE
# log_info "This is an info message"
# log_error "This is an error message"
# log_warning "This is a warning message"
# log_debug "This is a debug message"
# log_critical "This is a critical message"
# log_trace "This is a trace message"
# log_fatal "This is a fatal message"
# log_success "This is a success message"
# log_failure "This is a failure message"
# log "This is a log message"

# OUTPUT
# [18:32:50] [INFO    ] [logger.sh:72] This is an info message
# [18:32:50] [ERROR   ] [logger.sh:73] This is an error message
# [18:32:50] [WARNING ] [logger.sh:74] This is a warning message
# [18:32:50] [DEBUG   ] [logger.sh:75] This is a debug message
# [18:32:50] [CRITICAL] [logger.sh:76] This is a critical message
# [18:32:50] [TRACE   ] [logger.sh:77] This is a trace message
# [18:32:50] [FATAL   ] [logger.sh:78] This is a fatal message
# [18:32:50] [SUCCESS ] [logger.sh:79] This is a success message
# [18:32:50] [FAILURE ] [logger.sh:80] This is a failure message
# [18:32:50] [LOG     ] [logger.sh:81] This is a log message

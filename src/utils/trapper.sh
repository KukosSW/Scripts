#!/bin/bash

# Prevent double sourcing
if [[ -n "${TRAPPER_SOURCED:-}" ]]; then
    return 0
fi

export TRAPPER_SOURCED=1

set -Eeuo pipefail

# Get the directory of the current script
trapper_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the trap manager script
trap_manager_path="${trapper_dir}/../utils/trap_manager.sh"
if [[ -f "${trap_manager_path}" ]]; then
    # shellcheck source=/dev/null
    source "${trap_manager_path}"
else
    echo "Error: Could not find trap_manager.sh at ${trap_manager_path}"
    exit 1
fi

# Private function to print a message when a trap is triggered
# USAGE:
#   __trapper_message EXIT "Exiting..."
# OUTPUT:
#   [18:32:50] [TRAP EXIT    ] Exiting...
function __trapper_message()
{
    local trap_event="${1}"
    local message="${2}"
    local timestamp

    timestamp=$(date +"%H:%M:%S")

    local aligned_timestamp

    aligned_trap_event=$(printf "%-9s" "${trap_event}")
    aligned_timestamp=$(printf "%-8s" "${timestamp}")

    echo -e "[${aligned_timestamp}] [TRAP ${aligned_trap_event}] ${message}" 
}

# Capture the exit status in the EXIT trap
# Without this, the exit status will be always 0
# USAGE:
#   trapper_on_exit
# OUTPUT:
#   NO OUTPUT
function trapper_on_exit()
{
    local exit_status=$?
    __trapper_message EXIT "Script exited with code: '${exit_status}'"
}


# Common Signal Numbers and Names
# EXIT (0): Executes when the script exits, regardless of the exit status.
# SIGHUP (1): Terminal line hangup.
# SIGINT (2): Interrupt from keyboard (usually Ctrl+C).
# SIGQUIT (3): Quit from keyboard (usually Ctrl+).
# SIGILL (4): Illegal instruction.
# SIGTRAP (5): Trace/breakpoint trap.
# SIGABRT (6): Abort signal.
# SIGBUS (7): Bus error.
# SIGFPE (8): Floating-point exception.
# SIGKILL (9): Kill signal (cannot be trapped).
# SIGUSR1 (10): User-defined signal 1.
# SIGSEGV (11): Segmentation fault.
# SIGUSR2 (12): User-defined signal 2.
# SIGPIPE (13): Broken pipe: write to pipe with no readers.
# SIGALRM (14): Timer signal from alarm.
# SIGTERM (15): Termination signal.
# SIGSTKFLT (16): Stack fault on coprocessor (unused).
# SIGCHLD (17): Child stopped or terminated.
# SIGCONT (18): Continue if stopped.
# SIGSTOP (19): Stop process (cannot be trapped).
# SIGTSTP (20): Stop typed at terminal.
# SIGTTIN (21): Terminal input for background process.
# SIGTTOU (22): Terminal output for background process.
# SIGURG (23): Urgent condition on socket.
# SIGXCPU (24): CPU time limit exceeded.
# SIGXFSZ (25): File size limit exceeded.
# SIGVTALRM (26): Virtual alarm clock.
# SIGPROF (27): Profiling timer expired.
# SIGWINCH (28): Window size change.
# SIGIO (29): I/O now possible.
# SIGPWR (30): Power failure.
# SIGSYS (31): Bad system call.
# Special Traps
# DEBUG: Executes before every simple command, for debugging purposes.
# RETURN: Executes each time a shell function or a sourced script finishes executing.
# ERR: Executes whenever a command has a non-zero exit status (useful for error handling).

function trapper_enable()
{
    tm_trap_add EXIT trapper_on_exit

    tm_trap_add SIGHUP "__trapper_message SIGHUP \"Received SIGHUP signal. Exiting...\""
    # tm_trap_add SIGINT "__trapper_message SIGINT \"Received SIGINT signal. Exiting...\"" # Cannot be trapped
    tm_trap_add SIGQUIT "__trapper_message SIGQUIT \"Received SIGQUIT signal. Exiting...\""
    tm_trap_add SIGILL "__trapper_message SIGILL \"Received SIGILL signal. Exiting...\""
    tm_trap_add SIGTRAP "__trapper_message SIGTRAP \"Received SIGTRAP signal. Exiting...\""
    tm_trap_add SIGABRT "__trapper_message SIGABRT \"Received SIGABRT signal. Exiting...\""
    tm_trap_add SIGBUS "__trapper_message SIGBUS \"Received SIGBUS signal. Exiting...\""
    tm_trap_add SIGFPE "__trapper_message SIGFPE \"Received SIGFPE signal. Exiting...\""
    tm_trap_add SIGKILL "__trapper_message SIGKILL \"Received SIGKILL signal. Exiting...\""
    tm_trap_add SIGUSR1 "__trapper_message SIGUSR1 \"Received SIGUSR1 signal. Exiting...\""
    tm_trap_add SIGSEGV "__trapper_message SIGSEGV \"Received SIGSEGV signal. Exiting...\""
    tm_trap_add SIGUSR2 "__trapper_message SIGUSR2 \"Received SIGUSR2 signal. Exiting...\""
    tm_trap_add SIGPIPE "__trapper_message SIGPIPE \"Received SIGPIPE signal. Exiting...\""
    tm_trap_add SIGALRM "__trapper_message SIGALRM \"Received SIGALRM signal. Exiting...\""
    tm_trap_add SIGTERM "__trapper_message SIGTERM \"Received SIGTERM signal. Exiting...\""
    tm_trap_add SIGSTKFLT "__trapper_message SIGSTKFLT \"Received SIGSTKFLT signal. Exiting...\""
    # tm_trap_add SIGCHLD "__trapper_message SIGCHLD \"Received SIGCHLD signal. Exiting...\"" # Broken, infinite loop of messages on exit. Do not use.
    tm_trap_add SIGCONT "__trapper_message SIGCONT \"Received SIGCONT signal. Exiting...\""
    # tm_trap_add SIGSTOP "__trapper_message SIGSTOP \"Received SIGSTOP signal. Exiting...\"" # Cannot be trapped
    tm_trap_add SIGTSTP "__trapper_message SIGTSTP \"Received SIGTSTP signal. Exiting...\""
    tm_trap_add SIGTTIN "__trapper_message SIGTTIN \"Received SIGTTIN signal. Exiting...\""
    tm_trap_add SIGTTOU "__trapper_message SIGTTOU \"Received SIGTTOU signal. Exiting...\""
    tm_trap_add SIGURG "__trapper_message SIGURG \"Received SIGURG signal. Exiting...\""
    tm_trap_add SIGXCPU "__trapper_message SIGXCPU \"Received SIGXCPU signal. Exiting...\""
    tm_trap_add SIGXFSZ "__trapper_message SIGXFSZ \"Received SIGXFSZ signal. Exiting...\""
    tm_trap_add SIGVTALRM "__trapper_message SIGVTALRM \"Received SIGVTALRM signal. Exiting...\""
    tm_trap_add SIGPROF "__trapper_message SIGPROF \"Received SIGPROF signal. Exiting...\""
    tm_trap_add SIGWINCH "__trapper_message SIGWINCH \"Received SIGWINCH signal. Exiting...\""
    tm_trap_add SIGIO "__trapper_message SIGIO \"Received SIGIO signal. Exiting...\""
    tm_trap_add SIGPWR "__trapper_message SIGPWR \"Received SIGPWR signal. Exiting...\""
    tm_trap_add SIGSYS "__trapper_message SIGSYS \"Received SIGSYS signal. Exiting...\""
}
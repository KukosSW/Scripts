#!/bin/bash

set -Eu

# Get the directory of the current script
test_trapper_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the trapper script
trapper_path="${test_trapper_dir}/../src/utils/trapper.sh"
if [[ -f "${trapper_path}" ]]; then
    # shellcheck source=/dev/null
    source "${trapper_path}"
else
    echo "Error: Could not find trapper.sh at ${trapper_path}"
    exit 1
fi

function test_trapper_exit()
{
    local temp_output
    temp_output=$(mktemp -u)

    (
        trapper_enable
        exit 0
    ) > "${temp_output}" 2>&1 &

    wait

    if grep -q "TRAP EXIT" "${temp_output}"; then
        echo "TEST: test_trapper_exit: PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_trapper_exit: FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function __test_trapper_event()
{
    local event="${1}"
    local temp_output
    temp_output=$(mktemp -u)

    (
        trapper_enable
        sleep 2
        exit 0
    ) > "${temp_output}" 2>&1 &

    local subschell_pid=$!
    sleep 1
    kill -"${event}" "${subschell_pid}"

    wait "${subschell_pid}" || true

    if grep -q "TRAP ${event}" "${temp_output}"; then
        echo "TEST: test_trapper_event(${event}): PASSED"
        rm -f "${temp_output}"
    else
        echo "TEST: test_trapper_event(${event}): FAILED"
        rm -f "${temp_output}"
        exit 1
    fi
}

function test_trapper_sighup()
{
    __test_trapper_event "SIGHUP"
}

function test_trapper_sigquit()
{
    __test_trapper_event "SIGQUIT"
}

function test_trapper_sigill()
{
    __test_trapper_event "SIGILL"
}

function test_trapper_sigtrap()
{
    __test_trapper_event "SIGTRAP"
}

function test_trapper_sigabrt()
{
    __test_trapper_event "SIGABRT"
}

function test_trapper_sigfpe()
{
    __test_trapper_event "SIGFPE"
}

# Cannot be tested, as it kills the process
# function test_trapper_sigkill()
# {
#     __test_trapper_event "SIGKILL"
# }

function test_trapper_sigusr1()
{
    __test_trapper_event "SIGUSR1"
}

function test_trapper_sigsegv()
{
    __test_trapper_event "SIGSEGV"
}

function test_trapper_sigusr2()
{
    __test_trapper_event "SIGUSR2"
}

# Cannot be tested, as it broke the pipe
# function test_trapper_sigpipe()
# {
#     __test_trapper_event "SIGPIPE"
# }

function test_trapper_sigalrm()
{
    __test_trapper_event "SIGALRM"
}

function test_trapper_sigterm()
{
    __test_trapper_event "SIGTERM"
}

function test_trapper_sigstkflt()
{
    __test_trapper_event "SIGSTKFLT"
}

# Cannot be tested, as it kills the process
# function test_trapper_sigchld()
# {
#     __test_trapper_event "SIGCHLD"
# }

function test_trapper_sigcont()
{
    __test_trapper_event "SIGCONT"
}

function test_trapper_sigtstp()
{
    __test_trapper_event "SIGTSTP"
}

function test_trapper_sigttin()
{
    __test_trapper_event "SIGTTIN"
}

function test_trapper_sigttou()
{
    __test_trapper_event "SIGTTOU"
}

function test_trapper_sigurg()
{
    __test_trapper_event "SIGURG"
}

function test_trapper_sigxcpu()
{
    __test_trapper_event "SIGXCPU"
}

function test_trapper_sigxfsz()
{
    __test_trapper_event "SIGXFSZ"
}

function test_trapper_sigvtalrm()
{
    __test_trapper_event "SIGVTALRM"
}

function test_trapper_sigprof()
{
    __test_trapper_event "SIGPROF"
}

function test_trapper_sigwinch()
{
    __test_trapper_event "SIGWINCH"
}

function test_trapper_sigio()
{
    __test_trapper_event "SIGIO"
}

function test_trapper_sigpwr()
{
    __test_trapper_event "SIGPWR"
}

function test_trapper_sigsys()
{
    __test_trapper_event "SIGSYS"
}

function test_suite_trapper()
{
    test_trapper_exit
    test_trapper_sighup
    test_trapper_sigquit
    test_trapper_sigill
    test_trapper_sigtrap
    test_trapper_sigabrt
    test_trapper_sigfpe
    test_trapper_sigusr1
    test_trapper_sigsegv
    test_trapper_sigusr2
    test_trapper_sigalrm
    test_trapper_sigterm
    test_trapper_sigstkflt
    test_trapper_sigcont
    test_trapper_sigtstp
    test_trapper_sigttin
    test_trapper_sigttou
    test_trapper_sigurg
    test_trapper_sigxcpu
    test_trapper_sigxfsz
    test_trapper_sigvtalrm
    test_trapper_sigprof
    test_trapper_sigwinch
    test_trapper_sigio
    test_trapper_sigpwr
    test_trapper_sigsys
}
#!/bin/bash

set -Eu

# Get the directory of the current script
test_trap_manager_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the trap manager script
trap_manager_path="${test_trap_manager_dir}/../src/utils/trap_manager.sh"
if [[ -f "${trap_manager_path}" ]]; then
    # shellcheck source=/dev/null
    source "${trap_manager_path}"
else
    echo "Error: Could not find trap_manager.sh at ${trap_manager_path}"
    exit 1
fi

function test_tm_single_trap_exit()
{
    local trap_executed
    trap_executed=$(mktemp -u)
    rm -f "${trap_executed}"

    (
        tm_trap_add EXIT "touch ${trap_executed}"
        exit 0
    ) &

    wait

    if [[ -f "${trap_executed}" ]]; then
        echo "TEST: test_tm_single_trap_exit: PASSED"
        rm -f "${trap_executed}"
    else
        echo "TEST: test_tm_single_trap_exit: FAILED"
        exit 1
    fi
}

function test_tm_double_trap_exit()
{
    local trap_executed_1
    local trap_executed_2

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add EXIT "touch ${trap_executed_2}"
        exit 0
    ) &

    wait

    if [[ -f "${trap_executed_1}" && -f "${trap_executed_2}" ]]; then
        echo "TEST: test_tm_double_trap_exit: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
    else
        echo "TEST: test_tm_double_trap_exit: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        exit 1
    fi
}

function test_tm_single_trap_removed_exit()
{
    local trap_executed_1
    local trap_executed_2

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_remove EXIT
        tm_trap_add EXIT "touch ${trap_executed_2}"
        exit 0
    ) &

    wait

    if [[ -f "${trap_executed_2}" && ! -f "${trap_executed_1}" ]]; then
        echo "TEST: test_tm_single_trap_removed_exit: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
    else
        echo "TEST: test_tm_single_trap_removed_exit: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        exit 1
    fi
}

function test_tm_double_trap_removed_exit()
{
    local trap_executed_1
    local trap_executed_2

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add EXIT "touch ${trap_executed_2}"
        tm_trap_remove EXIT
        exit 0
    ) &

    wait

    if [[ ! -f "${trap_executed_2}" && ! -f "${trap_executed_1}" ]]; then
        echo "TEST: test_tm_double_trap_removed_exit: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
    else
        echo "TEST: test_tm_double_trap_removed_exit: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        exit 1
    fi
}

function test_tm_single_trap_exit_err()
{
    local trap_executed_1
    local trap_executed_2

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add ERR "touch ${trap_executed_2}"
        false
        exit 1
    ) &

    wait

    if [[ -f "${trap_executed_1}" && -f "${trap_executed_2}" ]]; then
        echo "TEST: test_tm_single_trap_exit_err: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
    else
        echo "TEST: test_tm_single_trap_exit_err: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        exit 1
    fi
}

function test_tm_single_trap_exit_double_err()
{
    local trap_executed_1
    local trap_executed_2
    local trap_executed_3

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    trap_executed_3=$(mktemp -u)
    rm -f "${trap_executed_3}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add ERR "touch ${trap_executed_2}"
        tm_trap_add ERR "touch ${trap_executed_3}"
        false
        exit 1
    ) &

    wait

    if [[ -f "${trap_executed_1}" && -f "${trap_executed_2}" && -f "${trap_executed_3}" ]]; then
        echo "TEST: test_tm_single_trap_exit_double_err: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"

    else
        echo "TEST: test_tm_single_trap_exit_double_err: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"
        exit 1
    fi
}

function test_tm_single_trap_exit_err_sigusr()
{
    local trap_executed_1
    local trap_executed_2
    local trap_executed_3

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    trap_executed_3=$(mktemp -u)
    rm -f "${trap_executed_3}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add ERR "touch ${trap_executed_2}"
        tm_trap_add SIGUSR1 "touch ${trap_executed_3}"
        
        sleep 2
        false 
        exit 1
    ) &
    local subschell_pid=$!
    sleep 1
    kill -USR1 "${subschell_pid}"
    wait "${subschell_pid}" || true

    if [[ -f "${trap_executed_1}" && -f "${trap_executed_2}" && -f "${trap_executed_3}" ]]; then
        echo "TEST: test_tm_single_trap_exit_err_sigterm: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"

    else
        echo "TEST: test_tm_single_trap_exit_err_sigterm: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"
        exit 1
    fi
}

function test_tm_single_trap_exit_double_err_removed()
{
    local trap_executed_1
    local trap_executed_2
    local trap_executed_3

    trap_executed_1=$(mktemp -u)
    rm -f "${trap_executed_1}"

    trap_executed_2=$(mktemp -u)
    rm -f "${trap_executed_2}"

    trap_executed_3=$(mktemp -u)
    rm -f "${trap_executed_3}"

    (
        tm_trap_add EXIT "touch ${trap_executed_1}"
        tm_trap_add ERR "touch ${trap_executed_2}"
        tm_trap_add ERR "touch ${trap_executed_3}"

        tm_trap_remove ERR
        
        false
        exit 1
    ) &

    wait

    if [[ -f "${trap_executed_1}" && ! -f "${trap_executed_2}" && ! -f "${trap_executed_3}" ]]; then
        echo "TEST: test_tm_single_trap_exit_double_err_removed: PASSED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"

    else
        echo "TEST: test_tm_single_trap_exit_double_err_removed: FAILED"
        rm -f "${trap_executed_1}"
        rm -f "${trap_executed_2}"
        rm -f "${trap_executed_3}"
        exit 1
    fi
}

function test_suite_trap_manager()
{
    test_tm_single_trap_exit
    test_tm_double_trap_exit
    test_tm_single_trap_removed_exit
    test_tm_double_trap_removed_exit
    test_tm_single_trap_exit_err
    test_tm_single_trap_exit_double_err
    test_tm_single_trap_exit_err_sigusr
    test_tm_single_trap_exit_double_err_removed
}
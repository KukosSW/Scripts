#!/bin/bash

set -Eu

# Get the directory of the current script
test_git_config_mkukowski_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the git config script
git_config_path="${test_git_config_mkukowski_dir}/../src/settings/git/git_config_mkukowski.sh"
if [[ -f "${git_config_path}" ]]; then
    # shellcheck source=/dev/null
    source "${git_config_path}" > /dev/null
else
    echo "Error: Could not find git_config_mkukowski.sh at ${git_config_path}"
    exit 1
fi

function test_git_config_user()
{
    if git config --list | grep -q "user.name=Michal Kukowski" && git config --list | grep -q "user.email=kukossw@gmail.com"; then
        echo "TEST: test_git_config_user PASSED"
    else
        echo "TEST: test_git_config_user: FAILED"
        exit 1
    fi
}

function test_git_config_smtp()
{
    if git config --list | grep -q "sendemail.smtpuser=kukossw@gmail.com"; then
        echo "TEST: test_git_config_smtp PASSED"
    else
        echo "TEST: test_git_config_smtp: FAILED"
        exit 1
    fi
}

function test_git_config_core()
{
    if git config --list | grep -q "core.editor=nvim"; then
        echo "TEST: test_git_config_core PASSED"
    else
        echo "TEST: test_git_config_core: FAILED"
        exit 1
    fi
}

function test_git_config_alias()
{
    if git config --list | grep -q "alias.sts=status --short --branch"; then
        echo "TEST: test_git_config_alias PASSED"
    else
        echo "TEST: test_git_config_alias: FAILED"
        exit 1
    fi
}

function test_suite_git_config_mkukowski()
{
    # We need to unset exit trap
    # Trap has been set in the git_config_mkukowski.sh
    # Tests should be run without any additional prints
    trap - EXIT

    test_git_config_user
    test_git_config_smtp
    test_git_config_core
    test_git_config_alias

    # Logger is sourced in git_config_mkukowski.sh
    # We need to clean up the logger files
    rm -f logger_*
}

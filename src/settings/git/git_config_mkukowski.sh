#!/bin/bash

set -euo pipefail

# Prevent double sourcing
if [[ -n "${LOGGER_SOURCED:-}" ]]; then
    return 0
fi

# source logger.sh
git_config_mkukowski_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Source the logger script
logger_path="${git_config_mkukowski_dir}/../../logger/logger.sh"
if [[ -f "${logger_path}" ]]; then
    # shellcheck source=/dev/null
    source "${logger_path}"
else
    echo "Error: Could not find logger.sh at ${logger_path}"
    exit 1
fi

# Source the trapper script
trapper_path="${git_config_mkukowski_dir}/../../utils/trapper.sh"
if [[ -f "${trapper_path}" ]]; then
    # shellcheck source=/dev/null
    source "${trapper_path}"
else
    echo "Error: Could not find trapper.sh at ${trapper_path}"
    exit 1
fi

function git_config_user_mkukowski_kukossw()
{
    log_info "Setting up user name and email"

    git config --global user.name "Michal Kukowski"
    git config --global user.email "kukossw@gmail.com"

    log_success "User name and email set up successfully"
}

function git_config_sendemail_mkukowski_kukossw()
{
    log_info "Setting up sendemail configuration"

    git config --global sendemail.smtpuser "kukossw@gmail.com"
    git config --global sendemail.smtpserver "smtp.gmail.com"
    git config --global sendemail.smtpserverport "587"
    git config --global sendemail.smtpencryption "tls"

    log_success "Sendemail configuration set up successfully"
}

function git_config_core()
{
    log_info "Setting up core configuration"

    git config --global core.editor "nvim"

    log_success "Core configuration set up successfully"
}

function git_config_aliases()
{
    log_info "Setting up aliases"

    git config --global alias.ci 'commit'
    git config --global alias.cim 'commit -m'
    git config --global alias.ca 'commit --amend'
    git config --global alias.caa 'commit --amend --no-edit'
    git config --global alias.pu 'push'
    git config --global alias.puf 'push --force'
    git config --global alias.st 'status'
    git config --global alias.sts 'status --short --branch'
    git config --global alias.res 'reset HEAD --'
    git config --global alias.co 'checkout'
    git config --global alias.cob 'checkout -b'
    git config --global alias.cp 'cherry-pick'
    git config --global alias.cpn 'cherry-pick -n'
    git config --global alias.br 'branch'
    git config --global alias.df 'diff'
    git config --global alias.dc 'diff --cached'
    git config --global alias.un 'reset --hard HEAD'
    git config --global alias.resh 'reset --hard ^HEAD'
    git config --global alias.lg 'log --oneline --decorate --all --graph'
    git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --numstat'
    git config --global alias.ld 'log --pretty=format:"%C(yellow)%h\\ %C(green)%ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short --graph'
    git config --global alias.ls 'log --pretty=format:"%C(green)%h\\ %C(yellow)[%ad]%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=relative'
    git config --global alias.show 'show --pretty="format:" --name-only'
    git config --global alias.cfglog 'config --list --show-origin --show-scope'
    git config --global alias.cfgalias 'config --get-regexp alias'

    log_success "Aliases set up successfully"
}

logger_enable_file_logger
log_info "Setting up git configuration for Michal Kukowski (kukossw@gmail.com)"

git_config_user_mkukowski_kukossw
git_config_sendemail_mkukowski_kukossw
git_config_core
git_config_aliases

log_success "Git configuration completed successfully"

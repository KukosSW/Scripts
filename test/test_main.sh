#!/bin/bash

set -euo pipefail

# Get the directory of the current script
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Run ShellCheck first
"${dir}"/../test/test_shellcheck.sh

# Source the trap manager script
test_trap_manager_path="${dir}/../test/test_trap_manager.sh"
if [[ -f "${test_trap_manager_path}" ]]; then
    # shellcheck source=/dev/null
    source "${test_trap_manager_path}"
else
    echo "Error: Could not find trap_manager.sh at ${test_trap_manager_path}"
    exit 1
fi

test_suite_trap_manager
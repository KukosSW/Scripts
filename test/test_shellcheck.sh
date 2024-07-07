#!/bin/bash

set -euo pipefail

# Get the directory of the current script
test_shellcheck_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../src/utils/trap_manager.sh"
shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../src/utils/trapper.sh"
shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../src/logger/logger.sh"


shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../test/test_trap_manager.sh"
shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../test/test_trapper.sh"
shellcheck --shell=bash --enable=all --check-sourced --external-sources "${test_shellcheck_dir}/../test/test_logger.sh"
#!/bin/bash

# Prevent double sourcing
if [[ -n "${TRAP_MANAGER_SOURCED:-}" ]]; then
    return 0
fi

export TRAP_MANAGER_SOURCED=1

set -Eu

# This function works perfectly for EXIT trap, but not for the ERR trap
# trap -p ERR was not giving me the current trap, so I had to use a different approach
# function tm_trap_add()
# {
#     local event="${1}"
#     local new_trap="${2}"
#     local current_trap

#     current_trap=$(trap -p "${event}" | awk -F"'" '{print $2}')

#     # Use single quotes, otherwise this expands now rather than when signalled
#     if [[ -n "${current_trap}" ]]; then
#         eval "trap '${current_trap}; ${new_trap}' ${event}"
#     else
#         # shellcheck disable=SC2064
#         trap "${new_trap}" "${event}"
#     fi

# }



# Declare associative arrays to store traps
declare -A tm_trap_map

# Function to add a trap to an event
# USAGE:
#   tm_trap_add EXIT echo "Exiting..."
# OUTPUT:
#   NO OUTPUT
function tm_trap_add()
{
    local event="${1}"
    local new_trap="${2}"

    if [[ -n "${tm_trap_map[${event}]:-}" ]]; then
        tm_trap_map[${event}]="${tm_trap_map[${event}]}; ${new_trap}"
    else
        tm_trap_map[${event}]="${new_trap}"
    fi

    eval "trap '${tm_trap_map[${event}]}' ${event}"
}


# function tm_trap_remove()
# {
#     local event="${1}"
#     local current_trap

#     current_trap=$(trap -p "${event}" | awk -F"'" '{print $2}')

#     if [[ -n "${current_trap}" ]]; then
#         trap - "${event}"
#     fi
# }

# Function to remove a trap from an event
# USAGE:
#   tm_trap_remove EXIT
# OUTPUT:
#   NO OUTPUT
function tm_trap_remove()
{
    local event="${1}"
    unset "tm_trap_map[${event}]"
    trap - "${event}"
}
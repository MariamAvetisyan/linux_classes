#!/bin/bash

# Function to validate an IPv4 address
is_valid_ipv4() {
    local ip=$1

    # Split the IP into its components
    IFS='.' read -r -a octets <<< "$ip"

    # Check the number of octets
    if [ "${#octets[@]}" -ne 4 ]; then
        echo "$ip is NOT a valid IPv4 address. It must have 4 octets."
        return
    fi

    # Validate each octet
    for i in "${!octets[@]}"; do
        local octet=${octets[i]}

        # Check if the octet is a number and within the valid range
        if ! [[ $octet =~ ^[0-9]+$ ]]; then
            echo "$ip is NOT a valid IPv4 address. Octet ${i+1} ('$octet') is not a number."
            return
        fi

        if [ "$i" -eq 0 ] && [ "$octet" -eq 0 ]; then
            echo "$ip is NOT a valid IPv4 address. The first octet cannot be 0."
            return
        fi

        if [ "$octet" -gt 255 ]; then
            echo "$ip is NOT a valid IPv4 address. Octet ${i+1} ('$octet') exceeds 255."
            return
        fi

        if [[ $octet =~ ^0 ]]; then
            echo "$ip is NOT a valid IPv4 address. Octet ${i+1} ('$octet') cannot have leading zeros."
            return
        fi
    done

    echo "$ip is a valid IPv4 address."
}

# Check if the user provided an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <IP_ADDRESS>"
    exit 1
fi

# Call the validation function with the provided argument
is_valid_ipv4 "$1"


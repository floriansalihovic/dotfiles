
#!/bin/bash

# Function to read password from macOS Keychain
# Usage: get_keychain_password "secret_name"
# Requires: USER environment variable to be set
get_keychain_password() {
    local secret_name="$1"
    
    # Check if secret name is provided
    if [[ -z "$secret_name" ]]; then
        echo "Error: Secret name is required" >&2
        return 1
    fi
    
    # Check if USER environment variable is set
    if [[ -z "$USER" ]]; then
        echo "Error: USER environment variable is not set" >&2
        return 1
    fi
    
    # Read password from keychain
    # -s: service name (using the secret name as service)
    # -a: account name (using the USER environment variable)
    # -w: output only the password
    security find-generic-password -s "$secret_name" -a "$USER" -w 2>/dev/null
    
    # Check if the command was successful
    if [[ $? -ne 0 ]]; then
        echo "Error: Could not find password for service '$secret_name' and account '$USER'" >&2
        return 1
    fi
}

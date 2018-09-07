#!/bin/bash -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <APP> [<exectuable ...>]"
    exit 1
fi

[ -z ${ROLE_ID} ] && ( echo "Missing ROLE_ID environment variable" && exit 1 )
[ -z ${SECRET_ID} ] && ( echo "Missing SECRET_ID environment variable" && exit 1 )
[ -z ${VAULT_URL} ] && ( echo "Missing VAULT_URL environment variable" && exit 1 )

SECRET_BASE_URL="${VAULT_URL}/v1/"
SECRET_PATH=$1
shift

TOKEN=$(curl -Ls --request POST \
             --data "{ \"role_id\": \"${ROLE_ID}\", \"secret_id\": \"${SECRET_ID}\" }" \
             ${VAULT_URL}/v1/auth/approle/login | jq -r .auth.client_token)

RESULT=$(curl -Ls --header "X-Vault-Token: $TOKEN" "${SECRET_BASE_URL}/${SECRET_PATH}")


VARIABLES=$( echo "${RESULT}" | jq -r ".data | to_entries[] | \"export '\(.key)'='\(.value)'\"" )

if [ $# -ne 0 ]; then
    echo "sourcing..."
    source <( echo ${VARIABLES} )
    echo "running..."
    exec $@
else
    echo "${VARIABLES}"
fi

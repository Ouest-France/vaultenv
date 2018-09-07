# vaultenv

This is designed to pull secrets from vault and exposes them as environment variables.
The vault configuration is based on environment variables that are provided by the instigator (CI, Kubernetes, Helm, ...)

    export ROLE_ID="e7e26076-91d9-bb59-fae8-af0f49dc2931"
    export SECRET_ID="8e5e7961-6d10-455e-f5e8-1307f60d6817"
    export VAULT_URL="https://vault.aws-sipa.ouest-france.fr"
    source <( ./vault-env.sh path/to/secrets )



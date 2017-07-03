#!/bin/bash
VERSION=$1

function usage {
    echo -e "
    USAGE EXAMPLES:

        ./$(basename $0) 0.8.7
        ./$(basename $0) 0.9.2
    "
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

EXISTING_VAULT_VERSION=$(vault version | head -n1 | awk '{print $2}' | sed 's/v//g')

if [ "${EXISTING_VAULT_VERSION}" != "${VERSION}" ]; then
    echo "-) You are trying to update this script for vault ${VERSION} while you have"
    echo "   vault ${EXISTING_VAULT_VERSION} installed at $(which vault)."
    echo "   Please update your local vault before using this script."
    exit 1
fi

echo "+) Acquiring vault-${VERSION}"
wget https://github.com/hashicorp/vault/archive/v${VERSION}.tar.gz

echo "+) Extracting vault-${VERSION}.tar.gz"
tar zxf v${VERSION}.tar.gz

echo "+) Running update_commands.rb"
./update_commands.rb

echo "+) Updating the badge in the README.md"
sed -i "/img.shields.io/c\[\![](https://img.shields.io/badge/Supports%20Vault%20Version-${VERSION}-blue.svg)](https://github.com/hashicorp/Vault/blob/v${VERSION}/CHANGELOG.md)" README.md

echo "+) Cleaning up after ourselves"
rm -f v${VERSION}.tar.gz
rm -rf vault-${VERSION}

git status

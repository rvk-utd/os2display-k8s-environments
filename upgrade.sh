#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
source _variables.source

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${SCRIPT_DIR}"

if [[ $# -eq 0 ]] ; then
    echo "Syntax: $0 <environment>"
    exit 1
fi

ENV=$1
ENV_STATE_DIR="${SCRIPT_DIR}/state/${ENV}"
RELEASE_NAME="${ENVIRONMENT_PREFIX}-${ENV}"
VALUES_PATH="${ENV_STATE_DIR}/values.yaml"
SECRETS_PATH="${ENV_STATE_DIR}/secrets.yaml"

if [[ ! -f "${VALUES_PATH}" ]] ; then
    echo "Missing values-file ${VALUES_PATH}"
    exit 1
fi

if [[ -f "${SECRETS_PATH}" ]] ; then
    echo "Secrets-file detected at ${SECRETS_PATH}, it should be removed!"
    exit 1
fi

echo "Upgrading ${ENV}."
echo
echo "Will"
echo "- Do a helm upgrade of ${RELEASE_NAME} using the values from ${VALUES_PATH} using the chart ${CHART_PATH}"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborting"
    exit 1
fi

echo "Upgrading the $ENV environment - waiting for all assets to be upgraded..."
# By using --reuse-values we don't have to supply the secrets used in the
# initial installation of the environment.
helm upgrade \
  --namespace="${RELEASE_NAME}" \
  --values="${VALUES_PATH}" \
  --wait \
  --reuse-values \
  "${RELEASE_NAME}" "${CHART_PATH}" 

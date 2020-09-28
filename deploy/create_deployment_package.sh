#!/bin/bash
# This script is used to build project and create lambda deployment package

while getopts ":d:n:" opt; do
    case $opt in
        d) DEPLOYMENT_PACKAGE_PATH=$OPTARG ;;
        n) DEPLOYMENT_PACKAGE_NAME=$OPTARG ;;
    esac
done

function die () {
    echo -e >&2 "$@"
    exit 1
}

# Input argument checks
if [[ ${DEPLOYMENT_PACKAGE_PATH} == "" || ${DEPLOYMENT_PACKAGE_NAME} == "" ]]; then
    die "[ERROR] One or more required input values (DEPLOYMENT_PACKAGE_PATH, DEPLOYMENT_PACKAGE_NAME) are not passed as arguments to this script. Aborting the execution..."
fi

npm install -g typescript
npm install
tsc

cp -r ./node_modules ${DEPLOYMENT_PACKAGE_PATH}/
zip -r ${DEPLOYMENT_PACKAGE_PATH}/${DEPLOYMENT_PACKAGE_NAME} ${DEPLOYMENT_PACKAGE_PATH}/

ls -la ${DEPLOYMENT_PACKAGE_PATH}/${DEPLOYMENT_PACKAGE_NAME}
if [[ $? == 0 ]]; then
    echo "Deployment package has been created successfully!"
else
    echo "Error when creating deployment package!"
fi
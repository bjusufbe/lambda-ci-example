#!/bin/bash
# This script is used to create new or update existing lambda function

while getopts ":f:d:r:a:h:m:" opt; do
    case $opt in
        f) FUNCTION_NAME=$OPTARG ;;
        d) DEPLOYMENT_PACKAGE=$OPTARG ;;
        r) REGION=$OPTARG ;;
        a) ROLE_ARN=$OPTARG ;;
        h) HANDLER_NAME=$OPTARG ;;
        m) MODE=$OPTARG ;;
    esac
done

function die () {
    echo -e >&2 "$@"
    exit 1
}

# Input argument checks
if [[ ${FUNCTION_NAME} == "" || ${DEPLOYMENT_PACKAGE} == "" || ${REGION} == "" ]]; then
    die "[ERROR] One or more required input values (FUNCTION_NAME, DEPLOYMENT_PACKAGE, REGION) are not passed as arguments to this script. Aborting the execution..."
fi

RESULT=""
if [[ ${MODE} != "create" && ${MODE} != "update" ]]; then
    die "[ERROR] Please specify correct mode (create or update). Aborting the execution..."
else
    if [[ ${MODE} == "create" ]]; then
        if [[ ${HANDLER_NAME} == "" || ${ROLE_ARN} == "" ]]; then
            die "[ERROR] One or more required input values (HANDLER_NAME, ROLE_ARN) for mode ${MODE} are not passed as arguments to this script. Aborting the execution..."
        else
            RESULT=`aws lambda create-function --region ${REGION} --function-name ${FUNCTION_NAME} --runtime nodejs12.x --role ${ROLE_ARN} --handler ${HANDLER_NAME} --zip-file fileb://${DEPLOYMENT_PACKAGE}/ | jq '.LastUpdateStatus'`
        fi
    else 
        RESULT=`aws lambda update-function-code --region ${REGION} --function-name ${FUNCTION_NAME} --zip-file fileb://${DEPLOYMENT_PACKAGE} | jq '.LastUpdateStatus'`
    fi
fi

if [[ ${RESULT} == '"Successful"' ]]; then
    echo "AWS lambda function ${FUNCTION_NAME} has been created/updated successfully!"
else
    echo "Error when creating/updating lambda function: ${FUNCTION_NAME}!"
fi
#!/bin/bash
# This script is used to invoke specific lambda function and render execution results

while getopts ":f:r:p:" opt; do
    case $opt in
        f) FUNCTION_NAME=$OPTARG ;;
        r) REGION=$OPTARG ;;
        p) PAYLOAD=$OPTARG ;;
    esac
done

function die () {
    echo -e >&2 "$@"
    exit 1
}

# Input argument checks
RESULT=""
OUTPUT=""
if [[ ${FUNCTION_NAME} == "" || ${REGION} == "" || ${PAYLOAD} == "" ]]; then
    die "[ERROR] One or more required input values (FUNCTION_NAME, REGION, PAYLOAD) are not passed as arguments to this script. Aborting the execution..."
else
    RESULT=`aws lambda invoke --region ${REGION} --function-name ${FUNCTION_NAME} --payload ${PAYLOAD} output.json`
    OUTPUT=`cat output.json`
fi

if [[ ${RESULT} ~= "200" ]]; then
    echo -e "AWS lambda function ${FUNCTION_NAME} has been executed successfully!\n  \n${OUTPUT}"
else
    echo "Error when executing lambda function: ${FUNCTION_NAME}!"
fi
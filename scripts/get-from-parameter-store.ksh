#!/usr/bin/env bash
#
# A helper to extract a parameter from the parameter store
#

#set -x

function show_use_and_exit {
   echo "use: $(basename $0) <parameter name>" >&2
   exit 1
}

# show the error message and exit
function error_and_exit {
   echo "$*" >&2
   exit 1
}

function ensure_tool_available {

   local TOOL_NAME=$1
   which $TOOL_NAME > /dev/null 2>&1
   res=$?
   if [ $res -ne 0 ]; then
      error_and_exit "$TOOL_NAME is not available in this environment"
   fi
}

# ensure correct usage
if [ $# -lt 1 ]; then
   show_use_and_exit
fi

# input parameters for clarity
PARAM_NAME=$1
shift

# check our environment requirements
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
   error_and_exit "AWS_ACCESS_KEY_ID is not defined in the environment"
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
   error_and_exit "AWS_SECRET_ACCESS_KEY is not defined in the environment"
fi
if [ -z "$AWS_DEFAULT_REGION" ]; then
   error_and_exit "AWS_DEFAULT_REGION is not defined in the environment"
fi

# ensure we have the necessary tools available
AWS_TOOL=aws
ensure_tool_available $AWS_TOOL

# get the parameter value
VALUE=$($AWS_TOOL ssm get-parameter --name $PARAM_NAME | grep "Value" | awk -F\" '{print $4}')

# ensure we got a value
if [ -z "$VALUE" ]; then
      error_and_exit "$PARAM_NAME is not defined"
fi

echo $VALUE

# all over
exit 0

#
# end of file
#

#!/usr/bin/env bash
#
# A helper to update the tag files to the latest build numbers
#

DIR=$(dirname $0)

#set -x

# define the list of services we are interested in
SERVICES="emma"

# for each service
for service in $SERVICES; do

   echo "Checking latest $service version..."
   $DIR/get-from-parameter-store.ksh /containers/uvalib/$service/latest > tags/$service.tag
   res=$?
   if [ $res -ne 0 ]; then
      exit $res
   fi

done

exit 0

#
# end of file
#

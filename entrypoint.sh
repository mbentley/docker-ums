#!/bin/sh

# check to see if ${FOLDER} has been passed
if [ -n "${FOLDER}" ]
then
  echo "INFO  $(date +"%H:%M:%S.%3N") [entrypoint] Setting media folder to '${FOLDER}'"
  # append the FOLDER variable data in the UMS.conf
  sed -i "s+^folders =$+folders = ${FOLDER}+g" /opt/ums/UMS.conf
fi

# hack: add /opt/ums/linux to path
echo "INFO  $(date +"%H:%M:%S.%3N") [entrypoint] Adding '/opt/ums/linux' to the PATH"
export PATH="$PATH:/opt/ums/linux"

# output message about ending entrypoint
echo "INFO  $(date +"%H:%M:%S.%3N") [entrypoint] Launching command '${*}'"
exec "${@}"

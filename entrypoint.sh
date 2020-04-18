#!/bin/bash

# function to provide some standard output
console_output() {
  echo -e "${1}  $(date +"%H:%M:%S.%3N") [entrypoint] ${2}"
}

# check to see if the FOLDER env var has been passed
if [ -n "${FOLDER}" ]
then
  console_output INFO "Setting media folder to '${FOLDER}'"

  # append the FOLDER variable data in the UMS.conf
  sed -i "s+^folders =$+folders = ${FOLDER}+g" /opt/ums/UMS.conf

  # check to see if we should set the permissions for the FOLDER
  if [ "${SET_MEDIA_PERMISSIONS}" = "true" ]
  then
    console_output INFO "SET_MEDIA_PERMISSIONS=true; setting 'o+rx' on '${FOLDER}'"
    chmod -R o+rx "${FOLDER}"
  fi
fi

# make sure permissions are set appropriately on each file/directory
for FILEorDIR in UMS.conf UMS.cred data database
do
  # make sure the file or directory exists before performing permission check; skip if it doesn't exists
  if [ -a "/opt/ums/${FILEorDIR}" ]
  then
    # get the owner and group
    OWNER="$(stat -c '%u' /opt/ums/${FILEorDIR})"
    GROUP="$(stat -c '%g' /opt/ums/${FILEorDIR})"

    # check to see if permissions are incorrect or FORCE_CHOWN=true
    if [ "${OWNER}" != "500" ] || [ "${GROUP}" != "500" ] || [ "${FORCE_CHOWN}" = "true" ]
    then
      # special output if FORCE_CHOWN=true
      if [ "${FORCE_CHOWN}" = "true" ]
      then
        # FORCE_CHOWN=true
        console_output INFO "FORCE_CHOWN=true; setting ownership on '/opt/ums/${FILEorDIR}' to (500:500)"
      else
        # permissions are just incorrect; notify user that uid:gid are not correct and fix them
        console_output WARN "ownership not correct on '/opt/ums/${FILEorDIR}' (${OWNER}:${GROUP}); setting correct ownership (500:500)"
      fi

      # change ownership
      chown -R 500:500 "/opt/ums/${FILEorDIR}"
    else
      console_output INFO "ownership is correct on '/opt/ums/${FILEorDIR}'"
    fi
  fi
done

# hack: add /opt/ums/linux to path
console_output INFO "Adding '/opt/ums/linux' to the PATH"
export PATH="$PATH:/opt/ums/linux"

# output message about ending entrypoint
console_output INFO "Launching command '${*}' as user ums"
exec gosu ums "${@}"
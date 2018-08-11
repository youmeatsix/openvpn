#!/bin/bash

declare -r REQUIRED_FILES="client.crt client.key ca.crt"
declare -r CLIENT_CONFIG_LOCATION=/share/openvpnclient

# create the tunnel for the openvpn client
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

cd /

jq --raw-output '.ovpn-config' /options.json > ${CLIENT_CONFIG_LOCATION}/client.ovpn

chmod 777 ${CLIENT_CONFIG_LOCATION}/client.ovpn


# therefore, wait until the user upload the required certification files
while true; do

    failed=0
    for file in ${REQUIRED_FILES}
    do
        if [[ ! -f ${CLIENT_CONFIG_LOCATION}/${file} ]]
        then
            failed=1
            break
        fi
    done

    if [[ ${failed} == 0 ]]
    then
        break
    fi

    sleep 5
done

# star the client
openvpn --config ${CLIENT_CONFIG_LOCATION}/client.ovpn
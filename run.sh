#!/bin/bash

CLIENT_CONFIG_LOCATION=/share/openvpnclient/client.ovpn

# create the tunnel for the openvpn client
mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

cd /

jq --raw-output '.ovpn-config' /options.json > ${CLIENT_CONFIG_LOCATION}

chmod 777 ${CLIENT_CONFIG_LOCATION}

# star the client
openvpn --config ${CLIENT_CONFIG_LOCATION}
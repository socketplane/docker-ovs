#!/bin/sh
# Copyright 2014 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

echo " -----> Enabling OVS userspace support"

if [ ! -d /dev/net ]; then
    su -c "mkdir -p /dev/net"
fi

if [ ! -c /dev/net/tun ]; then
    su -c "mknod /dev/net/tun c 10 200"
fi

echo " -----> Creating OVS Database"

mkdir -p /etc/openvswitch
mkdir -p /var/run/openvswitch

if [ ! -f /etc/openvswitch/conf.db ]; then
    ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
fi

#Make configure script executable
chmod +x /usr/share/openvswitch/scripts/configure-ovs.sh

echo "-----> Configuring Supervisor"

mkdir -p /var/log/supervisor/
cd /tmp/supervisor-stdout
python setup.py install -q


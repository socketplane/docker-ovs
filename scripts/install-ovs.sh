#!/bin/bash
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

echo " -----> Installing dependencies"
yum -q -y update
yum -q -y install gcc autoconf automake openssl openssl-devel libtool make perl pkgconfig python python-simplejson supervisor wget

echo " -----> Downloading OVS $OVS_VERSION"

OVS="openvswitch-$OVS_VERSION"
URL="http://openvswitch.org/releases/$OVS.tar.gz"

cd /tmp
wget $URL > /dev/null 2>&1
tar -xzf "$OVS.tar.gz" > /dev/null 2>&1

echo " -----> Installing OVS"

cd $OVS
./configure > /dev/null 2>&1
make > /dev/null 2>&1
make install > /dev/null 2>&1


echo " -----> Enabling OVS userspace support"

if [ ! -d /dev/net ]; then
    su -c "mkdir -p /dev/net"
fi

if [ ! -c /dev/net/tun ]; then
    su -c "mknod /dev/net/tun c 10 200"
fi

echo " -----> Configuring OVS"

mkdir -p /usr/local/etc/openvswitch

if [ ! -f /usr/local/etc/openvswitch/conf.db ]; then
    ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
fi

echo " -----> Cleaning up"

yum -q -y remove gcc autoconf automake openssl-devel libtool
yum -q -y clean all

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

ovs_version=$(ovs-vsctl -V | grep ovs-vsctl | awk '{print $4}')
ovs_db_version=$(ovsdb-tool schema-version)
#vtep_db_version=$(ovsdb-tool /usr/share/openvswitch/vtep.ovsschema schema-version)

#ovs_vtep_min_version="2.1.0"

#is_hardware_vtep_capable() {
#    if [ "${ovs_vtep_min_version}" ==  "${ovs_version}" ]; then
#        return 0
#    fi
#
#    local lowest_version=$(echo -e "${ovs_vtep_min_version}\n${ovs_version}" | sort -t '.' -g | head -1)
#
#    if [ "${lowest_version}" == "${ovs_vtep_min_version}" ]; then
#        return 0
#    fi
#
#    return 1
#}

# Add OVS module to PythonPath
cp -r /usr/share/openvswitch/python/ovs /usr/lib/python2.7/site-packages/ovs

# give ovsdb-server and vswitchd some space...
sleep 3
# begin configuring
ovs-vsctl --no-wait -- init
ovs-vsctl --no-wait -- set Open_vSwitch . db-version="${ovs_db_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . ovs-version="${ovs_version}"
ovs-vsctl --no-wait -- set Open_vSwitch . system-type="docker-ovs"
ovs-vsctl --no-wait -- set Open_vSwitch . system-version="0.1"
ovs-vsctl --no-wait -- set Open_vSwitch . external-ids:system-id=`cat /proc/sys/kernel/random/uuid`
ovs-appctl -t ovsdb-server ovsdb-server/add-remote db:Open_vSwitch,Open_vSwitch,manager_options

#if is_hardware_vtep_capable; then
#    ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep.ovsschema
#    supervisorctl stop ovsdb-server
#    supervisorctl start ovsdb-server-vtep
#    # Hardware VTEP doesn't have a version column in the Global table yet
#    # vtep-ctl --no-wait -- set Global . db-version="$vtep_db_version"e
#fi

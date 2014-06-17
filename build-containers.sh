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

ovs_versions=("1.4.6" "1.5.0" "1.6.1" "1.7.0" "1.7.1" \
"1.7.3" "1.9.0" "1.9.3" "1.10.0" "1.10.2" "1.11.0" "2.0.0" \
"2.0.1" "2.1.0" "2.1.1" "2.1.2")


if [ $1 == "-r" ]; then
    recreate=true
else
    recreate=false
fi

export BUILDROOT_DIR="/tmp/buildroot"

# Clean up running containers
for x in $(sudo docker ps -a -q); do sudo docker stop $x; sudo docker rm $x; done

for version in ${ovs_versions[@]}; do
    export OPENVSWITCH_VERSION="${version}"
    cd /tmp/buildroot
    if [ "$recreate" = true ]; then
        make clean
        make
        recreate=false
    else
        make openvswitch-reconfigure
        make
    fi
    ./dockerize.sh
    cd /vagrant
    sudo packer build -var "ovs_version=${version}" packer/docker-ovs.json
done

# Remove any orphaned images
for x in $(sudo docker images | grep none | awk '{print $3}'); do sudo docker rmi $x; done

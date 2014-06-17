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

IMAGE_DIR="${BUILDROOT_DIR}/output/images"

if [ ! -f "${IMAGE_DIR}/rootfs.tar" ]; then
    exit 1
fi

cd ${IMAGE_DIR}

rm -rf extra
mkdir extra extra/etc extra/sbin
touch extra/etc/resolv.conf
touch extra/sbin/init

cp rootfs.tar "ovsbase-${OPENVSWITCH_VERSION}.tar"
tar rvf "ovsbase-${OPENVSWITCH_VERSION}.tar" -C extra .
mv "ovsbase-${OPENVSWITCH_VERSION}.tar" "${HOME}"

cid=$(sudo docker images -q ovsbase-${version})
if [ -n "$cid" ]; then
    sudo docker rmi "$cid"
fi

sudo docker import - "ovsbase-${OPENVSWITCH_VERSION}" < "${HOME}/ovsbase-${OPENVSWITCH_VERSION}.tar"

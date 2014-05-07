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

if ! rpm -q epel-release > /dev/null; then
    echo "---> Installing EPEL"
    su -c 'rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'
fi

if [[ ! $(uname -r) =~ ^3. ]] ; then
    echo "---> Upgrading Kernel"
    su -c "yum -q -y install http://www.elrepo.org/elrepo-release-6-5.el6.elrepo.noarch.rpm"
    su -c "yum -q -y --enablerepo=elrepo-kernel install kernel-ml"
    su -c "sed -i s/default=1/default=0/g /boot/grub/grub.conf"
fi

if ! hash docker 2>/dev/null; then
    echo "---> Installing Docker"
    su -c 'yum -q -y install docker-io'
fi

# /sbin/packer is included in the base box - this is not the packer we are looking for
if [ -f /usr/sbin/packer ]; then
    sudo rm /usr/sbin/packer
fi

if ! hash packer 2>/dev/null; then
    echo "---> Installing Packer"
    yum -q -y install unzip
    cd /tmp
    wget https://dl.bintray.com/mitchellh/packer/0.5.2_linux_amd64.zip -O packer.zip -q
    unzip -q -d packer packer.zip
    su -c "mv packer /usr/local/packer"
    su -c "ln -s /usr/local/packer/* /usr/bin/"
fi

echo "---> Starting Docker"
su -c 'service docker start > /dev/null'
su -c 'chkconfig docker on'

echo "---> Enabling TUN/TAP interfaces"
su -c "modprobe tun"

echo "---> Rebooting"
su -c "reboot"

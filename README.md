docker-ovs
==========

docker-ovs creates userspace [Open vSwitch](http://openvswitch.org) containers.
Running Open vSwitch in userspace mode is experimental and performance is not guaranteed.
This is provided for testing purposes, specifically for testing against multiple versions of openvswitch with CI tools.

## Installation

The containers live on the Docker Index so they can be easily used as follows:

    docker pull socketplane/docker-ovs

Or:

    docker pull socketplane/docker-ovs:2.1.2

Or even:

    docker run -t -i socketplane/docker-ovs:2.1.2 /bin/sh

## Running the container

To run the container listening on port 6640 (OVSDB) and 9001 (Supervisor XML-RPC API) and with supervisor managing the Open vSwitch processes:

    sudo docker run -p 6640:6640 -p 9001:9001 --privileged=true -d -i -t socketplane/docker-ovs:2.1.2 /usr/bin/supervisord

To run the container listening on port 6640 (OVSDB) and 9001 (Supervisor XML-RPC API) with a shell - you must manually start the process:

    sudo docker run -p 6640:6640 -p 9001:9001 --privileged=true -i -t socketplane/docker-ovs:2.1.2 /bin/sh
    
Once the container starts, you can start Open vSwitch as follows:

    export OVS_RUNDIR=/var/run/openvswitch
	sed -i s/nodaemon=true/nodaemon=false/g /etc/supervisord.conf
	supervisord
	
The processes can be controlled using `supervisorctl`

> Note: You need the "tun" kernel module loaded to run this container

> Note: Change the tag for a different OVS version e.g socketplane/docker-ovs:2.0.0

> Note: Docker 0.10.0 upwards does not require the `--privileged=true` flag as 0.10.0 allows non-privileged containers to create device nodes. See the [Docker Changelog](https://github.com/dotcloud/docker/blob/master/CHANGELOG.md) for more information.

> Note: Port 9001 is used to controller supervisorctl over XML-RPC

### Supported Releases

The follwing releases are supported:

- 1.4.6
- 1.5.0
- 1.6.1
- 1.7.0
- 1.7.1
- 1.7.3
- 1.9.0
- 1.9.3
- 1.10.0
- 1.10.2
- 1.11.0
- 2.0.0
- 2.0.1
- 2.1.0
- 2.1.1
- 2.1.2

### Creating bridges

To create bridges, please set the datapath type to `netdev` as advised in the Open vSwitch's [INSTALL.userspace](http://git.openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob;f=INSTALL.userspace;h=f54b93e2e54c2efdc88054519038d98390e4183c;hb=HEAD)

    ovs-vsctl add-br br0
    ovs-vsctl set bridge br0 datapath_type=netdev
    ovs-vsctl add-port br0 eth0
    ovs-vsctl add-port br0 eth1
    ovs-vsctl add-port br0 eth2

### Hardware VTEP Support

Hardware VTEP support is enabled on OVS verisons greater than 2.1.0

To use this, make the necessary configuration changes over OVSDB or via the `ctl` commands in the container:

- Create a bridge called `br-vtep`
- Add a `eth0` to `br-vtep`
- Add the bridge and port as a Physical_Switch
- Set the `tunnel_ips`

Example using `ovs-vsctl` and `vtep-ctl`:

    ovs-vsctl add-br br-vtep
    ovs-vsctl add-port br-vtep eth0
    vtep-ctl add-ps br-vtep
    vtep-ctl add-port br-vtep eth0
    vtep-ctl set Physical_Switch br-vtep tunnel_ips=192.168.0.3

To start the VTEP Simulator you can use the Supervisor XML-RPC API

    export DOCKER_IP="<ip address>"
    ./scripts/start-vtep.py

## Test Environment

To bring up the test environment

    vagrant up

## Building Containers

The build system for the containers now uses [BuildRoot](http://buildroot.uclibc.org/) in addition to [Packer](http://packer.io)
To build the containers, pull up the Vagrantbox as shown above.

    cd /tmp/buildroot
    echo 'source "package/openvswitch/Config.in"' >> Config.in
    make menuconfig

From the menu select:

    openvswitch
    Target Packages > Utilities > Supervisor

Then exit.

    cd /vagrant
    ./build-containers.sh

This could take up to 5 hours the first time depending on how powerful your VM is!
Once this has finished you'll see a lot of `ovsbase-${version}` docker containers.
These are used by Packer to assemble the final containers.

If you want to do a "clean" build after you've added/removed some packages or libraries.

    ./build-containers -r

If you've made changes and are *sure* that you only need to run `make` for each container.

    ./build-containers -r

## Updating containers

Assuming you only want to make configuration changes.

- Changes to the install/configure scripts
- Changes to docker-ovs.json

You can run:

    ./reconfigure-containers.sh

This will re-run Packer and build your newly configured containers.

## Contributing

1. Raise an issue
2. Fork the repository
3. Fix the issue
4. Submit a pull request

## License & Authors

Author: Dave Tucker (djt@redhat.com)

    Copyright 2014 Red Hat Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

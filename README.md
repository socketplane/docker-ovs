docker-ovs
==========

docker-ovs creates userspace [Open vSwitch](http://openvswitch.org) containers.
Running Open vSwitch in userspace mode is experimental and performance is not guaranteed.
This is provided for testing purposes, specifically for testing against multiple versions of openvswitch with CI tools.

## Installation

    docker pull davetucker/docker-ovs

## Running the container

To run the container with supervisor managing the Open vSwitch processes:

    sudo docker run -p 6640:6640 -p 6633:6633 -p 6644:6644 --privileged=true -d -i -t davetucker/docker-ovs:2.1.2 /bin/supervisord -n

To run the container with bash shell - you must manually start the process:

    sudo docker run -p 6640:6640 -p 6633:6633 -p 6644:6644 --privileged=true -d -i -t davetucker/docker-ovs:2.1.2 /bin/bash

> Note: You need the "tun" kernel module loaded to run this container

> Note: Change the tag for a different OVS version e.g davetucker/docker-ovs:2.0.0

> Note: Docker 0.10.0 upwards does not require the `--privileged=true` flag as 0.10.0 allows non-privileged containers to create device nodes. See the [Docker Changelog}(https://github.com/dotcloud/docker/blob/master/CHANGELOG.md) for more information.

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

## Test Environment

To bring up the test environment

    vagrant up

Once logged in to the vagrant environment you can build the latest OVS container:

    sudo packer build packer/docker-ovs.json

Build a container with an older Open vSwitch version:

    sudo packer build -var 'ovs_version=1.6.1' packer/docker-ovs.json

Or build all containers:

    ./build_containers

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

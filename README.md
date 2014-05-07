docker-ovs
==========

docker-ovs creates userspace [Open vSwitch](http://openvswitch.org) containers.
Running Open vSwitch in userspace mode is experimental and performance is not guaranteed.
This is provided for testing purposes, specifically for testing against multiple versions of openvswitch with CI tools.

## Installation

    docker pull davetucker/docker-ovs

## Running the container

    sudo docker run -p 6640:6640 -p 6633:6633 -p 6644:6644 --privileged=true -d -i -t davetucker/docker-ovs:2.1.0 /bin/supervisord -n

> Note: You need the "tun" kernel module loaded to run this container

> Note: Change the tag for a different OVS version e.g davetucker/docker-ovs:2.0.0

## Test Environment

To bring up the test environment

    vagrant up

Once logged in to the vagrant environment

    sudo packer build packer/docker-ovs.json

To build a container with an older Open vSwitch version:

    sudo packer build -var 'ovs_version=1.6.1' packer/docker-ovs.json

To build all containers

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

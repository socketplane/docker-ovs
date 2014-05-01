docker-ovs
==========

docker-ovs creates userspace [Open vSwitch](http://openvswitch.org) containers.
Running Open vSwitch in userspace mode is experimental and performance is guaranteed.
This is provided for testing purposes, specifically for testing against multiple versions of openvswitch with CI tools.

## Installation

To build the Dockerfile

    docker build github.com/dave-tucker/docker-ovs

## Running the container

To run the container

    docker run docker-ovs

To change the version of OpenvSwitch used (default is 2.1.0)

    docker run docker-ovs -e "OVS_VERSION=1.6.1"

> Note: You need the "tun" kernel module loaded to run this container

## Test Environment

To bring up the test environment

    vagrant up

To build the container

    docker build -t davetucker/ovs-docker /vagrant

## Packer

First [install Packer](http://www.packer.io/docs/installation.html), to do this in OSX:

    brew tap homebrew/binary
    brew install packer

To build the docker container with the latest Open vSwitch:

    packer build packer/docker-ovs.json

To build a container with an older Open vSwitch version:

    packer build -var 'ovs_version=1.6.1' packer/docker-ovs.json

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

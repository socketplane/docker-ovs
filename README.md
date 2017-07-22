docker-ovs
==========

docker-ovs creates [Open vSwitch](http://openvswitch.org) containers for Docker

## Installation

The containers live in DockerHub so they can be easily used as follows:

    docker pull socketplane/openvswitch

Or:

    docker pull socketplane/openvswitch:2.3.1

Or even:

    docker run -itd socketplane/openvswitch:2.3.1

## Running the container

To run the container in userspace mode:

    docker run -itd --cap-add NET_ADMIN socketplane/openvswitch

To run the container with the kernel module (assuming you have Linux Kernel 3.7+):

    modprobe openvswitch
    docker run -itd --cap-add NET_ADMIN socketplane/openvswitch

While it's recommended to load the kernel module outside of the container, it is possible to load the kernel module from within:

    cid=$(docker run -itd --cap-add NET_ADMIN --cap-add SYS_MODULE -v /lib/modules:/lib/modules  socketplane/openvswitch)
    docker exec $cid modprobe openvswitch
    docker exec $cid supervisorctl restart ovs-vswitchd

> Note 1: You need the "tun" kernel module loaded to run in userspace mode
> Note 2: Change the tag for a specific OVS version e.g socketplane/openvswitch:2.3.0

## Controlling The Processes

The processes can be controlled using  `supervisorctl`

	cid=$(docker run -itd --cap-add NET_ADMIN socketplane/openvswitch)
	docker exec $cid supervisorctl
	docker exec $cid supervisorctl stop|start|restart ovs-vswitchd
	docker exec $cid supervisorctl stop|start|restart ovsdb-server

> Note 3: Port 9001 is used to control supervisorctl over XML-RPC

## Using the Open vSwitch Utilities

	cid=$(docker run -itd --cap-add NET_ADMIN socketplane/openvswitch)
	docker exec $cid ovs-vsctl show
	docker exec $cid ovs-vsctl add-br foo
	docker exec $cid ovs-ofctl -OOpenFlow13 dump-flows foo
	docker exec $cid ovs-dpctl show

### Supported Releases

The follwing releases are supported:

- 1.4.6
- 1.5.0
- 1.6.1
- 1.7.0
- 1.7.1
- 1.7.2
- 1.7.3
- 1.9.0
- 1.9.3
- 1.10.0
- 1.10.2
- 1.11.0
- 2.0
- 2.0.1
- 2.1.0
- 2.1.1
- 2.1.2
- 2.1.3
- 2.3
- 2.3.1
- 2.3.2
- 2.4.0
- 2.5.2

### Creating bridges in Userspace Mode

To create bridges, please set the datapath type to `netdev` as advised in the Open vSwitch's [INSTALL.userspace](http://git.openvswitch.org/cgi-bin/gitweb.cgi?p=openvswitch;a=blob;f=INSTALL.userspace;h=f54b93e2e54c2efdc88054519038d98390e4183c;hb=HEAD)

    ovs-vsctl add-br br0
    ovs-vsctl set bridge br0 datapath_type=netdev
    ovs-vsctl add-port br0 eth0
    ovs-vsctl add-port br0 eth1
    ovs-vsctl add-port br0 eth2

### Hardware VTEP Support

Hardware VTEP support is enabled on OVS verisons greater than 2.1.0

    cid=$(docker run -itd --cap-add NET_ADMIN socketplane/openvswitch)
    docker exec $cid ovsdb-tool create /etc/openvswitch/vtep.db /usr/share/openvswitch/vtep.ovsschema
    docker exec $cid supervisorctl stop ovsdb-server
    docker exec $cid supervisorctl start ovsdb-server-vtep
    docker exec $cid supervisorctl start ovs-vtep

Example using `ovs-vsctl` and `vtep-ctl`:

    ovs-vsctl add-br br-vtep
    ovs-vsctl add-port br-vtep eth0
    vtep-ctl add-ps br-vtep
    vtep-ctl add-port br-vtep eth0
    vtep-ctl set Physical_Switch br-vtep tunnel_ips=192.168.0.3

## Building Containers

To build a container

    docker build -t socketplane/openvswitch:2.3 2.3

Or to build all containers:

    make build

## Updating containers

The only files that require edits directly are:

- `Dockerfile`
- `latest`
- `Makefile`

... and possibly ...

- `configure-ovs.sh`
- `supervisord.conf`

### Adding a new version

Add the new version to `Makefile` and run `make reconfigure`:

If the new version you would like to add is the latest release, update the `Dockerfile` in the root of the repository  and `latest`, before running `make reconfigure`.

> Note: Only change the files in the root of the repository
> `make reconfigure`  handles copying these to the sub-directories
> Unfortunately, Docker doesn't allow for a folder to be "shared" between all contexts, and Automated Builds only supports branches/tags/subfolders for now.
> The better solution moving forward would be to have `Dockerfile.<tag>` in this reposirity, where `Dockerfile` is the latest, but we are dependent on changes in Docker Hub.

## Contributing

1. Raise an issue
2. Fork the repository
3. Fix the issue
4. Submit a pull request

## License & Authors

Author: Dave Tucker (djt@redhat.com, dave@socketplane.io)

    Copyright 2014 Red Hat Inc.
    Copyright 2015 SocketPlane Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

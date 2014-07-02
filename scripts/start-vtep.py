#!/usr/bin/env python

import os
import xmlrpclib

DOCKER_IP = os.getenv("DOCKER_IP", "127.0.0.1")

server = xmlrpclib.Server('http://%s:9001/RPC2' % DOCKER_IP)
server.supervisor.startProcess("ovs-vtep")

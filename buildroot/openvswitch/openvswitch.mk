#############################################################
#
# openvswitch
#
#############################################################
#OPENVSWITCH_VERSION=2.1.2
OPENVSWITCH_SOURCE = v$(OPENVSWITCH_VERSION).tar.gz
OPENVSWITCH_SITE = https://github.com/openvswitch/ovs/archive/
OPENVSWITCH_AUTORECONF = YES
OPENVSWITCH_DEPENDENCIES = bridge-utils openssl python python-simplejson

$(eval $(autotools-package))

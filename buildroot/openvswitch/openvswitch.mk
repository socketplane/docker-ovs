#############################################################
#
# openvswitch
#
#############################################################
#OPENVSWITCH_VERSION=2.1.2
OPENVSWITCH_SOURCE = openvswitch-$(OPENVSWITCH_VERSION).tar.gz
OPENVSWITCH_SITE = http://openvswitch.org/releases/ 
OPENVSWITCH_AUTORECONF = YES
OPENVSWITCH_DEPENDENCIES = bridge-utils openssl python python-simplejson

$(eval $(autotools-package))

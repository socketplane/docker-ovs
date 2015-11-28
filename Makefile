.PHONY=(all build reconfigure)

ifeq ($(shell uname -s),Darwin)
	SED=sed -i ''
else
	SED=sed -i
endif

OVS_VERSIONS = \
	"1.4.6" \
	"1.5.0" \
	"1.6.1" \
	"1.7.0" \
	"1.7.1" \
	"1.7.2" \
	"1.7.3" \
	"1.9.0" \
	"1.9.3" \
	"1.10.0" \
	"1.10.2" \
	"1.11.0" \
	"2.0" \
	"2.0.1" \
	"2.0.2" \
	"2.1.0" \
	"2.1.1" \
	"2.1.2" \
	"2.1.3" \
	"2.3" \
	"2.3.1" \
	"2.3.2" \
	"2.4.0"

all: reconfigure build

reconfigure:
	for v in ${OVS_VERSIONS} ; do \
		echo "====> Reconfiguring $$v" ; \
		rm -r $$v ; \
		mkdir -p $$v ; \
		cp supervisord.conf $$v/ ; \
		cp configure-ovs.sh $$v/ ; \
		cp Dockerfile $$v/ ; \
		args="s/$(shell cat latest)/$$v/g" ; \
		cmd="${SED} $$args $$v/Dockerfile" ; \
		eval $$cmd ; \
	done

build:
	for v in ${OVS_VERSIONS} ; do \
		echo "====> Building socketplane/openvswitch:$$v" ; \
		docker build -t socketplane/openvswitch:$$v $$v ; \
	done

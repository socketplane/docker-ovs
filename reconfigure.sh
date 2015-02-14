#!/bin/sh
# Reconfigure containers
# Updates the Dockerfile and build context for each OVS release

set -x

if [ "$(uname -s)" = "Darwin" ]; then
	sed="sed -i ''"
else
	sed='sed -i'
fi

ovs_versions=(
	"1.4.6"
	"1.5.0"
	"1.6.1"
	"1.7.0"
	"1.7.1"
	"1.7.2"
	"1.7.3"
	"1.9.0"
	"1.9.3"
	"1.10.0"
	"1.10.2"
	"1.11.0"
	"2.0"
	"2.0.1"
	"2.0.2"
	"2.1.0"
	"2.1.1"
	"2.1.2"
	"2.1.3"
	"2.3"
	"2.3.1"
)

for v in ${ovs_versions[@]}; do
	echo "====> Reconfiguring $v"
	rm -r $v
	mkdir -p $v
	cp supervisord.conf $v/
	cp configure-ovs.sh $v/
	cp Dockerfile $v/
	args="s/`cat latest`/$v/g"
	cmd="$sed $args $v/Dockerfile"
	eval $cmd
done

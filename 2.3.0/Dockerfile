FROM socketplane/busybox:latest
MAINTAINER Dave Tucker <dave@socketplane.io>
ENV OVS_VERSION 2.3
ENV SUPERVISOR_STDOUT_VERSION 0.1.1
# Configure supervisord
RUN mkdir -p /var/log/supervisor/
ADD supervisord.conf /etc/
# Install supervisor_stdout
WORKDIR /opt
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /etc/openvswitch
RUN wget https://pypi.python.org/packages/source/s/supervisor-stdout/supervisor-stdout-$SUPERVISOR_STDOUT_VERSION.tar.gz --no-check-certificate && \
	tar -xzvf supervisor-stdout-0.1.1.tar.gz && \
	mv supervisor-stdout-$SUPERVISOR_STDOUT_VERSION supervisor-stdout && \
	rm supervisor-stdout-0.1.1.tar.gz && \
	cd supervisor-stdout && \
	python setup.py install -q
# Get Open vSwitch
WORKDIR /
RUN wget https://s3-us-west-2.amazonaws.com/docker-ovs/openvswitch-$OVS_VERSION.tar.gz --no-check-certificate && \
	tar -xzvf openvswitch-$OVS_VERSION.tar.gz &&\
	mv openvswitch-$OVS_VERSION openvswitch &&\
	cp -r openvswitch/* / &&\
	rm -r openvswitch &&\
	rm openvswitch-$OVS_VERSION.tar.gz 
RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/local/share/openvswitch/vswitch.ovsschema
# Start OVS processes using supervisor
CMD "/usr/bin/supervisord"

# Copyright 2014 Red Hat Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define "centos" do |centos|
    centos.vm.box = "centos65x64"
    centos.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
    centos.vm.hostname = "centos"
    centos.vm.provider :virtualbox do |vb|
      vb.memory = 4096
      vb.cpus = 2
    end
    centos.vm.network "private_network", ip: "192.168.50.4"
    centos.vm.provision "shell", path: "scripts/bootstrap.sh"
    centos.vm.synced_folder ".", "/vagrant", type: "nfs"
  end
end

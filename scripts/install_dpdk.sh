# download dpdk

version=25.11.2

wget https://fast.dpdk.org/rel/dpdk-${version}.tar.xz

tar xJf dpdk-${version}.tar.xz
rm dpdk-${version}.tar.xz

cd dpdk-stable-${version}/

# install python
sudo apt-get update
sudo apt install -y python3-pip
sudo apt install -y python3.10-venv

python3 -m venv ~/venv
source ~/venv/bin/activate

# install meson and ninja
pip install meson ninja
# this automatically adds meson and ninja to the PATH variable due to venv

# libnuma
sudo apt install -y libnuma-dev

# pyelftools
sudo apt install -y python3-pyelftools
pip install pyelftools

# build dpdk
cd dpdk-stable-${version}/

meson setup build
cd build

meson configure -Dexamples=helloworld
ninja

# Setup hugepages
# echo '1024' | sudo tee -a  /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
# setup NUMA-aware hugepages. Else, dpdk will cry
echo 1024 | sudo tee /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages

# clear previous hugepages
# echo 0 | sudo tee /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
# echo 0 | sudo tee /sys/devices/system/node/node1/hugepages/hugepages-2048kB/nr_hugepages
# echo '0' | sudo tee -a  /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

# run helloworld example
cd ~/dpdk-stable-${version}
sudo ./build/examples/dpdk-helloworld -l 0-3 -n 4


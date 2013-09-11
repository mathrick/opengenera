set -e

# ideally this would be excluded in the preseed
sed -i.bak 's/^.*cdrom.*$//g' /etc/apt/sources.list
apt-get -y update

cat /etc/apt/sources.list
apt-cache search linux-headers
apt-cache search zlib1g-dev

#Updating the box
apt-get -y install linux-headers-$(uname -r) build-essential
apt-get -y install zlib1g-dev libssl-dev libreadline5-dev nfs-common
apt-get clean

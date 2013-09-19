set -e

#Installing the virtualbox guest additions
VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
cd /tmp
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
# It will try to install X11 modules and fail, there's no way to prevent that
sh /mnt/VBoxLinuxAdditions.run || true
umount /mnt

rm VBoxGuestAdditions_$VBOX_VERSION.iso

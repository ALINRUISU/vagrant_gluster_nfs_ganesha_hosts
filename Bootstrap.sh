#!/usr/bin/env bash
 
# BEGIN ########################################################################
echo -e "-- ------------------ --\n"
echo -e "-- BEGIN BOOTSTRAPING --\n"
echo -e "-- ------------------ --\n"
 
# VARIABLES ####################################################################    
 
# BOX ##########################################################################
echo -e "-- Updating packages list\n"
yum update -y
 
# packages #########################################################################
echo -e "-- Installing additional packages\n"
yum install -y yum-utils > /dev/null 2>&1
yum install -y centos-release-gluster > /dev/null 2>&1
yum install -y net-tools > /dev/null 2>&1
yum install -y glusterfs-server > /dev/null 2>&1
yum install -y corosync pacemaker pcs  > /dev/null 2>&1
yum install -y nfs-ganesha nfs-ganesha-gluster nfs-ganesha-vfs nfs-ganesha-utils > /dev/null 2>&1

# initalize service ##########################################################################
echo -e "-- Start Services"
systemctl enable glusterd.service
systemctl start  glusterd.service
systemctl enable pcsd.service
systemctl start pcsd.service
systemctl enable corosync.service
systemctl enable pacemaker.service

# Adding users ##########################################################################
echo -e "-- Adding users"
# NEVER EVER Do this in production (This is here for the ease of automation + administration)
echo "changeme123" | passwd hacluster --stdin

adduser rsu
echo "changeme123" | passwd rsu --stdin
cat <<EOT >> /etc/sudoers.d/99-admin
rsu ALL=(ALL) NOPASSWD:ALL
EOT

# partition config ##########################################################################
echo -e "-- Update storage size"
mkdir -p /srv/sdb1 
parted /dev/sdb --script -- mklabel gpt mkpart primary 0% 100%
mkfs.xfs /dev/sdb1 -f
echo "/dev/sdb1 /srv/sdb1 xfs defaults 0 0"  >> /etc/fstab
mkdir -p /srv/sdb1/brick
mount -a

# firewall ##########################################################################
iptables -A INPUT -p tcp -s 192.168.0.111 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.0.112 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.0.113 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.0.114 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# add hostfile ##########################################################################
cat <<EOT >> /etc/hosts
192.168.0.111   glusterfs01
192.168.0.112   glusterfs02
192.168.0.113   glusterfs03
192.168.0.114   glusterfs04
EOT

# END ##########################################################################
echo -e "-- ---------------- --"
echo -e "-- END BOOTSTRAPING --"
echo -e "-- ---------------- --"
echo Setting IP to $1
cat <<EOF > /etc/netplan/01-netcfg.yaml

network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      addresses : [$1/24]
      
EOF

#Restart networking to make IP active
sudo netplan apply
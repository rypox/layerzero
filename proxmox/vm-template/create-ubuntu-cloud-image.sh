#!/bin/bash

#create a vm template
VM_ID=10000

# download the image
if [ ! -f "noble-server-cloudimg-amd64.img" ];then
  wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
else
  echo "noble-server-cloudimg-amd64.img exists already, not downloading"
fi

# create a new VM with VirtIO SCSI controller
qm create $VM_ID --memory 2048 --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-single --name ubuntu-cloud --machine q35 --bios ovmf
qm set $VM_ID --cpu cputype=kvm64,flags=+aes --cores 2
qm set $VM_ID --description "created by bash script: create-ubuntu-cloud-image.sh"
#qm set $VM_ID --bios ovmf
qm set $VM_ID --efidisk0 storage:0,pre-enrolled-keys=1,efitype=4m,format=qcow2

# import the downloaded disk to the local-lvm storage, attaching it as a SCSI drive
qm disk import $VM_ID noble-server-cloudimg-amd64.img storage --format qcow2
# options iothread and following must also be set on the resource/disk config
qm set $VM_ID --scsi0 storage:$VM_ID/vm-$VM_ID-disk-1.qcow2,iothread=1,discard=on,backup=0,ssd=1,cache=writeback

# set network config to dhcp for ipv4 and ipv6
qm set $VM_ID --ipconfig0 ip=dhcp,ip6=auto

# Add Cloud-Init CD-ROM drive
qm set $VM_ID --ide2 storage:cloudinit

# can be removed with
#zfs destroy zfs3t/vm-$VM_ID-cloudinit

# set boot order
qm set $VM_ID --boot order=scsi0

#serial console
qm set $VM_ID --serial0 socket --vga serial0

# attache cloud-init config
qm set $VM_ID --cicustom "user=storage:snippets/cloud-init-config.yaml"

# convert it to a template (never start the vm before this step! It will receive a host id and every clone will inherit it.)
qm template $VM_ID


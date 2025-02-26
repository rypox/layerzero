# layerzero
create k8s infrastructure

## create VM template

* create a virtual machine template
* new VMs can clone this template for faster provisioning

* copy cloud-init-config.yaml and create-ubuntu-cloud-image.sh to proxmox host
```
scp vm-template/create-ubuntu-cloud-image.sh root@proxmox:/root/
scp vm-template/cloud-init-config.yaml root@proxmox:/opt/storage/snippets/
```
* folder vm-template contains bash script, run it on the proxmox host
* it uses a cloud image that is tailored for this purpose
```
ssh proxmox
./create-ubuntu-cloud-image.sh
```
* result is a VM with vmid 10000 on proxmox node

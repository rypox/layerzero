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

## create proxmox user for terraform
be careful and know what you're doing
* create .env file, set hostname and password
* copy .env file to proxmox host
* create user terraform-prov@pve in proxmox Datacenter, assign to group 'automation'
```
ssh proxmox
source .env
pveum user add $API_USER --password $API_PASSWORD
pveum passwd $API_USER
pveum aclmod / -user $API_USER -role TerraformProv
pveum user modify $API_USER -group automation
```
* create role TerraformProv with sufficient permissions
``` 
pveum roleadd TerraformProv -privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.Audit VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify"
```
* create API Token
```
pveum user token add "$API_USER" "tokenid" --comment "create token"
┌──────────────┬────────────────────────────────────────┐
│ key          │ value                                  │
╞══════════════╪════════════════════════════════════════╡
│ full-tokenid │ terraform-prov@pve!tokenid             │
├──────────────┼────────────────────────────────────────┤
│ info         │ {"comment":"create token","privsep":1} │
├──────────────┼────────────────────────────────────────┤
│ value        │ xxxxx849-51a9-xxxx-xxxx-4cxxxxxxx4f1   │
└──────────────┴────────────────────────────────────────┘
```
Use the token value in terraform.tfvars for variable virtual_environment_token.

## VM provisioning

use terraform to provision the virtual machines on proxmox
### connection to proxmox
* uses provider plugin bpg/proxmox
* provider.tf
### provisioning nodes
* master.tf
* worker.tf
* storage.tf
### terraform variables
* variable definition: variables.tf
* variable values: terraform.tfvars (cloned from terraform.tfvars-sample)
### installation
* set values in terraform.tfvars
* run the script vm-install.sh
* watch the VMs being created
* in case of errors use debug logging to support troubleshooting
```
export TF_LOG_PATH="terraform.log"
export TF_LOG=DEBUG
```

* the script executes these steps
```
terraform init
terraform plan
terraform apply --auto-approve
```
* VMs are created with vmid 5000 and above

resource "proxmox_virtual_environment_vm" "k8s_master" {
  count = 3
  name        = "k8s-master-${count.index + 1}"
  description = "kubernetes cluster node k8s-master-${count.index + 1}, Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "proxmox"
  vm_id     = 5000 + count.index

  agent {
    enabled = true
  }
  stop_on_destroy = true

#  target_node = "proxmox"
  clone {
    vm_id      = 10000
#     node_name       = "ubuntu-cloud"
    retries = 3
  }

  bios       = "ovmf"
  cpu {
    cores      = 2
    sockets    = 1
    type       = "host"
  }
  memory {
    dedicated = 4096
    floating  = 4096
  }
  disk {
    datastore_id = "thinpool"
    file_format  = "qcow2"
    interface    = "scsi0"
    cache        = "writeback"
    backup       = false
    discard      = "on"
    iothread     = true
    ssd          = true
    size         = 10
  }
  scsi_hardware  = "virtio-scsi-pci"


  network_device {
    model  = "virtio"
    bridge = "vmbr0"
    mac_address = format("00:50:56:00:30:%02x", count.index + 1)
  }

  initialization {
#     hostname = "k8s-master-${count.index + 1}"

    datastore_id = "storage"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

    user_data_file_id = "storage:snippets/cloud-init-config.yaml"
  }


  serial_device {
#     id   = 0
#     type = "socket"
  }

  vga {
    type = "serial0"
  }
}

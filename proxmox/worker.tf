resource "proxmox_virtual_environment_vm" "k8s_worker" {
  count = 3
  name        = "k8s-worker-${count.index + 1}"
  description = "kubernetes cluster node k8s-worker-${count.index + 1}, Managed by Terraform"
  tags        = ["terraform", "ubuntu"]

  node_name = "proxmox"
  vm_id     = 5100 + count.index

  agent {
    enabled = true
  }
  stop_on_destroy = true

#  target_node = "proxmox"
  clone {
    vm_id      = 10000
#     node_name       = "ubuntu-cloud"
  }

  bios       = "ovmf"
  cpu {
    cores      = 4
    sockets    = 1
    type       = "host"
  }
  memory {
    dedicated = 6144
    floating  = 6144
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
    size         = 20
  }
  scsi_hardware  = "virtio-scsi-pci"


  network_device {
    model  = "virtio"
    bridge = "vmbr0"
    mac_address = format("00:50:56:00:31:%02x", count.index + 1)
  }

  initialization {
#     hostname = "k8s-worker-${count.index + 1}"

    datastore_id = "storage"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
      ipv6 {
        address = "dhcp"
      }
    }

#     user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
#     user_data_file_id = proxmox_virtual_environment_file.cloud_init-config.id
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

# data "local_file" "ssh_public_key" {
#   filename = "./id_rsa.pub"
# }

# resource "proxmox_virtual_environment_file" "cloud_init-config" {
#   content_type = "snippets"
#   datastore_id = "storage"
#   node_name    = "proxmox"
#   source_file {
#     path = "cloud-init-config.yaml"
#   }
# }

# resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
#   content_type = "snippets"
#   datastore_id = "storage"
#   node_name    = "proxmox"
#
#   source_raw {
#     data = <<-EOF
#     #cloud-config
#     hostname: test-ubuntu
#     users:
#       - default
#       - name: janpfeil
#         groups:
#           - sudo
#         shell: /bin/bash
#         ssh_authorized_keys:
#           - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7gub5h20KSU6PJNX1XFxTcWoxXQRjbOQsVoGjo9joS jan.pfeil@rypox.net
#         sudo: ALL=(ALL) NOPASSWD:ALL
#
#     package_update: true
#         packages:
#         - htop
#         - git
#         - qemu-guest-agent
#
#     runcmd:
#         - systemctl enable qemu-guest-agent
#         - systemctl start qemu-guest-agent
#         - echo "done" > /tmp/cloud-config.done
#     EOF
#
#     file_name = "user-data-cloud-config.yaml"
#   }
# }

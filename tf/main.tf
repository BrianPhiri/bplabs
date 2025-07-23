resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "proxmox_lxc" "containers" {
  count = length(var.lxc_containers)

  hostname    = var.lxc_containers[count.index].hostname
  target_node = var.lxc_containers[count.index].target_node
  ostemplate  = var.lxc_containers[count.index].ostemplate
  password    = var.lxc_containers[count.index].password
  unprivileged = var.lxc_containers[count.index].unprivileged
  vmid = var.lxc_containers[count.index].vmid
  memory = var.lxc_containers[count.index].memory
  swap = var.lxc_containers[count.index].swap
  cores = var.lxc_containers[count.index].cores
  ssh_public_keys = tls_private_key.ssh_key.public_key_openssh
  features {
    nesting = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }

  rootfs {
    storage = var.lxc_containers[count.index].storage
    size    = var.lxc_containers[count.index].size
  }
  start = true
  onboot = true
}

resource "local_file" "ansible_inventory" {
  content = join("\n", [
    for c in proxmox_lxc.containers :
      "[lxc_${c.vmid}]\nlxd_${c.vmid} ansible_host=${c.network[0].ip} ansible_user=root ansible_ssh_private_key_file=./ssh/lxc/ansible/ssh_key"
  ])
  filename = "${path.module}/../inventory/hosts.yml"
}

resource "local_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/../ssh/lxc/ansible/ssh_key"
  file_permission = "0600"
}

#resource "proxmox_vm_qemu" "demo_vm" {
#  count       = 1
#  name        = "DemoVM"
#  target_node = "bonzosgarage"
#  vmid        = 0
#
#  os_type = "linux"
#  iso    = "local:iso/alpine-virt-3.21.3-x86_64.iso"
#  cores   = 1
#  sockets = 2
#  memory  = 2048
#
#  network {
#    bridge    = "vmbr0"
#    model     = "virtio"
#  }
#  disk {
#    slot    = 0
#    size    = "20G"
#    type    = "scsi"
#    storage = "LocalHDD"
#  }
#
#  bootdisk = "scsi0"
#  agent    = 1
#}
#

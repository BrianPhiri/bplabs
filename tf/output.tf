output "container_ips" {
  value = [for c in proxmox_lxc.containers : c.network[0].ip]
}

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

variable "lxc_containers" {
  description = "List of LXC containers to create"
  type = list(object({
    hostname     = string
    storage      = string
    size         = string
    ostemplate   = string
    password     = string
    target_node  = string
    unprivileged = optional(bool, true)
    vmid         = string
    memory       = number
    swap         = number
    cores        = number
  }))
}

variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "http://192.0.0.1:8006/api2/json"
}

variable "proxmox_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
  default     = ""
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  default     = ""
}

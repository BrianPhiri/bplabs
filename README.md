# Proxmox LXC Terraform & Ansible Lab

## Overview

This project automates the creation and configuration of Proxmox LXC containers using **Terraform** and **Ansible**.
- **Terraform** provisions LXC containers on your Proxmox server, generates SSH keys, and creates an Ansible inventory file.
- **Ansible** connects to the containers and configures them (e.g., installs Docker, creates users).

---

## How It Works

1. **Terraform Phase**
    - Generates an SSH key pair for secure access.
    - Provisions LXC containers on Proxmox using variables from `terraform.tfvars`.
    - Injects the SSH public key into each container for passwordless access.
    - Writes the SSH private key to `ssh/lxc/ansible/ssh_key`.
    - Creates an Ansible inventory file (`inventory/hosts.yml`) with container IPs (bug preventing the ips from being exported) and connection info.

2. **Ansible Phase**
    - Uses the generated inventory to connect to each container.
    - Runs roles such as `install_docker` and `create_user` to configure the containers.

---

## Usage

### 1. Clone the Repository

```sh
git clone <your-repo-url>
cd bplab23
```

### 2. Configure Terraform Variables

Edit `tf/terraform.tfvars` to match your Proxmox setup and desired container specs.

### 3. Run Terraform

```sh
cd tf
terraform init
terraform apply -auto-approve
```

> **Note:**
> After Terraform runs, you’ll need to get the container IPs manually from the lxd to get the ip as the provider does not return the ips (could be a bug in the lxds).

### 4. Run Ansible

```sh
cd ..
ansible-playbook -i inventory/hosts.yml playbook.yml
```

---

## Files & Structure

- `tf/main.tf` — Terraform configuration for LXC containers, SSH keys, and inventory.
- `tf/terraform.tfvars` — Variables for container specs and Proxmox credentials.
- `inventory/hosts.yml` — Generated Ansible inventory.
- `ssh/lxc/ansible/ssh_key` — Generated SSH private key for Ansible.
- `playbook.yml` — Ansible playbook to configure containers.
- `roles/` — Custom Ansible roles (e.g., `install_docker`, `create_user`).

---

## Tips

- Always run Terraform first to provision containers and generate the inventory.
- If you add or remove containers, re-run Terraform and then Ansible.
- You will have to ssh into the lxd to get the ip as the provider does not return the ip.

---

## Requirements

- Proxmox server with API access
- Terraform >= 1.0
- Ansible >= 2.10
- SSH access to containers (handled automatically)

---

## Example Workflow

```sh
# Provision containers
cd tf
terraform init
terraform apply -auto-approve

# Configure containers
cd ..
ansible-playbook -i inventory/hosts.yml playbook.yml
```

---

**Enjoy the automated

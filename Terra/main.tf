terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region              = "us-ashburn-1"
  auth                = "ApiKey"
  config_file_profile = "sacilotto.andre@gmail.com"
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "DiscordBot VCN"
}

# Subnet for compute instances
resource "oci_core_subnet" "discord_bot_subnet" {
  vcn_id                  = oci_core_vcn.internal.id
  cidr_block              = "172.16.1.0/24"
  compartment_id          = var.compartment_id
  display_name            = "DiscordBot Subnet"
  prohibit_public_ip_on_vnic = false
}

# Compute instance for Docker Swarm manager
resource "oci_core_instance" "bot_manager" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = var.compartment_id
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "DiscordBot Manager"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.discord_bot_subnet.id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}

variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "The OCID of the compartment"
  type        = string
  sensitive   = true
}
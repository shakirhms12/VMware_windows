provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
  api_timeout          = 60
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

#Template must have VMWaretools install
#and Sysprep set on reboot 
data "vsphere_virtual_machine" "template" {
  name          = "Window-Template"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_guest_os_customization" "window" {
  name = "win"
}



# Create a new VM from the template
resource "vsphere_virtual_machine" "windows_vm" {
  name             = "windows"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  firmware         = "efi"

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = var.disk_label
    size             = var.disk_size
    eagerly_scrub    = false
    thin_provisioned = true
    unit_number      = 0
  }

  disk {
    label            = "disk1"
    size             = 20 # Size in GB
    eagerly_scrub    = false
    thin_provisioned = true
    unit_number      = 1
  }

  # Customization during provisioning
  # Provisioner to copy the PowerShell script to the VM
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      windows_options {
        computer_name  = "windows-vm"
        admin_password = "VMware1!"
        join_domain = "translab1.translab1"
        domain_admin_user = "TRANSLAB1\\Administrator"
        domain_admin_password = "Admin@123"
      }
      network_interface {
        ipv4_address = "192.168.3.73"
        ipv4_netmask = 24
        dns_server_list = ["192.168.3.211"]
        dns_domain = "translab1.translab1"
      }
      ipv4_gateway = "192.168.3.1"
    }
  }
}

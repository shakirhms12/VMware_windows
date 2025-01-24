variable "vsphere_user" {
  description = "Provide user name"
  sensitive = true
  default = "administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "Provide password"
  sensitive = true
  default = "Admin@123"
}

variable "vsphere_server" {
  default = "192.168.2.30"
}

variable "network" {
  default = "VM Network"
}

variable "datacenter" {
  default = "Datacenter"
}

variable "datastore" {
  default = "TLAB-FC-LUN02"
}

variable "IP" {
  default = "192.168.2.60"
}

variable "pool" {
  # default = "resource-pool"
  default = "192.168.2.60/Resources"
  
}

variable "computer_name" {
  default = "test"
}

variable "admin_password" {
  default = "Translab@123"
}

variable "window_ip" {
  default = "192.168.3.73"
}

variable "window_netmask" {
  default = "24"
}

variable "Window_gateway" {
  default = "192.168.3.1"
}

variable "disk_label" {
  default = "disk0"
}


variable "disk_size" {
  default = "40"
}

variable "drive_letter" {
  type    = string
  default = "D"
}

variable "volume_label" {
  type    = string
  default = "volume2"
}
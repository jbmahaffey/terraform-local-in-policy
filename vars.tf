variable "fortigate" {
  type = string
}

variable "token" {
  sensitive = true
  type = string
}

// Add as many management IP's as you need following the structure below. 
variable "mgmtobj" {
  default = {
    mgmt-ip-1 = {
        "subnet" = "192.168.2.0 255.255.255.0"
        "type" = "ipmask"
        "obj_type" = "ip"
    }
    mgmt-ip-2 = {
        "subnet" = "192.168.101.0 255.255.255.0"
        "type" = "ipmask"
        "obj_type" = "ip"
    }
    mgmt-ip-3 = {
        "subnet" = "68.104.213.237 255.255.255.255"
        "type" = "ipmask"
        "obj_type" = "ip"
    }
    }
}

variable "external-interface" {
  type = string
  sensitive = false
}
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

# Modify if using a port other than standard ports
variable "http-port"{
    type = string
    default = "HTTP"
}

# Modify if using a port other than standard ports
variable "https-port" {
  type = string
  default = "10443" # If custom port put the port number ie. 10443
}

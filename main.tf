terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
  hostname = var.fortigate
  token = var.token
  insecure = "true"
}

resource "fortios_firewall_address" "mgmtadd" {
  for_each = var.mgmtobj
  name = each.key
  obj_type = each.value["obj_type"]
  subnet = each.value["subnet"]
  type = each.value["type"]
}

resource "fortios_firewall_object_addressgroup" "mgmtadd" {
  name          = "mgmt-addrgrp"
  member        = tolist(keys(var.mgmtobj))
  depends_on = [
    fortios_firewall_address.mgmtadd
  ]
}

resource "fortios_firewall_localinpolicy" "localin-deny" {
  action            = "deny"
  ha_mgmt_intf_only = "disable"
  intf              = var.external-interface
  policyid          = 0
  schedule          = "always"
  status            = "enable"
  depends_on = [
    fortios_firewall_localinpolicy.localin
  ]

  dstaddr {
    name = "all"
  }

  service {
    name = "HTTP"
  }

  service {
    name = "HTTPS"
  }

  srcaddr {
    name = "all"
  }
}

resource "fortios_firewall_localinpolicy" "localin" {
  action            = "accept"
  ha_mgmt_intf_only = "disable"
  intf              = var.external-interface
  policyid          = 0
  schedule          = "always"
  status            = "enable"

  dstaddr {
    name = "all"
  }

  service {
    name = "HTTP"
  }

  service {
    name = "HTTPS"
  }

  srcaddr {
    name = fortios_firewall_object_addressgroup.mgmtadd.name
  }
}

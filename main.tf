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

resource "fortios_firewallservice_custom" "adminporthttp" {
  count = var.http-port != "HTTP" ? 1 : 0
  category = "General"
  name = "mgmt-http-service"
  protocol = "TCP"
  protocol_number = 6
  tcp_portrange = var.http-port
}

resource "fortios_firewallservice_custom" "adminporthttps" {
  count = var.https-port != "HTTPS" ? 1 : 0
  category = "General"
  name = "mgmt-https-service"
  protocol = "TCP"
  protocol_number = 6
  tcp_portrange = var.https-port
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
  policyid          = 101
  schedule          = "always"
  status            = "enable"
  depends_on = [
    fortios_firewall_localinpolicy.localin
  ]

  dstaddr {
    name = "all"
  }

  service {
    name = var.http-port == "HTTP" ? var.http-port : fortios_firewallservice_custom.adminporthttp[0].name
  }

  service {
    name = var.https-port == "HTTPS" ? var.https-port : fortios_firewallservice_custom.adminporthttps[0].name
  }

  srcaddr {
    name = "all"
  }
}

resource "fortios_firewall_localinpolicy" "localin" {
  action            = "accept"
  ha_mgmt_intf_only = "disable"
  intf              = var.external-interface
  policyid          = 100
  schedule          = "always"
  status            = "enable"

  dstaddr {
    name = "all"
  }

  service {
    name = var.http-port == "HTTP" ? var.http-port : fortios_firewallservice_custom.adminporthttp[0].name
  }

  service {
    name = var.https-port == "HTTPS" ? var.https-port : fortios_firewallservice_custom.adminporthttps[0].name
  }

  srcaddr {
    name = fortios_firewall_object_addressgroup.mgmtadd.name
  }
}

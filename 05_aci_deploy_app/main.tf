#configure provider with your cisco aci credentials.
provider "aci" {
  # cisco-aci user name
  username = var.user.username
  # cisco-aci password
  password = var.user.password
  # cisco-aci url
  url      = var.user.url
  insecure = true
}

resource "aci_tenant" "terraform_tenant" {
    name        = "terraform_tenant"
    description = "This tenant is created by terraform"
}

resource "aci_vrf" "terraform_vrf" {
    tenant_dn              = aci_tenant.terraform_tenant.id
    name                   = "terraform_vrf"
}

resource "aci_bridge_domain" "terraform_bd" {
    tenant_dn                   = aci_tenant.terraform_tenant.id
    description                 = "terraform bridge domain"
    name                        = "terraform_bd"
}

resource "aci_subnet" "terraform_bd_subnet" {
    parent_dn        = aci_bridge_domain.terraform_bd.id
    description      = "This is subnet created by terraform for bridge domain"
    ip               = "10.0.3.28/27"
    preferred        = "yes"
}

resource "aci_filter" "terraform_filter" {
    for_each    = var.filters
    tenant_dn   = aci_tenant.terraform_tenant.id
    description = "This is filter ${each.key} created by terraform"
    name        = each.value.filter
}

resource "aci_filter_entry" "terraform_filter_entry" {
    for_each      = var.filters
    filter_dn     = aci_filter.terraform_filter[each.key].id
    name          = each.value.entry
}

resource "aci_contract" "terraform_contract" {
    for_each      = var.contracts
    tenant_dn     = aci_tenant.terraform_tenant.id
    name          = each.value.contract
    description   = "Contract created using terraform"
}

resource "aci_contract_subject" "terraform_contract_subject" {
    for_each      = var.contracts
    contract_dn   = aci_contract.terraform_contract[each.key].id
    name          = each.value.subject
}

# add filter to contract subject

resource "aci_application_profile" "terraform_ap" {
    tenant_dn  = aci_tenant.terraform_tenant.id
    name       = var.ap
}

resource "aci_application_epg" "terraform_epg" {
    for_each                = var.epgs
    application_profile_dn  = aci_application_profile.terraform_ap.id
    name                    = each.value.epg
}

# ENSURE DOMAIN IS BOUND TO EPG
# resource "aci_epg_to_domain" "terraform_epg_domain" {
#     for_each              = var.epgs
#     application_epg_dn    = aci_application_epg.terraform_epg[each.key].id
#     tdn                   = aci_vmm_domain.example.id
# }

resource "aci_epg_to_contract" "terraform_epg_contract" {
    for_each           = var.epg_contracts
    application_epg_dn = aci_application_epg.terraform_epg[each.value.epg].id
    contract_dn  = aci_contract.terraform_contract[each.value.contract].id
    contract_type = each.value.contract_type
}

# aci_rest
resource "aci_rest" "rest_l3_ext_out" {
    path       = "/api/node/mo/${aci_tenant.terraform_tenant.id}/out-corp_l3.json"
    class_name = "l3extOut"

    content = {
        "name" = "corp_l3"
        "descr" = "Created Using Terraform"
    }
}

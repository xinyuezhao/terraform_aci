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

# ENSURE APPLICATIONS TENANT EXISTS
resource "aci_tenant" "terraform_tenant" {
    name        = var.tenant
    description = "This tenant is created by terraform"
}

resource "aci_rest" "rest_l3_ext_out" {
    path       = "/api/node/mo/${aci_tenant.terraform_tenant.id}/out-corp_l3.json"
    class_name = "l3extOut"

    content = {
        "name" = "corp_l3"
        "descr" = "Created Using Terraform"
    }
}
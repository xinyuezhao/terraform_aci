variable "user" {
  description = "Login information"
  type        = map
  default     = {
    username = "admin"
    password = "ins3965!"
    url      = "https://173.36.219.123"
  }
}

variable "filters" {
  description = "Create filters with these names"
  type        = map
  default     = {
    filter_https = {
      filter   = "https",
      entry    = "https",
      protocol = "tcp",
      port     = "443"
    },
    filter_sql = {
      filter   = "sql",
      entry    = "sql",
      protocol = "tcp",
      port     = "1433"
    }
  }
}

variable "contracts" {
  description = "Create contracts with these contracts"
  type        = map
  default     = {
    contract_web = {
      contract = "web",
      subject  = "https",
      filter   = "https"
    },
    contract_sql = {
      contract = "sql",
      subject  = "sql",
      filter   = "sql"
    }
  }
}

variable "ap" {
    description = "Create application profile"
    type        = string
    default     = "intranet"
}

variable "epgs" {
    description = "Create epg"
    type        = map
    default     = {
        web_epg = {
            epg   = "web",
            bd    = "prod_bd",
            encap = "21"
        },
        db_epg = {
            epg   = "db",
            bd    = "prod_bd",
            encap = "22"
        }
    }
}

variable "epg_contracts" {
    description = "epg contracts"
    type        = map
    default     = {
        terraform_one = {
            epg           = "web_epg",
            contract      = "contract_web",
            contract_type = "provider" 
        },
        terraform_two = {
            epg           = "web_epg",
            contract      = "contract_sql",
            contract_type = "consumer" 
        },
        terraform_three = {
            epg           = "db_epg",
            contract      = "contract_sql",
            contract_type = "provider" 
        }
    }
}

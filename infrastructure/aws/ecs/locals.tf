locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    CostCenter  = "1"
    Application = "FlipTheScript"
    Owner       = "leticia.valladares@cloudreach.com"
  }

  resource_suffix = join("-", ["ec1", "flipthescript"])

    subnets = [
    {
      name     = "public-snet-a"
      type     = "public"
      cidr     = "10.1.10.0/24"
      vpc      = "external"
      rtb      = "public-snet-a"
      main_rtb = true
      az       = "eu-central-1a"
      routes = [{
        name      = "1"
        cidr_dest = "0.0.0.0/0"
        dest      = "igw"
        vpc       = "external"
        rtb       = "public-snet-a"
      }]
    },
        {
      name     = "public-snet-b"
      type     = "public"
      cidr     = "10.1.11.0/24"
      vpc      = "external"
      rtb      = "public-snet-b"
      main_rtb = false
      az       = "eu-central-1b"
      routes = [{
        name      = "2"
        cidr_dest = "0.0.0.0/0"
        dest      = "igw"
        vpc       = "external"
        rtb       = "public-snet-b"
      }]
    },
    {
      name     = "private-snet-a"
      type     = "private"
      cidr     = "10.1.2.0/24"
      vpc      = "external"
      rtb      = "private-snet-a"
      main_rtb = false
      az       = "eu-central-1a"
      routes = [{
        name      = "3"
        cidr_dest = "0.0.0.0/0"
        dest      = "nat"
        vpc       = "external"
        rtb       = "private-snet-a"
      }]

    },
    {
      name     = "private-snet-b"
      type     = "private"
      cidr     = "10.1.3.0/24"
      vpc      = "external"
      rtb      = "private-snet-b"
      main_rtb = false
      az       = "eu-central-1b"
      routes = [{
        name      = "4"
        cidr_dest = "0.0.0.0/0"
        dest      = "nat"
        vpc       = "external"
        rtb       = "private-snet-b"
        }]
    },
    {
      name     = "private-snet-c"
      type     = "private"
      cidr     = "10.1.4.0/24"
      vpc      = "external"
      rtb      = "private-snet-c"
      main_rtb = false
      az       = "eu-central-1c"
      routes = [{
        name      = "5"
        cidr_dest = "0.0.0.0/0"
        dest      = "nat"
        vpc       = "external"
        rtb       = "private-snet-c"
      }]
    }
  ]

  public_snets  = [for subnet, val in local.subnets : val.name if val.type == "public"]
  private_snets = [for subnet, val in local.subnets : val.name if val.type == "private"]

  vpcs = {
    external = {
      cidr           = "10.1.0.0/16"
    }
  }
}
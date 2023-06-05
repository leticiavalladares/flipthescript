locals {
  default_tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    CostCenter  = "1"
    Application = "FlipTheScript"
    Owner       = "leticia.valladares@cloudreach.com"
  }

  resource_suffix = join("-", ["ec1", "flipthescript"])
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# The Default Provider (Virginia - "On-Prem")
provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

# The Secondary Provider (Oregon - "Cloud")
provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}
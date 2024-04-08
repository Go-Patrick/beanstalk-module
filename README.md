# GO Terraform
Common terraform modules used at Golden Owl Solutions.
## Structure
### Modules
Contains list of modules that can be used
### Samples
How to apply modules in real case.

## How to use each module
- Create a new file provider.tf like this:
```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "patrick"
}
```

- Then import 
```terraform
module "module" {
  source               = "../../modules/module"
  some_variable = var.variable
}
```
- Then run command
```bash
terraform init
terraform apply -var-file=../../samples/sample.tfvars -auto-approve
```
## Submodules
- We can use some submodule inside some modules

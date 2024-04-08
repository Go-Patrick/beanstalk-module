# Beanstalk module
## Prerequisites
- A domain registered on route 53 (configured CNAME for authorization)
## How to use
- Use modules with different workspaces with different variables as the example.tfvars file with your own file name dev.tfvars
- Change to new workspace
```
terraform workspace new dev
terraform workspace select dev
```
- Run command to init terraform, then
```
terraform apply -var-file="dev.tfvars"
```
- Wait for the process

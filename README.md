# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
Once you've installed the dependencies, there are 3 main parts you should notice:
**First: Define and apply Azure Policy:**
  1. Create Resource Group by using template code at file: /policy/create-resource.sh
  2. Define the Azure Policy by running the command:
  `az policy definition create --name {policyDefinitionName} -- rules './policy/resource-policy.json' --display-name {policyDisplayName}`
  3. Assign Policy by running the command:
  `az policy assignment create --name {policyApplyName} --scope {your-scope} --policy {policyDefinitionName}`

**Second: Create Virtual Machine Image with Packer**
  1. Run the command to build the Packer File Image:
  `packer build server.json`
  2. Run the command to check the image are created:
  `az image list`
  3. Run this command if you want to delete the image:
  `az image delete`

**Third: Create Azure Resource with Terraform**
  1. First you need to create new file: `testing.tfvars` (naming with your style) to define all the variable value for applying the new resource
  2. You have to define the value for the `testing.tfvars` following the `variables.tf` file
  3. Run the command to show the plan created by Terraform:
  `terraform plan -var-file testing.tfvars -out solution.plan`
  4. Run the command to apply the creation to the Azure Portal:
  `terrafrorm apply solution.plan`
  5. If you want to destroy your resources created use this command:
  `terraform destroy -var-file testing.tfvars`


### Output
Here is the output for each scopes run:
**Define and apply Azure Policy:**
Azure Policy defined at the file: resource-policy.json are defined at Azure Portal

**Create Virtual Machine Image with Packer**
When you run the `az image list` command, make sure the virtual machine image are listed

**Create Azure Resource with Terraform**
Make sure you see all the resources create in Azure Portal when you run the `terraform apply`:
- Resource Group
- Virtual Network and Subnet on that
- Network Security Group allow traffic in the same subnet and deny all direct access from internet
- Network Interface
- Public IP
- Load Balancer
- Virtual Machine Scale Set
- Virtual Machines with image create by Packer
- Managed disks for the virtual machines


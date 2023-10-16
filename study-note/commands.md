Azure Policy commands:
 - az policy definition create: create azure policy definition
 - az policy assignment create: create azure policy assignment

Packer commands:
 - packer build <filename>: build the packer file
 - packer build -var 'client_id=my_client_id' -var 'client_secret=my_client_secret' your-packer-template.json: build the packer with variable
 - az image list: list all image created
 - az image delete -g packer: delete image 
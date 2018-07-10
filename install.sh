#!/bin/bash

curl -s --output terraform.zip https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_darwin_amd64.zip
unzip terraform.zip
rm -f terraform.zip
chmod +x terraform
mkdir -p ${HOME}/bin 
export PATH=${PATH}:${HOME}/bin
mv terraform ${HOME}/bin/
terraform -v

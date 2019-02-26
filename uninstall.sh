#!/bin/bash

version=0.1.0

echo "Terraform Uninstall v${version}"
echo "https://github.com/plus3it/terraform-bootstrap"
echo "------------------------------------------------"

terraform_installed=true
command -v terraform >/dev/null 2>&1 || { terraform_installed=false; }

if [ "${terraform_installed}" = true ] ; then
  echo "Attempting to remove Terraform"
  brew uninstall terraform >/dev/null 2>&1
  rm /usr/local/bin/terraform >/dev/null 2>&1
  rm "${GOPATH}/bin/terraform" >/dev/null 2>&1
  rm "${HOME}/bin/terraform" >/dev/null 2>&1

  terraform_installed=true
  command -v terraform >/dev/null 2>&1 || { terraform_installed=false; }

fi

if [ "$terraform_installed" = false ] ; then
  echo "Terraform successfully uninstalled"
else
  echo "Unable to uninstall Terraform"
fi

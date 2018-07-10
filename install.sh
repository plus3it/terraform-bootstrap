#!/bin/bash

echo "Terraform Bootstrap"
echo "https://github.com/YakDriver/terraform-bootstrap"
echo "------------------------------------------------"

# get the latest version -----------------------------
latest_github_release=https://github.com/hashicorp/terraform/releases/latest

latest_url=$(curl -LIs -o /dev/null -w %{url_effective} $latest_github_release)
latest_version=${latest_url##*/}

if [[ $latest_version == v* ]]; then
  # strip the v off
  latest_version=${latest_version#*v}
fi

echo "Latest Terraform version is $latest_version"

# get the platform -----------------------------------
platform=$(uname | tr '[:upper:]' '[:lower:]')
case $platform in
  darwin|freebsd|openbsd|solaris) echo "Platform specific download exists";;
  *)                              platform=linux;;
esac

echo "Your platform is $platform"

# get the processor ----------------------------------
processor=$(uname -m)
case "$processor" in
  x86_64      )   processor=amd64;;
  arm*        )   processor=arm;;
  *           )   processor=386;;
esac

echo "Your processor is $processor"

# download -------------------------------------------
echo "Downloading Terraform from HashiCorp..."
curl -so terraform.zip https://releases.hashicorp.com/terraform/${latest_version}/terraform_${latest_version}_${platform}_${processor}.zip

# Install --------------------------------------------
echo "Installing Terraform..."

unzip terraform.zip
rm -f terraform.zip
chmod +x terraform

success=0

# try /usr/local/bin first
install_location=/usr/local/bin
if [ -d $install_location ]; then
  mv -f terraform $install_location \
    && success=1
fi

# if that fails, try $HOME/bin
if [ $success -eq 0 ]; then
  install_location=$HOME/bin
  mkdir -p $install_location \
    && mv -f terraform $install_location \
    && success=1
fi

if [ $success -eq 1 ]; then
  # successfully installed so check path
  found=0
  echo "$PATH" | grep -q $install_location && found=1
  if [ $found -eq 0 ]; then
    echo "WARNING: Terraform was not installed to a location in your path."
    echo "If you want Terraform to be available in subsequent sessions, add "
    echo "$install_location to the path in .profile, .bash_profile or "
    echo "/etc/profile."

    # add terraform to path for current session
    export PATH=${PATH}:$install_location
  else
    echo "Terraform is available on your current path."
  fi

  echo "Terraform was installed at $install_location/terraform."

  terraform -v

else
  # wasn't installed
  echo "ERROR: Terraform was not installed."
fi

#!/bin/bash

version=0.1.0

echo "Terraform Bootstrap v${version}"
echo "https://github.com/plus3it/terraform-bootstrap"
echo "------------------------------------------------"

# get the platform -----------------------------------
platform=$(uname | tr '[:upper:]' '[:lower:]')
case "${platform}" in
  darwin|freebsd|openbsd|solaris) echo "Platform specific download exists";;
  *)                              platform=linux;;
esac

echo "Your platform is $platform ($(uname))"

# get the processor ----------------------------------
processor=$(uname -m)
case "${processor}" in
  x86_64      )   processor=amd64;;
  arm*        )   processor=arm;;
  *           )   processor=386;;
esac

echo "Your processor is ${processor} ($(uname -m))"

# check jq -------------------------------------------
jq_installed=true
jq_self_install=false
command -v jq >/dev/null 2>&1 || { jq_installed=false; }

if [ "$jq_installed" = false ] ; then
  echo 'Attempting to download jq'
  jq_ver=jq-1.6

  # https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64
  # https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
  # https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32
  case "${platform}-${processor}" in
    linux-amd64       )   jq_platform='linux64';;
    linux-*           )   jq_platform='linux32';;
    darwin-amd64      )   jq_platform='osx-amd64';;
    *                 )   jq_platform='';;
  esac

  if [ "${jq_platform}" != "" ] ; then
    jq_url="https://github.com/stedolan/jq/releases/download/${jq_ver}/jq-${jq_platform}"
    curl -L "${jq_url}" -o jq && chmod +x jq
    jq_self_install=true
    echo 'Successfully downloaded jq'
    PATH=${PATH}:.
  fi

  jq_installed=true
  command -v jq >/dev/null 2>&1 || { jq_installed=false; }
  if [ "$jq_installed" = false ] ; then
    # last ditch
    sudo apt-get install jq >/dev/null 2>&1
    sudo dnf install jq >/dev/null 2>&1
    sudo zypper install jq >/dev/null 2>&1
    sudo pacman -Sy jq >/dev/null 2>&1
    brew install jq >/dev/null 2>&1
    pkg install jq >/dev/null 2>&1
    pkgutil -i jq >/dev/null 2>&1
    chocolatey install jq >/dev/null 2>&1
    yum install jq >/dev/null 2>&1
  fi

  jq_installed=true
  command -v jq >/dev/null 2>&1 || { jq_installed=false; }
  if [ "$jq_installed" = false ] ; then
    echo "Unable to install Terraform (error: jq could not be installed"
    exit 1
  fi
fi

echo "$(jq --version) available"

# get terraform version ------------------------------
terraform_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
echo "Latest Terraform version is ${terraform_version}"

if [ "${jq_self_install}" = true ] ; then
  rm -f jq
fi

# download -------------------------------------------
echo "Downloading Terraform from HashiCorp..."
curl -so terraform.zip "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_${platform}_${processor}.zip"

# Install --------------------------------------------
echo "Installing Terraform..."

unzip terraform.zip
rm -f terraform.zip
chmod +x terraform

success=false

# try /usr/local/bin first
install_location=/usr/local/bin
if [ -d "${install_location}" ]; then
  mv -f terraform "${install_location}" \
    && success=true
fi

# if that fails, try $GOPATH/bin
if [ "$GOPATH" != "" ] && [ "$success" = false ]; then
  install_location="${GOPATH}/bin"
  mkdir -p "${install_location}" \
    && mv -f terraform "${install_location}" \
    && success=true
fi

# if that fails, try $HOME/bin
if [ "$success" = false ]; then
  install_location="${HOME}/bin"
  mkdir -p "${install_location}" \
    && mv -f terraform "${install_location}" \
    && success=true
fi

if [ "$success" = true ]; then
  # successfully installed so check path
  found=false
  echo "$PATH" | grep -q "${install_location}" && found=true
  if [ "$found" = false ]; then
    echo "WARNING: Terraform was not installed to a location in your path."
    echo "If you want Terraform to be available in subsequent sessions, add "
    echo "${install_location} to the path in .profile, .bash_profile or "
    echo "/etc/profile."

    # add terraform to path for current session
    export PATH="${PATH}":"${install_location}"
  else
    echo "Terraform is available on your current path."
  fi

  echo "Terraform was installed at ${install_location}/terraform."

  exit 0

else
  # wasn't installed
  echo "ERROR: Terraform was not installed."

  exit 1
fi

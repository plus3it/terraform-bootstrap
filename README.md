# terraform-bootstrap

Downloads and installs Terraform on Linux/Mac.

This script should install the latest version of Terraform specific to your Linux-like / Mac system. If it doesn't work, please open an issue or, better yet, a pull request with the fix.

Installing Terraform's latest version is simple.

```shell
$ git clone https://github.com/plus3it/terraform-bootstrap.git
$ cd terraform-bootstrap && chmod +x install.sh && ./install.sh
```

The script will attempts multiple install locations. If you want the
broadest installation, you can `sudo` the script.

This is the typical output you might expect.
```shell
$ git clone https://github.com/plus3it/terraform-bootstrap.git
Cloning into 'terraform-bootstrap'...
remote: Counting objects: 7, done.
remote: Compressing objects: 100% (7/7), done.
remote: Total 7 (delta 1), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (7/7), done.
$ cd terraform-bootstrap
$ chmod +x install.sh
$ ./install.sh
Terraform Bootstrap
https://github.com/plus3it/terraform-bootstrap
------------------------------------------------
Latest Terraform version is 0.11.7
Platform specific download exists
Your platform is darwin (Darwin)
Your processor is amd64 (x86_64)
Downloading Terraform from HashiCorp...
Installing Terraform...
Archive:  terraform.zip
  inflating: terraform               
Terraform is available on your current path.
Terraform was installed at /usr/local/bin/terraform.
Terraform v0.11.7
```

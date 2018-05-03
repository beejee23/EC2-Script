#! /bin/bash
sudo yum update -y

# Install git
sudo yum install git -y

# Install node and npm
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -
sudo yum install -y nodejs

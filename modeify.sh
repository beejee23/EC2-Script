#! /bin/bash
sudo yum update -y

# Install git
sudo yum install git -y

# Install node and npm
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -
sudo yum install -y nodejs

# Clone conveyal/modeify.git
cd /home/ec2-user
git clone https://github.com/conveyal/modeify.git modeify-v1.3.0
cd modeify-v1.3.0
git checkout tags/v1.3.0

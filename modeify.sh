#! /bin/bash
sudo yum update -y

# Install git
sudo yum install git -y

# Install node and npm
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_8.x | sudo -E bash -
sudo yum install -y nodejs

# Install yarn
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum install -y yarn

# Clone conveyal/modeify.git
cd /home/ec2-user
git clone https://github.com/conveyal/modeify.git modeify-v1.3.0
cd modeify-v1.3.0
git checkout tags/v1.3.0

# Update modeify settings and environment files
cd /home/ec2-user
aws s3 sync s3://modeify-files modeify-files
sudo mv /home/ec2-user/modeify-files/settings.yml /home/ec2-user/modeify-v1.3.0/configurations/default/settings.yml
sudo mv /home/ec2-user/modeify-files/env.yml /home/ec2-user/modeify-v1.3.0/configurations/default/env.yml

# Run yarn
sudo chmod 755 -R /home/ec2-use/modeify-v1.3.0
cd /home/ec2-use/modeify-v1.3.0
sudo yarn install

#! /bin/bash
sudo yum update -y

# Install java 1.8 and remove 1.7
sudo yum -y install java-1.8.0-openjdk
sudo yum remove java-1.7.0-openjdk -y

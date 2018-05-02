#! /bin/bash
sudo yum update -y

# Install java 1.8 and remove 1.7
sudo yum -y install java-1.8.0-openjdk
sudo yum remove java-1.7.0-openjdk -y

# Download OSM and GTFS files
mkdir /home/ec2-user/delaware_r5
cd /home/ec2-user/delaware_r5

curl http://download.geofabrik.de/north-america/us/delaware-latest.osm.pbf -o delaware-latest.osm.pbf
curl -LO http://dartfirststate.com/information/routes/gtfs_data/dartfirststate_de_us.zip -o dartfirststate_de_us.zip

# Install git
sudo yum install git -y

# Install maven
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven

# Clone r5
mkdir /home/ec2-user/gitprojetcs
cd /home/ec2-user/gitprojetcs
git clone  https://github.com/conveyal/r5.git r5-3.2.0
cd r5-3.2.0
git checkout tags/v3.4.1
mvn package -DskipTests

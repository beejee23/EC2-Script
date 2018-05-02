#! /bin/bash
sudo yum update -y

# Install java 1.8 and remove 1.7
sudo yum -y install java-1.8.0-openjdk
sudo yum remove java-1.7.0-openjdk -y

# Download OSM and GTFS files
cd /home/ec2-user
mkdir delaware_r5
cd delaware_r5

curl http://download.geofabrik.de/north-america/us/delaware-latest.osm.pbf -o delaware-latest.osm.pbf
curl -LO http://dartfirststate.com/information/routes/gtfs_data/dartfirststate_de_us.zip -o dartfirststate_de_us.zip

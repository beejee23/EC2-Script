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

# Download the r5build from public bucket
cd /home/ec2-user
aws s3 sync s3://r5-3.2.0 r5build

# Build jar
cd /home/ec2-user/r5build
sudo java -Xmx1G -cp target/v3.4.1.jar com.conveyal.r5.R5Main point --build /home/ec2-user/delaware_r5
sudo java -Xmx1G -cp target/v3.4.1.jar com.conveyal.r5.R5Main point --graphs /home/ec2-user/delaware_r5

# Clone conveyal/modeify.git
cd /home/ec2-user
git clone https://github.com/conveyal/modeify.git modeify-v1.3.0
cd modeify-v1.3.0
git checkout tags/v1.3.0

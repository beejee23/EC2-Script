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
aws s3 sync s3://r5-3.2.0 r5build

# Build jar
cd /home/ec2-user/r5build
sudo java -Xmx1G -cp target/v3.4.1.jar com.conveyal.r5.R5Main point --build /home/ec2-user/delaware_r5
sudo java -Xmx1G -cp target/v3.4.1.jar com.conveyal.r5.R5Main point --graphs /home/ec2-user/delaware_r5

# Need to change the date
curl 'http://localhost:8080/otp/routers/default/index/graphql' -H 'Accept-Encoding: gzip, deflate' -H 'Content-Type: application/json; charset=UTF-8' --data-binary '{"query":"query requestPlan($fromLat:Float!, $fromLon:Float!,\n $toLat:Float!, $toLon:Float!, $wheelchair:Boolean\n $fromTime: ZonedDateTime!, $toTime:ZonedDateTime!,\n $bikeTrafficStress:Int!, $minBikeTime:Int!\n ) {\nplan(fromLat:$fromLat, fromLon:$fromLon, toLat:$toLat,toLon:$toLon, wheelchair:$wheelchair, fromTime:$fromTime, toTime:$toTime, \n \n directModes:[WALK,BICYCLE,CAR],\n accessModes:[WALK,BICYCLE,CAR_PARK], egressModes:[WALK],\ntransitModes:[BUS],\nbikeTrafficStress: $bikeTrafficStress, minBikeTime: $minBikeTime) {\n patterns {\n tripPatternIdx\n trips {\n tripId\n serviceId\n wheelchairAccessible\n bikesAllowed\n }\n }\n options {\n summary,\n fares {\n type,low,peak,senior, transferReduction, currency\n }\n itinerary {\n waitingTime\n walkTime\n distance\n transfers\n duration\n transitTime\n startTime\n endTime,\n connection {\n access\n egress,\n transit {\n pattern\n time\n }\n }\n \n }\n \n \n transit {\n from {\n name,\n stopId,\n lon,\n lat,\n wheelchairBoarding\n },\n to {\n name,\n stopId,\n lon,\n lat,\n wheelchairBoarding\n },\n mode,\n routes {id, routeIdx shortName, mode, agencyName},\n segmentPatterns {\n patternId, patternIdx,\n\trouteIdx\n fromIndex\n toIndex,\n fromDepartureTime\n toArrivalTime,\n tripId\n \n \n },\n middle {\n mode,\n duration,\n distance,\n geometryGeoJSON,\n }\n },\n \n access {\n mode,\n duration,\n distance,\n #geometryGeoJSON,\n \n #elevation {\n #distance\n #elevation\n #},\n #alerts {\n #alertHeaderText\n #alertDescriptionText\n #alertUrl\n #effectiveStartDate\n #effectiveEndDate\n #},\n streetEdges {\n #edgeId\n distance\n geometryGeoJSON\n mode\n streetName\n relativeDirection\n absoluteDirection\n #stayOn\n #area\n #exit\n #bogusName,\n bikeRentalOnStation {\n id,\n name,\n lat,lon\n }\n bikeRentalOffStation {\n id,\n name,\n lat,lon\n }\n parkRide {\n id,\n name,\n lat,lon\n }\n }\n },\n egress {\n mode,\n duration,\n distance,\n geometryGeoJSON,\n \n #elevation {\n #distance\n #elevation\n #},\n #alerts {\n #alertHeaderText\n #alertDescriptionText\n #alertUrl\n #effectiveStartDate\n #effectiveEndDate\n #},\n streetEdges {\n #edgeId\n #distance\n #geometryPolyline\n mode\n geometryGeoJSON,\n streetName\n relativeDirection\n absoluteDirection\n #stayOn\n #area\n #exit\n #bogusName,\n #bikeRentalOnStation {\n #id,\n #name,\n #lon,lat\n #}\n }\n }\n } \n }\n \n #patterns{patternId, startTime, endTime, realTime, arrivalDelay, departureDelay}\n} \n","variables":"{\"fromLat\":\"39.828905\",\"fromLon\":\"-75.538053\",\"toLat\":\"39.806424\",\"toLon\":\"-75.552387\",\"wheelchair\":false,\"fromTime\":\"2018-05-02T07:00-04:00\",\"toTime\":\"2018-05-02T09:00-04:00\",\"minBikeTime\":5,\"bikeTrafficStress\":4}"}' --compressed

# Clone conveyal/modeify.git
cd /home/ec2-user
git clone https://github.com/conveyal/modeify.git modeify-v1.3.0
cd modeify-v1.3.0
git checkout tags/v1.3.0

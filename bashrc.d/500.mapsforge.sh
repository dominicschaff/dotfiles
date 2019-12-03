#!/usr/bin/env bash

maps_last_update()
{
  curl -s -I http://download.mapsforge.org/maps/v5/africa/south-africa-and-lesotho.map | grep 'Last-Modified'
}

wget_quiet()
{
  wget --quiet --show-progress "$1" -O "$2"
}

maps_run()
{
  TOOLS="graphhopper-web-0.13.0.jar"
  wget_quiet "http://central.maven.org/maven2/com/graphhopper/graphhopper-web/0.13.0/$TOOLS" $TOOLS &
  wget_quiet "https://download.geofabrik.de/africa/south-africa-latest.osm.pbf" area.osm.pbf &
  wget_quiet "http://download.mapsforge.org/maps/v5/africa/south-africa-and-lesotho.map" area.map &

  wait

  cat - > config.yml <<EOF
graphhopper:
  datareader.file: area.osm.pbf
  graph.location: area
  graph.flag_encoders: car,foot|turn_costs=true
  prepare.ch.weightings: fastest
  prepare.min_network_size: 1
  prepare.min_one_way_network_size: 1
  routing.non_ch.max_waypoint_distance: 1000000
  graph.dataaccess: RAM_STORE
server:
  applicationConnectors:
  - type: http
    port: 8989
    bindHost: localhost
  requestLog:
      appenders: []
  adminConnectors:
  - type: http
    port: 8990
    bindHost: localhost
EOF
  java -Xmx4000m -Xms1000m -server -jar "$TOOLS" import config.yml

  rm config.yml area.osm.pbf "$TOOLS"
}

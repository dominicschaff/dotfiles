#!/usr/bin/env bash

maps_last_update()
{
  curl -s -I --continue http://download.mapsforge.org/maps/v5/africa/south-africa-and-lesotho.map | grep 'Last-Modified'
}

wget_quiet()
{
  wget --quiet --show-progress "$1" -O "$2"
}

maps_run()
{
  TOOLS="graphhopper.jar"
  wget_quiet "https://repo1.maven.org/maven2/com/graphhopper/graphhopper-web/3.0/graphhopper-web-3.0.jar" $TOOLS &
  wget_quiet "https://download.geofabrik.de/africa/south-africa-latest.osm.pbf" area.osm.pbf &
  wget_quiet "http://download.mapsforge.org/maps/v5/africa/south-africa-and-lesotho.map" south-africa-and-lesotho.map &
  wget_quiet "http://download.mapsforge.org/maps/world/world.map" world.map &

  wait

  cat - > config.yml <<EOF
graphhopper:
  datareader.file: area.osm.pbf
  graph.location: area
  graph.flag_encoders: car,foot
  graph.encoded_values: road_class,road_class_link,road_environment,max_speed,road_access,surface,toll,track_type
  datareader.preferred_language: en
  graph.do_sort: true
  prepare.min_network_size: 1
  prepare.min_one_way_network_size: 1
  routing.non_ch.max_waypoint_distance: 1000000
  graph.dataaccess: RAM_STORE
  profiles:
    - name: car
      vehicle: car
      weighting: fastest
    - name: foot
      vehicle: foot
      weighting: fastest
  profiles_ch:
    - profile: car
    - profile: foot
server:
  application_connectors:
  - type: http
    port: 8989
    bind_host: localhost
  request_log:
      appenders: []
  admin_connectors:
  - type: http
    port: 8990
    bind_host: localhost
EOF
  rm -rf area
  java -Xmx8g -Xms1g -server -jar "$TOOLS" import config.yml

  if [[ "$1" == "keep" ]]; then
    echo "Not deleting base files"
  else
    rm config.yml area.osm.pbf "$TOOLS"
  fi
}

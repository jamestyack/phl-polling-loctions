#!/usr/bin/env ruby

require 'rubygems'
require 'rest_client'
require 'json'
require 'pp'
require 'CSV'
require 'open-uri'

$building_access_categories = {}
$building_access_categories['B'] = "Building Substantially Accessible"
$building_access_categories['F'] = "Building Fully Accessible"
$building_access_categories['A'] = "Alternate entrance"
$building_access_categories['M'] = "Building Accessibility Modified"
$building_access_categories['R'] = "Accessible With Ramp"
$building_access_categories['N'] = "Building Not Accessible"

$bldg_access_band = {}
$bldg_access_band['B'] = "#3288bd"
$bldg_access_band['F'] = "#99d594"
$bldg_access_band['A'] = "#e6f598"
$bldg_access_band['M'] = "#fee08b"
$bldg_access_band['R'] = "#fc8d59"
$bldg_access_band['N'] = "#d53e4f"

locationOfCsvFile = "https://raw.githubusercontent.com/CityOfPhiladelphia/phl-polling-loctions/master/locations.csv"

csv_data = open(locationOfCsvFile).read()
csv = CSV.new(csv_data, :headers => :headers)

output = File.open( "../geojson/polling_locations.json", "w")
features = []
counter = 0;
csv.each do |row|
  counter = counter + 1
  feature = {}
  propertiesForGeoJson = {}
  assetProperties = {}
  row.each do | attribute |
    propertiesForGeoJson[attribute[0]] = attribute[1]
  end
  feature['type'] = "Feature"
  feature['properties'] = propertiesForGeoJson
  feature['properties']['marker-color'] = $bldg_access_band[feature['properties']['Building Accessibility']]
  feature['properties']['Building Access Desc'] = $building_access_categories[feature['properties']['Building Accessibility']]
  properties = feature['properties']
  geometry = {}
  geometry['type'] = "Point"
  geometry['coordinates'] = []
  geometry['coordinates'].push feature['properties']['longitude']
  geometry['coordinates'].push feature['properties']['latitude']
  feature['geometry'] = geometry
  features.push feature
end
geoWrapper = {}
geoWrapper['type'] = "FeatureCollection";
geoWrapper['features'] = features;
output.puts(geoWrapper.to_json)
output.close


# coding: utf-8
require 'sinatra'
require 'json'
require 'base64'

## WEB
require 'redis'


$redis = Redis.new

get '/nectar/services' do
  @toto = "Hello1 "
  erb :process, :layout => :main
end

get '/nectar/redis' do
  erb :redis, :layout => :main
end


## EYE command API
get '/nectar/service/:name/:action' do
  `eye #{params[:action]} #{params[:name]}`
end


## GET/SET API
get '/nectar/redis/get/:key' do

  ## Camera DATA is encoded in Base64 for rendering in the browser.
  return Base64.encode64($redis.get(params[:key])) if params[:key] == "camera0"

  ## render the key as text
  $redis.get(params[:key])
end

get '/nectar/redis/set/:key' do
  $redis.set(params[:key], params[:value])
end


get '/nectar/info/:name' do
  return `eye i -j` if params[:name] == "all"
  `eye i #{params[:name]} -j`
end



get '/nectar/load_configuration' do

  file = params[:file]
  output = params[:output]
  type = params[:type]

  #### Markerboard
  ## http://localhost:4567/nectar/load_configuration?file=data/calib1.svg&output=calib1&type=mb

  ## http://localhost:4567/nectar/load_configuration?file=data/calibration-AstraS-rgb.yaml&output=camera0:calibration&type=pd
  ## http://localhost:4567/nectar/load_configuration?file=data/calibration-AstraS-depth.yaml&output=camera0:calibration:depth&type=pd


  ## http://localhost:4567/nectar/load_configuration?file=data/A4-default-aruco.svg&output=A4-aruco&type=mb

  cp = File.read "apps/apps.txt"
  `java -cp "#{cp}:apps/apps.jar" tech.lity.rea.nectar.apps.ConfigurationLoader -f "#{file}" -o "#{output}" -#{type}`
end


  # cp = File.read "apps/apps.txt"
  # `java -cp "#{cp}:apps/apps.jar" tech.lity.rea.nectar.apps.ConfigurationLoader -f "#{file}" -o "#{output}" -#{type}`



## Shortcuts - camera0

get '/nectar/camera0/:action' do
  if params[:action] == "test"
    return `java -jar -Xmx64m apps/camera-server-test.jar --input camera0`
  end

  if params[:action] == "status"
    j = JSON.parse `eye info camera -j`
    return j["subtree"][0]["state"]
  end
  `eye #{params[:action]} camera`

end


## Used where ?
# `eye start camera_intrinsics` if request.include? "/nectar/camera0/intrinsics"

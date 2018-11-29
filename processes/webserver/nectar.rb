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


## API

get '/nectar/service/:name/:action' do
  `eye #{params[:action]} #{params[:name]}`
end


## GET/SET API
get '/nectar/redis/get/:key' do

  return Base64.encode64($redis.get(params[:key])) if params[:key] == "camera0"
  
  $redis.get(params[:key])

  


end

get '/nectar/redis/set/:key' do
  $redis.set(params[:key], params[:value])
end


get '/nectar/info/:name' do
  return `eye i -j` if params[:name] == "all" 
  `eye i #{params[:name]} -j`
end


## Load all configurations...
get '/nectar/load_configuration' do
  `apps/load-configuration-from-sketchbook.sh`
end


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

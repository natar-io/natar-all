# coding: utf-8
require 'sinatra'
require 'json'

get '/nectar/service/:name/:action' do
#  "Nectar service: #{params[:name]} do: #{params[:action]}!"

  `eye #{params[:action]} #{params[:name]}`
end

get '/nectar/services' do
  @toto = "Hello1 "
  erb :process, :layout => :main
end


get '/nectar/info/:name' do
  return `eye i -j` if params[:name] == "all" 
  `eye i #{params[:name]} -j`
end


get '/nectar/camera/:action' do

  `eye start camera` if params[:action].eql? "start"
  if params[:action].eql? "info"
    info = JSON.parse `eye i -j` 
    info.to_s
  end
end
 

# `eye start camera` if request.include? "/nectar/camera0/start"
# `eye stop camera` if request.include? "/nectar/camera0/stop"
# `eye restart camera` if request.include? "/nectar/camera0/restart"
# `eye start camera_test` if request.include? "/nectar/camera0/test"
# `eye start camera_intrinsics` if request.include? "/nectar/camera0/intrinsics"
# cameraStatus =  `eye i camera`
# intrinsicsStatus = `eye i camera_intrinsics`


# session.print "HTTP/1.1 200\r\n"
# session.print "Content-Type: text/html\r\n"
# session.print "\r\n"

# session.print cameraStatus.to_s
# session.print "<br/>"
# session.print intrinsicsStatus.to_s

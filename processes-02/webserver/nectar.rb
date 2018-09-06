# http_server.rb

require 'socket'

server = TCPServer.new 8124

while session = server.accept
  request = session.gets
  `eye start camera` if request.include? "/nectar/camera0/start"
  `eye stop camera` if request.include? "/nectar/camera0/stop"
  `eye start camera_test` if request.include? "/nectar/camera0/restart"
  `eye start camera_intrinsics` if request.include? "/nectar/camera0/intrinsics"
  cameraStatus =  `eye i camera`
  intrinsicsStatus = `eye i camera_intrinsics`


  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "\r\n"
 
  session.print cameraStatus.to_s
  session.print "<br/>"
  session.print intrinsicsStatus.to_s
  puts request

  session.close
end

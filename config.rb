# /etc/eye/config.rb
# vi:syntax=ruby   

Eye.load('./apps-enabled/*.rb')

Eye.config do
  logger '/tmp/eye.log'
end

Eye.application :nectar_server_dev_getset do
#  env 'RAILS_ENV' => RAILS_ENV
  trigger :flapping, times: 10, within: 1.minute
  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes-getset ]))

  process :redis do
   daemonize true
    pid_file 'redis/db/redis_6379.pid'
    stdall 'redis/nectar-redis.log'

    start_command "/usr/bin/redis-server redis.conf"
    # stop_signals [:TERM, 5.seconds, :KILL]
    # restart_command 'kill -USR2 {PID}'

    # just sleep this until process get up status
    # (maybe enought to puma soft restart)
    # restart_grace 10.seconds

    check :cpu, every: 30, below: 80, times: 3
    check :memory, every: 30, below: 70.megabytes, times: [3, 5]
  end

  process :camera do
   daemonize true
    pid_file 'apps/camera-server.pid'
    stdall 'apps/camera-server.log'

    start_command "java -jar apps/camera-server.jar
              --driver OPENNI2 
							--device-id 0 
							--format rgb 
							--output camera0 
              --resolution 640x480 
							--stream-set 
							--verbose" 

    # stop_signals [:TERM, 5.seconds, :KILL]
    # restart_command 'kill -USR2 {PID}'

    # just sleep this until process get up status
    # (maybe enought to puma soft restart)
    # restart_grace 10.seconds

    ##JVM does the memory check with Xmx
    # check :cpu, every: 30, below: 80, times: 3
    # check :memory, every: 30, below: 70.megabytes, times: [3, 5]
  end

  process :markers do
   daemonize true
    pid_file 'apps/marker-server.pid'
    stdall 'apps/marker-server.log'

    start_command "apps/markers-detection-server 
              --input camera0 
              --output camera0:markers 
              --camera-parameters camera0 
              --markerboard-file apps/markerboard_480-499.cfg 
              --calibration-file apps/no_distortion.cal 
              --marker-type 0 
              --stream-get 
              --verbose"
  end

  process :pose do
    daemonize true
    pid_file 'apps/pose-server.pid'
    stdall 'apps/pose-server.log'

    start_command "java -jar apps/pose-estimator-server.jar
              --input camera0:markers --output camera0:pose 
              --marker-configuration apps/calib1.svg 
              --camera-configuration apps/calibration-AstraS-rgb.yaml 
              --stream-set 
              --verbose"
  end

end


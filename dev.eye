

Eye.application :nectar_server_dev do
#  env 'RAILS_ENV' => RAILS_ENV
  trigger :flapping, times: 10, within: 1.minute
  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))

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

    start_command "java -Xmx64m -jar apps/camera-server.jar -d OPENCV -id 0 -o camera0"
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

    start_command "apps/markers-detection-server -i camera0 --camera-parameters camera0 -o camera0:markers"
  end
end


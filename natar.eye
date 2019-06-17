Eye.application :natar_core do
  auto_start false
  working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))

  process :redis do
    daemonize true
    pid_file 'redis/db/redis_6379.pid'

    start_command "/usr/bin/redis-server redis.conf"
    check :cpu, every: 30, below: 80, times: 3
    check :memory, every: 30, below: 70.megabytes, times: [3, 5]
  end

  process :natar_webserver do
    auto_start true
    daemonize true
    pid_file 'apps/natar-webserver.pid'
    stdall 'apps/natar-webserver.log'

    start_command "ruby webserver/natar.rb"
    depend_on :redis
  end

  process :camera do
    daemonize true
    pid_file 'apps/camera-server.pid'

    start_command "apps/camera-server.sh"
    use_leaf_child true
    depend_on :redis

    check :cpu, every: 30, below: 80
    check :memory, every: 30, below: 200.megabytes
  end

  process :calibration_natar do
    daemonize true
    pid_file 'apps/calibration-server.pid'

    start_command "apps/chilitags-tracker -i projector0 -o projector0:markers -s -v --camera-parameters projector0"
    depend_on :redis
    check :cpu, every: 30, below: 80
    check :memory, every: 30, below: 200.megabytes
  end

  process :chilitags do
    daemonize true
    pid_file 'apps/chilitags-tracker.pid'

    start_command "apps/chilitags-tracker --input camera0 --output camera0:chilitags --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

  process :aruco do
    daemonize true
    pid_file 'apps/aruco-tracker.pid'

    start_command "apps/aruco-tracker --input camera0 --output camera0:aruco --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end


  process :artoolkit do
    daemonize true
    pid_file 'apps/artoolkit-tracker.pid'
    stdall 'apps/artoolkitplus-tracker.log'

    start_command "apps/artoolkitplus-tracker --input camera0 --output camera0:artoolkitplus --camera-parameters camera0
    --calibration-file data/artoolkitplus/no_distortion.cal --markerboard-file data/artoolkitplus/markerboard_480-499.cfg
    --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

end

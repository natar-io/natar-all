## Note: Redis is now handled by systemd
## The webadmin is served on port 80 through nginx and unicorn
## Use the scripts to install redis.conf and nginx.conf 

Eye.application :natar_webadmin do
  auto_start true
  working_dir "/usr/share/natar-webserver/"

  ## We suppose that nginx runs
  process :server do
    daemonize true
    pid_file 'tmp/pids/unicorn.pid'

    # Set the natar webserver to production so that it loads the local bundle js
    env 'APP_ENV' => 'production'
#    start_command "ruby natar-webserver/natar.rb"
    start_command "bundle exec unicorn -c unicorn.rb -E production"
  end

end

Eye.application :natar_core do
  auto_start false

  ## not install
  # working_dir File.expand_path(File.dirname(__FILE__))

  ## Installed
  wd =  "/usr/share/natar-utilities/"
  working_dir "/usr/share/natar-utilities/"

  process :camera do
    daemonize false
    
    ### Problem: The program should be able to output its PID"
    pid_file 'tmp/camera-server.pid'
        
    cp = (File.read wd+"apps/classpaths/apps.txt").strip
    env "CLASSPATH" => cp
    start_command "java -Xmx128m tech.lity.rea.nectar.camera.CameraServerImpl --driver OPENNI2 --device-id 0 --format rgb --output camera0 --stream --depth-camera -v"

    #    start_command "apps/camera-server.sh"
    #    use_leaf_child true

    # check :cpu, every: 30, below: 80
    # check :memory, every: 30, below: 250.megabytes
  end

  process :calibration_natar do
    daemonize true
    pid_file 'tmp/calibration-server.pid'

    start_command "apps/chilitags-tracker -i projector0 -o projector0:markers -s -v --camera-parameters projector0"
    check :cpu, every: 30, below: 80
    check :memory, every: 30, below: 200.megabytes
  end

  process :chilitags do
    daemonize true
    pid_file 'tmp/chilitags-tracker.pid'

    start_command "apps/chilitags-tracker --input camera0 --output camera0:chilitags --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

  process :aruco do
    daemonize true
    pid_file 'tmp/aruco-tracker.pid'

    start_command "apps/aruco-tracker --input camera0 --output camera0:aruco --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end


  process :artoolkitplus do
    daemonize true
    pid_file 'tmp/artoolkitplus-tracker.pid'
    stdall 'tmp/artoolkitplus-tracker.log'

    start_command "apps/artoolkitplus-tracker --input camera0 --output camera0:artoolkitplus --camera-parameters camera0
    --calibration-file data/artoolkitplus/no_distortion.cal --markerboard-file data/artoolkitplus/markerboard_480-499.cfg
    --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

end

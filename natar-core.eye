## Note: Redis is now handled by systemd
## The webadmin is served on port 80 through nginx and unicorn
## Use the scripts to install redis.conf and nginx.conf 

Eye.application :natar_core do
  auto_start false

  ## not install
#  working_dir File.expand_path(File.dirname(__FILE__))

  ## Installed
  wd =  "/usr/share/natar-utilities/"
  working_dir "/usr/share/natar-utilities/"


  process :developper_mode do
    daemonize true
    
    ### Problem: The program should be able to output its PID"
    pid_file 'tmp/camera-client-dev.pid'
    stdall 'tmp/camera-client-dev.log'

    env "DISPLAY" => ":0"
    start_command "camera-client -i display0 -f"
    use_leaf_child true

    # check :cpu, every: 30, below: 80
    # check :memory, every: 30, below: 250.megabytes
  end


  process :pose_estimator do
    daemonize true
    
    pid_file 'tmp/pose-estimator.pid'
    stdall 'tmp/pose-estimator.log'

    start_command "natar-app tech.lity.rea.nectar.apps.MultiPoseEstimator -i camera0 -x"
    use_leaf_child true

  end
  
  process :camera do
    daemonize true
    
    ### Problem: The program should be able to output its PID"
    pid_file 'tmp/camera-server.pid'
    stdall 'tmp/camera-server.log'

    # cp = (File.read wd+"apps/classpaths/apps.txt").strip
    # env "CLASSPATH" => cp
    # start_command "java -Xmx128m tech.lity.rea.nectar.camera.CameraServerImpl --driver OPENNI2 --device-id 0 --format rgb --output camera0 --stream --depth-camera -v"

#    env "JAVA_OPTS" => "-Xmx8G #{ENV["JAVA_OPTS"]}"
#    -Xmx128m -cp $CP:/usr/share/java/natar-apps.ja
    start_command "camera-server --driver OPENNI2 --device-id 0 --format rgb --output camera0 --stream --depth-camera"
    use_leaf_child true

    # check :cpu, every: 30, below: 80
    # check :memory, every: 30, below: 250.megabytes
  end

  ## TODO: Finish the calibration...
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

    start_command "natar-tracker-chilitags --input camera0 --output camera0:chilitags --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

  process :aruco do
    daemonize true
    pid_file 'tmp/aruco-tracker.pid'

    ##     start_command "natar-tracker-aruco --input camera0 --output camera0:aruco --camera-parameters camera0 --stream -g" 
    start_command "natar-tracker-aruco --input camera0 --output camera0:markers --camera-parameters camera0 --stream -g"
    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end


  process :artoolkitplus do
    daemonize true
    pid_file 'tmp/artoolkitplus-tracker.pid'
    stdall 'tmp/artoolkitplus-tracker.log'

    start_command "natar-tracker-artoolkitplus --input camera0 --output camera0:markers --camera-parameters camera0 --calibration-file /usr/share/natar/natar-tracker-artoolkitplus-git/no_distortion.cal --markerboard-file /usr/share/natar/natar-tracker-artoolkitplus-git/markerboard_480-499.cfg --stream -g"

    depend_on :camera
    check :memory, every:10, below: 200.megabytes
  end

end

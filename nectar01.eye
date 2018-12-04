Eye.application :nectar_core do
    auto_start false
	working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))

	process :redis do
	    daemonize true
		pid_file 'redis/db/redis_6379.pid'
#		stdall 'redis/nectar-redis.log'

		start_command "/usr/bin/redis-server redis.conf"
		check :cpu, every: 30, below: 80, times: 3
		check :memory, every: 30, below: 70.megabytes, times: [3, 5]
    end

    process :nectar do
        daemonize true
        pid_file 'apps/nectar-server.pid'
#        stdall 'apps/nectar-server.log'

        start_command "ruby webserver/nectar.rb"
        depend_on :redis
    end
    
    process :camera do
        daemonize true
        pid_file 'apps/camera-server.pid'
#		stdall 'apps/camera-server.log'

		start_command "java -jar -Xmx128m apps/camera-server.jar --driver OPENNI2 --device-id 0 --format rgb --output camera0 --stream --depth-camera"
        depend_on :redis
#        check :cpu, every: 30, below: 80
#        check :memory, every: 30, below: 200.megabytes
    end

    
    process :calibration_nectar do
        daemonize true
        pid_file 'apps/calibration-server.pid'
#		stdall 'apps/camera-server.log'

        start_command "apps/chilitags-server -i projector0 -o projector0:markers -s -v --camera-parameters projector0"
        depend_on :redis
#        check :cpu, every: 30, below: 80
#        check :memory, every: 30, below: 200.megabytes
    end

    process :chilitags do
        daemonize true
        pid_file 'apps/chilitags-server.pid'
#        stdall   'apps/chilitags-server.log'

        start_command "apps/chilitags-server --input camera0 --output camera0:markers --camera-parameters camera0 --stream"
        depend_on :camera
        check :memory, every:10, below: 200.megabytes
    end

    process :aruco do
        daemonize true
        pid_file 'apps/aruco-server.pid'
#        stdall   'apps/chilitags-server.log'

        start_command "apps/aruco-server --input camera0 --output camera0:markers --camera-parameters camera0 --stream"
        depend_on :camera
        check :memory, every:10, below: 200.megabytes
    end

    
    process :artoolkit do
        daemonize true
        pid_file 'apps/artoolkit-server.pid'
#        stdall   'apps/chilitags-server.log'

        start_command "apps/artk-server --input camera0 --output camera0:markers --camera-parameters camera0 --stream"
        depend_on :camera
        check :memory, every:10, below: 200.megabytes
    end

        
    process :pose do
        daemonize true
		pid_file 'apps/pose-server.pid'
#		stdall 'apps/pose-server.log'
		start_command "java -jar -Xmx64m apps/pose-estimator.jar --input camera0 --output sheet:pose --marker-configuration apps/chili1.svg --camera-configuration apps/calibration-AstraS-rgb.yaml --stream"
 
		depend_on :chilitags
    end

    process :camera_test do 
        daemonize true
        pid_file 'apps/camera-test.pid'
#        stdall 'apps/camera-test.log'

        start_command "java -jar -Xmx64m apps/camera-server-test.jar --input camera0"
        depend_on :camera
    end

    ## Will get outside of EYE soon
    process :projector_intrinsics do
        pid_file 'apps/projector_intrinsics.pid'
#        stdall 'apps/projector_intrinsics.log'

        start_command "java -jar -Xmx64m apps/config-loader --file apps/projector.yaml -o projector0:calibration -pd -pr"
    end

    process :projector_extrinsics do
        pid_file 'apps/projector_extrinsics.pid'
#        stdall 'apps/projector_extrinsics.log'

        start_command "java -jar -Xmx64m apps/config-loader --file apps/camProjExtrinsics.xml -o projector0:extrinsics -m -i"
    end

    process :camera_intrinsics do
        daemonize false
        pid_file 'apps/camera_intrinsics.pid'
#        stdall 'apps/camera_intrinsics.log'

        start_command "java -jar -Xmx64m apps/config-loader --file apps/calibration-AstraS-rgb.yaml -pd -o camera0:calibration"
    end
end

Eye.application :nectar_dev do
    auto_start false
	working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes-getset ]))

	process :redis do
	    daemonize true
		pid_file 'redis/db/redis_6379.pid'
		stdall 'redis/nectar-redis.log'

		start_command "/usr/bin/redis-server redis.conf"
		check :cpu, every: 30, below: 80, times: 3
		check :memory, every: 30, below: 70.megabytes, times: [3, 5]
    end
    
    process :camera do
        daemonize true
        pid_file 'apps/camera-server.pid'
		stdall 'apps/camera-server.log'

		start_command "java -jar -Xmx64m apps/camera-server.jar
							--driver OPENNI2
							--device-id 0 
							--format rgb 
							--output camera0 
							--resolution 640x480 
							--stream
							--stream-set 
							--depth-camera camera0:depth 
							--verbose" 
        depend_on :redis
        check :cpu, every: 30, below: 80
        check :memory, every: 30, below: 120.megabytes
    end
    
    process :chilitags do
        daemonize true
        pid_file 'apps/chilitags-server.pid'
        stdall   'apps/chilitags-server.log'

        start_command "apps/chilitags-server
                        --input camera0 
                        --output camera0:markers 
                        --camera-parameters camera0 
                        --stream
                        --stream-set"

        depend_on :camera
        check :memory, every:10, below: 200.megabytes
    end

    process :pose do
        daemonize true
		pid_file 'apps/pose-server.pid'
		stdall 'apps/pose-server.log'

		start_command "java -jar -Xmx64m apps/pose-estimator-papart-server.jar
								--input camera0
								--output camera0:pose
								--camera-configuration apps/calibration-AstraS-rgb.yaml 
								--marker-configuration apps/chili1.svg  
								--stream 
								--stream-set"
        depend_on :chilitags
        check :memory, every:10, below: 200.megabytes
    end
end

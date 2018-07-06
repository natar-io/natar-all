Eye.application :nectar_server_dev_getset do
	trigger :flapping, times: 10, within: 1.minute
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
							--stream 
							--stream-set
							--verbose"
		depend_on :camera
	end

	process :pose do
		daemonize true
		pid_file 'apps/pose-server.pid'
		stdall 'apps/pose-server.log'

		start_command "java -jar -Xmx64m apps/pose-estimator-server.jar
								--input camera0:markers --output camera0:pose 
								--marker-configuration apps/calib1.svg 
								--camera-configuration apps/calibration-AstraS-rgb.yaml 
								--stream-set 
								--verbose"
		depend_on :markers
	end

	process :chilis do
		daemonize true
		pid_file 'apps/chili-server.pid'
		stdall 'apps/chili-server.log'

		start_command "apps/markers-detection-server 
								--input camera0 
								--output camera0:markers
								--camera-parameters camera0 
								--markerboard-file apps/markerboard_480-499.cfg 
								--calibration-file apps/no_distortion.cal 
								--marker-type 1
								--stream
								--stream-set 
								--verbose"
		depend_on :camera
	end

	process :pose_stable do
		daemonize true
		pid_file 'apps/pose-papart-server.pid'
		stdall 'apps/pose-papart-server.log'

		start_command "java -jar -Xmx64m apps/pose-estimator-papart-server.jar
								--input camera0
								--output camera0:pose
								--camera-configuration apps/calibration-AstraS-rgb.yaml 
								--marker-configuration apps/chili1.svg  
								--stream 
								--stream-set
								--verbose"
		depend_on :chilis
	end

end


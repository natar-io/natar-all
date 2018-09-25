Eye.application :nectar_papart_dev do
	trigger :flapping, times: 10, within: 1.minute
	working_dir File.expand_path(File.join(File.dirname(__FILE__), %w[ processes ]))

	process :redis do
	        daemonize true
		pid_file 'redis/db/redis_6379.pid'
		stdall 'redis/nectar-redis.log'

		start_command "/usr/bin/redis-server redis.conf"
		check :cpu, every: 30, below: 80, times: 3
		check :memory, every: 30, below: 70.megabytes, times: [3, 5]
	end

	process :camera do
		pid_file 'apps/camera-server.pid'
		stdall 'apps/camera-server.log'

		start_command "java -jar -Xmx128m apps/camera-server.jar
							--driver OPENNI2	
							--device-id 0 
							--format rgb 
							--output camera0 
							--resolution 640x480 
							--stream
							--depth-camera camera0:depth" 
		depend_on :redis
	end

## java -jar -Xmx128m apps/camera-server.jar --driver OPENNI2 --device-id 0 --format rgb --output camera0 	--resolution 640x480 --stream --depth-camera camera0:depth"
	process :chili do
		pid_file 'apps/chili.pid'
		stdall 'apps/chili.log'

		start_command "apps/chilitags-server
					--input camera0 
					--output camera0:markers 
					--camera-parameters camera0 
					--stream"
                # apps/chilitags-server	--input camera0 --output camera0:markers --camera-parameters camera0 --stream
	end

        process :calib do
          pid_file 'apps/calib-chili.pid'
          stdall 'apps/calib-chili.pid'
          start_command "apps/chilitags-server -i projector0 -o projector0:markers -s --camera-parameters projector0"
        end

	process :aruco do
          daemonize true
	  pid_file 'apps/aruco.pid'
	  stdall 'apps/aruco.log'
	  start_command "apps/aruco-server 
	  		--input camera0 
			--output camera0:markers 
			--camera-parameters camera0 
			--stream"
	end


	  process :artoolkit do
	    daemonize true
		pid_file 'apps/artoolkit.pid'
		stdall 'apps/artoolkit.log'

		start_command "apps/artk-server 
					--input camera0 
					--output camera0:markers 
					--camera-parameters camera0 
					--markerboard-file apps/markerboard_480-499.cfg 
					--calibration-file apps/no_distortion.cal 
					--stream"
	end

end


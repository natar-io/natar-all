Eye.application :natar_webserver do
  auto_start true
  working_dir "/usr/share/natar-webserver/"

  ## We suppose that nginx runs
  process :server do
    daemonize true
    pid_file 'tmp/pids/unicorn.pid'
    stdall 'tmp/unicorn.log'
 
    # Set the natar webserver to production so that it loads the local bundle js
    env 'APP_ENV' => 'production'
#    start_command "ruby natar-webserver/natar.rb"
    start_command "bundle exec unicorn -c unicorn.rb -E production"
  end

end

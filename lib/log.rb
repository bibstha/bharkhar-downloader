require 'logger'
Log           = Logger.new(Bharkhar.config.fetch('log_path'))
Log.formatter = proc { |severity, datetime, progname, msg|
  dt = datetime.strftime('%Y-%b-%d@%H:%M:%S:%z')
  "#{[severity,dt,progname,msg].join(' ').squeeze(' ')}\n"
}
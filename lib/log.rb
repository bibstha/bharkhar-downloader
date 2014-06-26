require 'logger'
Log           = Logger.new('log/botcoin.log')
Log.formatter = proc { |severity, datetime, progname, msg|
  dt = datetime.strftime('%Y-%b-%d@%H:%M:%S:%z')
  "#{[severity,dt,progname,msg].join(' ').squeeze(' ')}\n"
}
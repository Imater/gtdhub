winston = require 'winston'
config = require '../../config/environment'

transports = [];

winston.remove winston.transports.Console if config.isProduction

winston.add winston.transports.File,
  filename: config.logfile
  maxsize: 20000

module.exports = winston

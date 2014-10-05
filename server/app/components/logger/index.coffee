winston = require 'winston'
config = require '../../config/environment'

transports = [];

winston.remove winston.transports.Console if config.isProduction

console.info config.root + config.logfile

winston.add winston.transports.File,
  filename: config.root + config.logfile
  maxsize: 20000

module.exports = winston

winston = require 'winston'
config = require '../../config/environment'

transports = [];

winston.remove winston.transports.Console if config.isProduction

winston.add winston.transports.File,
  filename: '../../../logs/winston/service-db.log'
  maxsize: 20000

module.exports = winston

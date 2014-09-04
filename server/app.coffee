process.env.NODE_ENV = process.env.NODE_ENV or "development"
express = require("express")
mongoose = require("mongoose")
config = require("./config/environment")
Sequelize = require 'sequelize'
amqp = require "amqplib"

# Connect to database
mongoose.connect config.mongo.uri, config.mongo.options

Sequelize.sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'postgres'
  port: config.db.port or 5433
  logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100
)

amqp.connect("amqp://localhost").then (_conn) ->
  amqp.conn = _conn

process.on 'exit', () ->
  amqp.conn.close()

# Populate DB with sample data
require "./config/seed"  if config.seedDB

# Setup server
app = express()
server = require("http").createServer(app)
socketio = require("socket.io").listen(server)
require("./config/socketio") socketio
require("./config/express") app
require("./routes") app


Sequelize.sequelize.sync().complete (err) ->
  if err
    console.info "sync error"
    throw err
  else
    # Start server
    console.info 'start-listen'
    server.listen config.port, config.ip, ->
      console.log "Express server listening on %d, in %s mode", config.port, app.get("env")


# Expose app
exports = module.exports = app

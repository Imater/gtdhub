process.env.NODE_ENV = process.env.NODE_ENV or "development"
express = require("express")
mongoose = require("mongoose")
config = require("./config/environment")
Sequelize = require 'sequelize'
amqp = require "amqp"

Sequelize.sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'mysql'
  port: config.db.port or 3306
  logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100
)

amqp.conn = amqp.createConnection
  host: config.amqp.host
  port: config.amqp.port
  login: config.amqp.login
  password: config.amqp.password
  connectionTimeout: 30000
  authMechanism: "AMQPLAIN"
  vhost: "/gtdhub/db"
  noDelay: true
  ssl:
    enabled: false

amqp.conn.on "connect", ()->
  console.info "Queue connection ok"


amqp.rpc = new (require("./components/rpc"))(amqp.conn)

amqp.conn.on "ready", ()->
  console.info "Queue connection Ready"

if false
  setTimeout ->
    amqp.rpc.makeRequest "api1.article.get1", {ass: 2, index: 1}, (err, answer) ->
      console.info "ANSWER", err, answer
  , 5000


process.on 'exit', () ->
  amqp.conn.close() if amqp.conn

# Populate DB with sample data
require "./config/seed" if config.seedDB

# Setup server
app = express()
server = require("http").createServer(app)
socketio = require("socket.io").listen(server)
#require("./config/socketio") socketio
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

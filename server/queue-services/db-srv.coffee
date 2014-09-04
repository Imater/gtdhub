amqp = require "amqplib"
config = require("../config/environment")
Sequelize = require 'sequelize'
_ = require 'lodash'

Sequelize.sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'postgres'
  port: config.db.port or 5433
  logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100
)

controller = require("../api/article")

listenQueue = (conn, listenPath, workerFunction) ->
  conn.createChannel().then (ch) ->
    reply = (msg) ->
      replyFunction = (status, res)->
        console.info 'yes sir! ;-)       ' + listenPath + "  "+ new Date().getTime()
        ch.sendToQueue msg.properties.replyTo, new Buffer(JSON.stringify({status, res})),
          correlationId: msg.correlationId
          ch.ack msg

      workerFunction JSON.parse(msg.content.toString()),
        json: replyFunction
        send: replyFunction
    ok = ch.assertQueue(listenPath,
      durable: true
    )
    ok = ok.then ->
      ch.prefetch 1
      ch.consume listenPath, reply

    ok.then ->
      console.info "Waiting server for "+listenPath


amqp.connect("amqp://localhost").then (conn) ->
  amqp.conn = conn
  _.each controller, (workerFunction, queuePath) ->
    listenQueue conn, queuePath, workerFunction
  process.once "SIGINT", ->
    conn.close()


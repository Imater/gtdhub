amqp = require "amqplib"
config = require("../config/environment")
Sequelize = require 'sequelize'

Sequelize.sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'postgres'
  port: config.db.port or 5433
  logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100
)

controller = require("../api/article/article.controller")

amqp.connect("amqp://localhost").then (conn) ->
  process.once "SIGINT", ->
    conn.close()
  conn.createChannel().then (ch) ->
    reply = (msg) ->
      controller.index msg.content.toString(),
        json: (status, res)->
          console.info 'yes sir! ;-)       ' + new Date().getTime()
          ch.sendToQueue msg.properties.replyTo, new Buffer(JSON.stringify({status, res})),
            correlationId: msg.correlationId
            ch.ack msg
    q = "api.article"
    ok = ch.assertQueue(q,
      durable: true
    )
    ok = ok.then ->
      ch.prefetch 1
      ch.consume q, reply

    ok.then ->
      console.info "Waiting server..."

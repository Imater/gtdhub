amqp = require "amqplib"
config = require("./config/environment")
Sequelize = require 'sequelize'
hs = require('node-handlersocket');
_ = require 'lodash'

Sequelize.sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'mysql'
  port: config.db.port or 3306
  #logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100
)

con = hs.connect({host: '127.0.0.1', port: 9999})
hs.con = con
con.on 'connect', ()->
  con.openIndex 'gtdhub', 'articles', 'PRIMARY', ['title', 'html'], (err, index) ->
    console.time 'start'
    index.find '=', [1], (err, records) ->
      console.timeEnd 'start'
      console.info err, records

controller = require("./api/article")

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


amqp.connect("amqp://edx:edx@localhost/gtdhub").then (conn) ->
  amqp.conn = conn
  _.each controller, (workerFunction, queuePath) ->
    listenQueue conn, queuePath, workerFunction
  process.once "SIGINT", ->
    console.info "close"
    conn.close()


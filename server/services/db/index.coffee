amqp = require "amqp"
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

con = hs.connect
  host: config.handlersocket.host
  port: config.handlersocket.port

hs.con = con
con.on 'error', (err)->
  console.info "handlersocket error", err
con.on 'connect', ()->
  con.openIndex 'gtdhub', 'articles', 'PRIMARY', ['title', 'html'], (err, index) ->
    console.time 'start'
    index.find '=', [1], (err, records) ->
      console.timeEnd 'start'
      console.info err, records

controller = require("./api/article")

if false
  amqp.conn.queue "api/article/tmp", (q) ->
    console.info "queue ok"
    q.bind("#");
    q.subscribe { ack: true, prefetchCount: 1 }, (message)->
      console.info "Message", message

if false
  listenQueue = (conn, listenPath, workerFunction) ->
    conn.queue listenPath, (q) ->
      console.info "Waiting server for "+listenPath
      q.bind("#")
      reply = (msg) ->
        replyFunction = (status, res)->
          console.info 'yes sir! ;-)       ' + listenPath + "  "+ new Date().getTime()
          ch.sendToQueue msg.properties.replyTo, new Buffer(JSON.stringify({status, res})),
            correlationId: msg.correlationId
            ch.ack msg

        workerFunction JSON.parse(msg.content.toString()),
          json: replyFunction
          send: replyFunction
      q.subscribe listenPath, reply
      return

listenQueue = (conn, listenPath, workerFunction) ->
  amqp.conn.queue listenPath, (q) ->
    replyFunction = (m) ->
      (status, res)->
        amqp.conn.publish m.replyTo,
          status: status
          res: res
        ,
          contentType: "application/json"
          contentEncoding: "utf-8"
          correlationId: m.correlationId

    console.info "queue waiting for #{listenPath}"
    q.subscribe (message, headers, deliveryInfo, m) ->
      console.info "RECIEVED RPC", deliveryInfo.routingKey, message
      workerFunction message,
        json: replyFunction(m)
        send: replyFunction(m)

###        console.info 'yes sir! ;-)       ' + listenPath + "  "+ new Date().getTime()
        ch.sendToQueue msg.properties.replyTo, new Buffer(JSON.stringify({status, res})),
          correlationId: msg.correlationId
          ch.ack msg

###
      #return index sent


createChannels = (conn) ->
  _.each controller, (workerFunction, queuePath) ->
    listenQueue conn, queuePath, workerFunction
  #process.once "SIGINT", ->
  #  console.info "close"
  #  conn.close()

amqp.conn = amqp.createConnection
  host: config.amqp.host
  port: config.amqp.port
  login: config.amqp.login
  password: config.amqp.password
  connectionTimeout: 3000
  authMechanism: "AMQPLAIN"
  vhost: "/gtdhub/db"
  noDelay: true
  ssl:
    enabled: false

amqp.conn.on "connect", ()->
  console.info "Queue connection ok"

amqp.conn.on "ready", ()->
  console.info "Queue connection Ready"
  createChannels amqp.conn
  console.log "listening on msg_queue"
  amqp.conn.queue "api1.article.get1", (q) ->
    console.info 'queue ok connected'
    q.subscribe (message, headers, deliveryInfo, m) ->
      console.info "RECIEVED RPC", deliveryInfo.routingKey, message

      #return index sent
      amqp.conn.publish m.replyTo,
        response: "OK"
        index: message.index
      ,
        contentType: "application/json"
        contentEncoding: "utf-8"
        correlationId: m.correlationId

if false
  amqp.conn.queue "api/article/tmp", (q) ->
    console.info "queue ok"
    q.bind("#");
    q.subscribe { ack: true, prefetchCount: 1 }, (message)->
      console.info "Message", message

amqp.conn.on "error", (err)->
  console.info "QUEUE error = ", err

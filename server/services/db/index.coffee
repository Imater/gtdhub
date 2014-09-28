amqp = require "amqp"
config = require("./config/environment")
mongoose = require("mongoose")
_ = require 'lodash'

# Connect to database
mongoose.connect "mongodb://178.62.223.164/gtdhub,"+
  "mongodb://188.226.143.126/gtdhub,"+
  "mongodb://178.62.7.92/gtdhub", (err) ->
    if err
      console.info "Mongo connection error #{err}"
    else
      console.info "Mongo connected"

mongoose.set('trace', true);

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

controller = require("./api/article")

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

amqp.conn.on "error", (err)->
  console.info "QUEUE error = ", err

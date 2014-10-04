amqp = require "amqp"
config = require("./config/environment")
mongoose = require("mongoose")
_ = require 'lodash'
logger = require("./components/logger")
# Connect to database
mongoose.connect config.mongo.hosts, (err) ->
    if err
      logger.info "Mongo connection error #{err}"
    else
      logger.info "Mongo connected"

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

    logger.info "queue waiting for #{listenPath}"
    q.subscribe (message, headers, deliveryInfo, m) ->
      logger.info "RECIEVED RPC", deliveryInfo.routingKey, message
      workerFunction message,
        json: replyFunction(m)
        send: replyFunction(m)

controller = require("./api/article")

createChannels = (conn) ->
  _.each controller, (workerFunction, queuePath) ->
    listenQueue conn, queuePath, workerFunction
  #process.once "SIGINT", ->
  #  logger.info "close"
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
  logger.info "Queue connection ok"

amqp.conn.on "ready", ()->
  logger.info "Queue connection Ready"
  createChannels amqp.conn

amqp.conn.on "error", (err)->
  logger.info "QUEUE error = ", err

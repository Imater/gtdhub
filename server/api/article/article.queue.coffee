amqp = require "amqplib"
uuid = require "node-uuid"

conn = undefined

amqp.connect("amqp://localhost").then (_conn) ->
  conn = _conn


askQueue = (channelPath, cb) ->
  return (req, res) ->
    corrId = uuid()
    responseFn = (answer, conn) ->
      answer = JSON.parse(answer.content.toString())
      res.setHeader("Content-Type", "application/json");
      res.json answer.status, answer.res
    amqp.conn.createChannel().then (ch) ->
      ok = ch.assertQueue "",
        exclusive: true
      .then (qok) ->
        qok.queue

      ok = ok.then (queue) ->
        ch.consume queue, (answer)->
          responseFn(answer, conn)
        ,
          noAck: true
        .then ->
          queue

      ok.then (queue) ->
        queueReq = { body: req.body, params: req.params }
        ch.sendToQueue channelPath, new Buffer( JSON.stringify( queueReq ) ),
          correlationId: corrId
          replyTo: queue

express = require("express")
controller = require("./article.controller")
router = express.Router()
router.get "/", askQueue("api1.article.get")
router.get "/:id", askQueue("api1.article.get.id")
router.post "/", askQueue("api1.article.post")
router.put "/:id", askQueue("api1.article.put.id")
router.patch "/:id", askQueue("api1.article.patch.id")
router.delete "/:id", askQueue("api1.article.delete.id")
module.exports = router



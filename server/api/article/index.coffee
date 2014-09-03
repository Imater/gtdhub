amqp = require "amqplib"
uuid = require "node-uuid"
queueResponse = (cb) ->
  return (req, res) ->
    corrId = uuid()
    responseFn = (answer, conn) ->
      answer = JSON.parse(answer.content.toString())
      res.json answer.status, answer.res
      conn.close()
    amqp.connect("amqp://localhost").then (conn) ->
      conn.createChannel().then (ch) ->
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
          ch.sendToQueue "api.article", new Buffer( JSON.stringify( queueReq ) ),
            correlationId: corrId
            replyTo: queue



express = require("express")
controller = require("./article.controller")
router = express.Router()
router.get "/", queueResponse controller.index
router.get "/:id", controller.show
router.post "/", controller.create
router.put "/:id", controller.update
router.patch "/:id", controller.update
router.delete "/:id", controller.destroy
module.exports = router



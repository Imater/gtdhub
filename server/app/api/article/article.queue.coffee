amqp = require "amqp"
uuid = require "node-uuid"

logger = require "winston"

askQueue = (channelPath, cb) ->
  return (req, res) ->
    logger.profile "Ask queue #{channelPath}"
    queueReq = { body: req.body, params: req.params }
    console.info "send request to queue", channelPath
    amqp.rpc.makeRequest channelPath, queueReq, (err, answer) ->
      if err
        res.send 500, err
        return
      console.info "answer is ..........", err, answer
      res.setHeader("Content-Type", "application/json");
      logger.profile "Ask queue #{channelPath}"
      res.json answer.status, answer.res

if false
  ok = ok.then (queue) ->
    ch.consume queue, (answer)->
      responseFn(answer, amqp.conn)
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
router = express.Router()
router.get "/", askQueue("api1.article.get")
router.get "/:id", askQueue("api1.article.get.id")
router.post "/", askQueue("api1.article.post")
router.put "/:id", askQueue("api1.article.put.id")
router.patch "/:id", askQueue("api1.article.patch.id")
router.delete "/:id", askQueue("api1.article.delete.id")
module.exports = router



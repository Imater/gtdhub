fib = (n) ->

  # Do it the ridiculous, but not most ridiculous, way. For better,
  # see http://nayuki.eigenstate.org/page/fast-fibonacci-algorithms
  a = 0
  b = 1
  i = 0

  while i < n
    c = a + b
    a = b
    b = c
    i++
  a
amqp = require("amqplib")
amqp.connect("amqp://localhost").then((conn) ->
  process.once "SIGINT", ->
    conn.close()
    return

  conn.createChannel().then (ch) ->
    reply = (msg) ->
      n = parseInt(msg.content.toString())
      console.log " [.] fib(%d)", new Date().getTime()
      response = fib(n)
      ch.sendToQueue msg.properties.replyTo, new Buffer(response.toString()),
        correlationId: msg.properties.correlationId

      ch.ack msg
      return
    q = "rpc_queue"
    ok = ch.assertQueue(q,
      durable: false
    )
    ok = ok.then(->
      ch.prefetch 1
      ch.consume q, reply
    )
    return ok.then(->
      console.log " [x] Awaiting RPC requests"
      return
    )
    return

).then null, console.warn
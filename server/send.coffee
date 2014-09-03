amqp = require("amqplib")
basename = require("path").basename
when_ = require("when")
defer = when_.defer
uuid = require("node-uuid")

# I've departed from the form of the original RPC tutorial, which
# needlessly introduces a class definition, and doesn't even
# parameterise the request.
n = undefined
try
  throw Error("Too few args")  if process.argv.length < 3
  n = parseInt(process.argv[2])
catch e
  console.error e
  console.warn "Usage: %s number", basename(process.argv[1])
  process.exit 1
amqp.connect("amqp://localhost").then((conn) ->
  when_(conn.createChannel().then((ch) ->
    maybeAnswer = (msg) ->
      console.timeEnd("long")
      answer.resolve msg.content.toString()  if msg.properties.correlationId is corrId
      return
    answer = defer()
    corrId = uuid()
    ok = ch.assertQueue("",
      exclusive: true
    ).then((qok) ->
      qok.queue
    )
    ok = ok.then((queue) ->
      ch.consume(queue, maybeAnswer,
        noAck: true
      ).then ->
        queue

    )
    ok = ok.then((queue) ->
      console.time("long")
      console.log " [x] Requesting fib(%d)", n
      ch.sendToQueue "rpc_queue", new Buffer(n.toString()),
        correlationId: corrId
        replyTo: queue

      answer.promise
    )
    ok.then (fibN) ->
      console.log " [.] Got %d", fibN
      return

  )).ensure ->
    conn.close()
    return

).then null, console.warn
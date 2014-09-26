#time to wait for response in ms
AmqpRpc = (connection) ->
  self = this
  @connection = (if typeof (connection) isnt "undefined" then connection else amqp.createConnection())
  @requests = {} #hash to store request in wait for response
  @response_queue = false #plaseholder for the future queue
  return
amqp = require("amqp")
crypto = require("crypto")
TIMEOUT = 12000
CONTENT_TYPE = "application/json"
exports = module.exports = AmqpRpc
AmqpRpc::makeRequest = (queue_name, content, callback) ->
  self = this
  console.info "Request", content

  #generate a unique correlation id for this call
  correlationId = crypto.randomBytes(16).toString("hex")

  #create a timeout for what should happen if we don't get a response
  tId = setTimeout((corr_id) ->

    #if this ever gets called we didn't get a response in a
    #timely fashion
    callback new Error("timeout " + corr_id)

    #delete the entry from hash
    delete self.requests[corr_id]

    return
  , TIMEOUT, correlationId)

  #create a request entry to store in a hash
  entry =
    callback: callback
    timeout: tId #the id for the timeout so we can clear it


  #put the entry in the hash so we can match the response later
  self.requests[correlationId] = entry

  #make sure we have a response queue
  self.setupResponseQueue ->
    #put the request on a queue
    self.connection.publish queue_name, content,
      correlationId: correlationId
      contentType: CONTENT_TYPE
      replyTo: self.response_queue

    return

  return

AmqpRpc::setupResponseQueue = (next) ->
  #don't mess around if we have a queue
  return next()  if @response_queue
  self = this

  #create the queue
  self.connection.queue "",
    exclusive: true
  , (q) ->

    #store the name
    self.response_queue = q.name

    #subscribe to messages
    q.subscribe (message, headers, deliveryInfo, m) ->

      #get the correlationId
      correlationId = m.correlationId

      #is it a response to a pending request
      if correlationId of self.requests

        #retreive the request entry
        entry = self.requests[correlationId]

        #make sure we don't timeout by clearing it
        clearTimeout entry.timeout

        #delete the entry from hash
        delete self.requests[correlationId]


        #callback, no err
        entry.callback null, message
      return

    next()

  return

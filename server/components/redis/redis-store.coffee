###*
This is a very basic example of how you can implement your own Redis-based
cache store with connection pooling.
###
redis_store = (args) ->
  connect = (cb) ->
    pool.acquire (err, conn) ->
      if err
        pool.release conn
        return cb(err)
      conn.select args.db  if args.db or args.db is 0
      cb null, conn if cb
      return

    return
  args = args or {
  }
  self = {}
  ttl = args.ttl
  self.name = "redis"
  self.client = require("redis").createClient(6379, '127.0.0.1', {})
  redis_options =
    host: args.host or "127.0.0.1"
    port: args.port or 6379

  pool = RedisPool(redis_options, {})
  self.get = (key, cb) ->
    connect (err, conn) ->
      return cb(err)  if err
      conn.get key, (err, result) ->
        pool.release conn
        return cb(err)  if err
        cb null, JSON.parse(result) if cb
        return

      return

    return

  self.set = (key, value, cb) ->
    connect (err, conn) ->
      return cb(err)  if cb and err
      if ttl
        conn.setex key, ttl, JSON.stringify(value), (err, result) ->
          pool.release conn
          cb err, result
          return

      else
        conn.set key, JSON.stringify(value), (err, result) ->
          pool.release conn
          cb err, result if cb
          return

      return

    return

  self.del = (key, cb) ->
    connect (err, conn) ->
      return cb(err)  if cb and err
      conn.del key, (err, result) ->
        pool.release conn
        cb err, result if cb
        return

      return

    return

  self.keys = (pattern, cb) ->
    if typeof pattern is "function"
      cb = pattern
      pattern = "*"
    connect (err, conn) ->
      return cb(err)  if cb and err
      conn.keys pattern, (err, result) ->
        pool.release conn
        cb err, result if cb
        return

      return

    return

  self
RedisPool = require("sol-redis-pool")
module.exports = create: (args) ->
  redis_store args

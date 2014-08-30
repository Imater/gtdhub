###
Broadcast updates to client when the model changes
###
onSave = (socket, doc, cb) ->
  socket.emit "article:save", doc
onRemove = (socket, doc, cb) ->
  socket.emit "article:remove", doc
"use strict"
article = require("./article.model")
exports.register = (socket) ->
  article.schema.post "save", (doc) ->
    onSave socket, doc

  article.schema.post "remove", (doc) ->
    onRemove socket, doc


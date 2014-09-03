"use strict"
###
Broadcast updates to client when the model changes
###
onSave = (socket, doc, cb) ->
  console.info "save...."
  socket.emit "article:save", doc
onRemove = (socket, doc, cb) ->
  socket.emit "article:remove", doc
article = require("./article.model")
exports.register = (socket) ->
  db.article.hook "afterUpdate", (doc) ->
    onSave socket, doc
  db.article.hook "afterDestroy", (doc) ->
    onRemove socket, doc


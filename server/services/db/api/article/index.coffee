amqp = require "amqplib"
uuid = require "node-uuid"

conn = undefined

amqp.connect("amqp://localhost").then (_conn) ->
  conn = _conn

if false
  express = require("express")
  controller = require("./article.controller.coffee")
  router = express.Router()
  router.get "/", controller.index
  router.get "/:id", controller.show
  router.post "/", controller.create
  router.put "/:id", controller.update
  router.patch "/:id", controller.update
  router.delete "/:id", controller.destroy

controller = require("./article.controller.coffee")

queueController =
  'api1.article.get': controller.index
  'api1.article.get.id': controller.show
  'api1.article.post': controller.create
  'api1.article.put.id': controller.update
  'api1.article.patch.id': controller.update
  'api1.article.delete.id': controller.destroy

module.exports = queueController



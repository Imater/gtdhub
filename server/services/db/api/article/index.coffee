controller = require("./article.controller.coffee")

queueController =
  'api1.article.get': controller.index
  'api1.article.get.id': controller.show
  'api1.article.post': controller.create
  'api1.article.put.id': controller.update
  'api1.article.patch.id': controller.update
  'api1.article.delete.id': controller.destroy

module.exports = queueController



"use strict"
###
Using Rails-like standard naming convention for endpoints.
GET     /articles              ->  index
POST    /articles              ->  create
GET     /articles/:id          ->  show
PUT     /articles/:id          ->  update
DELETE  /articles/:id          ->  destroy
###

# Get list of articles

# Get a single article

# Creates a new article in the DB.

# Updates an existing article in the DB.

# Deletes a article from the DB.
handleError = (res, err) ->
  res.send 500, err

_ = require("lodash")
hs = require('node-handlersocket');

db = require './article.model.coffee'
cache_manager = require('cache-manager')
memory_cache = cache_manager.caching({store: 'memory', max: 5, ttl: 1})
#
allFields = Object.keys(db.article.rawAttributes)

exports.index =
  (req, res) ->
    hs.con.openIndex 'gtdhub', 'articles', 'PRIMARY', allFields, (err, index) ->
      index.find '>=', [0], {limit: 1000, offset: 0}, (err, articles) ->
        return res.send(404)  unless articles
        articles = _.map articles, (value, key)->
          _.zipObject allFields, value
        res.json 200, articles

exports.create = (req, res) ->
  db.article.create(req.body)
  .complete (err, article) ->
    key = 'article_'+article.id
    memory_cache.wrap key, (cacheCb) ->
      cacheCb(err, article)
    , (err, article) ->
      res.json 201, article

exports.show = (req, res) ->
    hs.con.openIndex 'gtdhub', 'articles', 'PRIMARY', allFields, (err, index) ->
      index.find '=', [req.params.id], {limit: 1, offset: 0}, (err, article) ->
        return res.send(404)  unless article
        article = _.zipObject allFields, article[0]
        res.json 200, article

exports.update = (req, res) ->
  db.article.find
    where:
      id: req.params.id
  .complete (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
    updated = _.merge(article, req.body)
    updated.save().complete (err, article) ->
      key = 'article_'+req.params.id
      memory_cache.del(key)
      return handleError(res, err)  if err
      res.json 200, article

exports.destroy = (req, res) ->
  db.article.find
    where:
      id: req.params.id
  .complete (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
    article.destroy().complete (err) ->
      key = 'article_'+req.params.id
      memory_cache.del(key)
      return handleError(res, err)  if err
      res.send 204

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
db = require './article.model.coffee'
cache_manager = require('cache-manager')
memory_cache = cache_manager.caching({store: 'memory', max: 5, ttl: 1})
#

exports.index =
  (req, res) ->
    key = 'articles'
    memory_cache.wrap key, (cacheCb) ->
      db.article.findAll().complete (err, result) ->
        console.info 'not_from_cache'
        cacheCb(err, result)
    , (err, result) ->
      res.json 200, result

exports.create = (req, res) ->
  db.article.create(req.body)
  .complete (err, article) ->
    key = 'article_'+article.id
    memory_cache.wrap key, (cacheCb) ->
      cacheCb(err, article)
    , (err, article) ->
      res.json 201, article

exports.show = (req, res) ->
  key = 'article_'+req.params.id
  memory_cache.wrap key, (cacheCb) ->
    console.info 'not_from_cache = ', key, memory_cache.keys()
    db.article.find
      where:
        id: req.params.id
    .complete (err, article) ->
      cacheCb err, article
  , (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
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

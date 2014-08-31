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
db = require '../../models'
cache_manager = require('cache-manager')
memory_cache = cache_manager.caching({store: 'memory', max: 10000, ttl: 1})

exports.index = (req, res) ->
  key = Math.round Math.random()*10
  memory_cache.wrap key, (cacheCb) ->
    db.article.findAll().complete (err, result) ->
      console.info 'not_from_cache'
      cacheCb(err, result)
  , (err, result) ->
    res.json 200, result

exports.create = (req, res) ->
  db.article.create
    title: "first article"
    date: new Date()
    active: true
    html: "<h1>Hello!!!</h1>"
  .complete (err, result) ->
    res.send true
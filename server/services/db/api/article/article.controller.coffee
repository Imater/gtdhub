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

Article = require("./article.model.coffee")

exports.index =
  (req, res) ->
    Article.find (err, articles) ->
      return handleError(res, err)  if err
      res.json 200, articles

exports.show = (req, res) ->
  console.info "show ...."
  Article.findById req.params.id, (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
    res.json article

exports.create = (req, res) ->
  Article.create req.body, (err, article) ->
    return handleError(res, err)  if err
    res.json 201, article

exports.update = (req, res) ->
  delete req.body._id  if req.body._id
  Article.findById req.params.id, (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
    updated = _.merge(article, req.body)
    updated.save (err) ->
      return handleError(res, err)  if err
      res.json 200, article

exports.destroy = (req, res) ->
  Article.findById req.params.id, (err, article) ->
    return handleError(res, err)  if err
    return res.send(404)  unless article
    article.remove (err) ->
      return handleError(res, err)  if err
      res.send 204

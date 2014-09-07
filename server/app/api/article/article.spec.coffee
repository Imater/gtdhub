"use strict"
app = require("../../index")
request = require("supertest")(app)
should = require("should")
Article = require("./../../../services/db/api/article/article.model.coffee")


describe "GET /api/articles", ->
  it "should respond with JSON array", (done) ->
    request.get("/api/articles").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof Array
      done()

  it "should respond with JSON array Again, to test cache", (done) ->
    request.get("/api/articles").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof Array
      done()

describe "Article  save", ->
  newId = undefined
  oldLength = undefined

  it "should respond with JSON array", (done) ->
    request.get("/api/articles").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      oldLength = res.body.length
      res.body.should.be.instanceof Array
      done()

  it "add new Article", (done) ->
    request.post("/api/articles")
    .send({
      title: 'News title 2'
      html: '<br>'
      date: new Date()
      active: true
    }).expect(201)
    .end (err, res) ->
      newId = res.body.id
      done();

  for i in [0..3]
    it "can show just added with cache "+i, (done) ->
      request.get("/api/articles/"+newId)
      .expect(200).end (req, res) ->
        res.body.title.should.be.equal 'News title 2'
        done()

  it "can edit just saved new title", (done) ->
    request.put("/api/articles/"+newId)
    .send({title: 'New Title NOW CHANGED'})
    .expect(200).end (req, res) ->
      res.body.title.should.be.equal 'New Title NOW CHANGED'
      done()

  it "can show just edited", (done) ->
    request.get("/api/articles/"+newId)
    .expect(200).end (req, res) ->
      res.body.title.should.be.equal 'New Title NOW CHANGED'
      done()

  it "can show just edited from cache", (done) ->
    request.get("/api/articles/"+newId)
    .expect(200).end (req, res) ->
      res.body.title.should.be.equal 'New Title NOW CHANGED'
      done()

  it "can destroy just edited", (done) ->
    request.del("/api/articles/"+newId)
    .expect(200).end (req, res) ->
      done()



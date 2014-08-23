"use strict"
should = require("should")
app = require("../../app")
request = require("supertest")
Article = require("./article.model")


describe "GET /api/articles", ->
  it "should respond with JSON array", (done) ->
    request(app).get("/api/articles").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      res.body.should.be.instanceof Array
      done()

describe "Article save", ->
  newId = undefined
  oldLength = undefined

  it "should respond with JSON array", (done) ->
    request(app).get("/api/articles").expect(200).expect("Content-Type", /json/).end (err, res) ->
      return done(err) if err
      oldLength = res.body.length
      res.body.should.be.instanceof Array
      done()

  it "add new Article", (done) ->
    request(app).post("/api/articles")
    .send(
      title: 'News title 2'
      html: '<br>'
      date: new Date()
      active: true
    )
    .expect(201)
    .end (err, res) ->
      newId = res.body._id
      done();

  it "can read just saved", (done) ->
    request(app).get("/api/articles").expect(200).end (req, res) ->
      res.body.length.should.be.equal (oldLength+1)
      done()

  it "can edit just saved", (done) ->
    request(app).put("/api/articles/"+newId)
    .send({title: 'New Title NOW CHANGED'})
    .expect(200).end (req, res) ->
      console.info res.error
      res.body.title.should.be.equal 'New Title NOW CHANGED'
      done()

  it "can show just edited", (done) ->
    request(app).get("/api/articles/"+newId)
    .expect(200).end (req, res) ->
      res.body.title.should.be.equal 'New Title NOW CHANGED'
      done()

  it "can destroy just edited", (done) ->
    request(app).del("/api/articles/"+newId)
    .expect(200).end (req, res) ->
      done()
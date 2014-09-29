"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema
ModelSchema = new Schema({
    title: String
    html: String
    date: Date
    active: Boolean
  }, {
    read: 'nearest'
  }
)
module.exports = mongoose.model("Article", ModelSchema)

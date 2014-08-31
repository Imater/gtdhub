"use strict"
mongoose = require("mongoose")
Schema = mongoose.Schema
ArticleSchema = new Schema(
  title: String
  html: String
  date:
    type: Date
  active: Boolean
)
module.exports = mongoose.model("Article", ArticleSchema)

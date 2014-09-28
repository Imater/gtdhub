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

###
Sequelize = require 'sequelize'
sequelize = Sequelize.sequelize



sequelize.define 'article',
    title:
      type: Sequelize.STRING

    html:
      type: Sequelize.STRING

    date:
      type: Sequelize.DATE

    active:
      type: Sequelize.BOOLEAN
      defaultValue: false

module.exports = sequelize.models

###

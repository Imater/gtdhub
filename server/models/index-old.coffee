fs = require 'fs'
path = require 'path'
Sequelize = require 'sequelize'
lodash = require 'lodash'
config = require("../config/environment")

excludeFiles = ['index.coffee']
sequelize = new Sequelize(config.db.name, config.db.username, config.db.password,
  dialect: 'postgres'
  port: config.db.port or 5433
  logging: false
  pool:
    maxConnections: 50
  maxConcurrentQueries: 100

)
db = {}

fs.readdirSync(__dirname)
.filter (file) ->
  (file.indexOf('.') isnt 0) and (file not in excludeFiles) and (file.slice(-7) is ".coffee")
.forEach (file) ->
  model = sequelize.import(path.join(__dirname, file))
  db[model.name] = model

Object.keys(db).forEach (modelName) ->
  if db[modelName].options.hasOwnProperty('associate')
    db[modelName].options.associate db

module.exports = lodash.extend(
  sequelize: sequelize
  Sequelize: Sequelize
  db
)



"use strict"

# Development specific configuration
# ==================================
module.exports =

# MongoDB connection options
  mongo:
    uri: "mongodb://localhost/gtdhub-dev"

  seedDB: false

  db:
    name: "gtdhub"
    username: "root"
    password: ""
    port: 3306

  amqp:
    host: "localhost"
    port: 5672
    login: "db"
    password: "gtdhubdb"

  handlersocket:
    host: "localhost"
    port: 9998

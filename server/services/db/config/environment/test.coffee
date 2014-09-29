"use strict"

# Test specific configuration
# ===========================

# MongoDB connection options
module.exports =
  mongo:
    uri: "mongodb://localhost/gtdhub-test"
  seedDB: true

  db:
    name: "gtdhub-test"
    username: "postgres"
    password: "990990"
    port: 5433

  amqp:
    host: "localhost"
    port: 5672
    login: "db"
    password: "gtdhubdb"

  handlersocket:
    host: "localhost"
    port: 9998

  logfile: "../../../logs/winston/service-db.log"

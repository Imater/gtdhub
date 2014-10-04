"use strict"

# Production specific configuration
# =================================
module.exports =

# Server IP
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or `undefined`

# Server port
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080

# MongoDB connection options
  mongo:
    uri: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or process.env.OPENSHIFT_MONGODB_DB_URL + process.env.OPENSHIFT_APP_NAME or "mongodb://localhost/trello"
    hosts: "mongodb://node-1/gtdhub, mongodb://node-2/gtdhub, mongodb://node-3/gtdhub"

  db:
    name: "gtdhub"
    username: "postgres"
    password: "990990"
    port: 5432

  amqp:
    host: "178.62.235.131"
    port: 5672
    login: "db"
    password: "gtdhubdb"

  handlersocket:
    host: "localhost"
    port: 9998

  logfile: "/var/projects/gtdhub/logs/winston/service-db.log"

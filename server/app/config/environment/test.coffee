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
    username: "root"
    password: ""
    port: 3306

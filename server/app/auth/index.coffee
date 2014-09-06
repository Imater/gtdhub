"use strict"
express = require("express")
passport = require("passport")
config = require("../config/environment/index")
User = require("../api/user/user.model.coffee")

# Passport Configuration
require("./local/passport").setup User, config
require("./facebook/passport").setup User, config
require("./google/passport").setup User, config
require("./twitter/passport").setup User, config
router = express.Router()
router.use "/local", require("./local/index")
router.use "/facebook", require("./facebook/index")
router.use "/twitter", require("./twitter/index")
router.use "/google", require("./google/index")
module.exports = router

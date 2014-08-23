# Protractor configuration
# https://github.com/angular/protractor/blob/master/referenceConf.js

"use strict"
exports.config =
  seleniumAddress: 'http://0.0.0.0:4444/wd/hub'

# The timeout for each script run on the browser. This should be longer
# than the maximum time your application needs to stabilize between tasks.
  allScriptsTimeout: 110000

# A base URL for your application under test. Calls to protractor.get()
# with relative paths will be prepended with this.
  baseUrl: "http://localhost:" + (process.env.PORT or "9000")

  params: '---start-maximized --disable-popup-blocking'

  dfkaljdfa: 'dsf'
# If true, only chromedriver will be started, not a standalone selenium.
# Tests for browsers other than chrome will not run.
  chromeOnly: false

# list of files / patterns to load in the browser
  specs: ["e2e/**/*.spec.coffee"]

# Patterns to exclude.
  exclude: []

# ----- Capabilities to be passed to the webdriver instance ----
#
# For a full list of available capabilities, see
# https://code.google.com/p/selenium/wiki/DesiredCapabilities
# and
# https://code.google.com/p/selenium/source/browse/javascript/webdriver/capabilities.js
  capabilities:
    browserName: "chrome"


# ----- The test framework -----
#
# Jasmine and Cucumber are fully supported as a test and assertion framework.
# Mocha has limited beta support. You will need to include your own
# assertion framework if working with mocha.
  framework: "jasmine"

# ----- Options to be passed to minijasminenode -----
#
# See the full list at https://github.com/juliemr/minijasminenode
  jasmineNodeOpts:
    defaultTimeoutInterval: 30000

  onPrepare: ()->
    global.by_ = global['by']
    global.findBy = global['by']

###
conf.js PROTRACTOR

exports.config = {
  seleniumAddress: 'http://0.0.0.0:4444/wd/hub'
  baseUrl: 'http://localhost:3000'
  specs: ['tests/e2e/ * * / *.js']
  rootElement: '.ngApp'
  allScriptsTimeout: 60000
  onPrepare: ()->
    global.By = global.by
    global.findBy = global.by
}
###
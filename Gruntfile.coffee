module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-bg-shell');
  # Load grunt tasks automatically, when needed
  require("jit-grunt") grunt,
    express: "grunt-express-server"
    useminPrepare: "grunt-usemin"
    ngtemplates: "grunt-angular-templates"
    cdnify: "grunt-google-cdn"
    protractor: "grunt-protractor-runner"
    injector: "grunt-asset-injector"


  # Time how long tasks take. Can help when optimizing build times
  require("time-grunt") grunt

  # Define the configuration for all the tasks
  grunt.initConfig {
    # Project settings
    yeoman:
      # configurable paths
      client: require("./bower.json").appPath or "client"
      dist: "dist"

    shell:
      starteMQ:
        options:
          stderr: true
        target:
          command: 'rabbitmq-server -detached'

    bgShell:
      _defaults:
        bg: true
        stdout: true
        stderr: true

      startServices:
        cmd: 'coffee server/services/db/index.coffee'


    express:
      options:
        port: process.env.PORT or 9000
        opts: ['node_modules/coffee-script/bin/coffee']

      dev:
        options:
          script: "server/app/index.coffee"
          debug: false

      dbService:
        options:
          script: "server/services/db/index.coffee"
          debug: false
          background: true
          port: 9005

      devNoDebug:
        options:
          port: process.env.PORT or 9000
          script: "server/app/index.coffee"
          debug: false

      prod:
        options:
          script: "dist/server/app/index.coffee"

    open:
      server:
        url: "http://localhost:<%= express.options.port %>"

    watch:
      injectJS:
        files: [
          "<%= yeoman.client %>/{app,components}/**/*.js"
          "<%= yeoman.client %>/{app,components}/**/*.coffee"
          "!<%= yeoman.client %>/{app,components}/**/*.spec.js"
          "!<%= yeoman.client %>/{app,components}/**/*.mock.js"
          "!<%= yeoman.client %>/app/app.js"
        ]
        tasks: ["injector:scripts"]

      injectCss:
        files: ["<%= yeoman.client %>/{app,components}/**/*.css"]
        tasks: ["injector:css"]

      mochaTest:
        files: ["server/**/*.coffee", "server/**/*.spec.coffee"]
        tasks: [
          "mochaTest"
        ]
        options: {
          spawn: true
          #interrupt: true
          #debounceDelay: 2250
        }

      jsTest:
        files: [
          "<%= yeoman.client %>/{app,components}/**/*.spec.js"
          "<%= yeoman.client %>/{app,components}/**/*.mock.js"
        ]
        tasks: [
          "newer:jshint:all"
          "karma"
        ]

      injectLess:
        files: ["<%= yeoman.client %>/{app,components}/**/*.less"]
        tasks: ["injector:less"]

      less:
        files: ["<%= yeoman.client %>/{app,components}/**/*.less"]
        tasks: [
          "less"
          "autoprefixer"
        ]

      coffee:
        files: [
          "<%= yeoman.client %>/{app,components}/**/*.{coffee,litcoffee,coffee.md}"
          "!<%= yeoman.client %>/{app,components}/**/*.spec.{coffee,litcoffee,coffee.md}"
        ]
        tasks: [
          "newer:coffee"
          "injector:scripts"
        ]

      coffeeTest:
        files: ["<%= yeoman.client %>/{app,components}/**/*.spec.{coffee,litcoffee,coffee.md}"]
        tasks: []

      gruntfile:
        files: ["Gruntfile.js"]

      livereload:
        files: [
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.css"
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.html"
          "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js"
          "!{.tmp,<%= yeoman.client %>}{app,components}/**/*.spec.js"
          "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js"
          "<%= yeoman.client %>/assets/images/{,*//*}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        options:
          livereload: 35730

      express:
        files: ["server/**/*.{coffee,js,json}"]
        tasks: [
          "express:dev"
          "wait"
        ]
        options:
          livereload: 35730
          #nospawn: true
          #Without this option specified express won't be reloaded

      protractor:
        files: [
          "e2e/**/*.coffee"
        ]
        tasks: [
          "test:e2eWatch"
        ]


    # Make sure code styles are up to par and there are no obvious mistakes
    jshint:
      options:
        jshintrc: "<%= yeoman.client %>/.jshintrc"
        reporter: require("jshint-stylish")

      server:
        options:
          jshintrc: "server/.jshintrc"

        src: ["server/{,*/}*.js"]

      all: [
        "<%= yeoman.client %>/{app,components}/**/*.js"
        "!<%= yeoman.client %>/{app,components}/**/*.spec.js"
        "!<%= yeoman.client %>/{app,components}/**/*.mock.js"
      ]
      test:
        src: [
          "<%= yeoman.client %>/{app,components}/**/*.spec.js"
          "<%= yeoman.client %>/{app,components}/**/*.mock.js"
        ]


    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            ".tmp"
            "<%= yeoman.dist %>/*"
            "!<%= yeoman.dist %>/.git*"
            "!<%= yeoman.dist %>/.openshift"
            "!<%= yeoman.dist %>/Procfile"
          ]
        ]
      dev: [
        "<%= yeoman.client %>/{app,components}/**/*.{js,map}"
        "!<%= yeoman.client %>/{components}/redactor/**/*.js"
      ]


      server: ".tmp"


    # Add vendor prefixed styles
    autoprefixer:
      options:
        browsers: ["last 1 version"]

      dist:
        files: [
          expand: true
          cwd: ".tmp/"
          src: "{,*/}*.css"
          dest: ".tmp/"
        ]


    # Debugging with node inspector
    "node-inspector":
      custom:
        options:
          "web-host": "localhost"


    # Use nodemon to run server in debug mode with an initial breakpoint
    nodemon:
      debug:
        script: "server/app/index.coffee"
        options:
          nodeArgs: ["--debug-brk"]
          env:
            PORT: process.env.PORT or 9000

          callback: (nodemon) ->
            nodemon.on "log", (event) ->
              console.log event.colour
              return


            # opens browser on initial server start
            nodemon.on "config:update", ->
              setTimeout (->
                require("open") "http://localhost:8080/debug?port=5858"
                return
              ), 500
              return

            return


    # Automatically inject Bower components into the app
    bowerInstall:
      target:
        src: "<%= yeoman.client %>/index.html"
        ignorePath: "<%= yeoman.client %>/"
        exclude: [
          /bootstrap-sass-official/
          /bootstrap.js/
          "/json3/"
          "/es5-shim/"
          /bootstrap.css/
          /font-awesome.css/
        ]


    # Renames files for browser caching purposes
    rev:
      dist:
        files:
          src: [
            "<%= yeoman.dist %>/public/{,*/}*.js"
            "<%= yeoman.dist %>/public/{,*/}*.css"
            "<%= yeoman.dist %>/public/assets/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
            "<%= yeoman.dist %>/public/assets/fonts/*"
          ]


    # Reads HTML for usemin blocks to enable smart builds that automatically
    # concat, minify and revision files. Creates configurations in memory so
    # additional tasks can operate on them
    useminPrepare:
      html: ["<%= yeoman.client %>/index.html"]
      options:
        dest: "<%= yeoman.dist %>/public"


    # Performs rewrites based on rev and the useminPrepare configuration
    usemin:
      html: ["<%= yeoman.dist %>/public/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/public/{,*/}*.css"]
      js: ["<%= yeoman.dist %>/public/{,*/}*.js"]
      options:
        assetsDirs: [
          "<%= yeoman.dist %>/public"
          "<%= yeoman.dist %>/public/assets/images"
        ]

        # This is so we update image references in our ng-templates
        patterns:
          js: [
            [
              /(assets\/images\/.*?\.(?:gif|jpeg|jpg|png|webp|svg))/g
              "Update the JS to reference our revved images"
            ]
          ]


    # The following *-min tasks produce minified files in the dist folder
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.client %>/assets/images"
          src: "{,*/}*.{png,jpg,jpeg,gif}"
          dest: "<%= yeoman.dist %>/public/assets/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.client %>/assets/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/public/assets/images"
        ]


    # Allow the use of non-minsafe AngularJS files. Automatically makes it
    # minsafe compatible so Uglify does not destroy the ng references
    ngmin:
      dist:
        files: [
          expand: true
          cwd: ".tmp/concat"
          src: "*/**.js"
          dest: ".tmp/concat"
        ]


    # Package all the html partials into a single javascript payload
    ngtemplates:
      options:
        # This should be the name of your apps angular module
        module: "gtdhubApp"
        htmlmin:
          collapseBooleanAttributes: true
          collapseWhitespace: true
          removeAttributeQuotes: true
          removeEmptyAttributes: true
          removeRedundantAttributes: true
          removeScriptTypeAttributes: true
          removeStyleLinkTypeAttributes: true

        usemin: "app/app.js"

      main:
        cwd: "<%= yeoman.client %>"
        src: ["{app,components}/**/*.html"]
        dest: ".tmp/templates.js"

      tmp:
        cwd: ".tmp"
        src: ["{app,components}/**/*.html"]
        dest: ".tmp/tmp-templates.js"


    # Replace Google CDN references
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]


    # Copies remaining files to places other tasks can use
    copy:
      dist:
        files: [
          {
            expand: true
            dot: true
            cwd: "<%= yeoman.client %>"
            dest: "<%= yeoman.dist %>/public"
            src: [
              "*.{ico,png,txt}"
              ".htaccess"
              "bower_components/**/*"
              "assets/images/{,*/}*.{webp}"
              "assets/fonts/**/*"
              "index.html"
            ]
          }
          {
            expand: true
            cwd: ".tmp/images"
            dest: "<%= yeoman.dist %>/public/assets/images"
            src: ["generated/*"]
          }
          {
            expand: true
            dest: "<%= yeoman.dist %>"
            src: [
              "package.json"
              "server/**/*"
            ]
          }
        ]

      styles:
        expand: true
        cwd: "<%= yeoman.client %>"
        dest: ".tmp/"
        src: ["{app,components}/**/*.css"]


    # Run some tasks in parallel to speed up the build process
    concurrent:
      server: [
        "coffee"
        "less"
      ]
      test: [
        "coffee"
        "less"
      ]
      debug:
        tasks: [
          "nodemon"
          "node-inspector"
        ]
        options:
          logConcurrentOutput: true

      dist: [
        "coffee"
        "less"
        "imagemin"
        "svgmin"
      ]


    # Test settings
    karma:
      unit:
        configFile: "karma.conf.coffee"
        singleRun: true
      serve:
        configFile: "karma.conf.coffee"
        singleRun: false
        autoWatch: true

    mochaTest:
      options:
        reporter: "spec"
        clearRequireCache: true

      src: ["server/**/*.spec.coffee"]

    protractor:
      options:
        configFile: "./protractor.conf.coffee"
        args: {
        }

      chrome:
        options:
          configFile: "./protractor.conf.coffee"

    env:
      test:
        NODE_ENV: "test"

      prod:
        NODE_ENV: "production"

      all: require("./server/app/config/local.env")


    # Compiles CoffeeScript to JavaScript
    coffee:
      options:
        sourceMap: true
        sourceRoot: ""

      server:
        files: [
          expand: true
          cwd: "client"
          src: [
            "{app,components}/**/*.coffee"
            "!{app,components}/**/*.spec.coffee"
          ]
          dest: ".tmp"
          ext: ".js"
        ]


    # Compiles Less to CSS
    less:
      options:
        paths: [
          "<%= yeoman.client %>/bower_components"
          "<%= yeoman.client %>/app"
          "<%= yeoman.client %>/components"
        ]

      server:
        files:
          ".tmp/app/app.css": "<%= yeoman.client %>/app/app.less"

    injector:
      options: {}

      # Inject application script files into index.html (doesn't include bower)
      scripts:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/", "")
            filePath = filePath.replace("/.tmp/", "")
            "<script src=\"" + filePath + "\"></script>"

          starttag: "<!-- injector:js -->"
          endtag: "<!-- endinjector -->"

        files:
          "<%= yeoman.client %>/index.html": [
            [
              "{.tmp,<%= yeoman.client %>}/{app,components}/**/*.js"
              "!{.tmp,<%= yeoman.client %>}/app/app.js"
              "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.spec.js"
              "!{.tmp,<%= yeoman.client %>}/{app,components}/**/*.mock.js"
            ]
          ]


      # Inject component less into app.less
      less:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/app/", "")
            filePath = filePath.replace("/client/components/", "")
            "@import '" + filePath + "';"

          starttag: "// injector"
          endtag: "// endinjector"

        files:
          "<%= yeoman.client %>/app/app.less": [
            "<%= yeoman.client %>/{app,components}/**/*.less"
            "!<%= yeoman.client %>/app/app.less"
          ]


      # Inject component css into index.html
      css:
        options:
          transform: (filePath) ->
            filePath = filePath.replace("/client/", "")
            filePath = filePath.replace("/.tmp/", "")
            "<link rel=\"stylesheet\" href=\"" + filePath + "\">"

          starttag: "<!-- injector:css -->"
          endtag: "<!-- endinjector -->"

        files:
          "<%= yeoman.client %>/index.html": ["<%= yeoman.client %>/{app,components}/**/*.css"]
  }

  # Used for delaying livereload until after server has restarted
  grunt.registerTask "wait", ->
    grunt.log.ok "Waiting for server reload..."
    done = @async()
    setTimeout (->
      grunt.log.writeln "Done waiting!"
      done()
      return
    ), 500
    return

  grunt.registerTask "express-keepalive", "Keep grunt running", ->
    @async()
    return

  grunt.registerTask "serve", (target) ->
    if target is "dist"
      return grunt.task.run([
        "build"
        "env:all"
        "env:prod"
        "express:prod"
        "open"
        "express-keepalive"
      ])
    if target is "debug"
      return grunt.task.run([
        "clean:server"
        "env:all"
        "injector:less"
        "concurrent:server"
        "injector"
        "bowerInstall"
        "autoprefixer"
        "concurrent:debug"
      ])
    grunt.task.run [
      "bgShell:startServices"
      "wait"
      "clean:server"
      "env:all"
      "injector:less"
      "concurrent:server"
      "injector"
      "bowerInstall"
      "autoprefixer"
      "express:dev"
      #"wait"
      #"open"
      "watch"
    ]
    return

  grunt.registerTask "server", ->
    grunt.log.warn "The `server` task has been deprecated. Use `grunt serve` to start a server."
    grunt.task.run ["serve"]
    return

  grunt.registerTask "test", (target) ->
    if target is "server"
      grunt.task.run [
        "bgShell:startServices"
        "wait"
        "env:test"
        "mochaTest"
      ]
    else if target is "client"
      grunt.task.run [
        "clean:server"
        "env:all"
        "injector:less"
        "concurrent:test"
        "injector"
        "autoprefixer"
        "karma:unit"
      ]
    else if target is "e2e"
      grunt.task.run [
        "bgShell:startServices"
        "wait"
        "clean:server"
        "env:all"
        "env:test"
        "injector:less"
        "concurrent:test"
        "injector"
        "bowerInstall"
        "autoprefixer"
        "express:devNoDebug"
        "protractor"
      ]
    else if target is "e2eWatch"
      grunt.task.run [
        "bgShell:startServices"
        "wait"
        "protractor"
        "watch:protractor"
      ]
    else
      grunt.task.run [
        "test:server"
        "test:client"
      ]
    return

  grunt.registerTask "build", [
    "clean:dist"
    "injector:less"
    "concurrent:dist"
    "injector"
    "bowerInstall"
    "useminPrepare"
    "autoprefixer"
    "ngtemplates"
    "concat"
    "ngmin"
    "copy:dist"
    "cdnify"
    "cssmin"
    "uglify"
    "rev"
    "usemin"
    ]
  grunt.registerTask "default", [
    "serve"
    #"test"
    #"build"
  ]
  grunt.registerTask "clean-dev", [
    "clean:dev"
  ]
  grunt.registerTask "test-tdd", [
    "env:test"
    "watch:mochaTest"
  ]
  grunt.registerTask('service', [
    "express:dbService"
    "express-keepalive"
  ]);
  return

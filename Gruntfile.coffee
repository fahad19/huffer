config    = require './config'
path      = require 'path'
lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
fs        = require 'fs'
cs        = require 'grunt-contrib-coffee/node_modules/coffee-script/lib/coffee-script/coffee-script'
exec      = require('child_process').exec

folderMount = (connect, point) ->
  connect.static path.resolve(point)

module.exports = (grunt) ->
  # Project configuration.
  grunt.initConfig
    # Metadata.
    pkg: grunt.file.readJSON 'package.json'
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n'
    # Task configuration.
    copy:
      theme:
        files: [
          {
            src: ['themes/' + config.theme + '/layouts/index.html']
            dest: 'public/index.html'
          }
          {
            src: ['themes/' + config.theme + '/img/*']
            dest: 'public/img/'
          }
          {
            src: ['themes/' + config.theme + '/fonts/*']
            dest: 'public/fonts/'
          }
        ]
      test: 
        files: [
          {
            src: ['tests/layouts/index.html']
            dest: 'public/test.html'
          }
        ]
    coffee:
      test:
        files:
          'tmp/coffee_test.js': 'tests/**/*.coffee'
    stitch_extra:
      app:
        files: [
          {
            dest: 'tmp/app_compiled.js'
            paths: [__dirname + '/app']
            listModules: true
            listModulesId: 'config/modules'
            compilers:
              coffee: (module, filename) ->
                source = fs.readFileSync filename, 'utf8'
                module._compile cs.compile(source), filename
          }
        ]
    concat:
      options:
        banner: '<%= banner %>'
      app:
        src: config.vendors.concat [
          'tmp/templates.js'
          'tmp/app_compiled.js'
        ]
        dest: 'public/js/app.js'
      test:
        src: [
          'tmp/coffee_test.js'
          'tests/**/*.js'
        ]
        dest: 'public/js/test.js'
    less:
      theme:
        options:
          compress: config.compress
        files:
          'public/css/app.css': 'themes/' + config.theme + '/css/theme.less'
    ember_templates:
      app:
        options:
          templateName: (sourceFile) ->
            name = sourceFile.replace 'app/templates/', ''
            String(name).split('.')[0]
        files:
          'tmp/templates.js': 'app/templates/**/*.handlebars'
    connect:
      server:
        options:
          keepalive: true
          port: config.server.port
          base: 'public'
      test:
        options:
          keepalive: false
          port: config.server.port
          base: 'public'
      livereload:
        options:
          port: config.server.port
          middleware: (connect, options) ->
            [
              lrSnippet,
              folderMount connect, 'public'
            ]
    jshint:
      options:
        curly: true
        eqeqeq: true
        eqnull: true
        browser: true
        globals:
          jQuery: true
      app: ['app/**/*.js']
    uglify:
      app:
        files:
          'public/js/app.js': ['public/js/app.js']
    open:
      server:
        path: 'http://localhost:' + config.server.port
      test:
        path: 'http://localhost:' + config.server.port + '/test.html'
    regarde:
      build:
        files: [
          'config.js'
          'app/**/*'
          'themes/**/*'
        ]
        tasks: ['build']
      live:
        files: [
          'config.js'
          'app/**/*'
          'themes/**/*'
        ]
        tasks: [
          'build'
          'livereload'
        ]
      test:
        files: [
          'config.js'
          'app/**/*'
          'tests/**/*'
          'themes/**/*'
        ]
        tasks: [
          'test'
          'livereload'
        ]
    clean:
      server:
        files: [{
          dot: true
          src: [
            'tmp'
            'public/*'
            '!public/vendors*'
          ]
        }]

  # These plugins provide necessary tasks.
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-jshint'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-ember-templates'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-open'
  grunt.loadNpmTasks 'grunt-stitch-extra'

  # Tasks
  buildTasks = [
    'clean:server'
    'jshint:app'
    'copy:theme'
    'ember_templates:app'
    'stitch_extra:app'
    'concat:app'
    'less:theme'
  ]
  if config.compress
    buildTasks.push 'uglify:app'

  grunt.registerTask 'default', buildTasks
  grunt.registerTask 'build', 'default'
  grunt.registerTask 'server', [
    'build'
    'connect:server'
  ]
  grunt.registerTask 'watch', ['regarde:build']
  grunt.registerTask 'live', [
    'build'
    'livereload-start'
    'connect:livereload'
    'open:server'
    'regarde:live'
  ]
  grunt.registerTask 'test', [
    'build'
    'copy:test'
    'coffee:test'
    'concat:test'
  ]
  grunt.registerTask 'test-server', [
    'test'
    'connect:test'
  ]
  grunt.registerTask 'test-live', [
    'test'
    'livereload-start'
    'connect:livereload'
    'open:test'
    'regarde:test'
  ]
  grunt.registerTask 'test-run', [
    'test-server'
    'test-mocha-phantomjs'
  ]
  grunt.registerTask 'test-mocha-phantomjs', () ->
    grunt.task.requires 'test-server'
    done = @async()
    url = 'http://localhost:' + config.server.port + '/test.html'
    cmd = __dirname + '/node_modules/.bin/mocha-phantomjs ' + url
    
    console.log 'Running command: ' + cmd
    exec cmd, (error, stdout, stderr) =>
      if error then throw error

      if stdout
        console.log stdout
      else
        console.log stderr

      done()
  grunt.registerTask 'clear', ['clean:server']

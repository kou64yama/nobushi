'use strict'

module.exports = (grunt) ->
  (require 'time-grunt') grunt
  (require 'load-grunt-tasks') grunt

  config =
    src: '.'
    test: 'test'
    dist: 'dist'
    tmp: '.tmp'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    config: config

    watch:
      coffee:
        files: ['<%= config.src %>/{,*/}*.coffee']
        tasks: ['newer:coffeelint:all', 'karma']
      coffeeLint:
        files: ['coffeelint.json']
        tasks: ['coffeelint:all']
      coffeeTest:
        files: [
          '<%= config.dist %>/<%= pkg.name %>.js'
          '<%= config.test %>/{spec,mock}/{,*/}*.coffee'
        ]
        tasks: ['newer:coffeelint:test', 'karma']
      gruntfile:
        files: ['Gruntfile.coffee']
        tasks: ['coffeelint:gruntfile']

    # Replace @@version
    replace:
      dist:
        options:
          patterns: [
            json: '<%= pkg %>'
          ]
        files: [
          expand: true
          src: ['<%= config.src %>/<%= pkg.name %>.coffee']
          dest: '<%= config.tmp %>'
        ]

    # Compile CoffeeScript code
    coffee:
      dist:
        files:
          '<%= config.dist %>/<%= pkg.name %>.js': [
            '<%= config.tmp %>/<%= pkg.name %>.coffee'
          ]

    # Make sure code styles are up to par and there are no obvious mistakes
    coffeelint:
      options: configFile: 'coffeelint.json'
      all: ['<%= config.src %>/{,*/}*.coffee']
      test: ['<%= config.test %>/{spec,mock}/{,*/}*.coffee']
      gruntfile: ['Gruntfile.coffee']

    # Minify JavaScript code
    uglify:
      options:
        compress: true
        mangle: true
        preserveComments: 'some'
        ASCIIOnly: true
      dist:
        options:
          sourceMap: true
          sourceMapName: '<%= config.dist %>/<%= pkg.name %>.min.map'
        files:
          '<%= config.dist %>/<%= pkg.name %>.min.js': [
            '<%= config.dist %>/<%= pkg.name %>.js'
          ]

    # Generates documentation
    docco:
      dist:
        src: ['<%= config.tmp %>/<%= pkg.name %>.coffee']

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            '<%= config.dist %>/{,*/}*'
            '<%= config.tmp %>/{,*/}*'
            '!<%= config.dist %>/.git*'
          ]
        ]

    # Test settings
    karma:
      unit:
        configFile: '<%= config.test %>/karma.conf.js'
        singleRun: true


  grunt.registerTask 'test', [
    'build'
    'karma'
  ]

  grunt.registerTask 'doc', [
    'replace:dist'
    'docco:dist'
  ]

  grunt.registerTask 'build', [
    'replace:dist'
    'coffee:dist'
    'uglify'
  ]

  grunt.registerTask 'default', 'build'

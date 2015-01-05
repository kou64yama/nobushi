'use strict'

module.exports = (grunt) ->
  (require 'time-grunt') grunt
  (require 'load-grunt-tasks') grunt

  config =
    src: '.'
    test: 'test'
    dist: 'dist'

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    config: config

    watch:
      coffee:
        files: ['<%= config.src %>/{,*/}*.coffee']
        tasks: ['newer:coffeelint:all', 'karma']
      coffeeTest:
        files: [
          '<%= config.dist %>/<%= pkg.name %>.js'
          '<%= config.test %>/{spec,mock}/{,*/}*.coffee'
        ]
        tasks: ['newer:coffeelint:test', 'karma']
      gruntfile:
        files: ['Gruntfile.coffee']
        tasks: ['coffeelint:gruntfile']

    coffee:
      dist:
        files:
          '<%= config.dist %>/<%= pkg.name %>.js': [
            '<%= config.src %>/<%= pkg.name %>.coffee'
          ]

    # Make sure code styles are up to par and there are no obvious mistakes
    coffeelint:
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

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: [
            '<%= config.dist %>/{,*/}*'
            '!<%= config.dist %>/.git*'
          ]
        ]

    # Run some tasks in parallel to speed up the build process
    concurrent:
      test: [
      ]
      dist: [
        'coffee:dist'
      ]

    # Test settings
    karma:
      unit:
        configFile: '<%= config.test %>/karma.conf.js'
        singleRun: true


  grunt.registerTask 'test', [
    'concurrent:test'
    'karma'
  ]

  grunt.registerTask 'build', [
    'clean:dist'
    'concurrent:dist'
    'uglify'
  ]

  grunt.registerTask 'default', [
    'newer:coffeelint'
    'test'
    'watch'
  ]

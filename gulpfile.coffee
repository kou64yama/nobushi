'use strict'

gulp = require 'gulp'
plugins = (require 'gulp-load-plugins')()
run = require 'run-sequence'

gulp.task 'default', -> run 'test', 'build'

gulp.task 'test', ->
  gulp.src ['test/*.coffee'], read: false
  .pipe plugins.mocha()

gulp.task 'build', ->
  gulp.src ['nobushi.coffee'], read: false
  .pipe plugins.browserify
    debug: true
    transform: ['coffeeify']
    extensions: ['.coffee', '.js']
    standalone: 'nbs'
  .pipe plugins.rename extname: '.js'
  .pipe gulp.dest './dist'
  .pipe plugins.sourcemaps.init()
  .pipe plugins.uglify()
  .pipe plugins.rename extname: '.min.js'
  .pipe plugins.sourcemaps.write './'
  .pipe gulp.dest './dist'

gulp.task 'watch', ->
  run 'test', 'build'
  gulp.watch ['{nobushi,lib/*}.coffee'], ['default']
  gulp.watch ['test/*.coffee'], ['test']

'use strict'

io = require './io'

module.exports = io.in (x, y) ->
  x or y

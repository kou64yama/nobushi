'use strict'

NbsArray = require './nbs-array'

module.exports = (f, xs) ->
  new NbsArray ((i) -> f xs[i]), xs.length

'use strict'

module.exports = class NbsArray extends Array
  constructor: (@f, @length = Number.POSITIVE_INFINITY) ->
    @allocated = []

  '!!': (i) ->
    if @allocated[i]
      @[i]
    else
      @allocated[i] = true
      @[i] = @f i

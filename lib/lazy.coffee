'use strict'

LaziedFunction = require './lazied-function'

module.exports = (f) ->
  (new LaziedFunction f).func @

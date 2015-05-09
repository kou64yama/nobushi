'use strict'

module.exports = (x) ->
  while typeof x?.eval is 'function'
    x = x.eval()
  x

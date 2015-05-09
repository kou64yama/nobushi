'use strict'

root = @
previousNbs = root.nbs

class Nbs
  constructor: (x) ->
    for key, value of prelude when typeof value is 'function'
      do (f = value) =>
        @[key] = nbs.lazy if x is undefined
          (y, zs...) ->
            f.apply nbs, [y, x].concat zs
        else
          (xs...) ->
            f.apply nbs, [x].concat xs

nbs = module.exports = (x) -> new Nbs x
nbs.lazy = require './lib/lazy'
nbs['$!'] = require './lib/eval'
nbs.io = require './lib/io'

nbs.noConflict = ->
  root.nbs = previousNbs
  nbs

prelude =
  '&&': require './lib/and'
  '||': require './lib/or'
  '!': require './lib/not'
  not: require './lib/not'

for key, value of prelude when typeof value is 'function'
  nbs[key] = nbs.lazy value

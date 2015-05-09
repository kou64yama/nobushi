'use strict'

module.exports = class NbsFunction
  constructor: (@f, @length = @f.length) ->
    @__this__ = @

  body: (context) -> (xs...) =>
    @f.apply context, xs

  eval: ->
    @f()

  apply: (context, xs = []) ->
    @f.apply context, xs

  call: (context, xs...) ->
    @apply context, xs

  bind: (context, xs...) ->
    f = @f
    for x in xs
      f = f.bind context x
    (new NbsFunction f).func context

  func: (context) ->
    body = @body context
    for key, fn of (@constructor::) when typeof fn is 'function'
      body[key] = fn.bind @
    body

'use strict'

_eval = require './eval'
map = require './map'

io = module.exports = (f) ->
  g = (xs...) -> _eval f.apply null, (_eval x for x in xs)
  g.__IO__ = true
  g.__IO_IN__ = true
  g.__IO_OUT__ = true
  g

io.in = (f) ->
  g = (xs...) -> f.apply null, (_eval x for x in xs)
  g.__IO__ = true
  g.__IO_IN__ = true
  g.__IO_OUT__ = false
  g

io.out = (f) ->
  g = (xs...) -> _eval f.apply null, xs
  g.__IO__ = true
  g.__IO_IN__ = false
  g.__IO_OUT__ = true
  g

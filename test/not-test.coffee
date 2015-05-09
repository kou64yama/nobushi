'use strict'

nbs = require '../nobushi'
chai = require 'chai'

expect = nbs.io chai.expect

describe 'nbs["!"](x)', ->
  it 'expect to return false; where x is true', ->
    (expect nbs['!'] true).to.equal false

  it 'expect to return true; where x is false', ->
    (expect nbs['!'] false).to.equal true

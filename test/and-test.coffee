'use strict'

nbs = require '../nobushi'
chai = require 'chai'

expect = nbs.io chai.expect

describe 'nbs["&&"](x, y)', ->
  it 'expect to return true; where both x and y are true', ->
    (expect nbs['&&'] true, true).to.equal true

  it 'expect to return false; where x is true and y is false', ->
    (expect nbs['&&'] true, false).to.equal false

  it 'expect to return false; where x is false and y is true', ->
    (expect nbs['&&'] false, true).to.equal false

  it 'expect to return false; where both x and y are false', ->
    (expect nbs['&&'] false, false).to.equal false

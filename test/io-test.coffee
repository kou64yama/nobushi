'use strict'

chai = require 'chai'
chai.should()

nbs = require '../nobushi'

describe 'nbs.io', ->
  it 'should be a function', ->
    nbs.should.be.a 'function'

  it 'should make an IO function', ->
    id1 = (x) -> x
    id2 = nbs.lazy id1
    f = nbs.io id1
    g = nbs.io id2

    (f 42).should.equal 42
    (g 42).should.equal 42

'use strict'

chai = require 'chai'
chai.should()

LaziedFunction = require '../lib/lazied-function'

describe 'LaziedFunction', ->
  describe 'x = new LaziedFunction(f)', ->
    f = (x, y, z) -> 42
    x = new LaziedFunction f

    it 'should have a property length, equal f.length', ->
      x.should.have.a.property 'length'
      x.length.should.equal f.length

    it 'should have a method eval, return f()', ->
      x.eval.should.be.a 'function'
      x.eval().should.equal f()

  describe 'x = new LaziedFunction(f).func()', ->
    f = (x, y, z) -> "#{x}#{y}#{z}"
    x = (new LaziedFunction f).func()

    it 'should be a function, return a function', ->
      x.should.be.a 'function'
      x().should.be.a 'function'

    it 'should have a property length, equal 0', ->
      x.should.have.a.property 'length'
      x.length.should.equal 0

    it 'should have a method eval, return f()', ->
      x.eval.should.be.a 'function'

      x.eval().should.equal f()
      (x 'x', 'y', 'z').eval().should.equal (f 'x', 'y', 'z')
      x('x')('y')('z').eval().should.equal (f 'x', 'y', 'z')

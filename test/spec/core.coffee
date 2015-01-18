'use strict'

describe 'nbs.curry(f)', ->
  foo = (x, y, z) -> "#{x}#{y}#{z}"
  it 'converts an uncurried function to a curried function', ->
    bar = nbs.curry foo
    expect(bar).not.toBe foo
    expect(bar('x')('y')('z')).toBe 'xyz'
    expect(bar('x', 'y')('z')).toBe 'xyz'
    expect(bar('x')('y', 'z')).toBe 'xyz'
    expect(bar('x', 'y', 'z')).toBe 'xyz'
  it 'appends "_length" to a returned function\'s property', ->
    bar = nbs.curry foo
    expect(bar._length).toBe 3
    expect(bar('x')._length).toBe 2
    expect(bar('x', 'y')._length).toBe 1
  it 'doesn\'t convert a curried function', ->
    bar = nbs.curry foo
    expect(nbs.curry bar).toBe bar

describe 'nbs().func', ->
  it 'returns a function, same as nbs.flip(nbs.func)', ->
    expect(nbs()['/'](2)(4)).toBe 2
    expect(nbs()['/'](2, 4)).toBe 2

describe 'nbs.max(x, y)', ->
  it 'returns x, where x is greater than y', ->
    expect(nbs.max 1, 2).toBe 2
  it 'returns y, where x is less than y', ->
    expect(nbs.max 2, 1).toBe 2

describe 'nbs.min(x, y)', ->
  it 'returns x, where x is less than y', ->
    expect(nbs.min 1, 2).toBe 1
  it 'returns y, where x is greater than y', ->
    expect(nbs.min 2, 1).toBe 1

describe 'nbs.succ(x)', ->
  it 'returns the successor of x', ->
    for i in [-10..10]
      expect(nbs.succ i).toBe i + 1

describe 'nbs.pred(x)', ->
  it 'returns the predecessor of x', ->
    for i in [-10..10]
      expect(nbs.pred i).toBe i - 1

describe 'nbs.enumFromTo(n, m)', ->
  it 'returns [n..m]', ->
    expect(nbs.enumFromTo(5, 10)).toEqual [5..10]
    expect(nbs.enumFromTo(10, 5)).toEqual [10..5]
    expect(nbs.enumFromTo(-5, 5)).toEqual [-5..5]
    expect(nbs.enumFromTo(5, -5)).toEqual [5..-5]
    expect(nbs.enumFromTo(-10, -5)).toEqual [-10..-5]
    expect(nbs.enumFromTo(-5, -10)).toEqual [-5..-10]

describe 'nbs.enumFromThenTo(n0, n1, m)', ->
  it 'returns (x for x in [n0..m] by n1 - n0)', ->
    expect(nbs.enumFromThenTo(0, 1, 10)).toEqual (x for x in [0..10] by 1)
    expect(nbs.enumFromThenTo(5, 7, 10)).toEqual (x for x in [5..10] by 2)

describe 'nbs.negate(x)', ->
  it 'returns the unary negation of x', ->
    expect(nbs.negate 0).toBe 0
    expect(nbs.negate 10).toBe -10
    expect(nbs.negate -5.5).toBe 5.5

describe 'nbs.abs(x)', ->
  it 'returns the absolute value of x', ->
    expect(nbs.abs 0).toBe 0
    expect(nbs.abs 5).toBe 5
    expect(nbs.abs -5.5).toBe 5.5

describe 'nbs.signum(x)', ->
  it 'returns the sign of x', ->
    expect(nbs.signum -5).toBe -1
    expect(nbs.signum -0.0000001).toBe -1
    expect(nbs.signum 0).toBe 0
    expect(nbs.signum 0.0000001).toBe 1
    expect(nbs.signum 5).toBe 1

describe 'nbs.quot(x, y)', ->
  it 'return the integer division truncated toward zero', ->
    expect(nbs(6).quot(3)).toBe 2
    expect(nbs(10).quot(3)).toBe 3
    expect(nbs(11).quot(3)).toBe 3
    expect(nbs(-10).quot(3)).toBe -3
    expect(nbs(-11).quot(3)).toBe -3

describe 'nbs.rem(x, y)', ->
  it '''
  return the integer remainder, satisfying
  nbs(x).quot(y) * y + nbs(x).rem(y) == x
  ''', ->
    expect(nbs(6).rem(3)).toBe 0
    expect(nbs(10).rem(3)).toBe 1
    expect(nbs(11).rem(3)).toBe 2
    expect(nbs(-10).rem(3)).toBe -1
    expect(nbs(-11).rem(3)).toBe -2

describe 'nbs.div(x, y)', ->
  it 'returns the integer division trucated toward negative infinity', ->
    expect(nbs(6).div(3)).toBe 2
    expect(nbs(10).div(3)).toBe 3
    expect(nbs(11).div(3)).toBe 3
    expect(nbs(-10).div(3)).toBe -4
    expect(nbs(-11).div(3)).toBe -4

describe 'nbs.mod(x, y)', ->
  it '''
  returns integer modulus, satisfying
  nbs(x).div(y) * y + nbs(x).mod(y) == x
  ''', ->
    expect(nbs(6).mod(3)).toBe 0
    expect(nbs(10).mod(3)).toBe 1
    expect(nbs(11).mod(3)).toBe 2
    expect(nbs(-10).mod(3)).toBe 2
    expect(nbs(-11).mod(3)).toBe 1

describe 'nbs.quotRem(x, y)', ->
  it 'returns simultaneous quot and rem', ->
    times = 1000
    while 0 < times--
      x = Math.random() * 0x100000000 >> 0
      y = Math.random() * 0x100000000 >> 0
      t = nbs(x).quotRem(y)
      expect(t[0]).toBe nbs(x).quot(y)
      expect(t[1]).toBe nbs(x).rem(y)
  it 'satisfy nbs(x).quot(y) * y + nbs(x).rem(y) == x', ->
    times = 1000
    while 0 < times--
      x = Math.random() * 0x100000000 >> 0
      y = Math.random() * 0x100000000 >> 0
      t = nbs(x).quotRem(y)
      expect(t[0] * y + t[1]).toBe x

describe 'nbs.divMod(x, y)', ->
  it 'returns simultaneous div and mod', ->
    times = 1000
    while 0 < times--
      x = Math.random() * 0x100000000 >> 0
      y = Math.random() * 0x100000000 >> 0
      t = nbs(x).divMod(y)
      expect(t[0]).toBe nbs(x).div(y)
      expect(t[1]).toBe nbs(x).mod(y)
  it 'satisfy nbs(x).div(y) * y + nbs(x).mod(y) == x', ->
    times = 1000
    while 0 < times--
      x = Math.random() * 0x100000000 >> 0
      y = Math.random() * 0x100000000 >> 0
      t = nbs(x).divMod(y)
      expect(t[0] * y + t[1]).toBe x

describe 'nbs.recip(x)', ->
  it 'returns the reciprocal fraction', ->
    expect(nbs.recip 10).toBe 0.1
    expect(nbs.recip 0.1).toBe 10
    expect(nbs.recip 1).toBe 1
    expect(nbs.recip 0).toBe 1 / 0

describe 'nbs.truncate(x)', ->
  it 'returns the integer nearest x between zero and x', ->
    expect(nbs.truncate 1).toBe 1
    expect(nbs.truncate -1).toBe -1
    expect(nbs.truncate 1.5).toBe 1
    expect(nbs.truncate -1.5).toBe -1
    expect(nbs.truncate 9.9999).toBe 9
    expect(nbs.truncate -9.9999).toBe -9

describe 'nbs.round(x)', ->
  it 'returns the nearest integer to x', ->
    expect(nbs.round 1).toBe 1
    expect(nbs.round -1).toBe -1
    expect(nbs.round 1.49999).toBe 1
    expect(nbs.round 1.5).toBe 2
    expect(nbs.round -1.5).toBe -1
    expect(nbs.round -1.50001).toBe -2

describe 'nbs.ceiling(x)', ->
  it 'returns the least integer not less than x', ->
    expect(nbs.ceiling 1).toBe 1
    expect(nbs.ceiling 1.0001).toBe 2
    expect(nbs.ceiling -2).toBe -2
    expect(nbs.ceiling -1.9999).toBe -1

describe 'nbs.floor(x)', ->
  it 'returns the greatest integer not greater than x', ->
    expect(nbs.floor 1.9999).toBe 1
    expect(nbs.floor 2).toBe 2
    expect(nbs.floor -1.0001).toBe -2
    expect(nbs.floor -1).toBe -1

describe 'nbs.even(x)', ->
  it 'returns true, where x is an even number', ->
    for i in [0..20] by 2
      expect(nbs.even i).toBeTruthy()
  it 'returns false, where x is not an even number', ->
    for i in [1..21] by 2
      expect(nbs.even i).toBeFalsy()

describe 'nbs.odd(x)', ->
  it 'returns true, where x is an odd number', ->
    for i in [1..21] by 2
      expect(nbs.odd i).toBeTruthy()
  it 'returns false, where x is an odd number', ->
    for i in [0..20] by 2
      expect(nbs.odd i).toBeFalsy()

describe 'nbs.gcd(x, y)', ->
  it '''
  returns the non-negative factor of both x and y of which every common factor
  of x and y is also a factor
  ''', ->
    expect(nbs.gcd 4, 2).toBe 2
    expect(nbs.gcd -4, 6).toBe 2
    expect(nbs.gcd 13 * 2, 13 * 3).toBe 13
    expect(nbs.gcd 17 * 3, 17 * 2).toBe 17
  it 'returns 1, where both x and y are prime', ->
    expect(nbs.gcd 83, 71).toBe 1
  it 'returns x, where y is 0', ->
    expect(nbs.gcd 0, 4).toBe 4
  it 'returns y, where x is 0', ->
    expect(nbs.gcd 5, 0).toBe 5
  it 'returns 0, where both x and y are 0', ->
    expect(nbs.gcd 0, 0).toBe 0

describe 'nbs.lcm(x, y)', ->
  it 'returns the smallest positive integer that both x and y divide.', ->
    expect(nbs.lcm 1, 1).toBe 1
    expect(nbs.lcm 2, 3).toBe 6
    expect(nbs.lcm 4, 6).toBe 12
  it '''
  returns the product of x and y, where both x and y are prime and x is not y
  ''', ->
    ps = [2, 3, 5, 7, 11, 13, 17, 19, 23]
    for x in ps
      for y in ps when x isnt y
        expect(nbs.lcm x, y).toBe x * y
  it 'returns the 0, where either x or y are 0', ->
    expect(nbs.lcm 0, 123).toBe 0
    expect(nbs.lcm 123, 0).toBe 0
    expect(nbs.lcm 0, 0).toBe 0

describe 'nbs(x)["^"](n)', ->
  it 'returns a non-negative integral power', ->
    expect(nbs(2)['^'](2)).toBe 4
    expect(nbs(-3)['^'](3)).toBe -27
    expect(nbs(0.5)['^'](2)).toBeCloseTo 0.25, 0.00001
  it 'returns 1, where x = 0, n = 0', ->
    expect(nbs(0)['^'](0)).toBe 1
  it 'throws an error, where n is negative', ->
    expect(-> nbs(1)['^'](-2))

describe 'nbs(x)["^^"](n)', ->
  it 'returns a integral power', ->
    expect(nbs(2)['^^'](2)).toBe 4
    expect(nbs(-3)['^^'](3)).toBe -27
    expect(nbs(0.5)['^^'](2)).toBeCloseTo 0.25, 0.0001
    expect(nbs(2)['^^'](-2)).toBeCloseTo 0.25, 0.0001
  it 'returns 1, where x = 0, n = 0', ->
    expect(nbs(0)['^^'](0)).toBe 1

describe 'nbs.id(x)', ->
  it 'returns x', ->
    expect(nbs.id i).toBe i for i in [0..10]
    expect(nbs.id true).toBe true
    arr = []
    expect(nbs.id arr).toBe arr
    obj = {}
    expect(nbs.id obj).toBe obj
    str = 'foo'
    expect(nbs.id str).toBe str

describe 'nbs.$const(x)', ->
  it 'returns function which returns x', ->
    for i in [0..10]
      foo = nbs.$const i
      expect(foo()).toBe i

describe 'nbs.flip(f)', ->
  it 'takes its first two arguments in the reverse order of f', ->
    foo = nbs.flip (x, y) -> [x, y]
    expect(foo 1, 2).toEqual [2, 1]

    foo = nbs.flip (x, y, z) -> [x, y, z]
    expect(foo 1, 2, 3).toEqual [2, 1, undefined]

    foo = nbs.flip nbs.curry (x, y, z) -> [x, y, z]
    expect(foo(1, 2)(3)).toEqual [2, 1, 3]

describe 'nbs.until(p, f, x)', ->
  it 'yields the result of applying f to x until p holds', ->
    expect(nbs.until nbs.odd, ((x) -> x / 2), 400).toBe 25

describe 'nbs.error(message)', ->
  it 'throws an error', ->
    expect(-> nbs.error 'foo').toThrowError 'foo'

describe 'nbs.map(f, xs)', ->
  it 'returns the list obtained by applying f to each element of xs', ->
    expect(nbs.map nbs.succ, [0..10]).toEqual [1..11]
    expect(nbs.map nbs.odd, [1, 2, 3, 4]).toEqual [true, false, true, false]

describe 'nbs(xs)["++"](ys)', ->
  it 'appends two lists', ->
    expect(nbs([0..2])['++']([3..5])).toEqual [0..5]
    expect(nbs([0..2])['++']([5..7])).toEqual [0, 1, 2, 5, 6, 7]

describe 'nbs.filter(p, xs)', ->
  it 'returns the list of elements of xs that satisfy p', ->
    expect(nbs.filter nbs.odd, [1..5]).toEqual [1, 3, 5]
    expect(nbs.filter ((x) -> x < 3), [0..20]).toEqual [0..2]

describe 'nbs.head(xs)', ->
  it 'extract the first element of xs', ->
    expect(nbs.head [1..10]).toBe 1
    expect(nbs.head [2..10]).toBe 2
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.head []).toThrowError 'nbs.head: empty list'

describe 'nbs.last(xs)', ->
  it 'extract the last element of xs', ->
    expect(nbs.last [0..10]).toBe 10
    expect(nbs.last [0..7]).toBe 7
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.last []).toThrowError 'nbs.last: empty list'

describe 'nbs.tail(xs)', ->
  it 'extract the elements after the head of xs', ->
    expect(nbs.tail [0..10]).toEqual [1..10]
    expect(nbs.tail [4..10]).toEqual [5..10]
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.tail []).toThrowError 'nbs.tail: empty list'

describe 'nbs.init(xs)', ->
  it 'extract the elements before the last of xs', ->
    expect(nbs.init [0..10]).toEqual [0..9]
    expect(nbs.init [0..4]).toEqual [0..3]
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.init []).toThrowError 'nbs.init: empty list'

describe 'nbs.$null(xs)', ->
  it 'returns true, where xs is empty', ->
    expect(nbs.$null []).toBeTruthy()
    expect(nbs.$null '').toBeTruthy()
  it 'returns false, where xs is not empty', ->
    expect(nbs.$null [1]).toBeFalsy()
    expect(nbs.$null 'foo').toBeFalsy()

describe 'nbs.$length(xs)', ->
  it 'returns the length of xs', ->
    expect(nbs.$length []).toBe 0
    expect(nbs.$length [1]).toBe 1
    expect(nbs.$length [1..10]).toBe 10

describe 'nbs(xs)["!!"](n)', ->
  xs = [4..6]
  it 'means same as xs[n]', ->
    expect(nbs(xs)['!!'](0)).toBe 4
    expect(nbs(xs)['!!'](1)).toBe 5
    expect(nbs(xs)['!!'](2)).toBe 6
  it 'throws an error, where n is negative', ->
    expect(-> nbs(xs)['!!'](-1)).toThrowError 'nbs.!!: negative index'
  it 'throws an error, where n is too large', ->
    expect(-> nbs(xs)['!!'](3)).toThrowError 'nbs.!!: index too large'

describe 'nbs.reverse(xs)', ->
  it 'returns the elements of xs inreverse order', ->
    expect(nbs.reverse [0..5]).toEqual [5..0]

describe 'nbs.foldl(f, z, xs)', ->
  it 'reduces the list using binary operator f, from right to left', ->
    expect(nbs.foldl nbs['/'], 64, [4, 2, 4]).toBe 2
    expect(nbs.foldl nbs['/'], 3, []).toBe 3
    expect(nbs.foldl nbs.max, 5, [1..7]).toBe 7
    expect(nbs.foldl ((x, y) -> 2 * x + y), 4, [1..3]).toBe 43

describe 'nbs.foldl1(f, xs)', ->
  it '''
  is a variant of nbs.foldl(f, z, xs) same as nbs.foldl(f, head(xs), tail(xs))
  ''', ->
    expect(nbs.foldl1 nbs['+'], [1..4]).toBe 10
    expect(nbs.foldl1 nbs['/'], [64, 4, 2, 8]).toBe 1
    expect(nbs.foldl1 nbs['/'], [12]).toBe 12
    expect(nbs.foldl1 nbs['&&'], [1 > 2, 3 > 2, 5 is 5]).toBeFalsy()
    expect(nbs.foldl1 nbs.max, [3, 6, 12, 4, 55, 11]).toBe 55
    expect(nbs.foldl1 ((x, y) -> (x + y) / 2), [3, 5, 10, 5]).toBe 6
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.foldl1 nbs['+'], []).toThrowError 'nbs.foldl1: empty list'

describe 'nbs.foldr(f, z, xs)', ->
  it 'reduces the list using binary operator f, from left to right', ->
    expect(nbs.foldr nbs['+'], 5, [1..4]).toBe 15
    expect(nbs.foldr nbs['/'], 2, [8, 12, 24, 4]).toBe 8
    expect(nbs.foldr nbs['/'], 3, []).toBe 3
    expect(nbs.foldr nbs['&&'], true, [1 > 2, 3 > 2, 5 is 5]).toBeFalsy()
    expect(nbs.foldr nbs.max, 18, [3, 6, 12, 4, 55, 11]).toBe 55
    expect(nbs.foldr nbs.max, 111, [3, 6, 12, 4, 55, 11]).toBe 111
    expect(nbs.foldr ((x, y) -> (x + y) / 2), 54, [12, 4, 10, 6]).toBe 12

describe 'nbs.foldr1(f, xs)', ->
  it 'is a variant of nbs.foldr(f, z, xs), same as nbs.foldr', ->
    expect(nbs.foldr1 nbs['+'], [1..4]).toBe 10
    expect(nbs.foldr1 nbs['/'], [8, 12, 24, 4]).toBe 4
    expect(nbs.foldr1 nbs['/'], [12]).toBe 12
    expect(nbs.foldr1 nbs['&&'], [1 > 2, 3 > 2, 5 is 5]).toBeFalsy()
    expect(nbs.foldr1 nbs.max, [3, 6, 12, 4, 55, 11]).toBe 55
    expect(nbs.foldr1 ((x, y) -> (x + y) / 2), [12, 4, 10, 6]).toBe 9
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.foldr1 nbs['-'], []).toThrowError 'nbs.foldr1: empty list'

describe 'nbs.and(xs)', ->
  it 'returns true, where xs doesn\'t contain false', ->
    expect(nbs.and [true, true, true, true]).toBeTruthy()
    expect(nbs.and []).toBeTruthy()
  it 'returns flase, where xs contains false', ->
    expect(nbs.and [false]).toBeFalsy()
    expect(nbs.and [true, true, true, false, true]).toBeFalsy()

describe 'nbs.or(xs)', ->
  it 'returns true, where xs contains false', ->
    expect(nbs.or [false, false, false, true, false, false]).toBeTruthy()
  it 'returns false, where xs doesn\'t contain false', ->
    expect(nbs.or [false, false, false]).toBeFalsy()
    expect(nbs.or []).toBeFalsy()

describe 'nbs.any(p, xs)', ->
  it 'returns true, where x satisfying p exists', ->
    expect(nbs.any nbs.even, [1, 2, 3, 5]).toBeTruthy()
  it 'returns false, where all elements of xs don\'t satisfy p', ->
    expect(nbs.any nbs.odd, [2, 6, 10, 24, 50]).toBeFalsy()

describe 'nbs.all(p, xs)', ->
  it 'returns true, where all elements of xs satisfy p', ->
    expect(nbs.all ((x) -> x > 0), [3..16]).toBeTruthy()
  it 'returns false, where xs contains elements not satisfying p', ->
    expect(nbs.all ((x) -> x % 3 is 0), [1, 2, 4, 5, 6]).toBeFalsy()

describe 'nbs.sum(xs)', ->
  it 'returns the summation of xs', ->
    expect(nbs.sum [1..100]).toBe 5050
  it 'returns 0, where xs is empty', ->
    expect(nbs.sum []).toBe 0

describe 'nbs.product(xs)', ->
  it 'returns the production of xs', ->
    expect(nbs.product [1..5]).toBe 120
  it 'returns 1, where xs is empty', ->
    expect(nbs.product []).toBe 1

describe 'nbs.concat(xs)', ->
  it 'concat xs', ->
    expect(nbs.concat [[0..4], [3..1], [9..6]]).toEqual(
      [0, 1, 2, 3, 4, 3, 2, 1, 9, 8, 7, 6])
    expect(nbs.concat ['abc', 'def']).toBe 'abcdef'

describe 'nbs.concatMap(f, xs)', ->
  it 'apply f to all elements and concat these', ->
    expect(nbs.concatMap ((x) -> "(#{x})"), [0, 1, 2, 3]).toBe '(0)(1)(2)(3)'

describe 'nbs.maximum(xs)', ->
  it 'returns the greatest number of xs', ->
    expect(nbs.maximum [4, 1, 7, 3]).toBe 7
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.maximum []).toThrowError 'nbs.maximum: empty list'

describe 'nbs.minimum(xs)', ->
  it 'returns the least number of xs', ->
    expect(nbs.minimum [4, -1, 5, -11]).toBe -11
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.minimum []).toThrowError 'nbs.minimum: empty list'

describe 'nbs.scanl(f, z, xs)', ->
  it 'does not tested', -> # TODO: Write behavior
    expect(nbs.scanl nbs['/'], 64, [4, 2, 4]).toEqual [64, 16, 8, 2]
    expect(nbs.scanl nbs['/'], 3, []).toEqual [3]
    expect(nbs.scanl nbs.max, 5, [1..4]).toEqual [5, 5, 5, 5, 5]
    expect(nbs.scanl nbs.max, 5, [1..7]).toEqual [5, 5, 5, 5, 5, 5, 6, 7]
    expect(nbs.scanl ((x, y) -> 2 * x + y), 4, [1..3]).toEqual [4, 9, 20, 43]

describe 'nbs.scanl1(f, xs)', ->
  it 'does not tested', -> # TODO: Write behavior
    expect(nbs.scanl1 nbs['+'], [1..4]).toEqual [1, 3, 6, 10]
    expect(nbs.scanl1 nbs['/'], [64, 4, 2, 8]).toEqual [64, 16, 8, 1]
    expect(nbs.scanl1 nbs['/'], [12]).toEqual [12]
    expect(nbs.scanl1 nbs.max, [3, 6, 12, 4, 55, 11]).toEqual(
      [3, 6, 12, 12, 55, 55])
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.scanl1 (->), []).toThrowError 'nbs.scanl1: empty list'

describe 'nbs.scanr(f, z, xs)', ->
  it 'does not tested', -> # TODO: Write behavior
    expect(nbs.scanr nbs['+'], 5, [1..4]).toEqual [15, 14, 12, 9, 5]
    expect(nbs.scanr nbs['/'], 2, [8, 12, 24, 4]).toEqual [8, 1, 12, 2, 2]
    expect(nbs.scanr nbs['/'], 3, []).toEqual [3]
    expect(nbs.scanr nbs.max, 18, [3, 6, 12, 4, 55, 11]).toEqual(
      [55, 55, 55, 55, 55, 18, 18])
    expect(nbs.scanr nbs.max, 111, [3, 6, 12, 4, 55, 11]).toEqual(
      [111, 111, 111, 111, 111, 111, 111])
    expect(nbs.scanr ((x, y) -> (x + y) / 2), 54, [12, 4, 10, 6]).toEqual(
      [12, 12, 20, 30, 54])

describe 'nbs.scanr1(f, xs)', ->
  it 'does not tested', -> # TODO: Write behavior
    expect(nbs.scanr1 nbs['+'], [1..4]).toEqual [10, 9, 7, 4]
    expect(nbs.scanr1 nbs['/'], [8, 12, 24, 2]).toEqual [8, 1, 12, 2]
    expect(nbs.scanr1 nbs['/'], [12]).toEqual [12]
    expect(nbs.scanr1 nbs['&&'], [1 > 2, 3 > 2, 5 is 5]).toEqual(
      [false, true, true])
    expect(nbs.scanr1 nbs.max, [3, 6, 12, 4, 55, 11]).toEqual(
      [55, 55, 55, 55, 55, 11])
    expect(nbs.scanr1 ((x, y) -> (x + y) / 2), [12, 4, 10, 6]).toEqual(
      [9, 6, 8, 6])
  it 'throws an error, where xs is empty', ->
    expect(-> nbs.scanr1 (->), []).toThrowError 'nbs.scanr1: empty list'

describe 'nbs.replicate(n, x)', ->
  it 'does not tested', ->
    expect(nbs.replicate 5, 3).toEqual [3, 3, 3, 3, 3]
    expect(nbs.replicate 4, 'a').toEqual 'aaaa'
    expect(nbs.replicate 3, 'abc').toEqual ['abc', 'abc', 'abc']

describe 'nbs.take(n, xs)', ->
  it 'returns the prefix of xs of length n', ->
    expect(nbs.take 4, [1..10]).toEqual [1..4]
  it 'returns the list same as xs, where xs.length < n', ->
    expect(nbs.take 10, [1..5]).toEqual [1..5]

describe 'nbs.drop(n, xs)', ->
  it 'returns the suffix of xs of length n', ->
    expect(nbs.drop 4, [1..10]).toEqual [5..10]
  it 'returns [], where xs.length < n', ->
    expect(nbs.drop 10, [1..5]).toEqual []

describe 'nbs.splitAt(n, xs)', ->
  it '''
  returns a list where first element is xs prefix of length n and second element
  it the remainder of the list
  ''', ->
    expect(nbs.splitAt 4, [1..10]).toEqual [[1..4], [5..10]]

describe 'nbs.takeWhile(p, xs)', ->
  it 'returns the longest prefix of xs of elements that satisfy p', ->
    expect(nbs.takeWhile nbs.even, [2, 6, 8, 7, 2, 4, 2]).toEqual [2, 6, 8]

describe 'nbs.dropWhile(p, xs)', ->
  it 'returns the suffix remaining after nbs.takeWhile(p, xs)', ->
    expect(nbs.dropWhile nbs.even, [2, 6, 8, 7, 2, 4, 2]).toEqual [7, 2, 4, 2]

describe 'nbs.span(p, xs)', ->
  it '''returns the list where first element is longest prefix of xs of elements
  that satisfy p and second element is the remainder of the list.''', ->
    xs = [2, 6, 8, 7, 2, 4, 2]
    expect(nbs.span nbs.even, xs).toEqual [[2, 6, 8], [7, 2, 4, 2]]

describe 'nbs.$break(p, xs)', ->
  it '''returns the list where first element is longest prefix of xs of elements
  *do not satisfy* p and second element is the remainder of the list.''', ->
    xs = [2, 6, 8, 7, 2, 4, 2]
    expect(nbs.$break nbs.odd, xs).toEqual [[2, 6, 8], [7, 2, 4, 2]]

describe 'nbs.elem(x, xs)', ->
  it 'returns true where xs contains x', ->
    expect(nbs(2).elem [1..4]).toBeTruthy()
  it 'returns false where xs do not contains x', ->
    expect(nbs(5).elem [1..4]).toBeFalsy()

describe 'nbs.notElem(x, xs)', ->
  it 'returns true where xs do not contains x', ->
    expect(nbs(5).notElem [1..4]).toBeTruthy()
  it 'returns false where xs contains x', ->
    expect(nbs(2).notElem [1..4]).toBeFalsy()

describe 'nbs.zip(xs, ys)', ->
  it 'returns a list of corresponding pair', ->
    expect(nbs.zip [1..3], [3..1]).toEqual [[1, 3], [2, 2], [3, 1]]

describe 'nbs.zip3(xs, ys, zs)', ->
  it 'returns a list of triples, analogous to nbs.zip', ->
    expected = [[1, 2, 3], [2, 2, 2], [3, 2, 1]]
    expect(nbs.zip3 [1..3], [2, 2, 2], [3..1]).toEqual expected

describe 'nbs.zipWith(f, xs, ys)', ->
  it '''generalises nbs.zip by zipping whti the function given as the first
  argument, instead of a tupling function''', ->
    expect(nbs.zipWith nbs['+'], [1..3], [3..1]).toEqual [4, 4, 4]

describe 'nbs.zipWith3(f, xs, ys, zs)', ->
  it '''returns a list of thier point-wise combination, analogous to
  nbs.zipWith''', ->
    f = (x, y, z) -> (x + y) / z
    expected = [2, 2, 2]
    expect(nbs.zipWith3 f, [1..3], [3..1], [2, 2, 2]).toEqual expected

describe 'nbs.unzip(ws)', ->
  it '''transforms a list of pairs into a list of first components and list of
  second components''', ->
    expect(nbs.unzip [[1, 3], [2, 2], [3, 1]]).toEqual [[1..3], [3..1]]

describe 'nbs.unzip3(ws)', ->
  it 'three lists, analogous to nbs.unzip', ->
    expected = [[1..3], [2, 2, 2], [3..1]]
    expect(nbs.unzip3 [[1, 2, 3], [2, 2, 2], [3, 2, 1]]).toEqual expected

describe 'nbs.lines(x)', ->
  it 'breaks a string up into a list of strings at newline characters', ->
    expect(nbs.lines 'abc\ndef\r\nghi').toEqual ['abc', 'def', 'ghi']

describe 'nbs.words(x)', ->
  it '''breaks a string up into a list of words, which were delimited by white
  space.''', ->
    expected = ['abc', 'def', 'ghi', 'jkl']
    expect(nbs.words 'abc  def\r\nghi\tjkl').toEqual expected

describe 'nbs.unlines(xs)', ->
  it 'joins lines, after appending a termiating newline to each', ->
    expect(nbs.unlines ['abc', 'def']).toBe 'abc\ndef'

describe 'nbs.unwords(xs)', ->
  it 'joins words with separating spaces', ->
    expect(nbs.unwords ['abc', 'def']).toBe 'abc def'

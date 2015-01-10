###!
# NobushiJS @@version - @@description
# @@homepage
#
# Copyright 2014 Koji YAMADA and other contributors
# Released under the MIT license.
# @@homepage/raw/master/LICENSE
###

# Haskell Prelude:
# https://hackage.haskell.org/package/base-4.7.0.2/docs/Prelude.html

'use strict'

root = @

nbs = (obj) ->
  return obj if obj instanceof nbs
  return new nbs obj unless @ instanceof nbs

  for name, func of nbs when typeof func is 'function'
    @[name] = if obj is undefined
      do (f = func) => (args...) => nbs.flip(f).apply @, args
    else
      do (f = func) => (args...) => f.apply @, [obj].concat args

  @

nbs.VERSION = '@@version'
nbs.toString = -> "NobushiJS #{nbs.VERSION}"

# Core
# ----

# `nbs.curry` converts an uncurried function to a curried function.
nbs.curry = curry = (f) ->
  return f if f._curried

  do (length = if f._length? then f._length else f.length) ->
    _curry = (xs...) ->
      if length <= xs.length
        f.apply @, xs
      else
        g = (ys...) -> _curry.apply @, xs.concat ys
        g._length = length - xs.length
        g

    _curry._length = length
    _curry._curried = true
    _curry

# Standart types, classes and related functions
# ---------------------------------------------

# ### Basic data types

# #### Bool

# Boolean "and"
nbs['&&'] = curry (x, y) -> x && y

# Boolean "or"
nbs['||'] = curry (x, y) -> x || y

# Boolean "not"
nbs['!'] = nbs.not = curry (x) -> not x

# ### Basic type classes

# #### class Eq methods

nbs['=='] = nbs['==='] = curry (x, y) -> x == y
nbs['/='] = nbs['!='] = nbs['!=='] = curry (x, y) -> x != y
nbs['<'] = curry (x, y) -> x < y
nbs['>='] = curry (x, y) -> x >= y
nbs['>'] = curry (x, y) -> x > y
nbs['<='] = curry (x, y) -> x <= y
nbs.max = curry (x, y) -> if x < y then y else x
nbs.min = curry (x, y) -> if x < y then x else y

# #### class Enum methods

# the successor of a value.  For numeric types, `nbs.succ` adds 1.
nbs.succ = (x) -> x + 1

# the predecessor of a value.  For numeric types, `nbs.pred` subtracts 1.
nbs.pred = (x) -> x - 1

# `nbs.enumFromTo(n, m)` means the same as `[n..m]`.
nbs.enumFromTo = curry (n, m) -> [n..m]

# `nbs.enumFromThenTo(n0, n1, m)` means the same as
# `(x for x in [n0..m] by n1 - n0)`.
nbs.enumFromThenTo = curry (n0, n1, m) ->
  (x for x in [n0..m] by n1 - n0)

# ### Numeric type classes

nbs['+'] = curry (x, y) -> x + y
nbs['-'] = curry (x, y) -> x - y
nbs['*'] = curry (x, y) -> x * y

# Unary negation.
nbs.negate = curry (x) -> -x

# Absolute value.
nbs.abs = curry (x) -> if x < 0 then -x else x

# Sign of a number.  The functions `nbs.abs` and `nbs.signum` should satisfy the
# law:
#
# ```
# nbs.abs(x) * nbs.signum(x) == x
# ```
#
# For real numbers, the `nbs.signum` is either `-1` (negative), `0` (zero) or
# `1` (positive).
nbs.signum = curry (x) -> switch
  when x < 0 then -1
  when 0 < x then 1
  else 0

# integer division truncated toward zero
nbs.quot = curry (x, y) -> (nbs.quotRem x, y)[0]

# integer remainder, satisfying
#
# ```
# nbs(x).quot(y) * y + nbs(x).rem(y) == x
# ```
nbs.rem = curry (x, y) -> (nbs.quotRem x, y)[1]

# integer division truncated toward negative infinity
nbs.div = curry (x, y) -> (nbs.divMod x, y)[0]

# integer modulus, satisfying
#
# ```
# nbs(x).div(y) * y + nbs(x).mod(y) == x
# ```
nbs.mod = nbs['%'] = curry (x, y) -> (nbs.divMod x, y)[1]

# simultaneous `quot` and `rem`
nbs.quotRem = curry (x, y) ->
  do (quot = nbs.truncate x / y) -> [quot, x - quot * y]

# simultaneous `div` and `mod`
nbs.divMod = curry (x, y) ->
  do (div = nbs.floor x / y) -> [div, x - div * y]

# fractional division
nbs['/'] = curry (x, y) -> x / y

# reciprocal fraction
nbs.recip = nbs(1)['/']

# `nbs.truncate(x)` returns the integer nearest `x` between zero and `x`
nbs.truncate = curry (x) -> parseInt x, 10

# `nbs.round(x)` returns the nearest integer to `x`; the even integer if `x` is
# equidistant between two integers
nbs.round = curry Math.round

# `nbs.ceiling(x)` returns the least integer not less than `x`
nbs.ceiling = curry Math.ceil

# `nbs.floor(x)` returns the greatest integer not greater than `x`
nbs.floor = curry Math.floor

# #### Numeric functions

nbs.even = curry (x) -> x % 2 == 0
nbs.odd = curry (x) -> x % 2 == 1

# `nbs.gcd(x, y)` is the non-negative factor of both `x` and `y` of which every
# common factor of `x` and `y` is also a factor; for example `nbs.gcd(4, 2)` =
# `2`, `nbs.gcd(-4, 6)` = `2`, `nbs.gcd(0, 4)` = `4`.  `nbs.gcd(0, 0)` = `0`.
# (That is, the common divisor that is "greatest" in the divisibility
# preordering.)
nbs.gcd = curry (x, y) ->
  _gcd = (a, b) -> if b == 0 then a else _gcd b, nbs(a).rem(b)
  _gcd nbs.abs(x), nbs.abs(y)

# `nbs.lcm(x, y)` is the smallest positive integer that both `x` and `y` divide.
nbs.lcm = curry (x, y) ->
  if x == 0 or y == 0 then 0 else nbs.abs nbs(x).quot(nbs.gcd(x, y)) * y

# raise a number to a non-negative integral power
nbs['^'] = curry (x0, y0) ->
  f = (x, y) -> switch
    when nbs.even y then f (x * x), nbs(y).quot(2)
    when y == 1 then x
    else g (x * x), nbs(y - 1).quot(2), x
  g = (x, y, z) -> switch
    when nbs.even y then g (x * x), nbs(y).quot(2), z
    when y == 1 then x * z
    else g (x * x), nbs(y - 1).quot(2), (x * z)
  switch
    when y0 < 0 then nbs.error 'Negative exponent'
    when y0 == 0 then 1
    else f x0, y0

# raise a number to an integral power
nbs['^^'] = curry (x, n) ->
  if 0 <= n
    nbs(x)['^'](n)
  else
    nbs.recip nbs(x)['^'](-n)

# ### Miscellaneous functions

# Identity function.
nbs.id = curry (x) -> x

# Constant function.
nbs.$const = nbs.$const = curry (x) -> (-> x)

# `nbs.flip(f)` takes its (first) two arguments in the reverse order of f.
nbs.flip = curry (f) -> curry ((x, y) -> f y, x)

# `nbs.until(p, f)` yields the result of applying `f` until `p` holds.
nbs.until = curry (p, f, x) ->
  x = f x until p x
  x

# `nbs.error` stops execution and displays an error message.
nbs.error = curry (message) -> throw new Error message

# List operations
# ---------------

# `nbs.map(f, xs)` is the list obtained by applying `f` to each element of `xs`.
nbs.map = curry (f, xs) -> f x for x in xs

# Append two lists.
nbs['++'] = curry (xs, ys) -> xs.concat ys

# `nbs.filter`, applied to a predicate and a list, returns the list of those
# elements that satisfy the predicate.
nbs.filter = curry (p, xs) -> x for x in xs when p x

# Extract the first element of a list, which must be non-empty.
nbs.head = curry (xs) ->
  nbs.error 'nbs.head: empty list' if nbs.$null xs
  xs[0]

# Extract the last element of a list, which must be non-empty.
nbs.last = curry (xs) ->
  nbs.error 'nbs.last: empty list' if nbs.$null xs
  xs[xs.length - 1]

# Extract the elements after the head of a list, which must be non-empty.
nbs.tail = curry (xs) ->
  nbs.error 'nbs.tail: empty list' if nbs.$null xs
  xs.slice 1

# Return all the elements of a list expect the last one.  The list must be
# non-empty.
nbs.init = curry (xs) ->
  nbs.error 'nbs.init: empty list' if nbs.$null xs
  xs.slice 0, -1

# Test whether a list is empty.
nbs.$null = curry (xs) -> xs.length <= 0

# `nbs.$length` returns the length of a list.
nbs.$length = curry (xs) -> xs.length

# List index (subscript) operator, starting from 0.
nbs['!!'] = curry (xs, n) -> switch
  when n < 0 then nbs.error 'nbs.!!: negative index'
  when xs.length <= n then nbs.error 'nbs.!!: index too large'
  else xs[n]

# `nbs.reverse(xs)` returns the elements of `xs` in reverse order.
nbs.reverse = curry (xs) ->
  if typeof xs is 'string' then xs.split('').reverse().join '' else xs.reverse()

# ### Reducing lists (folds)

# `nbs.foldl`, applied to a binary operator, a starting value (typically the
# left-identity of the operator), and a list, reduces the list using the binary
# operator, from left ro right.
nbs.foldl = curry (f, z, xs) ->
  for x in xs
    z = f z, x
  z

# `nbs.foldl1` is a variant of `nbs.foldl` that has no starting value argument,
# and thus must be applied to non-empty lists.
nbs.foldl1 = curry (f, xs) ->
  nbs.error 'nbs.foldl1: empty list' if nbs.$null xs
  nbs.foldl f, (nbs.head xs), (nbs.tail xs)

# `nbs.foldr`, applied to binary operator, a starting value (typically the
# right-identity of the operator), and a list, reduces the list using the
# binary operator, form right to left:
nbs.foldr = curry (f, z, xs) ->
  for x in xs.reverse()
    z = f x, z
  z

# 'nbs.foldr1' is a variant of `nbs.foldr` that has no starting value argument,
# and thus must be applied to non-empty lists.
nbs.foldr1 = curry (f, xs) ->
  nbs.error 'nbs.foldr1: empty list' if nbs.$null xs
  nbs.foldr f, (nbs.last xs), (nbs.init xs)

# #### Special folds

# `nbs.and` returns the conjunction of a Boolean list.
nbs.and = curry (xs) -> nbs.all nbs.id, xs

# `nbs.or` returns the disjunction of a Boolean list.
nbs.or = curry (xs) -> nbs.any nbs.id, xs

# Applied to a predicate and a list, `nbs.any` determines if any element of the
# list satisfies the predicate.
nbs.any = curry (p, xs) ->
  for x in xs when p x
    return true
  false

# Applied to a predicate and a list, `nbs.all` determines if all elements of the
# list satisfy the predicate.
nbs.all = curry (p, xs) ->
  for x in xs when not p x
    return false
  true

# The `nbs.sum` function computes the sum of a list of numbers.
nbs.sum = curry (xs) -> nbs.foldl nbs['+'], 0, xs

# The 'nbs.product' function computes the product of a list of numbers.
nbs.product = curry (xs) -> nbs.foldl nbs['*'], 1, xs

# Concatenate a list of lists.
nbs.concat = curry (xs) ->
  x = nbs.head xs
  x.concat.apply x, nbs.tail xs

# Map a function over a list and concatenate the results.
nbs.concatMap = curry (f, xs) -> nbs.concat (nbs.map f, xs)

# `nbs.maximum` returns the maximum value from a list, which must be non-empty.
nbs.maximum = curry (xs) ->
  nbs.error 'nbs.maximum: empty list' if nbs.$null xs
  nbs.foldl1 nbs.max, xs

# `nbs.minimum` returns the minimum value from a list, whcih must be non-empty.
nbs.minimum = curry (xs) ->
  nbs.error 'nbs.minimum: empty list' if nbs.$null xs
  nbs.foldl1 nbs.min, xs

# ### Building lists

# #### Scans

# `nbs.scanl` is similar to `nbs.foldl`, but returns a list of successive
# reduced values from the left:
nbs.scanl = curry (f, z, xs) ->
  ys = [z]
  for x in xs
    ys.push z = f z, x
  ys

# `nbs.scanl1` is a variant of `nbs.scanl` that has no starting value argument.
nbs.scanl1 = curry (f, xs) ->
  nbs.error 'nbs.scanl1: empty list' if nbs.$null xs
  nbs.scanl f, (nbs.head xs), (nbs.tail xs)

# `nbs.scanr` is the right-to-left dual of `nbs.scanl`.
nbs.scanr = curry (f, z, xs) ->
  ys = [z]
  for x in xs.reverse()
    ys.unshift z = f x, z
  ys

# `nbs.scanr1` is a variant of `nbs.scanr` that has no starting value argument.
nbs.scanr1 = curry (f, xs) ->
  nbs.error 'nbs.scanr1: empty list' if nbs.$null xs
  nbs.scanr f, (nbs.last xs), (nbs.init xs)

# #### Finite lists

# `nbs.replicate(n, x)` is a list of length `n` with `x` the value of every
# element.
nbs.replicate = curry (n, x) ->
  if typeof x is 'string' and x.length == 1
    (x while 0 < n--).join ''
  else
    x while 0 < n--

# ### Sublists

# `nbs.take(n)`, applied to a list `xs`, returns the prefix of `xs` of length
# `n`, or `xs` itself if `n > xs.length`
nbs.take = curry (n, xs) -> xs.slice 0, nbs.max 0, n

# `nbs.drop(n, xs)` returns the suffix of `xs` after the first `n` elements, or
# `[]` if `n > xs.length`.
nbs.drop = curry (n, xs) -> xs.slice nbs.max 0, n

# `nbs.splitAt(n, xs)` returns a tuple where first element is `xs` prefix of
# length `n` and second element is the remainder of the list
#
# It is equivalent to `[(nbs.take n, xs), (nbs.drop n, xs)]`.
nbs.splitAt = curry (n, xs) -> [(nbs.take n, xs), (nbs.drop n, xs)]

# `nbs.takeWhile`, applied to a predicate `p` and a list `xs`, returns the
# longest prefix (possibly empty) of `xs` of elements that satisfy `p`.
nbs.takeWhile = curry (p, xs) ->
  ys = []
  for x in xs
    break unless p x
    ys.push x
  ys

# `nbs.dropWhile(p, xs)` returns the suffix remaining after
# `nbs.takeWhile(p, xs)`.
nbs.dropWhile = curry (p, xs) ->
  while not nbs.$null xs
    break unless p nbs.head xs
    xs = nbs.tail xs
  xs

# `nbs.span`, applied to a predicate `p` and a list `xs`, returns a tuple where
# first element is longest prefix (possibly empty) of `xs` of elements that
# satisfy `p` and second element is the remainder of the list.
nbs.span = curry (p, xs) ->
  ys = []
  zs = xs
  while not nbs.$null zs
    z = nbs.head zs
    break unless p z
    ys.push z
    zs = nbs.tail zs
  [ys, zs]

# `nbs.break`, apllied to a predicate `p` and a list `xs`, returns a tuple
# where first element is longest prefix (possibly empty) of `xs` of elements
# *do not satisfy* `p` and second element is the remainder of the list.
nbs.$break = curry (p, xs) -> nbs.span ((x) -> not p x), xs

# ### Searching lists

# `nbs.elem` is the list membership predicate, usually written in infix form,
# e.g., `nbs(x).elem(xs)`.
nbs.elem = curry (x, xs) ->
  for i in xs when x == i
    return true
  false

# `nbs.notElem` is the negation of `nbs.elem`.
nbs.notElem = curry (x, xs) -> not nbs(x).elem(xs)

# ### Zipping and unzipping lists

# `nbs.zip` takes two lists and returns a list of corresponding pairs.  If one
# input list is short, excess elements of the longer list are discarded.
nbs.zip = (xs, ys) -> nbs.zipWith ((x, y) -> [x, y]), xs, ys

# `nbs.zip3` takes three lists and returns a list of triples, analogous to
# `nbs.zip`.
nbs.zip3 = (xs, ys, zs) -> nbs.zipWith3 ((x, y, z) -> [x, y, z]), xs, ys, zs

# `nbs.zipWith` generalises `nbs.zip` by zipping with the function given as the
# first argument, instead of a tupling function.
nbs.zipWith = curry (f, xs, ys) ->
  length = nbs.min xs.length, ys.length
  f xs[i], ys[i] for i in [0...length]

# The `nbs.zipWith3` function takes a function which combines three elements,
# as well as three lists and returns a list of their point-wise combination,
# analogous to `nbs.zipWith`.
nbs.zipWith3 = curry (f, xs, ys, zs) ->
  length = nbs.minimum nbs.map nbs.$length, [xs, ys, zs]
  f xs[i], ys[i], zs[i] for i in [0...length]

# `nbs.unzip` transforms a list of pairs into a list of first components and
# list of second components.
nbs.unzip = curry (ts) ->
  xs = []
  ys = []
  for t in ts
    xs.push t[0]
    ys.push t[1]
  [xs, ys]

# The `nbs.unzip3` function takes a list of triples and returns three lists,
# analogous to `nbs.unzip`.
nbs.unzip3 = curry (ts) ->
  xs = []
  ys = []
  zs = []
  for t in ts
    xs.push t[0]
    ys.push t[1]
    zs.push t[2]
  [xs, ys, zs]

# ### Functions on strings

# `nbs.lines` breaks a string up into a list of strings at newline characters.
# The resulting strings do not contain newlines.
nbs.lines = curry (s) -> s.replace(/(\r\n|\r)/g, '\n').split '\n'

# `nbs.words` breaks a string up info a list of words, which were delmited by
# white space.
nbs.words = curry (s) -> s.replace(/\s+/g, ' ').split ' '

# `nbs.unlines` is an inverse operation to `nbs.lines`.  It joins lines, after
# appending a terminating newline to each.
nbs.unlines = curry (xs) -> xs.join '\n'

# `nbs.unwords` is an inverse operation to `nbs.words`.  It joins words with
# separating spaces.
nbs.unwords = curry (xs) -> xs.join ' '

# Export nbs
# ----------

if typeof define is 'function' and define.amd
  # AMD
  define [], -> nbs
else if typeof module is 'object'
  # CommonJS
  module.exports = nbs
else
  # Browser global
  root.nbs = nbs

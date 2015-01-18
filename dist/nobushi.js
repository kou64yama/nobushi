
/*!
 * NobushiJS 0.1.0 - JavaScript library that is similar to the Haskell Prelude.
 * https://github.com/kou64yama/nobushi
 *
 * Copyright 2014 Koji YAMADA and other contributors
 * Released under the MIT license.
 * https://github.com/kou64yama/nobushi/raw/master/LICENSE
 */

(function() {
  'use strict';
  var curry, nbs, root,
    __slice = [].slice;

  root = this;

  nbs = function(obj) {
    var func, name;
    if (obj instanceof nbs) {
      return obj;
    }
    if (!(this instanceof nbs)) {
      return new nbs(obj);
    }
    for (name in nbs) {
      func = nbs[name];
      if (typeof func === 'function') {
        this[name] = obj === void 0 ? (function(_this) {
          return function(f) {
            return function() {
              var args;
              args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
              return nbs.flip(f).apply(_this, args);
            };
          };
        })(this)(func) : (function(_this) {
          return function(f) {
            return function() {
              var args;
              args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
              return f.apply(_this, [obj].concat(args));
            };
          };
        })(this)(func);
      }
    }
    return this;
  };

  nbs.VERSION = '0.1.0';

  nbs.toString = function() {
    return "NobushiJS " + nbs.VERSION;
  };

  nbs.curry = curry = function(f) {
    if (f._curried) {
      return f;
    }
    return (function(length) {
      var _curry;
      _curry = function() {
        var g, xs;
        xs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (length <= xs.length) {
          return f.apply(this, xs);
        } else {
          g = function() {
            var ys;
            ys = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
            return _curry.apply(this, xs.concat(ys));
          };
          g._length = length - xs.length;
          return g;
        }
      };
      _curry._length = length;
      _curry._curried = true;
      return _curry;
    })(f._length != null ? f._length : f.length);
  };

  nbs['&&'] = curry(function(x, y) {
    return x && y;
  });

  nbs['||'] = curry(function(x, y) {
    return x || y;
  });

  nbs['!'] = nbs.not = curry(function(x) {
    return !x;
  });

  nbs['=='] = nbs['==='] = curry(function(x, y) {
    return x === y;
  });

  nbs['/='] = nbs['!='] = nbs['!=='] = curry(function(x, y) {
    return x !== y;
  });

  nbs['<'] = curry(function(x, y) {
    return x < y;
  });

  nbs['>='] = curry(function(x, y) {
    return x >= y;
  });

  nbs['>'] = curry(function(x, y) {
    return x > y;
  });

  nbs['<='] = curry(function(x, y) {
    return x <= y;
  });

  nbs.max = curry(function(x, y) {
    if (x < y) {
      return y;
    } else {
      return x;
    }
  });

  nbs.min = curry(function(x, y) {
    if (x < y) {
      return x;
    } else {
      return y;
    }
  });

  nbs.succ = function(x) {
    return x + 1;
  };

  nbs.pred = function(x) {
    return x - 1;
  };

  nbs.enumFromTo = curry(function(n, m) {
    var _i, _results;
    return (function() {
      _results = [];
      for (var _i = n; n <= m ? _i <= m : _i >= m; n <= m ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this);
  });

  nbs.enumFromThenTo = curry(function(n0, n1, m) {
    var x, _i, _ref, _results;
    _results = [];
    for (x = _i = n0, _ref = n1 - n0; _ref > 0 ? _i <= m : _i >= m; x = _i += _ref) {
      _results.push(x);
    }
    return _results;
  });

  nbs['+'] = curry(function(x, y) {
    return x + y;
  });

  nbs['-'] = curry(function(x, y) {
    return x - y;
  });

  nbs['*'] = curry(function(x, y) {
    return x * y;
  });

  nbs.negate = curry(function(x) {
    return -x;
  });

  nbs.abs = curry(function(x) {
    if (x < 0) {
      return -x;
    } else {
      return x;
    }
  });

  nbs.signum = curry(function(x) {
    switch (false) {
      case !(x < 0):
        return -1;
      case !(0 < x):
        return 1;
      default:
        return 0;
    }
  });

  nbs.quot = curry(function(x, y) {
    return (nbs.quotRem(x, y))[0];
  });

  nbs.rem = curry(function(x, y) {
    return (nbs.quotRem(x, y))[1];
  });

  nbs.div = curry(function(x, y) {
    return (nbs.divMod(x, y))[0];
  });

  nbs.mod = nbs['%'] = curry(function(x, y) {
    return (nbs.divMod(x, y))[1];
  });

  nbs.quotRem = curry(function(x, y) {
    return (function(quot) {
      return [quot, x - quot * y];
    })(nbs.truncate(x / y));
  });

  nbs.divMod = curry(function(x, y) {
    return (function(div) {
      return [div, x - div * y];
    })(nbs.floor(x / y));
  });

  nbs['/'] = curry(function(x, y) {
    return x / y;
  });

  nbs.recip = nbs(1)['/'];

  nbs.truncate = curry(function(x) {
    return parseInt(x, 10);
  });

  nbs.round = curry(Math.round);

  nbs.ceiling = curry(Math.ceil);

  nbs.floor = curry(Math.floor);

  nbs.even = curry(function(x) {
    return x % 2 === 0;
  });

  nbs.odd = curry(function(x) {
    return x % 2 === 1;
  });

  nbs.gcd = curry(function(x, y) {
    var _gcd;
    _gcd = function(a, b) {
      if (b === 0) {
        return a;
      } else {
        return _gcd(b, nbs(a).rem(b));
      }
    };
    return _gcd(nbs.abs(x), nbs.abs(y));
  });

  nbs.lcm = curry(function(x, y) {
    if (x === 0 || y === 0) {
      return 0;
    } else {
      return nbs.abs(nbs(x).quot(nbs.gcd(x, y)) * y);
    }
  });

  nbs['^'] = curry(function(x0, y0) {
    var f, g;
    f = function(x, y) {
      switch (false) {
        case !nbs.even(y):
          return f(x * x, nbs(y).quot(2));
        case y !== 1:
          return x;
        default:
          return g(x * x, nbs(y - 1).quot(2), x);
      }
    };
    g = function(x, y, z) {
      switch (false) {
        case !nbs.even(y):
          return g(x * x, nbs(y).quot(2), z);
        case y !== 1:
          return x * z;
        default:
          return g(x * x, nbs(y - 1).quot(2), x * z);
      }
    };
    switch (false) {
      case !(y0 < 0):
        return nbs.error('Negative exponent');
      case y0 !== 0:
        return 1;
      default:
        return f(x0, y0);
    }
  });

  nbs['^^'] = curry(function(x, n) {
    if (0 <= n) {
      return nbs(x)['^'](n);
    } else {
      return nbs.recip(nbs(x)['^'](-n));
    }
  });

  nbs.id = curry(function(x) {
    return x;
  });

  nbs.$const = nbs.$const = curry(function(x) {
    return function() {
      return x;
    };
  });

  nbs.flip = curry(function(f) {
    return curry((function(x, y) {
      return f(y, x);
    }));
  });

  nbs.until = curry(function(p, f, x) {
    while (!p(x)) {
      x = f(x);
    }
    return x;
  });

  nbs.error = curry(function(message) {
    throw new Error(message);
  });

  nbs.map = curry(function(f, xs) {
    var x, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      _results.push(f(x));
    }
    return _results;
  });

  nbs['++'] = curry(function(xs, ys) {
    return xs.concat(ys);
  });

  nbs.filter = curry(function(p, xs) {
    var x, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      if (p(x)) {
        _results.push(x);
      }
    }
    return _results;
  });

  nbs.head = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.head: empty list');
    }
    return xs[0];
  });

  nbs.last = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.last: empty list');
    }
    return xs[xs.length - 1];
  });

  nbs.tail = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.tail: empty list');
    }
    return xs.slice(1);
  });

  nbs.init = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.init: empty list');
    }
    return xs.slice(0, -1);
  });

  nbs.$null = curry(function(xs) {
    return xs.length <= 0;
  });

  nbs.$length = curry(function(xs) {
    return xs.length;
  });

  nbs['!!'] = curry(function(xs, n) {
    switch (false) {
      case !(n < 0):
        return nbs.error('nbs.!!: negative index');
      case !(xs.length <= n):
        return nbs.error('nbs.!!: index too large');
      default:
        return xs[n];
    }
  });

  nbs.reverse = curry(function(xs) {
    if (typeof xs === 'string') {
      return xs.split('').reverse().join('');
    } else {
      return xs.reverse();
    }
  });

  nbs.foldl = curry(function(f, z, xs) {
    var x, _i, _len;
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      z = f(z, x);
    }
    return z;
  });

  nbs.foldl1 = curry(function(f, xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.foldl1: empty list');
    }
    return nbs.foldl(f, nbs.head(xs), nbs.tail(xs));
  });

  nbs.foldr = curry(function(f, z, xs) {
    var x, _i, _len, _ref;
    _ref = xs.reverse();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      z = f(x, z);
    }
    return z;
  });

  nbs.foldr1 = curry(function(f, xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.foldr1: empty list');
    }
    return nbs.foldr(f, nbs.last(xs), nbs.init(xs));
  });

  nbs.and = curry(function(xs) {
    return nbs.all(nbs.id, xs);
  });

  nbs.or = curry(function(xs) {
    return nbs.any(nbs.id, xs);
  });

  nbs.any = curry(function(p, xs) {
    var x, _i, _len;
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      if (p(x)) {
        return true;
      }
    }
    return false;
  });

  nbs.all = curry(function(p, xs) {
    var x, _i, _len;
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      if (!p(x)) {
        return false;
      }
    }
    return true;
  });

  nbs.sum = curry(function(xs) {
    return nbs.foldl(nbs['+'], 0, xs);
  });

  nbs.product = curry(function(xs) {
    return nbs.foldl(nbs['*'], 1, xs);
  });

  nbs.concat = curry(function(xs) {
    var x;
    x = nbs.head(xs);
    return x.concat.apply(x, nbs.tail(xs));
  });

  nbs.concatMap = curry(function(f, xs) {
    return nbs.concat(nbs.map(f, xs));
  });

  nbs.maximum = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.maximum: empty list');
    }
    return nbs.foldl1(nbs.max, xs);
  });

  nbs.minimum = curry(function(xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.minimum: empty list');
    }
    return nbs.foldl1(nbs.min, xs);
  });

  nbs.scanl = curry(function(f, z, xs) {
    var x, ys, _i, _len;
    ys = [z];
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      ys.push(z = f(z, x));
    }
    return ys;
  });

  nbs.scanl1 = curry(function(f, xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.scanl1: empty list');
    }
    return nbs.scanl(f, nbs.head(xs), nbs.tail(xs));
  });

  nbs.scanr = curry(function(f, z, xs) {
    var x, ys, _i, _len, _ref;
    ys = [z];
    _ref = xs.reverse();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      x = _ref[_i];
      ys.unshift(z = f(x, z));
    }
    return ys;
  });

  nbs.scanr1 = curry(function(f, xs) {
    if (nbs.$null(xs)) {
      nbs.error('nbs.scanr1: empty list');
    }
    return nbs.scanr(f, nbs.last(xs), nbs.init(xs));
  });

  nbs.replicate = curry(function(n, x) {
    var _results;
    if (typeof x === 'string' && x.length === 1) {
      return ((function() {
        var _results;
        _results = [];
        while (0 < n--) {
          _results.push(x);
        }
        return _results;
      })()).join('');
    } else {
      _results = [];
      while (0 < n--) {
        _results.push(x);
      }
      return _results;
    }
  });

  nbs.take = curry(function(n, xs) {
    return xs.slice(0, nbs.max(0, n));
  });

  nbs.drop = curry(function(n, xs) {
    return xs.slice(nbs.max(0, n));
  });

  nbs.splitAt = curry(function(n, xs) {
    return [nbs.take(n, xs), nbs.drop(n, xs)];
  });

  nbs.takeWhile = curry(function(p, xs) {
    var x, ys, _i, _len;
    ys = [];
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      x = xs[_i];
      if (!p(x)) {
        break;
      }
      ys.push(x);
    }
    return ys;
  });

  nbs.dropWhile = curry(function(p, xs) {
    while (!nbs.$null(xs)) {
      if (!p(nbs.head(xs))) {
        break;
      }
      xs = nbs.tail(xs);
    }
    return xs;
  });

  nbs.span = curry(function(p, xs) {
    var ys, z, zs;
    ys = [];
    zs = xs;
    while (!nbs.$null(zs)) {
      z = nbs.head(zs);
      if (!p(z)) {
        break;
      }
      ys.push(z);
      zs = nbs.tail(zs);
    }
    return [ys, zs];
  });

  nbs.$break = curry(function(p, xs) {
    return nbs.span((function(x) {
      return !p(x);
    }), xs);
  });

  nbs.elem = curry(function(x, xs) {
    var i, _i, _len;
    for (_i = 0, _len = xs.length; _i < _len; _i++) {
      i = xs[_i];
      if (x === i) {
        return true;
      }
    }
    return false;
  });

  nbs.notElem = curry(function(x, xs) {
    return !nbs(x).elem(xs);
  });

  nbs.zip = function(xs, ys) {
    return nbs.zipWith((function(x, y) {
      return [x, y];
    }), xs, ys);
  };

  nbs.zip3 = function(xs, ys, zs) {
    return nbs.zipWith3((function(x, y, z) {
      return [x, y, z];
    }), xs, ys, zs);
  };

  nbs.zipWith = curry(function(f, xs, ys) {
    var i, length, _i, _results;
    length = nbs.min(xs.length, ys.length);
    _results = [];
    for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
      _results.push(f(xs[i], ys[i]));
    }
    return _results;
  });

  nbs.zipWith3 = curry(function(f, xs, ys, zs) {
    var i, length, _i, _results;
    length = nbs.minimum(nbs.map(nbs.$length, [xs, ys, zs]));
    _results = [];
    for (i = _i = 0; 0 <= length ? _i < length : _i > length; i = 0 <= length ? ++_i : --_i) {
      _results.push(f(xs[i], ys[i], zs[i]));
    }
    return _results;
  });

  nbs.unzip = curry(function(ts) {
    var t, xs, ys, _i, _len;
    xs = [];
    ys = [];
    for (_i = 0, _len = ts.length; _i < _len; _i++) {
      t = ts[_i];
      xs.push(t[0]);
      ys.push(t[1]);
    }
    return [xs, ys];
  });

  nbs.unzip3 = curry(function(ts) {
    var t, xs, ys, zs, _i, _len;
    xs = [];
    ys = [];
    zs = [];
    for (_i = 0, _len = ts.length; _i < _len; _i++) {
      t = ts[_i];
      xs.push(t[0]);
      ys.push(t[1]);
      zs.push(t[2]);
    }
    return [xs, ys, zs];
  });

  nbs.lines = curry(function(s) {
    return s.replace(/(\r\n|\r)/g, '\n').split('\n');
  });

  nbs.words = curry(function(s) {
    return s.replace(/\s+/g, ' ').split(' ');
  });

  nbs.unlines = curry(function(xs) {
    return xs.join('\n');
  });

  nbs.unwords = curry(function(xs) {
    return xs.join(' ');
  });

  if (typeof define === 'function' && define.amd) {
    define([], function() {
      return nbs;
    });
  } else if (typeof module === 'object') {
    module.exports = nbs;
  } else {
    root.nbs = nbs;
  }

}).call(this);

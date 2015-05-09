'use strict'

NbsFunction = require './nbs-function'

module.exports = class LaziedFunction extends NbsFunction
  body: (context) -> (xs...) =>
    f = @f
    for x in xs
      f = f.bind context, x
    (new LaziedFunction f).func context

test = require 'noflo-test'

test.component('HBM-const').
  discuss('When receiving a value').
    send.data('value', 5).
    discuss('should recieve array of that value').
      receive.data('out', (5 for [1..100])).
export module

test = require 'noflo-test'

`
//process.on('uncaughtException', function(err) {
//  console.log('Caught exception: ' + err.stack);
//});
`

test.component('HBM-const').
  describe('When receiving a val').
    send.data('valu', 5).
    it('should recieve array of that val').
      receive.data('out', (5 for [1..100])).
export module

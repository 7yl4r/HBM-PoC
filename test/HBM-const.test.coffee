chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-const.coffee').getComponent()

describe 'When receiving a val', ->
    t = new Tester c

    before (done) ->
        t.start ->
            done()

    it 'should be able to test out based on in', (done) ->
        VALUE = 1
        LEN = 2
        t.receive 'numbers', (data) ->
            chai.expect(data).to.eql(VALUE for [1..LEN])
            done()

        t.send 'length', LEN
        t.send 'value', VALUE

    it 'should not receive array of some other value', (done) ->
        VALUE = 1
        LEN = 2

        t.receive 'numbers', (data) ->
            chai.expect(data).to.not.equal(-1 for [1..100])
            done()

        t.send 'length', LEN
        t.send 'value', VALUE

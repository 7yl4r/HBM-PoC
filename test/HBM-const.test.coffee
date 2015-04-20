chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-const.coffee').getComponent

describe 'When receiving a val', ->
    t = new Tester c
    
    before (done) ->
        t.start ->
            done()
    
    send.data('valu', 5).
    it 'should recieve array of that val', (done) ->
        t.receive 'out', (data)->
            chai.expect(data).to.equal (5 for [1..100])
            done()
            
        t.send 'valu', 5

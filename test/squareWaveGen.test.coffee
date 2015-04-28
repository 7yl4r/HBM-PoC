chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-squareWaveGen.coffee').getComponent()


describe 'HBM square wave generator component', ->

    beforeEach (done) ->
        @t = new Tester c
        @t.start ->
            done()

        # reset to default values to prevent old values causing computation
        @t.send 'high',  10
        @t.send 'low',   1
        @t.send 'period', 6


    it 'should work using default params', (done) ->
        @t.receive 'out', (data) ->
            EXPECT = [1,1,1,10,10,10,1,1,1,10,10,10]
            for t of data
                chai.expect(data[t]).to.equal(EXPECT[t])   # aka equal(10) in this case...
            done()

        @t.send 'len', 12

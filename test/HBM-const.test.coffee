chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-const.coffee').getComponent()

describe('when running a test', ()->
    it('should be able to return before 2000ms', (done)->
        done()
    )
    it('should be able to compare values w/ chai', (done)->
        chai.expect(1).to.equal(1)
        done()
    )
    it('should be able to call done from a callback', (done)->
        funkyShun = (data)->
            done()

        funkyShun({fake:'data'})
    )
    it('should be able to use Tester', (done)->
        t = new Tester c
        done()
    )
    it('should be able to use t.start', (done)->
        t = new Tester c
        before (done) ->
            t.start ->
                done()

        done()
    )
    it 'should be able to receive', (done)->
        t = new Tester c

        t.start ->
            done()

        t.receive 'out', (data)->
            done()

        t.send 'valu', 'whateverFakeDataHere'
)

describe 'When receiving a val', ->

    it 'should receive array of that val', (done) ->
        t = new Tester c

        t.start ->
            done()

        t.receive 'out', (data)->
            chai.expect(data).to.equal (5 for [1..100])
            done()

        t.send 'valu', 5

    it 'should not receive array of another value', (done) ->
        t = new Tester c
        t.start ->
            done()

        t.receive 'out', (data)->
            chai.expect(data).to.not.equal (-1 for [1..100])

        t.send 'valu', 5

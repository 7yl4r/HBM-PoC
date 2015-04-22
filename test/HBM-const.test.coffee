chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-const.coffee').getComponent()

describe('when running tests', ()->
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
    it('should not have c == undefined', (done)->
        chai.expect(c).to.not.be.undefined
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

        t.start(done)

        t.receive 'out', (data)->
            done()

        t.send 'valu', 'whateverFakeDataHere'
)

describe 'when testing a component', ->
    # A SISO component
    com = new noflo.Component
    com.description = 'Echoes its input to the output'
    com.inPorts.add 'in',
        com.outPorts.add 'out'
    noflo.helpers.WirePattern com,
        forwardGroups: true
    , (input, groups, out) ->
        out.send input

    t = new Tester com

    before (done)->
        t.start(done)

    it 'should be able to test out based on in', (done) ->
        VALUE = 1
        t.receive 'out', (data) ->
            chai.expect(data).to.equal(VALUE)

        t.send 'in', VALUE



describe 'When receiving a val', ->
    t = new Tester c

    before (done)->
        t.start(done)
        done()

    it 'should receive array of that val', (done) ->

        t.receive 'out', (data)->
            chai.expect(data).to.equal (5 for [1..100])
            done()

        t.send 'valu', 5

    it 'should not receive array of some other value', (done) ->

        t.receive 'out', (data)->
            chai.expect(data).to.not.equal (-1 for [1..100])
            done()

        t.send 'valu', 5

chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

# A SISO component
com = new noflo.Component
com.description = 'Echoes its input to the output'
com.inPorts.add 'in',
    com.outPorts.add 'out'
noflo.helpers.WirePattern com,
    forwardGroups: true
, (input, groups, out) ->
    out.send input

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
        t = new Tester com
        done()
    )
    it('should be able to import component with require()', (done)->
        c = require('../components/HBM-const.coffee').getComponent()
        chai.expect(c).to.not.be.undefined
        done()
    )
)

describe 'when testing a component', ->
    t = new Tester com

    before (done) ->
        t.start ->
            done()

    it 'should be able to test out based on in', (done) ->
        VALUE = 1
        t.receive 'out', (data) ->
            chai.expect(data).to.equal(VALUE)
            done()

        t.send 'in', VALUE

chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-linearAdd.coffee').getComponent()

describe 'HBM linear add internals', ->

    it 'should compute one step correctly', (done)->
        c1 = 1
        c2 = 1
        dep1 = [1, 1, 1]
        dep2 = [1, 1, 1]
        t = 1
        expected = c1*dep1[t] + c2*dep2[t]
        actual   = c.step(t, c1, dep1, c2, dep2)
        chai.expect(actual).to.equal(expected)
        done()

describe 'HBM linear add component', ->

    beforeEach (done) ->
        @t = new Tester c
        @t.start ->
            done()

        # reset to default values to prevent old values causing computation
        @t.send 'c_1', 1
        @t.send 'c_2', 1
        @t.send 'in_1', undefined
        @t.send 'in_2', undefined

    it 'should add two arrays', (done) ->
        IN1 = [9,8,7,6,5,4,3,2,1]
        IN2 = [1,2,3,4,5,6,7,8,9]
        @t.receive 'out', (data) ->
            for t of data
                chai.expect(data[t]).to.equal(10)   # aka equal(10) in this case...
            done()

        @t.send 'in_1', IN1
        @t.send 'in_2', IN2

    it 'should add two arrays with linear scalars', (done) ->
        IN_ONE = [1, 10, 100]
        IN_TWO = [1,  1,   1]
        C1 = 1
        C2 = 2
        expectation = [3, 12, 102]

        @t.receive 'out', (data) ->
            for t of data
                chai.expect(data[t]).to.equal(expectation[t])   # aka equal(10) in this case...
            done()

        @t.send 'c_1', C1
        @t.send 'c_2', C2
        @t.send 'in_1', IN_ONE
        @t.send 'in_2', IN_TWO

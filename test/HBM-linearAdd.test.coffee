chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/HBM-linearAdd.coffee').getComponent()

describe 'HBM linear add', ->
    t = new Tester c

    before (done) ->
        t.start ->
            done()

    it 'should add two arrays', (done) ->
        IN1 = [9,8,7,6,5,4,3,2,1]
        IN2 = [1,2,3,4,5,6,7,8,9]
        t.receive 'out', (data) ->
            for t of data
                chai.expect(data[t]).to.equal(10)   # aka equal(10) in this case...
            done()

        t.send 'in_1', IN1
        t.send 'in_2', IN2

    it 'should add two arrays with linear scalars', (done) ->
        IN_ONE = [1, 10, 100]
        IN_TWO = [1,  1,   1]
        C1 = 1
        C2 = 2
        expectation = [3, 12, 102]

        # reset in_2 to prevent send in_1 from causing computation
        t.send 'in_2', undefined

        t.receive 'out', (data) ->
            for t of data
                chai.expect(data[t]).to.equal(expectation[t])   # aka equal(10) in this case...
            done()

        t.send 'c_1', C1
        t.send 'c_2', C2
        t.send 'in_1', IN_ONE
        t.send 'in_2', IN_TWO

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
                chai.expect(data[t]).to.equal(IN1[t] + IN2[t])   # aka equal(10) in this case...
            done()

        t.send 'in_1', IN1
        t.send 'in_2', IN2

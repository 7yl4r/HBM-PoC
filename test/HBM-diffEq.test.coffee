chai = require 'chai'
noflo = require 'noflo'
Tester = require 'noflo-tester'

c = require('../components/diffEq.coffee').getComponent()

describe 'HBM differential equation', ->

    beforeEach (done) ->
        @t = new Tester c
        @t.start ->
            done()

        @t.send 'in_1', undefined
        @t.send 'in_2', undefined
        @t.send 'c_1', 1
        @t.send 'c_2', 1
        @t.send 'theta_1', 0
        @t.send 'theta_2', 0
        @t.send 'tao', 0.5

    it 'fits in bounds of expected solution for flat [0] + step(1,5), default theta/tao/c', (done) ->
        # c(t) = - tau_c * dc/dt + c_a * a(t - theta_a) + c_b * b(t - theta_b)
        IN1 = [0,0,0,0,0,0,0,0]
        IN2 = [1,1,1,1,5,5,5,5]
        STEP_T = 4  # index of the step

        @t.receive 'out', (data) ->
            min = 0
            for t of data  # TODO: replace this with actual solution rather than these silly bounds
                if t < STEP_T
                    chai.expect(data[t]).to.be.at.most(1)
                    chai.expect(data[t]).to.be.at.least(min)
                else
                    chai.expect(data[t]).to.be.at.most(5)
                    chai.expect(data[t]).to.be.at.least(min)

                if data[t] > min
                    min = data[t]
            done()

        @t.send 'in_1', IN1
        @t.send 'in_2', IN2


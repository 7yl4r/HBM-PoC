#chai = require 'chai'
#noflo = require 'noflo'
#Tester = require 'noflo-tester'
#
#c = require('../components/HBM-diffEq.coffee').getComponent()
#
#describe 'HBM differential equation', ->
    #t = new Tester c
#
    #before (done) ->
        #t.start ->
            #done()
#
    #it 'flat [0] + step(1,5), thetas=0, consts=1', (done) ->
        ## c(t) = tau_c * dc/dt = c + c_a * a(t - theta_a) + c_b * b(t - theta_b)
        #IN1 = [0,0,0,0,0,0,0,0]
        #c_IN1 = 1
        #th_IN1 = 0
        #IN2 = [1,1,1,5,5,5,5,5]
        #c_IN2 = 1
        #th_IN1 = 0
        #t.receive 'out', (data) ->
            #for t of data
                #if t < 1
                    #prev = data[0]
                #else
                    #prev = data[t-1]
                #next = prev + c_IN1 * IN1[t-th_IN1) + c_IN2 * b(t-th_IN2)
                #chai.expect(data[t]).to.equal(next)
            #done()
#
        #t.send 'in_1', IN1
        #t.send 'in_2', IN2
        #

noflo = require 'noflo'

class MyComponent extends noflo.Component
  description: "Combines two inflows linearly."
  # icon

  constructor:  ->
    @c_1 = 1
    @c_2 = 1

    # TODO: try to use this syntax:
#      c.inPorts.add 'max',
#          datatype: "number"
#          description: "absolute maximum value"
#      , (event, payload) =>
#          if event is 'data'
#              @max = payload

    @inPorts = new noflo.InPorts
      in_1:
        datatype: 'array'
        required: true
      in_2:
        datatype: 'array'
        required: true
      c_1:
        datatype: 'number'
        required: false
      c_2:
        datatype: 'number'
        required: false

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'array'

    @inPorts.in_1.on 'data', (data) =>
      @in_1 = data
      @compute()
    @inPorts.in_2.on 'data', (data) =>
      @in_2 = data
      @compute()
    @inPorts.c_1.on 'data', (data) =>
      @c_1 = data
      @compute()
    @inPorts.c_2.on 'data', (data) =>
      @c_2 = data
      @compute()

  # function to get value @ t from dependency time-series objects
  step: (t, c1, dep1, c2, dep2)->
    #console.log('step(', t, c1, dep1[t], c2, dep2[t], ')')
    return c1*dep1[t] + c2*dep2[t]
    # TODO: handle out-of-bounds t by wrapping array calls
    #   in a function?

  compute: ->
    return unless @outPorts.out.isAttached()
    return unless @in_1? and @in_2?

    if @in_1.length != @in_2.length
      throw Error('input arrays must be same length, ' +
          @in_1.length +
          '!=' +
          @in_2.length
      )
    else
      values = (0 for [1..@in_1.length])
      for t of @in_1
        values[t] = @step(t, @c_1, @in_1, @c_2, @in_2)

#      console.log('data:', values)
      @outPorts.out.send(values)

      @outPorts.out.disconnect()

exports.getComponent = -> new MyComponent
noflo = require 'noflo'

class MyComponent extends noflo.Component
  description: "Combines two inflows linearly."
  # icon

  constructor:  ->
    @inPorts = new noflo.InPorts
      in_1:
        datatype: 'array'
        required: true
      in_2:
        datatype: 'array'
        required: true

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'array'

    @inPorts.in_1.on 'data', (data) =>
      @in_1 = data
      @compute()

    @inPorts.in_2.on 'data', (data) =>
      @in_2 = data
      @compute()


  # function to get value @ t from dependency time-series objects
  step: (t, dep1, dep2)->
    return dep1[t] + dep2[t]
    # TODO: handle out-of-bounds t by wrapping array calls
    #   in a function?

  compute: ->
    return unless @outPorts.out.isAttached()
    return unless @in_1? and @in_2?

    if @in_1.length != @in_2.length
      throw Error('input arrays must be same length!')
    else
      values = (0 for [1..@in_1.length])
      for t of @in_1
        values[t] = @step(t, @in_1, @in_2)

      @outPorts.out.send(@values)

      @outPorts.out.disconnect()

exports.getComponent = -> new MyComponent

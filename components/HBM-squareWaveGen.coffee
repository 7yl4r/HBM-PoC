noflo = require 'noflo'

class MyComponent extends noflo.Component
  description: "Combines two inflows linearly."
  # icon

  constructor:  ->
    @high = 10
    @low = 1
    @period = 6

    @inPorts = new noflo.InPorts
      high:
        datatype: 'number'
        required: true
      low:
        datatype: 'number'
        required: true
      period:
        datatype: 'number'
        required: false
      len:
        datatype: 'number'
        required: false

    @outPorts = new noflo.OutPorts
      out:
        datatype: 'array'

    @inPorts.high.on 'data', (data) =>
      @high = data
      @compute()
    @inPorts.low.on 'data', (data) =>
      @low = data
      @compute()
    @inPorts.period.on 'data', (data) =>
      @period = data
      @compute()
    @inPorts.len.on 'data', (data) =>
      @len = data
      @compute()

  # function to get value @ t from dependency time-series objects
  step: (t)->
    if t%@period < @period/2
      return @low
    else
      return @high

  compute: ->
    return unless @outPorts.out.isAttached()
    if not @len?
      console.warn('squareWaveGen requires len input')
    else
      values = (0 for [1..@len])
      for t of values
        values[t] = @step(t)

#      console.log('data:', values)
      @outPorts.out.send(values)

      @outPorts.out.disconnect()

exports.getComponent = -> new MyComponent
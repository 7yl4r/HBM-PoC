noflo = require 'noflo'

class HBMConst extends noflo.Component
  description: "Creates array of given length with given value"
  # icon

  constructor:  ->
    @inPorts = new noflo.InPorts
      value:
        datatype: 'number'
        required: true
      length:
        datatype: 'number'
        required: true

    @outPorts = new noflo.OutPorts
      numbers:
        datatype: 'array'

    @inPorts.value.on 'data', (data) =>
      @value = data
      @compute()

    @inPorts.length.on 'data', (data) =>
      @len = data
      @compute()

  compute: ->
    return unless @outPorts.numbers.isAttached()
    return unless @len? and @value? > 0

    @outPorts.numbers.send(@value for [1..@len])

    @outPorts.numbers.disconnect()

exports.getComponent = -> new HBMConst

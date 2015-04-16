noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  
  value = 1
  @len = 1000
  @values = (value for [1..@len])
  
  c.inPorts.add 'value',
    datatype: "number",
  ,(event, payload) =>
    return unless event is 'data'
    @values = (payload for [1..@len])
    # Do something with the packet, then
    c.outPorts.out.send payload
  c.outPorts.add 'out'
  c
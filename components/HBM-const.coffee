noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  
  @len = 100
  @values = (1 for [1..@len])
  
  c.outPorts.add 'out'
  c.outPorts.out.send @values
  
  c.inPorts.add 'valu',
    datatype: "number",
  ,(event, payload) =>
    return unless event is 'data'
    @values = (payload for [1..@len])
    # Do something with the packet, then
    c.outPorts.out.send @values
  return c

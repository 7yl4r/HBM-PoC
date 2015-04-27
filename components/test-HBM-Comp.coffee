noflo = require 'noflo'
 
exports.getComponent = ->
  c = new noflo.Component
  c.description = "base human-behavior-model component to build onto"
  c.icon = "question"
  
  MAX_LEN = 1000  # max time steps in simulation
  # TODO: how can I better guess this?
  
  # START base in ports which all HBM components should have
  @average = 100
  c.inPorts.add 'average', (event, payload) =>
    if event is 'data'
      @average = payload
  @variance = 1
  c.inPorts.add 'variance', (event, payload) =>
    if event is 'data'
      @variance = payload
  @min = -200
  c.inPorts.add 'min', (event, payload) =>
    if event is 'data'
      @min = payload
  @max = 300
  c.inPorts.add 'max',
    datatype: "number"
    description: "absolute maximum value"
  , (event, payload) =>
    if event is 'data'
      @max = payload
  # END base ports
  
  # init with an array of average values (to help reolve loops)
  #TODO: randomize this series instead of using avg?
  @values = (@average for [1..MAX_LEN])
  
  # array of values
  c.outPorts.add 'out'
  c.outPorts.out.send @values
  console.log('component init:',@values)
  
  # function to get value @ t from dependency time-series objects
  @step = (t, dep1, dep2)=>
    return dep1[t] + dep2[t]
    # TODO: handle out-of-bounds t by wrapping array calls
    #   in a function?
  
  @compute = ()=>
    for t of @values
      # compute value for given dependencies
      @values[t] = @step(t, @dep1, @dep2)
      # TODO: where to get these dep time-series from?
      # store them on object or are they already on c?
      	
    console.log('component update:', @values)
    c.outPorts.out.send @values
  
  # inflows (dependencies)
  c.inPorts.add 'dep1', (event, payload) =>
    if event is 'data'
      @dep1 = payload
      @compute()
  
  c.inPorts.add 'dep2', (event, payload) =>
    if event is 'data'
      @dep2 = payload
      @compute()
 
  return c
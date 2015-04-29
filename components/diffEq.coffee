noflo = require 'noflo'

# START INTEGRATOR
# Includes Euler and Runge-Kutta numerical integration written in asm.js.
# Adapted from https://github.com/uniphil/integrate

ASMIntegrators = (_, foreign)->
  'use asm'

  f = foreign.f

  euler = (y0, t0, h)->
    # Follow tangents on the curve over short distances.
    # You probably should use rk4 instead, which converges faster.
    # https://en.wikipedia.org/wiki/Numerical_methods_for_ordinary_differential_equations#Euler_method
    y0 = +y0      # double
    t0 = +t0      # double
    h = +h        # double
    yh = 0.0  # -> double

    yh = y0 + h*+f(t0, y0)

    return +yh


  rk4 = (y0, t0, h)->
# Compute the next value by taking a weighted average of four samples of f
# https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods#The_Runge.E2.80.93Kutta_method
    y0 = +y0      # double
    t0 = +t0      # double
    h = +h        # double
    k1 = 0.0  # double
    k2 = 0.0  # double
    k3 = 0.0  # double
    k4 = 0.0  # double
    yh = 0.0  # -> double

    k1 = +f(+(t0 )       , +(y0 ))
    k2 = +f(+(t0 + h/2.0), +(y0 + h/2.0*k1))
    k3 = +f(+(t0 + h/2.0), +(y0 + h/2.0*k2))
    k4 = +f(+(t0 + h)    , +(y0 + h *   k3))

    yh = y0 + h/6.0*(k1 + 2.0*k2 + 2.0*k3 + k4)

    return +yh

  rk4general = (y0, t0, h, lambda)->
    # Generalized RK4, where lambda can by 1, 3, 4, or 5.
    # lambda=2 is the classical rk4.
    # the last part of:
    # https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods#The_Runge.E2.80.93Kutta_method
    y0 = +y0      # double
    t0 = +t0      # double
    h = +h        # double
    lambda = lambda|0 # int -- should be in [1, 5], but this is not validated
    littleLambda  = 0.0
    k1 = 0.0  # double
    k2 = 0.0  # double
    k3 = 0.0  # double
    k4 = 0.0  # double
    yh = 0.0  # -> double

    littleLambda = +~lambda  # convert int to double

    k1 = +f(+(t0 )       , +(y0 ))
    k2 = +f(+(t0 + h/2.0), +(y0 + h/2.0*k1))
    k3 = +f(+(t0 + h/2.0),
            +(y0 + (0.5-1.0/littleLambda)*k1*h + 1.0/littleLambda*k2*h))
    k4 = +f(+(t0 + h)    ,
            +(y0 + (1.0-littleLambda/2.0)*k2*h + littleLambda/2.0*k3*h))

    yh = y0 + h/6.0*(k1 + (4.0-littleLambda)*k2 + littleLambda*k3 + k4)

    return +yh


  return {
    euler: euler,
    rk4: rk4,
    rk4general: rk4general
  }


Integrator = (f)->
  # nicer wrapper around the asm.js constructor
  return ASMIntegrators(null, {f: f})

# END INTEGRATOR

class MyComponent extends noflo.Component
  description: "Combines two inflows using a 1st-order differential equation."
  icon: "tint"

  constructor:  ->
    @STEP = .25  # sub-time step for integrator
    @INTEGRATOR = Integrator((t, y)=>
      val = 0
      parents = [@in_1, @in_2]
      thetas  = [@theta_1, @theta_2]
      consts  = [@c_1, @c_2]
      for parentN of parents
        theta = parseFloat(thetas[parentN])  # theta = time delay
        C = parseFloat(consts[parentN])          # C = regression weight

        # use 1st value as steady state before(TODO: improve this)
        if t-theta <= 0
          parent_v = parents[parentN][0]
        # use last value as steady state after (TODO: improve this)
        else if t-theta >= @in_1.length
          parent_v = parents[parentN][@in_1.length-1]
        else # t is within bounds
          parent_v = parents[parentN][t - theta]

        val += C * parent_v
        if isNaN(val)
          console.log('ERR INFO:: theta:',theta,'C:',C,'p:',parent_v )

      val = (val - y) / parseFloat(@tao)
      return val
    )

    @c_1 = 1
    @c_2 = 1
    @theta_1 = 0
    @theta_2 = 0
    @tao = 0.5

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
      theta_1:
        datatype: 'number'
        required: false
      theta_2:
        datatype: 'number'
        required: false
      tao:
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
    @inPorts.theta_1.on 'data', (data) =>
      @theta_1 = data
      @compute()
    @inPorts.theta_2.on 'data', (data) =>
      @theta_2 = data
      @compute()
    @inPorts.tao.on 'data', (data) =>
      @tao = data
      @compute()

  # function to get value @ t from dependency
  # time-series objects
  step: (t, prev_value)->
    return @INTEGRATOR.euler(prev_value, t, @STEP)

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

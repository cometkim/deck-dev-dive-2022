type state = {
  celsius: float,
  fahrenheit: float,
}

type action =
  | UpdateCelsius(float)
  | UpdateFahrenheit(float)

// F = C * (9/5) + 32
let ce2fa = ce => ce *. (9. /. 5.) +. 32.
// C = (F - 32) * (5/9)
let fa2ce = fa => (fa -. 32.) *. (5. /. 9.)

let reduce = (state, action) => {
  switch (state, action) {
  | (_, UpdateCelsius(celsius)) => {
      celsius,
      fahrenheit: celsius->ce2fa,
    }
  | (_, UpdateFahrenheit(fahrenheit)) => {
      fahrenheit,
      celsius: fahrenheit->fa2ce,
    }
  }
}

let initialState = {
  celsius: 5.,
  fahrenheit: ce2fa(5.),
}

module Program = {
  type t = {
    state: state,
    onUpdate: (state, state) => unit,
  }

  let make = onUpdate => {
    state: initialState,
    onUpdate,
  }

  let dispatch = (program, action) => {
    let prev = program.state
    let next = program.state->reduce(action)
    program.onUpdate(prev, next)
    next
  }

  let updateCelsius = (program, ce) => {
    let state = program->dispatch(UpdateCelsius(ce))
    {...program, state}
  }

  let updateFahrenheit = (program, fa) => {
    let state = program->dispatch(UpdateFahrenheit(fa))
    {...program, state}
  }
}

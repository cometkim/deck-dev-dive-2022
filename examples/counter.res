type state = {count: int}

let reduce = (state, unit) => {count: state.count + 1}

let initialState = {count: 0}

module Program = {
  type t = {
    state: state,
    onUpdate: (state, state) => unit,
  }

  let make = onUpdate => {
    state: initialState,
    onUpdate,
  }

  let dispatch = (program, ()) => {
    let prev = program.state
    let next = reduce(program.state, ())
    program.onUpdate(prev, next)
    next
  }

  let increase = program => {
    let state = program->dispatch()
    {...program, state}
  }
}

type field =
  | Empty
  | Valid(string)
  | Invalid(string)

type state =
  | OneWay(field)
  | Returning(field, field)

// TODO: 아 귀찮...

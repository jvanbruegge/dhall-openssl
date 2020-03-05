let prelude = ./prelude.dhall

let Tuple = { mapKey : Text, mapValue : Optional Text }

let concatFilter =
        λ(start : Text)
      → λ(xs : List Tuple)
      → List/fold
          Tuple
          xs
          Text
          (   λ(curr : Tuple)
            → λ(acc : Text)
            → let value = prelude.Optional.default Text "" curr.mapValue

              in        if prelude.Optional.null Text curr.mapValue

                  then  acc

                  else  ''
                        ${acc}
                        ${curr.mapKey} = ${value}''
          )
          start

in  { concatFilter = concatFilter, Tuple = Tuple }

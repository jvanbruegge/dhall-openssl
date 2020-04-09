let Policy =
      { country : Bool
      , state : Bool
      , locality : Bool
      , organization : Bool
      , organizationalUnit : Bool
      , commonName : Bool
      , emailAddress : Bool
      }

let serverPolicy =
      { country = False
      , state = False
      , locality = False
      , organization = False
      , organizationalUnit = False
      , commonName = True
      , emailAddress = False
      }

let caPolicy =
      { country = True
      , state = True
      , locality = True
      , organization = True
      , organizationalUnit = False
      , commonName = True
      , emailAddress = True
      }

in  { Type = Policy, default = serverPolicy, caPolicy = caPolicy }

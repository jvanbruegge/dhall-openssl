let DistinguishedName = ./DistinguishedName.dhall

let KeyUsage = ./KeyUsage.dhall

let Config =
      { defaultBits : Natural
      , encryptKey : Bool
      , defaultMd : Text
      , stringMask : Text
      , utf8 : Bool
      , prompt : Bool
      , usage : List KeyUsage
      , altIPs : List Text
      , altNames : List Text
      , distinguishedName : DistinguishedName.Type
      }

let configDefaults =
      { defaultBits = 4096
      , encryptKey = False
      , defaultMd = "sha256"
      , stringMask = "utf8only"
      , utf8 = True
      , prompt = False
      , altIPs = [] : List Text
      , altNames = [] : List Text
      , usage = [ KeyUsage.DigitalSignature, KeyUsage.KeyEncipherment ]
      , distinguishedName = DistinguishedName.default
      }

in  { default = configDefaults, Type = Config }

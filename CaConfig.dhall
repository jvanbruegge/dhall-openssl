let DistinguishedName = ./DistinguishedName.dhall

let KeyUsage = ./KeyUsage.dhall

let CaConfig =
      { defaultBits : Natural
      , encryptKey : Bool
      , defaultMd : Text
      , stringMask : Text
      , utf8 : Bool
      , prompt : Bool
      , usage : List KeyUsage
      , distinguishedName : DistinguishedName.Type
      }

let caConfigDefaults =
      { defaultBits = 4096
      , encryptKey = True
      , defaultMd = "sha256"
      , stringMask = "utf8only"
      , utf8 = True
      , prompt = False
      , usage = [KeyUsage.CrlSign, KeyUsage.DigitalSignature, KeyUsage.KeyCertSign]
      , distinguishedName = DistinguishedName.default
      }

in  { default = caConfigDefaults, Type = CaConfig }

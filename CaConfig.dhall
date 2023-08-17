let DistinguishedName = ./DistinguishedName.dhall

let KeyUsage = ./KeyUsage.dhall

let Policy = ./Policy.dhall

let Config =
      { allowedHosts : List Text
      , allowedIPs : List Text
      , caDir : Text
      , crl : Optional Text
      , crlDir : Optional Text
      , crlNumber : Optional Text
      , database : Text
      , defaultBits : Natural
      , defaultDays : Natural
      , defaultMd : Text
      , defaultPolicy : Optional Text
      , distinguishedName : DistinguishedName.Type
      , encryptKey : Bool
      , pathlen : Optional Natural
      , policies : List { name : Text, policy : Policy.Type }
      , prompt : Bool
      , serial : Text
      , stringMask : Text
      , uniqueSubject : Bool
      , usage : List KeyUsage
      , utf8 : Bool
      }

let configDefaults =
      { allowedHosts = [] : List Text
      , allowedIPs = [] : List Text
      , crl = None Text
      , crlDir = None Text
      , crlNumber = None Text
      , database = "\$base_dir/ca.index"
      , defaultBits = 4096
      , defaultDays = 365
      , defaultMd = "sha256"
      , defaultPolicy = Some "server_policy"
      , distinguishedName = DistinguishedName.default
      , encryptKey = True
      , pathlen = None Natural
      , policies =
        [ { name = "server_policy", policy = Policy.default }
        , { name = "ca_policy", policy = Policy.caPolicy }
        ]
      , prompt = False
      , serial = "\$base_dir/ca.serial"
      , stringMask = "utf8only"
      , uniqueSubject = False
      , usage = [ KeyUsage.CrlSign, KeyUsage.KeyCertSign ]
      , utf8 = True
      }

in  { default = configDefaults, Type = Config }

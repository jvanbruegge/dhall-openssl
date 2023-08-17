let DistinguishedName = ./DistinguishedName.dhall

let Config =
      { crlDir : Text
      , crl : Text
      , crlNumber : Text
      , defaultCrlDays : Natural
      , database : Text
      , defaultDays : Natural
      , defaultMd : Text
      , distinguishedName : DistinguishedName.Type
      }

let configDefaults =
      { crl = "\$base_dir/crl.pem"
      , crlNumber = "\$base_dir/number"
      , database = "\$base_dir/index.txt"
      , defaultCrlDays = 30
      , defaultDays = 365
      , defaultMd = "default"
      , distinguishedName = DistinguishedName.default
      }

in  { default = configDefaults, Type = Config }

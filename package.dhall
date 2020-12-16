let KeyUsage = ./KeyUsage.dhall

in  { DistinguishedName = ./DistinguishedName.dhall
    , Config = ./Config.dhall
    , CaConfig = ./CaConfig.dhall
    , KeyUsage
    , mkConfig = ./mkConfig.dhall
    , mkCaConfig = ./mkCaConfig.dhall
    , usage =
      { signing = [ KeyUsage.CrlSign, KeyUsage.KeyCertSign ]
      , server = [ KeyUsage.DigitalSignature, KeyUsage.KeyEncipherment ]
      , auth = [ KeyUsage.ServerAuth, KeyUsage.ClientAuth ]
      }
    }

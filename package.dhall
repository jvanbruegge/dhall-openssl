let KeyUsage = ./KeyUsage.dhall

in  { DistinguishedName = ./DistinguishedName.dhall
    , Config = ./Config.dhall
    , CaConfig = ./CaConfig.dhall
    , CrlConfig = ./CrlConfig.dhall
    , KeyUsage
    , mkConfig = ./mkConfig.dhall
    , mkCaConfig = ./mkCaConfig.dhall
    , mkCrlConfig = ./mkCrlConfig.dhall
    , usage =
      { signing = [ KeyUsage.CrlSign, KeyUsage.KeyCertSign ]
      , server = [ KeyUsage.DigitalSignature, KeyUsage.KeyEncipherment ]
      , auth = [ KeyUsage.ServerAuth, KeyUsage.ClientAuth ]
      }
    }

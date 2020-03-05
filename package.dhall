let KeyUsage = ./KeyUsage.dhall

in  { DistinguishedName = ./DistinguishedName.dhall
    , CaConfig = ./CaConfig.dhall
    , KeyUsage = KeyUsage
    , mkCaConfig = ./mkCaConfig.dhall
    , usage =
        { signing =
          [ KeyUsage.CrlSign, KeyUsage.DigitalSignature, KeyUsage.KeyCertSign ]
        , auth = [ KeyUsage.ServerAuth, KeyUsage.ClientAuth ]
        }
    }

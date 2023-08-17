let Config = ./CrlConfig.dhall

let prelude = ./prelude.dhall

let render = ./render.dhall

in  λ(config : Config.Type) →
      let distinguishedName = render.distinguishedName config.distinguishedName

      in  ''
          [ ca ]
          default_ca = CA_default

          [ crl_ext ]
          authorityKeyIdentifier=keyid:always,issuer:always

          ${distinguishedName}

          [ CA_default ]
          base_dir = ${config.crlDir}
          crl = ${config.crl}
          crlnumber = ${config.crlNumber}
          database = ${config.database}
          default_crl_days = ${Natural/show config.defaultCrlDays}
          default_md = ${config.defaultMd}
          default_days = ${Natural/show config.defaultDays}
          ''

let Config = ./CaConfig.dhall

let Policy = ./Policy.dhall

let prelude = ./prelude.dhall

let render = ./render.dhall

in  λ(config : Config.Type) →
      let distinguishedName = render.distinguishedName config.distinguishedName

      let mkConstraints =
            λ(type : Text) →
            λ(hosts : List Text) →
              prelude.Text.concatMapSep
                "\n"
                { index : Natural, value : Text }
                ( λ(data : { index : Natural, value : Text }) →
                    "permitted;${type}.${Natural/show
                                           data.index} = ${data.value}"
                )
                (prelude.List.indexed Text hosts)

      let policies =
            prelude.Text.concatMapSep
              "\n"
              { name : Text, policy : Policy.Type }
              render.policy
              config.policies

      let pathlen =
            prelude.Optional.fold
              Natural
              config.pathlen
              Text
              (λ(n : Natural) → ", pathlen:${Natural/show n}")
              ""

      let defaultPolicy =
            prelude.Optional.fold
              Text
              config.defaultPolicy
              Text
              (λ(policy : Text) → "policy = ${policy}")
              ""

      let crl =
            prelude.Optional.fold
              Text
              config.crl
              Text
              ( λ(p : Text) →
                  ''

                  crl = ${p}''
              )
              ""

      let crlDir =
            prelude.Optional.fold
              Text
              config.crlDir
              Text
              ( λ(p : Text) →
                  ''

                  crl_dir = ${p}''
              )
              ""

      let crlNumber =
            prelude.Optional.fold
              Text
              config.crlNumber
              Text
              ( λ(p : Text) →
                  ''

                  crl_dir = ${p}''
              )
              ""

      in  ''
          [ req ]
          default_bits = ${Natural/show config.defaultBits}
          encrypt_key = ${render.yesNo config.encryptKey}
          default_md = ${config.defaultMd}
          string_mask = ${config.stringMask}
          utf8 = ${render.yesNo config.utf8}
          prompt = ${render.yesNo config.prompt}
          x509_extensions = x509_ext
          distinguished_name = distinguished_name

          [ x509_ext ]
          basicConstraints = critical, CA:true${pathlen}
          ${if    prelude.List.null Text config.allowedHosts
            then  ""
            else  "nameConstraints = critical, @name_constraints"}
          subjectKeyIdentifier = hash
          issuerAltName = issuer:copy
          authorityKeyIdentifier = keyid:always, issuer:always
          ${render.keyUsage config.usage}

          ${distinguishedName}

          [ ca ]
          default_ca = CA_default

          [ CA_default ]
          base_dir = ${config.caDir}
          database = ${config.database}
          serial = ${config.serial}
          new_certs_dir = ${config.caDir}${crl}${crlDir}${crlNumber}
          default_md = ${config.defaultMd}
          default_days = ${Natural/show config.defaultDays}
          email_in_dn = no
          ${defaultPolicy}
          copy_extensions = copy
          uniqueSubject = ${render.yesNo config.uniqueSubject}

          ${policies}

          [ name_constraints ]
          ${mkConstraints "DNS" config.allowedHosts}
          ${mkConstraints "IP" config.allowedIPs}
          ''

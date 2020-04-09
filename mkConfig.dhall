let Config = ./Config.dhall

let prelude = ./prelude.dhall

let render = ./render.dhall

in    λ(config : Config.Type)
    → let distinguishedName = render.distinguishedName config.distinguishedName

      let altNames =
            prelude.Text.concatMapSep
              "\n"
              { index : Natural, value : Text }
              (   λ(data : { index : Natural, value : Text })
                → "DNS.${Natural/show data.index} = ${data.value}"
              )
              (prelude.List.indexed Text config.altNames)

      in  ''
          [ req ]
          default_bits = ${Natural/show config.defaultBits}
          encrypt_key = ${render.yesNo config.encryptKey}
          default_md = ${config.defaultMd}
          string_mask = ${config.stringMask}
          utf8 = ${render.yesNo config.utf8}
          prompt = ${render.yesNo config.prompt}
          req_extensions = req_ext
          distinguished_name = distinguished_name

          [ req_ext ]
          basicConstraints = CA:false
          subjectAltName = @alt_names
          ${render.keyUsage config.usage}

          ${distinguishedName}

          [ alt_names ]
          ${altNames}
          ''

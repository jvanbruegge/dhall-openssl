let CaConfig = ./CaConfig.dhall

let utils = ./utils.dhall
let renderKeyUsage = ./renderKeyUsage.dhall

let yesNo = λ(s : Bool) → if s then "yes" else "no"


in    λ(config : CaConfig.Type)
    → let distinguishedName =
            utils.concatFilter
              "[ distinguished_name ]"
              ( toMap
                  { countryName = config.distinguishedName.country
                  , stateOrProvinceName = config.distinguishedName.state
                  , localityName = config.distinguishedName.locality
                  , postalCode = config.distinguishedName.locality
                  , streetAddress = config.distinguishedName.streetAddress
                  , emailAddress = config.distinguishedName.emailAddress
                  , commonName = Some config.distinguishedName.commonName
                  , organizationName = config.distinguishedName.organization
                  , organizationalUnitName =
                      config.distinguishedName.organizationalUnit
                  }
              )

      in  ''
          [ req ]
          default_bits = ${Natural/show config.defaultBits}
          encrypt_key = ${yesNo config.encryptKey}
          default_md = ${config.defaultMd}
          string_mask = ${config.stringMask}
          utf8 = ${yesNo config.utf8}
          prompt = ${yesNo config.prompt}
          x509_extensions = req_ext
          distinguished_name = distinguished_name

          [ req_ext ]
          basicConstraints = critical, CA:true
          subjectKeyIdentifier = hash
          issuerAltName = issuer:copy
          ${renderKeyUsage config.usage}

          ${distinguishedName}
          ''

let DistringuishedName = ./DistinguishedName.dhall

let Policy = ./Policy.dhall

let utils = ./utils.dhall

let renderKeyUsage = ./renderKeyUsage.dhall

let renderDistinguishedName =
        λ(name : DistringuishedName.Type)
      → utils.concatFilter
          "[ distinguished_name ]"
          ( toMap
              { countryName = name.country
              , stateOrProvinceName = name.state
              , localityName = name.locality
              , postalCode = name.locality
              , streetAddress = name.streetAddress
              , emailAddress = name.emailAddress
              , commonName = Some name.commonName
              , organizationName = name.organization
              , organizationalUnitName = name.organizationalUnit
              }
          )

let renderBool =
      λ(true : Text) → λ(false : Text) → λ(s : Bool) → if s then true else false

let renderPolicy =
        λ(arg : { name : Text, policy : Policy.Type })
      → let renderOpt = renderBool "supplied" "optional"

        in  ''
            [ ${arg.name} ]
            countryName = ${renderOpt arg.policy.country}
            stateOrProvinceName = ${renderOpt arg.policy.state}
            localityName = ${renderOpt arg.policy.locality}
            organizationName = ${renderOpt arg.policy.organization}
            organizationalUnitName = ${renderOpt arg.policy.organizationalUnit}
            commonName = ${renderOpt arg.policy.commonName}
            emailAddress = ${renderOpt arg.policy.emailAddress}
            ''

in  { distinguishedName = renderDistinguishedName
    , yesNo = renderBool "yes" "no"
    , keyUsage = renderKeyUsage
    , policy = renderPolicy
    }

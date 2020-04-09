let prelude = ./prelude.dhall

let utils = ./utils.dhall

let KeyUsage = ./KeyUsage.dhall

let filterSome =
        λ(xs : List (Optional Text))
      → List/fold
          (Optional Text)
          xs
          (List Text)
          (   λ(curr : Optional Text)
            → λ(acc : List Text)
            → Optional/fold
                Text
                curr
                (List Text)
                (λ(x : Text) → acc # [ x ])
                acc
          )
          ([] : List Text)

let keyUsageToString =
      { DigitalSignature = Some "digitalSignature"
      , NonRepudiation = Some "nonRepudiation"
      , KeyEncipherment = Some "keyEncipherment"
      , DataEncipherment = Some "dataEncipherment"
      , KeyAgreement = Some "keyAgreement"
      , KeyCertSign = Some "keyCertSign"
      , CrlSign = Some "cRLSign"
      , EncipherOnly = Some "encipherOnly"
      , DecipherOnly = Some "decipherOnly"
      , OID = λ(oid : Text) → None Text
      , ServerAuth = None Text
      , ClientAuth = None Text
      , CodeSigning = None Text
      , EmailProtection = None Text
      , TimeStamping = None Text
      , OcspSigning = None Text
      , IpsecInternetKeyExchange = None Text
      }

let extendedKeyUsageToString =
      { OID = λ(oid : Text) → Some oid
      , ServerAuth = Some "serverAuth"
      , ClientAuth = Some "clientAuth"
      , CodeSigning = Some "codeSigning"
      , EmailProtection = Some "emailProtection"
      , TimeStamping = Some "timeStamping"
      , OcspSigning = Some "OCSPSigning"
      , IpsecInternetKeyExchange = Some "ipsecIKE"
      , DigitalSignature = None Text
      , NonRepudiation = None Text
      , KeyEncipherment = None Text
      , DataEncipherment = None Text
      , KeyAgreement = None Text
      , KeyCertSign = None Text
      , CrlSign = None Text
      , EncipherOnly = None Text
      , DecipherOnly = None Text
      }

in    λ(keyUsages : List KeyUsage)
    → let standardKeyUsages =
            filterSome
              ( prelude.List.map
                  KeyUsage
                  (Optional Text)
                  (λ(x : KeyUsage) → merge keyUsageToString x)
                  keyUsages
              )

      let extendedKeyUsages =
            filterSome
              ( prelude.List.map
                  KeyUsage
                  (Optional Text)
                  (λ(x : KeyUsage) → merge extendedKeyUsageToString x)
                  keyUsages
              )

      let keyUsage =
                  if prelude.List.null Text standardKeyUsages

            then  None Text

            else  Some (prelude.Text.concatSep ", " standardKeyUsages)

      let extendedKeyUsage =
                  if prelude.List.null Text extendedKeyUsages

            then  None Text

            else  Some (prelude.Text.concatSep ", " extendedKeyUsages)

      let lines =
            utils.concatFilter
              ""
              ( toMap
                  { keyUsage = keyUsage, extendedKeyUsage = extendedKeyUsage }
              )

      in  "${lines}"

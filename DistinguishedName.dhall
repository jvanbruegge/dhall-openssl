let DistinguishedName =
      { country : Optional Text
      , commonName : Text
      , emailAddress : Optional Text
      , locality : Optional Text
      , organization : Optional Text
      , organizationalUnit : Optional Text
      , postalCode : Optional Text
      , state : Optional Text
      , streetAddress : Optional Text
      }

let defaultName =
      { country = None Text
      , emailAddress = None Text
      , locality = None Text
      , organization = None Text
      , organizationalUnit = None Text
      , postalCode = None Text
      , state = None Text
      , streetAddress = None Text
      }

in  { default = defaultName, Type = DistinguishedName }

# dhall-openssl

OpenSSL configuration is a mess. I compiled the stuff I learned from reading through the man oages, so you don't have to.

## Usage

```dhall
let openssl = https://raw.githubusercontent.com/jvanbruegge/dhall-openssl/master/package.dhall
{-
You should probably run `dhall freeze` over the file to cache the remote import
-}

in  openssl.mkCaConfig
      openssl.CaConfig::{
      , distinguishedName = openssl.DistinguishedName::{
        , commonName = "My self-signed root CA"
        , country = Some "US"
        }
      , usage = openssl.usage.signing
      }
```

Running this with `dhall text < ca.dhall` will print the following configuration to stdout:
```
[ req ]
default_bits = 4096
encrypt_key = yes
default_md = sha256
string_mask = utf8only
utf8 = yes
prompt = no
x509_extensions = req_ext
distinguished_name = distinguished_name

[ req_ext ]
basicConstraints = critical, CA:true
subjectKeyIdentifier = hash
issuerAltName = issuer:copy
authorityKeyIdentifier = keyid:always, issuer:always
keyUsage = keyCertSign, digitalSignature, cRLSign

[ distinguished_name ]
countryName = US
commonName = My self-signed root CA
```

## Actually generating certificates with this

To generate a self-signed CA run these commands:
```bash
# Generate the private key
openssl genpkeg -algorithm RSA -aes-256-cbc -out ca.key -pkeyopt rsa_keygen_bits:4096
chmod 400 ca.key

# Generate and sign the certificate
export CA_CONF=$(mktemp)
dhall text < myCaConfig.dhall > "$CA_CONF"
openssl req -new -out ca.crt -config "$CA_CONF" -x509 -days 1825 -key ca.key
rm "$CA_CONF"
```

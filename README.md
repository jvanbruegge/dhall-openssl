# dhall-openssl

OpenSSL configuration is a mess. I compiled the stuff I learned from reading through the man oages, so you don't have to.

## Usage

In this example we will first create a self-signed CA and then a client certificate that is signed by this CA.

### Creating the CA

First, we create a dhall config file that contains the information about our CA:
```dhall
-- ca.conf.dhall
let openssl = https://raw.githubusercontent.com/jvanbruegge/dhall-openssl/master/package.dhall

in  openssl.mkCaConfig
      openssl.CaConfig::{
      , distinguishedName = openssl.DistinguishedName::{
        , commonName = "My own personal root Certificate Authority"
        }
      , allowedHosts = [ "myDomain.com", "myDomain.local" ]
      , caDir = "ca"
      }
```

Then we generate the CA with these commands

```
mkdir ca           # We will store the config and the certificates here
                   # Needs to be the same as the `caDir` in the config

touch ca/ca.index
openssl rand -hex 16 > ca/ca.serial

dhall text --file ca.conf.dhall > ca/ca.conf

openssl genpkey -algorithm RSA -aes-256-cbc -out ca/ca.key -pkeyopt rsa_keygen_bits:4096
chmod 400 ca/ca.key

openssl req -new -out ca/ca.crt -config ca/ca.conf -x509 -days 1825 -key ca/ca.key
```

### Creating a server certificate

Again, we need a dhall file that describes the certificate we want:
```dhall
-- server.conf.dhall

let openssl = https://raw.githubusercontent.com/jvanbruegge/dhall-openssl/master/package.dhall

in  openssl.mkConfig
      openssl.Config::{
      , distinguishedName = openssl.DistinguishedName::{
        , commonName = "mySubdomain.myDomain.com"
        }
      , altNames = [ "mySubdomain.mySubdomain.local" ]
      }
```

Then we use openssl again to create our certificates:
```
export TEMP_FILE=$(mktemp)
dhall text --file server.conf.dhall > "$TEMP_FILE"

# Create a new certificate
openssl req -new -nodes -newkey rsa:4096 -keyout server.key -out server.csr -config "$TEMP_FILE"

# Sign it with our CA
openssl ca -config ca/ca.conf -cert ca/ca.crt -keyfile ca/ca.key -out server.crt -infiles server.csr
```

Afterwards you can inspect your newly create certificate with `openssl x509 -text -noout -in server.crt`.

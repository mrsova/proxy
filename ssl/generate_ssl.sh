#!/usr/bin/env bash
if [ -z "$1" ]
then
  echo "Please supply a subdomain to create a certificate for";
  echo "e.g. mysite.localhost"
  exit;
fi

DOMAIN=$1
COMMON_NAME=${2:-$1}

mkdir certs
mkdir dhparam

openssl genrsa -out certs/rootCA.key 2048
openssl req -x509 -new -nodes -key certs/rootCA.key -sha256 -days 1024 -out certs/rootCA.pem

if [ -f $DOMAIN.key ]; then
  KEY_OPT="-key"
else
  KEY_OPT="-keyout"
fi

SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=$COMMON_NAME"
NUM_OF_DAYS=999

openssl req -new -newkey rsa:2048 -sha256 -nodes $KEY_OPT certs/device.key -subj "$SUBJECT" -out certs/device.csr

cat v3.ext | sed s/%%DOMAIN%%/$COMMON_NAME/g > /tmp/__v3.ext

openssl x509 -req -in certs/device.csr -CA certs/rootCA.pem -CAkey certs/rootCA.key -CAcreateserial -out certs/device.crt -days $NUM_OF_DAYS -sha256 -extfile /tmp/__v3.ext

mv certs/device.csr certs/$DOMAIN.csr
mv certs/rootCA.pem dhparam/$DOMAIN.pem
cp certs/device.crt certs/$DOMAIN.crt
cp certs/device.key certs/$DOMAIN.key

# remove temp file
rm -f certs/rootCA.key;
rm -f certs/rootCA.srl;
rm -f certs/$DOMAIN.csr;
rm -f certs/device.key;
rm -f certs/device.crt;

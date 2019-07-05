#!/usr/bin/env bash

#	Field 	Meaning 				Example
#
#	/C= 	Country 				RU
#	/ST= 	State 					Vologda
#	/L= 	Location 				Vologda
#	/O= 	Organization 			Global Security
#	/OU= 	Organizational Unit 	IT Department
#	/CN= 	Common Name 			example.com

LIFE=365
ST='Vologda'
C='RU'
O='Company'
CN='FQDN_Company'

openssl genrsa -out rootCA.key 4096
openssl req -x509 -new -key rootCA.key -days $LIFE -out rootCA.crt -subj "/C=$C/ST=$ST/O=$O/CN=$CN"
openssl genrsa -out client.key 4096
openssl req -new -sha256 -key client.key -subj "/C=$C/ST=$ST/O=$O/CN=$CN" -out client.csr
openssl x509 -req -in client.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out client.crt -days $LIFE
cat rootCA.key rootCA.crt > rootCA.pem
cat client.key client.crt > client.pem
openssl pkcs12 -export -inkey rootCA.key -in rootCA.crt -certfile rootCA.pem -out rootCA.pfx  -passout pass:
openssl pkcs12 -export -inkey client.key -in client.crt -certfile client.pem -out client.pfx  -passout pass:

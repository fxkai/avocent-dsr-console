#!/bin/bash

if [ -z $4 ]; then
	echo "Usage : $0 <IP> <user> <pass> <kvm-slot>"
	exit 1
fi

TMPFILE=`mktemp`
SECFILE=`mktemp`

echo "Creating temporay jnlp and security addon files"

LOGINID=`curl -s -k "https://$1/cgi-bin/kvm.cgi?&file=login" \
-XPOST \
-H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Content-Length: 213' \
-H 'Accept-Language: en-us' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.3 Safari/605.1.15' \
-H 'Accept-Encoding: br, gzip, deflate' \
-H 'Connection: keep-alive' \
--data "action=SAVE&saveParms=login&filename=login&spcDevice=%28NULL%29&spcSocket=%28NULL%29&spcInlet=%28NULL%29&userindex=%28NULL%29&id=%28NULL%29&index=%28NULL%29&loginUsername=$2&loginPassword=$3&htmlLanguage=0"  | grep META | sed "s/.*userid=//" | sed "s/\".*//" `

echo Login ID for $2@https://$1 : $LOGINID

curl -s -k https://$1/cgi-bin/kvm.cgi\?\&file\=jnlp\&userID\=$LOGINID\&index\=$4 >$TMPFILE

cat >$SECFILE <<EOF
jdk.certpath.disabledAlgorithms=MD2, RSA keySize < 1024
jdk.tls.disabledAlgorithms=SSLv3, RC4
EOF

echo Starting and waiting for JavaWS
javaws -verbose -J"-Djava.security.properties=$SECFILE" $TMPFILE

# Might be too little for slow systems
sleep 8

rm $TMPFILE
rm $SECFILE

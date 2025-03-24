#!/bin/bash
#
#
# Bash shell script that downloads the published (gov.me) MNE TrustList, verifies the signature, 
# and extracts CA certificates. Provides ca-bundle files in PEM and P7B formats, for all, root, and leaf CAs.
#
# Copyright (c) 2021 Djordje Zekovic <dj@zeko.me>
# Licensed under the Apache License, Version 2.0
# See the LICENSE file.
#
#
set -euo pipefail

# adjust on next known update (!!!)
TRUST_LIST_URL=https://wapi.gov.me/download/80f77a60-3a92-4a36-86b2-ca90d9a52df1?version=1.0
TRUSTED_SIGNER_URL=https://wapi.gov.me/download/133d6553-1d2b-4302-833d-3f359441ee2b?version=1.0

# filenames
TRUST_LIST=trustlist-mne.xml
TRUSTED_SIGNER=signer.pem
XML_SIGNER=trustlist_signer.pem
CA_BUNDLE_PEM=mne-all-ca-bundle.pem
CA_BUNDLE_P7B=mne-all-ca-bundle.p7b
ROOT_CA_BUNDLE_PEM=mne-root-ca-bundle.pem
ROOT_CA_BUNDLE_P7B=mne-root-ca-bundle.p7b
LEAF_CA_BUNDLE_PEM=mne-leaf-ca-bundle.pem
LEAF_CA_BUNDLE_P7B=mne-leaf-ca-bundle.p7b

# install tools
dnf -yq install perl-XML-XPath xmlsec1 xmlsec1-openssl &>/dev/null

# fetch trust list
wget --quiet -O ${TRUST_LIST} ${TRUST_LIST_URL}

# fetch trusted signer
wget --quiet -O ${TRUSTED_SIGNER} ${TRUSTED_SIGNER_URL}

# verify signature without verifying signer certificate
xmlsec1 --verify --insecure trustlist-mne.xml &>/dev/null

# extract signer certificate from trusted list
xpath -e '//ds:Signature/ds:KeyInfo/ds:X509Data/ds:X509Certificate' trustlist-mne.xml 2>/dev/null|sed -E 's|<ds:X509Certificate>|-----BEGIN CERTIFICATE-----\n|g'|sed -E 's|</ds:X509Certificate>|\n-----END CERTIFICATE-----\n|g'|fold -w 64 > ${XML_SIGNER}

# check if trusted signer certificate differs from xml signer certificate
# signer certificate is self-issued, but not self-signed...
fingerprint1=`openssl x509 -in ${XML_SIGNER} -noout -fingerprint`
fingerprint2=`openssl x509 -in ${TRUSTED_SIGNER} -noout -fingerprint`
if [[ ${fingerprint1} != ${fingerprint2} ]] 
then
	echo "Not signed by trusted signer"
	exit 1
fi

TSL_SEQUENCE_NUMBER=`xpath -e '//SchemeInformation/TSLSequenceNumber/text()' trustlist-mne.xml 2>/dev/null`
LIST_ISSUE_DATE_TIME=`xpath -e '//SchemeInformation/ListIssueDateTime/text()' trustlist-mne.xml 2>/dev/null`
NEXT_UPDATE_DATE_TIME=`xpath -e '//SchemeInformation/NextUpdate/dateTime/text()' trustlist-mne.xml 2>/dev/null`



# make all ca-bundle pem
xpath -e '//ServiceInformation[ServiceTypeIdentifier[contains(.,"CA")]]//X509Certificate' trustlist-mne.xml 2>/dev/null|sed -E 's|<X509Certificate>|-----BEGIN CERTIFICATE-----\n|g'|sed -E 's|</X509Certificate>|\n-----END CERTIFICATE-----\n|g'|fold -w 64 > ${CA_BUNDLE_PEM}

# make root ca-bundle pem
flag=0
rm -f ${ROOT_CA_BUNDLE_PEM}
rm -f ${LEAF_CA_BUNDLE_PEM}
while read line
do
        if [[ "$line" =~ ^[-]*BEGIN ]]
        then
                flag=1
		echo "-----BEGIN CERTIFICATE-----" > tmp.crt
                continue
        fi

        if [[ "$line" =~ ^[-]*END ]]
	then
		flag=0
		echo "-----END CERTIFICATE-----" >> tmp.crt
		`openssl verify -CAfile tmp.crt tmp.crt &>/dev/null` && cat tmp.crt >> ${ROOT_CA_BUNDLE_PEM} || cat tmp.crt >> ${LEAF_CA_BUNDLE_PEM}
		rm -f tmp.crt
	fi

        [ $flag -eq 1 ] && echo ${line} >> tmp.crt

done < ${CA_BUNDLE_PEM}

# make all ca-bundle p7b
openssl crl2pkcs7 -nocrl -certfile ${CA_BUNDLE_PEM} -out ${CA_BUNDLE_P7B} -outform DER

# make root ca-bundle p7b
openssl crl2pkcs7 -nocrl -certfile ${ROOT_CA_BUNDLE_PEM} -out ${ROOT_CA_BUNDLE_P7B} -outform DER

# make leaf ca-bundle p7b
openssl crl2pkcs7 -nocrl -certfile ${LEAF_CA_BUNDLE_PEM} -out ${LEAF_CA_BUNDLE_P7B} -outform DER


# cleanup
rm -f ${XML_SIGNER}

ARCHIVE_DATE=`date -d "${LIST_ISSUE_DATE_TIME}" +"%Y%m%d"`
SIGNER_MNE_ARCHIVE="signer-${ARCHIVE_DATE}-${TSL_SEQUENCE_NUMBER}.crt"
TRUSTLIST_MNE_ARCHIVE="trustlist-mne-${ARCHIVE_DATE}-${TSL_SEQUENCE_NUMBER}.xml"
mkdir -p archive &>/dev/null
mv -f ${TRUSTED_SIGNER} archive/${SIGNER_MNE_ARCHIVE}
mv -f ${TRUST_LIST} archive/${TRUSTLIST_MNE_ARCHIVE}



echo "### ALL"
# print all ca-bundle subjects
openssl pkcs7 -print_certs -text -noout -inform DER -in ${CA_BUNDLE_P7B}|grep "Subject: "|sed 's/^ *//g'|sed 's/Subject: //g'

echo
echo "###  ROOT"
# print root ca-bundle subjects
openssl pkcs7 -print_certs -text -noout -inform DER -in ${ROOT_CA_BUNDLE_P7B}|grep "Subject: "|sed 's/^ *//g'|sed 's/Subject: //g'

echo
echo "###  LEAF"
# print leaf ca-bundle subjects
openssl pkcs7 -print_certs -text -noout -inform DER -in ${LEAF_CA_BUNDLE_P7B}|grep "Subject: "|sed 's/^ *//g'|sed 's/Subject: //g'

echo
echo "###  FILES"
echo ${CA_BUNDLE_PEM}
echo ${CA_BUNDLE_P7B}
echo ${ROOT_CA_BUNDLE_PEM}
echo ${ROOT_CA_BUNDLE_P7B}
echo ${LEAF_CA_BUNDLE_PEM}
echo ${LEAF_CA_BUNDLE_P7B}

echo
echo "###  INFO"
echo "TSL sequence number: ${TSL_SEQUENCE_NUMBER}"
echo "List issue date time: ${LIST_ISSUE_DATE_TIME}"
echo "Next update date time: ${NEXT_UPDATE_DATE_TIME}"

echo



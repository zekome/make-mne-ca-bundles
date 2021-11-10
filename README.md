# make-mne-ca-bundles.sh
Bash shell script that downloads the published (gov.me) MNE TrustList, verifies the signature, and extracts CA certificates. Provides ca-bundle files in PEM and P7B formats, for all, root, and leaf CAs.

Tested on Fedora Release 33. Note that the script installs the required packages initially. The repository contains ca-bundles from the run example.

You should update TRUST_LIST_URL and TRUSTED_SIGNER_URL variables within the script with valid download URLs for TrustList XML file and the trusted signer certificate.
You should first search www.gov.me for the latest published records.

## Variable settings

TRUST_LIST_URL=https://wapi.gov.me/download/7a51aa32-c2e7-4124-a481-46a16570d882?version=1.0
TRUSTED_SIGNER_URL=https://wapi.gov.me/download/529b9382-b72e-46ec-8668-44ca1943ce6c?version=1.0

## Run script example

```shell
$ ./make-mne-ca-bundles.sh

### ALL
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID Root CA
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID CA1
C=me, O=PostaCG, CN=PostaCG CA
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Root CA
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Sub CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust Root CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust GP CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust RP CA
C=ME, O=GOV, OU=GOVME CA

###  ROOT
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID Root CA
C=me, O=PostaCG, CN=PostaCG CA
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Root CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust Root CA
C=ME, O=GOV, OU=GOVME CA

###  LEAF
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID CA1
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Sub CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust GP CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust RP CA

###  FILES
mne-all-ca-bundle.pem
mne-all-ca-bundle.p7b
mne-root-ca-bundle.pem
mne-root-ca-bundle.p7b
mne-leaf-ca-bundle.pem
mne-leaf-ca-bundle.p7b

###  INFO
TSL sequence number: 1
List issue date time: 2021-10-18T01:00:00Z
Next update date time: 2022-04-17T23:00:00Z
```


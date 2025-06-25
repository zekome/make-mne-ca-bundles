# make-mne-ca-bundles.sh
Bash shell script that downloads the published (gov.me) MNE TrustList, verifies the signature, and extracts CA certificates. Provides ca-bundle files in PEM and P7B formats, for all, root, and leaf CAs.

Tested on Fedora Release 33. Note that the script installs the required packages initially. The repository contains ca-bundles from the run example.

You should update TRUST_LIST_URL and TRUSTED_SIGNER_URL variables within the script with valid download URLs for TrustList XML file and the trusted signer certificate.
You should first search www.gov.me for the latest published records. Please note that the signer certificate is self-issued, but not self-signed. So, we trust the official published records.

## Variable settings

TRUST_LIST_URL=https://wapi.gov.me/download/080ef058-4923-4088-9666-30a0efe6bdb8?version=1.0

TRUSTED_SIGNER_URL=https://wapi.gov.me/download/191722c5-7d65-4548-b0bb-7ce110546685?version=1.0

## Run script example

```shell
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
C=ME, O=Ministarstvo javne uprave/organizationIdentifier=VATME-11070043, CN=GovME Root CA
C=ME, O=Ministarstvo javne uprave/organizationIdentifier=VATME-11070043, CN=GovME Sub CA
C=ME, O=Centralna Banka Crne Gore/organizationIdentifier=VATME-02011328, CN=Root CA Centralna Banka CG
C=ME, O=Centralna Banka Crne Gore/organizationIdentifier=VATME-02011328, CN=CA Centralna Banka CG

###  ROOT
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID Root CA
C=me, O=PostaCG, CN=PostaCG CA
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Root CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust Root CA
C=ME, O=GOV, OU=GOVME CA
C=ME, O=Ministarstvo javne uprave/organizationIdentifier=VATME-11070043, CN=GovME Root CA
C=ME, O=Centralna Banka Crne Gore/organizationIdentifier=VATME-02011328, CN=Root CA Centralna Banka CG

###  LEAF
C=ME/organizationIdentifier=VATME-02016010, O=Ministarstvo unutra\xC5\xA1njih poslova, CN=MNE eID CA1
C=ME, O=Coreit/organizationIdentifier=VATME-02775018, CN=Coreit Sub CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust GP CA
C=ME/organizationIdentifier=VATME-02289377, O=Crnogorski Telekom A.D. Podgorica, CN=CTrust RP CA
C=ME, O=Ministarstvo javne uprave/organizationIdentifier=VATME-11070043, CN=GovME Sub CA
C=ME, O=Centralna Banka Crne Gore/organizationIdentifier=VATME-02011328, CN=CA Centralna Banka CG

###  FILES
mne-all-ca-bundle.pem
mne-all-ca-bundle.p7b
mne-root-ca-bundle.pem
mne-root-ca-bundle.p7b
mne-leaf-ca-bundle.pem
mne-leaf-ca-bundle.p7b

###  INFO
TSL sequence number: 20
List issue date time: 2025-06-20T01:00:00Z
Next update date time: 2025-12-20T00:00:00Z
```


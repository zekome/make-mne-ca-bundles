# make-mne-ca-bundles.sh
Bash shell script that downloads the published (gov.me) MNE TrustList, verifies the signature, and extracts CA certificates. Provides ca-bundle files in PEM and P7B formats, for all, root, and leaf CAs.

Tested on Fedora Release 33. Note that the script installs the required packages initially.

You should update TRUST_LIST_URL and TRUSTED_SIGNER_URL variables within the script with valid download URLs for TrustList XML file and the trusted signer certificate.
You should first search www.gov.me for the latest published records.

For example:

TRUST_LIST_URL=https://wapi.gov.me/download/7a51aa32-c2e7-4124-a481-46a16570d882?version=1.0
TRUSTED_SIGNER_URL=https://wapi.gov.me/download/529b9382-b72e-46ec-8668-44ca1943ce6c?version=1.0


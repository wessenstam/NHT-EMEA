# Script file name
MY_SCRIPT_NAME=`basename "$0"` 	# Watch the ` symbol and not the ‘ symbol!
# Derive HPOC number from IP 3rd byte
MY_CVM_IP=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{ print $2}')
array=(${MY_CVM_IP//./ })
MY_HPOC_SITE=${array[1]}
MY_HPOC_NUMBER=${array[2]}
MY_NEW_PE_PASSWORD='techX2019!' 	# CHANGE THIS TO YOUR PASSWORD!!!!
MY_PE_PASSWORD='nutanix/4u' 	# CHANGE THIS TO YOUR PASSWORD!!!!
MY_SP_NAME='SP01'
MY_CONTAINER_NAME='Default'
MY_IMG_CONTAINER_NAME='Images'
MY_FND_SRC_URL='http://download.nutanix.com/foundation/foundation-4.3.4/Foundation_VM-4.3.4-disk-0.qcow2'
MY_XRAY_SRC_URL='http://download.nutanix.com/xray/3.4.0/xray.qcow2'

# Source Nutanix environments (for PATH and other things)
source /etc/profile.d/nutanix_env.sh
# Logging function
function my_log {
    echo $(date "+%Y-%m-%d %H:%M:%S") $1
}
# Check if we got a password from environment or from the settings above, otherwise exit before doing anything
if [[ -z ${MY_PE_PASSWORD} ]]; then
    my_log "No password provided, exiting"
    exit -1
fi

# Install jq from the internal HTTP repo server
wget -q http://10.42.194.11/workshop_staging/jq-linux64.dms # Download to local CVM
chmod u+x jq-linux64.dms 						# Set execution permissions
ln -s jq-linux64.dms jq 						# Create a symbolic link
mv jq* ${HOME}/bin/ 						# move to the bin dir so we can run it using just jq


# Create single node cluster
echo y | cluster --cluster_name=NHTLab --dns_servers=10.42.196.10 --ntp_servers=10.42.196.10 --svm_ips=${MY_CVM_IP} create

# Wait for Prism to start using API calls
result=$(curl -X POST https://127.0.0.1:9440/api/nutanix/v3/clusters/list -H 'Content-Type: application/json' --insecure -u admin:"${MY_NEW_PE_PASSWORD}"  -d '{"kind":"cluster","length":500,"offset":0}' --silent | jq '.entities[].metadata.kind' |  grep cluster | wc -l)

while [[ ${result} -lt 1 ]]
do
    # Cluster is not yet initiated
    sleep 30 # Wait 30 seconds
    result=$(curl -X POST https://127.0.0.1:9440/api/nutanix/v3/clusters/list -H 'Content-Type: application/json' --insecure -u admin:"${MY_NEW_PE_PASSWORD}"  -d '{"kind":"cluster","length":500,"offset":0}' --silent | jq '.entities[].metadata.kind' |  grep cluster | wc -l)
done

# Set Admin password
ncli user reset-password user-name='admin' password=${MY_NEW_PE_PASSWORD}

# Rename default storage pool to MY_SP_NAME
my_log "Rename default storage pool to ${MY_SP_NAME}"
default_sp=$(ncli storagepool ls | grep 'Name' | cut -d ':' -f 2 | sed s/' '//g)
ncli sp edit name="${default_sp}" new-name="${MY_SP_NAME}"
# Check if there is a container named MY_IMG_CONTAINER_NAME, if not create one
my_log "Check if there is a container named ${MY_IMG_CONTAINER_NAME}, if not create one"
(ncli container ls | grep -P '^(?!.*VStore Name).*Name' | cut -d ':' -f 2 | sed s/' '//g | grep "^${MY_IMG_CONTAINER_NAME}" 2>&1 > /dev/null) \
    && echo "Container ${MY_IMG_CONTAINER_NAME} already exists" \
    || ncli container create name="${MY_IMG_CONTAINER_NAME}" sp-name="${MY_SP_NAME}"

# Validate EULA on PE
my_log "Validate EULA on PE"
curl --insecure --silent -u admin:${MY_NEW_PE_PASSWORD} -k -H 'Content-Type: application/json' -X POST \
  https://127.0.0.1:9440/PrismGateway/services/rest/v1/eulas/accept \
  -d '{
    "username": "SE",
    "companyName": "NTNX",
    "jobTitle": "SE"
}'

# Disable Pulse in PE
my_log "Disable Pulse in PE"
curl --insecure --silent -u admin:${MY_NEW_PE_PASSWORD} -k -H 'Content-Type: application/json' -X PUT \
  https://127.0.0.1:9440/PrismGateway/services/rest/v1/pulse \
  -d '{
    "defaultNutanixEmail": null,
    "emailContactList": null,
    "enable": false,
    "enableDefaultNutanixEmail": false,
    "isPulsePromptNeeded": false,
    "nosVersion": null,
    "remindLater": null,
    "verbosityType": null
}'

# Importing images
MY_IMAGE="Foundation.qcow2"
retries=1
MY_FND_SRC_URL='http://download.nutanix.com/foundation/foundation-4.3.4/Foundation_VM-4.3.4-disk-0.qcow2'

until [[ $(acli image.create ${MY_IMAGE} container="${MY_IMG_CONTAINER_NAME}" image_type=kDiskImage source_url=${MY_FND_SRC_URL} wait=true) =~ "complete" ]]; do
  let retries++
  if [ $retries -gt 5 ]; then
    my_log "${MY_IMAGE} failed to upload after 5 attempts. This cluster may require manual remediation."
    acli vm.create STAGING-FAILED-${MY_IMAGE}
    break
  fi
  my_log "acli image.create ${MY_IMAGE} FAILED. Retrying upload (${retries} of 5)..."
  sleep 5
done

MY_IMAGE="X-Ray.qcow2"
retries=1
my_log "Importing ${MY_IMAGE} image"
until [[ $(acli image.create ${MY_IMAGE} container="${MY_IMG_CONTAINER_NAME}" image_type=kDiskImage source_url=${MY_XRAY_SRC_URL} wait=true) =~ "complete" ]]; do
  let retries++
  if [ $retries -gt 5 ]; then
    my_log "${MY_IMAGE} failed to upload after 5 attempts. This cluster may require manual remediation."
    acli vm.create STAGING-FAILED-${MY_IMAGE}
    break
  fi
  my_log "acli image.create ${MY_IMAGE} FAILED. Retrying upload (${retries} of 5)..."
  sleep 5
done

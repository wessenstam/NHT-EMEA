#echo "Y" | cluster stop
#echo "Y" | cluster destroy # DOES NOT WORK, REQUIRES LOCAL INPUT - need to change reservations to be 3 out of 4 nodes, and orchestrate

# Script file name
MY_SCRIPT_NAME=`basename "$0"`
# Derive HPOC number from IP 3rd byte
MY_CVM_IP=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{ print $2}')
array=(${MY_CVM_IP//./ })
MY_HPOC_SITE=${array[1]}
MY_HPOC_NUMBER=${array[2]}
MY_NEW_PE_PASSWORD='techX2018!'
MY_SP_NAME='SP01'
MY_CONTAINER_NAME='Default'
MY_IMG_CONTAINER_NAME='Images'
MY_FND_SRC_URL='http://download.nutanix.com/foundation/foundation-4.1.2/Foundation_VM-4.1.2-disk-0.qcow2'

# Source Nutanix environments (for PATH and other things)
source /etc/profile.d/nutanix_env.sh
# Logging function
function my_log {
    #echo `$MY_LOG_DATE`" $1"
    echo $(date "+%Y-%m-%d %H:%M:%S") $1
}
# Check if we got a password from environment or from the settings above, otherwise exit before doing anything
if [[ -z ${MY_PE_PASSWORD+x} ]]; then
    my_log "No password provided, exiting"
    exit -1
fi

# Create single node cluster
yes | cluster --cluster_name=NHTLab --dns_servers=10.21.253.10 --ntp_servers=10.21.253.10 --svm_ips=${MY_CVM_IP} create

# Wait for Prism to start
sleep 300

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

# Importing images
MY_IMAGE="Foundation"
retries=1
my_log "Importing ${MY_IMAGE} image"
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

# Validate EULA on PE
my_log "Validate EULA on PE"
curl -u admin:${MY_NEW_PE_PASSWORD} -k -H 'Content-Type: application/json' -X POST \
  https://127.0.0.1:9440/PrismGateway/services/rest/v1/eulas/accept \
  -d '{
    "username": "SE",
    "companyName": "NTNX",
    "jobTitle": "SE"
}'

# Disable Pulse in PE
my_log "Disable Pulse in PE"
curl -u admin:${MY_NEW_PE_PASSWORD} -k -H 'Content-Type: application/json' -X PUT \
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

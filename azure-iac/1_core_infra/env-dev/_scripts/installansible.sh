#!/bin/bash

# Function to log messages
log() {
  echo "$(date +"%Y-%m-%d %T") - $1"
}

# Function to handle errors
exit_on_error() {
  if [ $? -ne 0 ]; then
    log "Error: $1"
    exit 1
  fi
}

log "Starting Ansible and Azure CLI setup for Ubuntu 22.04..."

# Update package list and install dependencies
log "Updating package list and installing dependencies..."
sudo apt update -y && sudo apt install -y software-properties-common curl wget unzip apt-transport-https ca-certificates gnupg lsb-release jq python3-pip || exit_on_error "Failed to install dependencies."

# Add Ansible PPA and install Ansible
log "Adding Ansible PPA..."
sudo add-apt-repository --yes --update ppa:ansible/ansible || exit_on_error "Failed to add Ansible PPA."
log "Installing Ansible..."
sudo apt install -y ansible || exit_on_error "Failed to install Ansible."

# Verify Ansible installation
log "Verifying Ansible installation..."
ansible --version || exit_on_error "Ansible verification failed."

# Install Azure CLI
log "Installing Azure CLI..."
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash || exit_on_error "Azure CLI installation script failed."

# Configure Azure CLI repository
sudo mkdir -p /etc/apt/keyrings
curl -sLS https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor | sudo tee /etc/apt/keyrings/microsoft.gpg > /dev/null
sudo chmod go+r /etc/apt/keyrings/microsoft.gpg
sudo apt-get update && sudo apt-get install -y azure-cli || exit_on_error "Failed to install Azure CLI."

AZ_DIST=$(lsb_release -cs)
echo "Types: deb
URIs: https://packages.microsoft.com/repos/azure-cli/
Suites: ${AZ_DIST}
Components: main
Architectures: $(dpkg --print-architecture)
Signed-by: /etc/apt/keyrings/microsoft.gpg" | sudo tee /etc/apt/sources.list.d/azure-cli.sources

# Update package list and install Azure CLI
sudo apt-get update && sudo apt-get install azure-cli

# Install Azure Ansible collection
log "Installing Azure Ansible collection..."
ansible-galaxy collection install azure.azcollection || exit_on_error "Failed to install Azure Ansible collection."

pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt

ansible-galaxy collection install azure.azcollection --force

# Authenticate with Azure
log "Authenticating with Azure..."
az login --identity || exit_on_error "Azure authentication failed."

# Fetch password from Azure Key Vault
KEYVAULT_NAME="vcloudlab001"  # Replace with your Key Vault name
SECRET_NAME="vmpassword"      # Replace with your secret name
ANSIBLE_PASSWORD=$(az keyvault secret show --vault-name "$KEYVAULT_NAME" --name "$SECRET_NAME" --query value -o tsv)
exit_on_error "Failed to retrieve password from Azure Key Vault."

ANSIBLE_USER="azureadmin"      # Ansible username
INVENTORY_FILE="/tmp/playbook/inventory.yml" # Output inventory file

# Create inventory directory
mkdir -p /tmp/playbook || exit_on_error "Failed to create playbook directory."

# Fetch VM details
log "Fetching VM details from Azure..."
VM_DATA=$(az vm list-ip-addresses \
  --query "[?virtualMachine.name!='ansiblevm001'].{Name:virtualMachine.name, PrivateIP:virtualMachine.network.privateIpAddresses[0]}" \
  -o json)
exit_on_error "Failed to retrieve VM details."

# Define the output file
OUTPUT_FILE="/tmp/playbook/inventory.yml"

# Define the Ansible inventory header
HEADER="
all:
  children:
    windows:
      hosts:
"

# Extract the host data from the JSON in proper YAML format
HOSTS=$(echo "$VM_DATA" | jq -r '.[] | "        windows_\(.Name):\n          ansible_host: \(.PrivateIP)"')

# Define the Ansible inventory vars
VARS="
  vars:
    ansible_user: azureadmin
    ansible_connection: winrm
    ansible_winrm_transport: ntlm
    ansible_port: 5986
    ansible_winrm_server_cert_validation: ignore
"

# Write the Ansible inventory file
sudo bash -c "cat > $OUTPUT_FILE" << EOF
$HEADER
$HOSTS
$VARS
EOF

echo "Ansible inventory file written to $OUTPUT_FILE"

# Download and run the Ansible playbook
PLAYBOOK_PATH="/tmp/playbook"
log "Downloading Ansible playbook..."
wget https://vcloudlabdemo01test.blob.core.windows.net/scripts/playbook.zip -O ${PLAYBOOK_PATH}.zip || exit_on_error "Failed to download playbook."
log "Unzipping playbook archive..."
unzip -o ${PLAYBOOK_PATH}.zip -d ${PLAYBOOK_PATH} || exit_on_error "Failed to unzip playbook."

log "Running Ansible playbook..."
ansible-playbook -i ${PLAYBOOK_PATH}/inventory.yml ${PLAYBOOK_PATH}/win_playbook.yml -v > /tmp/output.log || exit_on_error "Failed to execute Ansible playbook."

log "Setup completed successfully."
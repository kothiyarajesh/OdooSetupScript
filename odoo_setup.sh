#!/bin/bash
################################################################################
# Script for installing and setting up Odoo on Ubuntu 23.04 
# (Can be used for other versions too)
# Author: Rajesh Kothiya
# Execute the script to set up Odoo:
# . odoo_setup.sh
################################################################################

# Set flags for installations
PYTHON_INSTALL="True"
POSTGRESQL_INSTALL="True"
ANACONDA_INSTALL="True"

# Define the workspace directory
WORKSPACE_DIR="$HOME/workspace"

echo -e "\n---------- Start ----------"

# Prompt user for Odoo version numbers to install (space-separated)
read -p "Enter one or more Odoo version numbers for setup (e.g., 15 16 17): " VNAMES

# Validate input to ensure only version numbers 15, 16, or 17 are allowed
if ! [[ $VNAMES =~ (^|[^0-9.])(15|16|17)([^0-9.]|$) ]]; then 
    echo "Invalid input for Odoo versions!"
    return 1
fi

# Update and upgrade system packages
sudo apt-get update
sudo apt-get upgrade -y

# Function to install Python 3 and related packages
install_python() {
    echo -e "\n--- Installing Python 3 and related packages ---"
    sudo apt-get install git python3 python3-pip build-essential wget \
    python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev \
    libsasl2-dev python3-setuptools node-less libpng12-0 libjpeg-dev gdebi -y
}

# Function to install PostgreSQL
install_postgresql() {
    echo -e "\n---- Installing PostgreSQL Server ----"
    sudo apt-get install postgresql postgresql-server-dev-all -y
}

# Function to install Anaconda
install_anaconda() {
    echo -e "\n---- Installing Anaconda ----"
    sudo apt install curl bzip2 -y
    curl --output anaconda.sh https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
    sha256sum anaconda.sh
    bash anaconda.sh -b  # Run the Anaconda installer without prompts
    source ~/.bashrc
    conda --version
}

# Function to set up Odoo for a specific version
setup_odoo() {
    local version=$1
    local workspace_dir=$2

    echo -e "\n==== Creating directory for Odoo $version ===="
    mkdir -p "$workspace_dir/odoo$version/enterprise" "$workspace_dir/odoo$version/odoo" "$workspace_dir/odoo$version/projects"
    
    cd "$workspace_dir/odoo$version/odoo"
    
    # Create and activate a new Anaconda environment for this Odoo version
    conda create -n env_odoo$version python=3.10 -y
    conda activate env_odoo$version

    # Clone the specific Odoo branch
    git clone https://www.github.com/odoo/odoo --depth 1 --branch $version.0 --single-branch .

    # Install required Python packages
    # The command is modified to continue on errors with problematic packages logged.
    echo -e "\n---- Installing Python dependencies ----"
    pip3 install -r requirements.txt || {
        echo "Warning: Some packages failed to install (At last manually run pip3 install -r requirements.txt inside the environment to install with correct packages) Continuing..."
    }

    # Install additional dependencies
    pip3 install libsass==0.22.0

    # Deactivate the environment
    conda deactivate
    conda deactivate
    cd "$workspace_dir"
}

# Install Python if flag is set
if [ $PYTHON_INSTALL = "True" ]; then
    install_python
fi

# Install PostgreSQL if flag is set
if [ $POSTGRESQL_INSTALL = "True" ]; then
    install_postgresql
fi

# Install Anaconda if flag is set
if [ $ANACONDA_INSTALL = "True" ]; then
    install_anaconda
fi

# Create workspace directory if it doesn't exist
mkdir -p $WORKSPACE_DIR
echo -e "\n==== Workspace created at $WORKSPACE_DIR ===="
cd $WORKSPACE_DIR

# Loop through each Odoo version provided and set up the environment
for ODOOV in $VNAMES; do
    setup_odoo $ODOOV $WORKSPACE_DIR
done

echo -e "\n---------- Setup Complete ----------"

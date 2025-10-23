#!/bin/bash

# Install tfsec for running security scans on Terraform code
# This script installs tfsec on Linux/macOS systems

echo "Installing tfsec..."

# Check if tfsec is already installed
if command -v tfsec &> /dev/null; then
    echo "✅ tfsec is already installed!"
    echo "Version: $(tfsec --version | grep -o 'v[0-9]*\.[0-9]*\.[0-9]*')"
    exit 0
fi

# Check if running on macOS or Linux
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if command -v brew &> /dev/null; then
        echo "Installing tfsec via Homebrew..."
        brew install tfsec
    else
        echo "Installing tfsec via direct download..."
        LATEST_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
        curl -L "https://github.com/aquasecurity/tfsec/releases/download/${LATEST_VERSION}/tfsec-darwin-amd64" -o tfsec
        chmod +x tfsec
        sudo mv tfsec /usr/local/bin/
    fi
else
    # Linux
    echo "Installing tfsec for Linux via direct download..."
    LATEST_VERSION=$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)
    echo "Downloading tfsec version: ${LATEST_VERSION}"
    
    # Download and install tfsec
    curl -L "https://github.com/aquasecurity/tfsec/releases/download/${LATEST_VERSION}/tfsec-linux-amd64" -o tfsec
    chmod +x tfsec
    sudo mv tfsec /usr/local/bin/
fi

# Verify installation
if command -v tfsec &> /dev/null; then
    echo "✅ tfsec installed successfully!"
    echo "Version: $(tfsec --version)"
    echo ""
    echo "You can now run 'tfsec .' to scan your Terraform files for security issues."
else
    echo "❌ Installation failed. Please install manually:"
    echo "Visit: https://github.com/aquasecurity/tfsec#installation"
fi
# Using JSON tfvars with Terraform

## Overview

Terraform supports both `.tfvars` and `.tfvars.json` formats for variable files. JSON format can be easier to generate programmatically and integrate with CI/CD pipelines.

## Files Created

1. **terraform.tfvars** - Your original HCL format variables
2. **terraform.tfvars.json** - JSON format of the same variables
3. **complete-vars.tfvars.json** - Extended JSON variables for the full configuration
4. **convert-tfvars.sh** - Script to convert between formats

## Usage Examples

### Using JSON tfvars files with Terraform commands:

```bash
# Use the JSON file explicitly
terraform plan -var-file="terraform.tfvars.json"
terraform apply -var-file="terraform.tfvars.json"

# Use the extended JSON file
terraform plan -var-file="complete-vars.tfvars.json"

# Terraform automatically loads these files:
# - terraform.tfvars
# - terraform.tfvars.json
# - *.auto.tfvars
# - *.auto.tfvars.json
```

### Convert between formats:

```bash
# Convert .tfvars to .json
./convert-tfvars.sh tfvars-to-json terraform.tfvars terraform.tfvars.json

# Convert .json to .tfvars
./convert-tfvars.sh json-to-tfvars terraform.tfvars.json terraform.tfvars
```

## JSON Format Benefits

- **Programmatic generation**: Easier to generate from scripts or CI/CD
- **Integration friendly**: JSON is universally supported
- **Validation**: Can be validated with JSON schema tools
- **Consistent formatting**: No ambiguity in syntax

## Example JSON Structure

```json
{
  "project_id": "app-xyz-dev",
  "region": "us-central1",
  "environment": "dev",
  "function_settings": {
    "memory": "128M",
    "timeout": 60
  },
  "enabled_apis": ["cloudfunctions.googleapis.com", "cloudbuild.googleapis.com"]
}
```

## Terraform Variable Precedence (highest to lowest)

1. Command line flags (`-var` and `-var-file`)
2. `*.auto.tfvars.json` files (alphabetical order)
3. `*.auto.tfvars` files (alphabetical order)
4. `terraform.tfvars.json`
5. `terraform.tfvars`
6. Environment variables (`TF_VAR_name`)
7. Variable defaults in configuration

#!/bin/bash

# Generate GitHub Secrets JSON for Terraform Variables
# Usage: ./generate-github-secret.sh [environment]

ENVIRONMENT=${1:-dev}
PROJECT_BASE="app-xyz"

echo "Generating GitHub secret JSON for environment: $ENVIRONMENT"
echo "=================================================="

# Generate JSON based on environment
cat > "github-secret-${ENVIRONMENT}.json" << EOF
{
  "project_id": "${PROJECT_BASE}-${ENVIRONMENT}",
  "region": "us-central1",
  "environment": "${ENVIRONMENT}",
  "function_name_http": "hello-http-${ENVIRONMENT}",
  "function_name_pubsub": "hello-pubsub-${ENVIRONMENT}",
  "pubsub_topic_name": "hello-topic-${ENVIRONMENT}",
  "function_memory": "128M",
  "max_instances": $([ "$ENVIRONMENT" = "prod" ] && echo 3 || echo 1),
  "python_runtime": "python311"
}
EOF

echo "✅ Generated: github-secret-${ENVIRONMENT}.json"
echo ""
echo "📋 To use this in GitHub:"
echo "1. Go to your repo Settings → Secrets and variables → Actions"
echo "2. Click 'New repository secret'"
echo "3. Name: TERRAFORM_VARS_JSON (or TERRAFORM_VARS_${ENVIRONMENT^^}_JSON for env-specific)"
echo "4. Value: Copy the content below:"
echo ""
echo "================== COPY THIS TO GITHUB SECRET =================="
cat "github-secret-${ENVIRONMENT}.json"
echo ""
echo "================================================================="
echo ""
echo "🧪 To test locally:"
echo "cp github-secret-${ENVIRONMENT}.json terraform.tfvars.json"
echo "terraform validate"
echo "terraform plan -var-file=\"terraform.tfvars.json\""
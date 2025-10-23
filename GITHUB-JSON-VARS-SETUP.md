# GitHub Actions JSON Variables Setup Guide

## Method 1: Single JSON Secret (Recommended)

### Step 1: Create the JSON content for GitHub Secret

Based on your `complete-vars.tfvars.json`, create a GitHub secret named `TERRAFORM_VARS_JSON` with this content:

```json
{
  "project_id": "your-actual-project-id",
  "region": "us-central1",
  "environment": "dev",
  "function_name_http": "hello-http",
  "function_name_pubsub": "hello-pubsub",
  "pubsub_topic_name": "hello-topic",
  "function_memory": "128M",
  "max_instances": 1,
  "python_runtime": "python311"
}
```

### Step 2: Add the secret to GitHub

1. Go to your repository on GitHub
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `TERRAFORM_VARS_JSON`
5. Value: The JSON content above (with your actual values)
6. Click **Add secret**

### Step 3: The workflow will automatically:

- Create `terraform.tfvars.json` from the secret
- Use it with `terraform plan -var-file="terraform.tfvars.json"`

---

## Method 2: Environment-Specific JSON Secrets

For different environments (dev, staging, prod), create multiple secrets:

### Secrets to create:

- `TERRAFORM_VARS_DEV_JSON`
- `TERRAFORM_VARS_STAGING_JSON`
- `TERRAFORM_VARS_PROD_JSON`

### Example workflow modification:

```yaml
- name: Set environment
  id: set-env
  run: |
    if [[ "${{ github.ref }}" == "refs/heads/main" ]]; then
      echo "environment=prod" >> $GITHUB_OUTPUT
    elif [[ "${{ github.ref }}" == "refs/heads/staging" ]]; then
      echo "environment=staging" >> $GITHUB_OUTPUT
    else
      echo "environment=dev" >> $GITHUB_OUTPUT
    fi

- name: Create terraform.tfvars.json from environment-specific secret
  run: |
    if [[ "${{ steps.set-env.outputs.environment }}" == "prod" ]]; then
      echo '${{ secrets.TERRAFORM_VARS_PROD_JSON }}' > terraform.tfvars.json
    elif [[ "${{ steps.set-env.outputs.environment }}" == "staging" ]]; then
      echo '${{ secrets.TERRAFORM_VARS_STAGING_JSON }}' > terraform.tfvars.json
    else
      echo '${{ secrets.TERRAFORM_VARS_DEV_JSON }}' > terraform.tfvars.json
    fi
```

---

## Method 3: Individual Variables as Secrets

If you prefer individual secrets for each variable:

### GitHub Secrets to create:

- `TF_PROJECT_ID` → "your-actual-project-id"
- `TF_REGION` → "us-central1"
- `TF_ENVIRONMENT` → "dev"
- `TF_FUNCTION_NAME_HTTP` → "hello-http"
- `TF_FUNCTION_NAME_PUBSUB` → "hello-pubsub"
- `TF_PUBSUB_TOPIC_NAME` → "hello-topic"
- `TF_FUNCTION_MEMORY` → "128M"
- `TF_MAX_INSTANCES` → "1"
- `TF_PYTHON_RUNTIME` → "python311"

### Workflow step:

```yaml
- name: Create terraform.tfvars.json from individual secrets
  run: |
    cat > terraform.tfvars.json << EOF
    {
      "project_id": "${{ secrets.TF_PROJECT_ID }}",
      "region": "${{ secrets.TF_REGION }}",
      "environment": "${{ secrets.TF_ENVIRONMENT }}",
      "function_name_http": "${{ secrets.TF_FUNCTION_NAME_HTTP }}",
      "function_name_pubsub": "${{ secrets.TF_FUNCTION_NAME_PUBSUB }}",
      "pubsub_topic_name": "${{ secrets.TF_PUBSUB_TOPIC_NAME }}",
      "function_memory": "${{ secrets.TF_FUNCTION_MEMORY }}",
      "max_instances": ${{ secrets.TF_MAX_INSTANCES }},
      "python_runtime": "${{ secrets.TF_PYTHON_RUNTIME }}"
    }
    EOF
```

---

## Method 4: Using GitHub Environments

For production-grade setups, use GitHub Environments:

1. Go to **Settings** → **Environments**
2. Create environments: `development`, `staging`, `production`
3. Add environment-specific secrets to each
4. Modify workflow to use environments:

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ github.ref == 'refs/heads/main' && 'production' || 'development' }}
    steps:
      - name: Create terraform.tfvars.json
        run: |
          echo '${{ secrets.TERRAFORM_VARS_JSON }}' > terraform.tfvars.json
```

---

## Security Best Practices

### ✅ Do:

- Use GitHub Secrets for sensitive data
- Keep JSON structure consistent across environments
- Use environment-specific secrets for different deployments
- Validate JSON format before committing

### ❌ Don't:

- Commit actual values to the repository
- Use plain text for sensitive information
- Mix development and production values

---

## Testing Locally

To test your JSON format locally before adding to GitHub:

```bash
# Validate JSON syntax
cat terraform.tfvars.json | jq .

# Test with Terraform
terraform validate
terraform plan -var-file="terraform.tfvars.json"
```

# Quick Setup: GitHub JSON Variables

## 🚀 **Quick Start (5 minutes)**

### 1. Copy the JSON content

```json
{
  "project_id": "app-xyz-dev",
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

### 2. Add to GitHub Secrets

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **"New repository secret"**
3. Name: `TERRAFORM_VARS_JSON`
4. Value: Paste the JSON above (update `project_id` with your actual project ID)
5. Click **"Add secret"**

### 3. Done!

Your GitHub Actions workflow will now:

- ✅ Create `terraform.tfvars.json` from the secret
- ✅ Run `terraform plan -var-file="terraform.tfvars.json"`
- ✅ Deploy with the JSON variables

---

## 🔧 **Generate for Different Environments**

```bash
# Generate dev environment JSON
./generate-github-secret.sh dev

# Generate prod environment JSON
./generate-github-secret.sh prod

# Generate staging environment JSON
./generate-github-secret.sh staging
```

---

## 📋 **Required GitHub Secrets**

| Secret Name           | Required | Description                       |
| --------------------- | -------- | --------------------------------- |
| `TERRAFORM_VARS_JSON` | ✅ Yes   | JSON with all Terraform variables |
| `GCP_SA_KEY`          | ✅ Yes   | GCP Service Account JSON key      |
| `GCP_PROJECT_ID`      | ❌ No\*  | _Now in JSON_                     |
| `GCP_REGION`          | ❌ No\*  | _Now in JSON_                     |

---

## 🧪 **Test Locally First**

```bash
# Test the JSON format
terraform validate
terraform plan -var-file="terraform.tfvars.json"
```

For complete setup details, see `GITHUB-JSON-VARS-SETUP.md`

### You can test it with:

curl https://<FUNCTION_URL> -H "Content-Type: application/json" -d '{"name":"Eduardo"}'

### Trigger pub/sub manually

gcloud pubsub topics publish $(terraform output -raw pubsub_topic_name) --message="Hello from Pub/Sub!"

### Create a service account

gcloud iam service-accounts create terraform-ci \
 --display-name "Terraform GitHub CI"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
 --member="serviceAccount:terraform-ci@<PROJECT_ID>.iam.gserviceaccount.com" \
 --role="roles/editor"

gcloud projects add-iam-policy-binding <PROJECT_ID> \
 --member="serviceAccount:terraform-ci@<PROJECT_ID>.iam.gserviceaccount.com" \
 --role="roles/storage.admin"

gcloud iam service-accounts keys create key.json \
 --iam-account terraform-ci@<PROJECT_ID>.iam.gserviceaccount.com

### Add GitHub Secrets

Settings → Secrets → Actions → New repository secret
GCP_PROJECT_ID → your GCP project ID
GCP_REGION → e.g. us-central1
GCP_SA_KEY → paste full content of key.json

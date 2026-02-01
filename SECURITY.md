# Security Scanning Setup

This project is configured to run `tfsec` security scans automatically before commits and in CI/CD pipelines.

## Quick Setup

1. **Install tfsec** (if not already installed):

   ```bash
   ./install-tfsec.sh
   ```

2. **Test the security scan**:
   ```bash
   tfsec .
   ```

## Automated Security Scanning

### Git Hooks (Local Development)

A pre-commit hook is configured to run tfsec automatically before each commit. This ensures security issues are caught early in the development process.

**What happens:**

- Before each `git commit`, tfsec runs automatically
- If security issues are found, the commit is blocked
- Fix the issues and try committing again

**To bypass the hook** (not recommended):

```bash
git commit --no-verify -m "your message"
```

### Pre-commit Framework (Optional)

For advanced users, we also provide a `.pre-commit-config.yaml` configuration that includes:

- tfsec security scanning
- Terraform formatting and validation
- General code quality checks

**Setup:**

```bash
# Install pre-commit
pip install pre-commit

# Install the hooks
pre-commit install

# Run on all files (optional)
pre-commit run --all-files
```

### GitHub Actions (CI/CD)

The GitHub Actions workflow automatically runs tfsec on every push to ensure security compliance in the CI/CD pipeline.

## Security Scan Configuration

### tfsec Options

You can customize tfsec behavior by modifying the hooks or running it manually:

```bash
# Basic scan
tfsec .

# Scan with specific format
tfsec . --format json

# Exclude specific checks
tfsec . --exclude AWS001,AWS002

# Scan with custom config
tfsec . --config-file tfsec.yml
```

### Common Security Issues

tfsec checks for common Terraform security issues including:

- Unencrypted storage
- Open security groups
- Missing logging
- Weak IAM policies
- Insecure configurations

## Troubleshooting

### Fixing Security Issues

1. **Review the tfsec output** to understand the security issue
2. **Check the tfsec documentation** for specific rule details
3. **Update your Terraform code** to follow security best practices
4. **Re-run tfsec** to verify the fix

### Common Commands

```bash
# Run security scan
tfsec .

# Check specific directory
tfsec ./modules/vpc

# Get help
tfsec --help

# Check version
tfsec --version
```

## Current Security Posture

The following security measures are in place:

### Terraform (main.tf)

- **Storage bucket:** `uniform_bucket_level_access = true`, `force_destroy = false`, `public_access_prevention = "enforced"` to prevent public exposure and accidental deletion.
- **Cloud Function:** `ingress_settings = "ALLOW_INTERNAL_AND_GCLB"` so the function is not directly reachable from the public internet (only internal traffic and Load Balancer).
- **Bucket encryption:** Google-managed encryption is used by default; customer-managed keys are optional (see `customer-managed-encryption-example.tf` and `tfsec.yml` exclusions for dev).

### Application Code (function/)

- **main.py (HTTP):** User input `name` is sanitized (length limit, printable chars only, no newlines) to reduce XSS and header injection risk.
- **main_trigger_pub.py (Pub/Sub):** Message payload is decoded safely with size limit and error handling; only message length is logged to avoid leaking sensitive content.

### Optional: Customer-Managed Encryption

For production, you may enable customer-managed keys (CMEK) for the bucket. See `customer-managed-encryption-example.tf` and [tfsec documentation](https://github.com/aquasecurity/tfsec). The check is excluded in `tfsec.yml` for development.

For more information, visit the [tfsec documentation](https://github.com/aquasecurity/tfsec).

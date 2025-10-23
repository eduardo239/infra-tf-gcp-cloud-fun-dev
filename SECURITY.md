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

## Current Security Issues in Your Project

Your project currently has 2 security issues detected by tfsec:

### Issue #1 (MEDIUM): Bucket has uniform bucket level access disabled

**Location:** `main.tf:27-30`  
**Fix:** Add `uniform_bucket_level_access = true` to your storage bucket resource.

### Issue #2 (LOW): Storage bucket encryption does not use customer-managed key

**Location:** `main.tf:27-30`  
**Fix:** This is optional but recommended for production. Requires setting up Cloud KMS.

### Quick Fix for Issue #1

To fix the uniform bucket level access issue, update your `google_storage_bucket` resource in `main.tf`:

```terraform
resource "google_storage_bucket" "function_bucket" {
  name     = "${var.project_id}-functions"
  location = var.region

  # Add this line to fix the security issue
  uniform_bucket_level_access = true
}
```

After making this change, run `tfsec .` again to verify the fix, then commit your changes.

For more information, visit the [tfsec documentation](https://github.com/aquasecurity/tfsec).

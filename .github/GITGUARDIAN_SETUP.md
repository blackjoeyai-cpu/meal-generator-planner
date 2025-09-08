# GitGuardian Setup Guide

## Overview
GitGuardian has been integrated into the CI/CD workflow to provide comprehensive security scanning for secrets, API keys, and sensitive information in the Meal Generator Planner repository.

## Setup Instructions

### 1. Get GitGuardian API Key
1. Visit [GitGuardian Dashboard](https://dashboard.gitguardian.com/)
2. Sign up or log in to your account
3. Navigate to **API** → **Personal Access Tokens**
4. Create a new token with the following permissions:
   - `scan` - Required for secret scanning
   - `incidents:read` - Optional for incident reporting
5. Copy the generated API key

### 2. Configure GitHub Secret
1. Go to your repository on GitHub
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Set:
   - **Name**: `GITGUARDIAN_API_KEY`
   - **Value**: Your GitGuardian API key from step 1
5. Click **Add secret**

### 3. Configuration Files

#### `.gitguardian.yml`
The repository includes a GitGuardian configuration file that:
- Excludes build artifacts and generated files from scanning
- Configures comprehensive security policies
- Sets up proper exit codes for CI/CD integration
- Enables verbose output for debugging

#### Workflow Integration
GitGuardian is integrated in two places:
1. **Validation Job**: Quick secret scan during code validation
2. **Security Job**: Comprehensive security scanning with full history

## Features Enabled

### Secret Detection
- API keys and tokens
- Database credentials
- Private keys and certificates
- Cloud provider credentials
- Generic secrets and passwords

### Security Policies
- **secrets_detection**: Comprehensive secret scanning
- **sensitive_files**: Detection of sensitive file types
- **infrastructure_as_code**: IaC security scanning

### Scanning Scope
- **Pull Requests**: Scans changed files and commits
- **Push Events**: Scans new commits since last push
- **Full History**: Comprehensive scan of entire repository history

## Usage

### Automatic Scanning
GitGuardian runs automatically on:
- Every pull request
- Every push to main branches (`main`, `release`, `dev`)
- Manual workflow dispatch

### Viewing Results
1. **GitHub Actions**: View scan results in the workflow logs
2. **GitGuardian Dashboard**: Detailed incident reports and remediation guidance
3. **Pull Request Comments**: Automatic comments on PRs with findings (if configured)

### Handling Findings

#### If Secrets Are Found
1. **Stop**: Do not merge the PR or deploy the code
2. **Remove**: Delete the secret from the codebase
3. **Rotate**: Invalidate and regenerate the exposed secret
4. **Clean History**: Remove secret from Git history if needed
5. **Re-scan**: Push changes and verify clean scan

#### False Positives
If GitGuardian detects a false positive:
1. Add it to the `matches-ignore` section in `.gitguardian.yml`
2. Include a descriptive comment explaining why it's safe
3. Commit and push the configuration update

## Best Practices

### Prevention
- Never commit real secrets, even temporarily
- Use environment variables for configuration
- Use GitHub Secrets for CI/CD credentials
- Implement pre-commit hooks for local scanning

### Response
- Set up GitGuardian alerts for immediate notification
- Regularly review the GitGuardian dashboard
- Keep the `.gitguardian.yml` configuration updated
- Train team members on secret management

## Troubleshooting

### Common Issues

#### API Key Issues
- Verify the API key is correctly set in GitHub Secrets
- Ensure the key has proper permissions (`scan`)
- Check for expired or revoked tokens

#### Configuration Issues
- Validate `.gitguardian.yml` syntax
- Ensure path exclusions are correctly formatted
- Check policy configurations

#### Scan Failures
- Review workflow logs for detailed error messages
- Check GitGuardian service status
- Verify repository access permissions

### Support
- GitGuardian Documentation: https://docs.gitguardian.com/
- GitHub Actions Integration: https://docs.gitguardian.com/integrations/ci-cd/github-actions
- Support Contact: support@gitguardian.com

## Advanced Configuration

### Custom Policies
To add custom detection rules, update `.gitguardian.yml`:
```yaml
policies:
  - policy_name: "custom_rule"
    enabled: true
    ignore_known_secrets: false
```

### Severity Levels
Configure different actions based on finding severity:
```yaml
severity:
  high: fail
  medium: warn
  low: ignore
```

### Integration with Security Team
- Configure SIEM integration for enterprise security
- Set up automated ticket creation for incident response
- Implement security metrics and reporting

## Monitoring and Metrics

### Key Metrics
- Number of secrets detected per month
- Time to remediation for security incidents
- False positive rate and accuracy
- Coverage percentage of scanned code

### Dashboards
- GitGuardian Dashboard for security overview
- GitHub Actions for CI/CD integration status
- Custom metrics in monitoring tools

This comprehensive security scanning helps maintain the highest security standards for the Meal Generator Planner project! 🔒
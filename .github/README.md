# GitHub Workflows for Meal Generator Planner

This directory contains GitHub Actions workflows for the Meal Generator Planner Flutter application.

## CI/CD Workflow (`ci-cd.yml`)

This workflow provides comprehensive Continuous Integration and Continuous Deployment for the Flutter application.

### Trigger Events
- **Push** to branches: `main`, `release`, `dev`
- **Pull Request** to any branch

### Jobs Overview

#### 1. 🧪 Validate & Test
- Runs on every push and PR
- Validates conventional commit format (PRs only)
- Sets up Flutter environment
- Installs dependencies with caching
- Generates code (Hive & JSON serialization)
- Performs code analysis
- Checks code formatting
- Runs comprehensive test suite with coverage
- GitGuardian security scan for secrets detection
- Project structure compliance validation

#### 2. 🔒 Security Scan
- Dedicated security scanning job
- Comprehensive GitGuardian policy enforcement
- Full repository history scanning
- Secrets and sensitive data detection
- Security policy compliance verification

#### 3. 📱 Build Android
- Runs only on push events (not PRs)
- Builds Android APK
- Creates debug builds for non-release branches
- Creates release builds for `release` branch
- Uploads APK artifacts with configurable retention

#### 4. 🌐 Build Web
- Runs on push to main branches and PRs
- Builds Flutter web application
- Uploads web build artifacts for deployment

#### 5. 🚀 Deploy to Vercel
- Deploys web build to Vercel
- Production deployment for `main` and `release` branches
- Preview deployment for `dev` branch and PRs
- Requires Vercel secrets configuration

#### 6. 📋 Workflow Summary
- Provides consolidated status report
- Runs after all jobs complete
- Shows comprehensive workflow results

### Required Secrets

Configure these secrets in your GitHub repository settings:

- `VERCEL_TOKEN`: Your Vercel authentication token
- `VERCEL_ORG_ID`: Your Vercel organization ID
- `VERCEL_PROJECT_ID`: Your Vercel project ID
- `GITGUARDIAN_API_KEY`: GitGuardian API key for security scanning

### Repository Variables

Configure these variables in your repository settings:

- `FLUTTER_VERSION`: Flutter version to use (defaults to 3.24.0)
- `ARTIFACT_RETENTION_DAYS`: Days to retain build artifacts (defaults to 7)

### Concurrency Control

The workflow includes concurrency control to prevent multiple runs on the same branch, automatically canceling older runs when new ones are triggered.

### Branch Strategy

The workflow supports the following branch strategy:
- `main`: Production-ready code, deploys to Vercel production
- `release`: Release preparation, deploys to Vercel production  
- `dev`: Development branch, deploys to Vercel preview
- Feature branches: Run validation only on PRs

### Caching Strategy

The workflow implements efficient caching for:
- Flutter SDK installation
- Pub dependencies cache
- Reduces build times on subsequent runs

## Setup Instructions

1. **Add Required Secrets**: Configure Vercel secrets in repository settings
2. **Set Variables**: Configure Flutter version and retention settings
3. **Configure Vercel Project**: Ensure your Vercel project is properly configured
4. **Test Workflow**: Create a PR to test the complete workflow

## Customization

The workflow can be customized by:
- Modifying branch names in trigger conditions
- Adjusting retention days for artifacts
- Adding additional deployment targets
- Extending test coverage requirements
- Adding security scanning jobs

## Troubleshooting

Common issues and solutions:
- **Build failures**: Check Flutter version compatibility
- **Deployment issues**: Verify Vercel secrets and project configuration
- **Test failures**: Ensure all tests pass locally before pushing
- **Cache issues**: Clear cache by updating workflow file
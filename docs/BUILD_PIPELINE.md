# 🚀 Pond Defender - Android Build Pipeline

This document explains how to set up and use the automated build pipeline for generating signed APK and AAB files.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Security Guarantees](#security-guarantees)
3. [Prerequisites](#prerequisites)
4. [Step 1: Generate Keystore](#step-1-generate-keystore)
5. [Step 2: Add GitHub Secrets](#step-2-add-github-secrets)
6. [Step 3: Trigger the Build](#step-3-trigger-the-build)
7. [Step 4: Download Artifacts](#step-4-download-artifacts)
8. [Troubleshooting](#troubleshooting)

---

## Overview

The build pipeline automatically:
- ✅ Builds **signed APK** and **AAB** on every push to `main`/`master`/`develop`
- ✅ Uses keystore provided through **GitHub Secrets only**
- ✅ Decodes keystore from Base64 at runtime
- ✅ Signs the app and **deletes sensitive files** after build
- ✅ **Never prints or exposes** secrets in logs
- ✅ Uploads APK + AAB as downloadable workflow artifacts

---

## Security Guarantees

### Keystore Generation Script

The `scripts/generate_keystore.ps1` (Windows) and `scripts/generate_keystore.sh` (macOS/Linux) scripts:

| Guarantee | Description |
|-----------|-------------|
| ✅ **No System Data** | Does NOT read any system information |
| ✅ **No User Data** | Does NOT read any user/account information |
| ✅ **No IP Address** | Does NOT read or transmit IP addresses |
| ✅ **No Location Data** | Does NOT access GPS or location services |
| ✅ **No Auto-Fill** | Does NOT auto-fill any values |
| ✅ **Manual Input Only** | ALL values must be manually entered by user |

### GitHub Actions Workflow

| Guarantee | Description |
|-----------|-------------|
| ✅ **Secrets Masked** | All secrets are masked in logs by GitHub |
| ✅ **Runtime Decode** | Keystore decoded from Base64 at runtime only |
| ✅ **Secure Cleanup** | Keystore and key.properties deleted after build |
| ✅ **No Secret Echo** | Secrets never echoed or printed |

---

## Prerequisites

Before starting, ensure you have:

- [ ] **Java JDK** installed (keytool must be in PATH)
- [ ] **GitHub repository** with Actions enabled
- [ ] **Repository admin access** (to add secrets)

---

## Step 1: Generate Keystore

### Windows (PowerShell)

```powershell
# Navigate to project root
cd "C:\path\to\Pond Defender"

# Run the script
.\scripts\generate_keystore.ps1
```

### macOS / Linux (Bash)

```bash
# Navigate to project root
cd /path/to/pond-defender

# Make script executable
chmod +x scripts/generate_keystore.sh

# Run the script
./scripts/generate_keystore.sh
```

### What You'll Be Asked

The script will prompt you for **company-specific information only**:

| # | Prompt | Example |
|---|--------|---------|
| 1 | Company/App Name | `Homyens Studios` |
| 2 | Organizational Unit | `Mobile Development` |
| 3 | Organization Name | `Homyens Inc` |
| 4 | City/Locality | `San Francisco` |
| 5 | State/Province | `California` |
| 6 | Country Code (2 letters) | `US` |
| 7 | Key Alias | `homyens-release-key` |
| 8 | Keystore Password | *(your secure password)* |
| 9 | Key Password | *(your secure password)* |
| 10 | Validity (years) | `25` |

### Output Files

After running, you'll have:

```
📄 homyens-release-keystore.jks    # The actual keystore (KEEP SAFE!)
📄 homyens-keystore-base64.txt     # Base64 encoded version (for GitHub)
```

⚠️ **IMPORTANT**: Store the `.jks` file in a secure location. If you lose it, you **cannot update your app** on Play Store!

---

## Step 2: Add GitHub Secrets

1. Go to your GitHub repository
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add the following secrets:

| Secret Name | Value |
|-------------|-------|
| `HOMYENS_KEYSTORE_BASE64` | Contents of `homyens-keystore-base64.txt` |
| `HOMYENS_STORE_PASSWORD` | Your keystore password |
| `HOMYENS_KEY_PASSWORD` | Your key password |
| `HOMYENS_KEY_ALIAS` | Your key alias (e.g., `homyens-release-key`) |

### Adding the Base64 Keystore

1. Open `homyens-keystore-base64.txt` in a text editor
2. Copy the **entire content** (it's one long line)
3. Paste it as the value for `HOMYENS_KEYSTORE_BASE64`

---

## Step 3: Trigger the Build

The build triggers automatically on:
- Push to `main`, `master`, or `develop` branches
- Pull requests to `main` or `master`

### Manual Trigger

1. Go to **Actions** tab in your repository
2. Click **Android Release Build** workflow
3. Click **Run workflow** dropdown
4. Click **Run workflow** button

---

## Step 4: Download Artifacts

After a successful build:

1. Go to **Actions** tab
2. Click on the completed workflow run
3. Scroll down to **Artifacts**
4. Download:
   - `pond-defender-apk` - The signed APK file
   - `pond-defender-aab` - The signed AAB file (for Play Store)
   - `debug-symbols` - Symbols for crash reports

---

## Troubleshooting

### Build Fails: "Keystore file not found"

**Cause**: GitHub Secret `HOMYENS_KEYSTORE_BASE64` is empty or invalid.

**Solution**: 
1. Regenerate the keystore using the script
2. Copy the **entire** contents of `homyens-keystore-base64.txt`
3. Update the GitHub Secret

### Build Fails: "Wrong password"

**Cause**: Password in GitHub Secret doesn't match keystore.

**Solution**:
1. Verify `HOMYENS_STORE_PASSWORD` matches what you entered during generation
2. Verify `HOMYENS_KEY_PASSWORD` matches what you entered during generation

### Build Fails: R8/ProGuard Errors

**Cause**: Missing ProGuard rules for dependencies.

**Solution**: Add appropriate `-dontwarn` rules to `android/app/proguard-rules.pro`

### APK Not Signed

**Cause**: `key.properties` file not created properly.

**Solution**: Check that all 4 secrets are properly set in GitHub Secrets.

---

## File Structure

```
.github/
└── workflows/
    └── android-release.yml     # GitHub Actions workflow

android/
└── app/
    ├── build.gradle.kts        # Build config with signing
    └── proguard-rules.pro      # ProGuard/R8 rules

scripts/
├── generate_keystore.ps1       # Windows keystore generator
└── generate_keystore.sh        # macOS/Linux keystore generator

docs/
└── BUILD_PIPELINE.md           # This documentation
```

---

## Support

If you encounter issues:

1. Check the **Actions** tab for detailed error logs
2. Verify all GitHub Secrets are correctly set
3. Ensure the keystore was generated correctly
4. Review ProGuard rules if R8 errors occur

---

*Last updated: January 2026*

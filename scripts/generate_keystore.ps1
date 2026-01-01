<#
.SYNOPSIS
    Keystore Generation Script for Pond Defender (Homyens)
    
.DESCRIPTION
    This script generates a JKS keystore for signing Android apps.
    It prompts ONLY for company-specific information.
    
    ⚠️  SECURITY NOTICE:
    - This script does NOT read any system information
    - This script does NOT read any user information
    - This script does NOT read IP addresses or location data
    - This script does NOT auto-fill any values
    - All inputs must be manually provided by the user
    
.NOTES
    Author: Development Team
    Version: 1.0
    Requirements: Java JDK (keytool must be in PATH)
#>

# ============================================
# BANNER
# ============================================
Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "    KEYSTORE GENERATION SCRIPT - POND DEFENDER (HOMYENS)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will generate a signing keystore for your app." -ForegroundColor Yellow
Write-Host ""
Write-Host "[SECURITY NOTICE]" -ForegroundColor Red
Write-Host "- No system/user/IP/location data is collected" -ForegroundColor Green
Write-Host "- All values must be manually entered" -ForegroundColor Green
Write-Host "- Nothing is auto-filled" -ForegroundColor Green
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================
# CHECK JAVA/KEYTOOL
# ============================================
Write-Host "Checking for Java keytool..." -ForegroundColor Yellow
try {
    $keytoolVersion = & keytool -help 2>&1 | Select-String -Pattern "keytool" | Select-Object -First 1
    if ($keytoolVersion) {
        Write-Host "✅ keytool found" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ ERROR: Java keytool not found in PATH" -ForegroundColor Red
    Write-Host "Please install Java JDK and ensure keytool is in your PATH" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# ============================================
# COLLECT COMPANY INFORMATION (MANUAL INPUT ONLY)
# ============================================
Write-Host "Please enter your company/organization details:" -ForegroundColor Cyan
Write-Host "(Press Enter after each input)" -ForegroundColor Gray
Write-Host ""

# Company Name (CN - Common Name)
do {
    $companyName = Read-Host "1. Company/App Name (e.g., Homyens Studios)"
    if ([string]::IsNullOrWhiteSpace($companyName)) {
        Write-Host "   ⚠️  Company name cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($companyName))

# Organizational Unit (OU)
do {
    $orgUnit = Read-Host "2. Organizational Unit (e.g., Mobile Development)"
    if ([string]::IsNullOrWhiteSpace($orgUnit)) {
        Write-Host "   ⚠️  Organizational unit cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($orgUnit))

# Organization (O)
do {
    $organization = Read-Host "3. Organization Name (e.g., Homyens Inc)"
    if ([string]::IsNullOrWhiteSpace($organization)) {
        Write-Host "   ⚠️  Organization cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($organization))

# City/Locality (L)
do {
    $city = Read-Host "4. City/Locality (e.g., San Francisco)"
    if ([string]::IsNullOrWhiteSpace($city)) {
        Write-Host "   ⚠️  City cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($city))

# State/Province (ST)
do {
    $state = Read-Host "5. State/Province (e.g., California)"
    if ([string]::IsNullOrWhiteSpace($state)) {
        Write-Host "   ⚠️  State cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($state))

# Country Code (C)
do {
    $country = Read-Host "6. Country Code - 2 letters (e.g., US, UK, DE)"
    if ([string]::IsNullOrWhiteSpace($country) -or $country.Length -ne 2) {
        Write-Host "   ⚠️  Country code must be exactly 2 letters" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($country) -or $country.Length -ne 2)
$country = $country.ToUpper()

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Now enter your keystore credentials:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Key Alias
do {
    $keyAlias = Read-Host "7. Key Alias (e.g., homyens-release-key)"
    if ([string]::IsNullOrWhiteSpace($keyAlias)) {
        Write-Host "   ⚠️  Key alias cannot be empty" -ForegroundColor Yellow
    }
} while ([string]::IsNullOrWhiteSpace($keyAlias))

# Store Password
Write-Host ""
Write-Host "8. Keystore Password (minimum 6 characters)" -ForegroundColor White
Write-Host "   ⚠️  IMPORTANT: Remember this password! You'll need it for GitHub Secrets" -ForegroundColor Yellow
do {
    $storePassword = Read-Host "   Enter Keystore Password" -AsSecureString
    $storePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($storePassword))
    if ($storePasswordPlain.Length -lt 6) {
        Write-Host "   ⚠️  Password must be at least 6 characters" -ForegroundColor Yellow
    }
} while ($storePasswordPlain.Length -lt 6)

# Key Password
Write-Host ""
Write-Host "9. Key Password (minimum 6 characters)" -ForegroundColor White
Write-Host "   TIP: Can be the same as keystore password" -ForegroundColor Gray
do {
    $keyPassword = Read-Host "   Enter Key Password" -AsSecureString
    $keyPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPassword))
    if ($keyPasswordPlain.Length -lt 6) {
        Write-Host "   ⚠️  Password must be at least 6 characters" -ForegroundColor Yellow
    }
} while ($keyPasswordPlain.Length -lt 6)

# Validity (years)
Write-Host ""
$validityYears = Read-Host "10. Validity in years (default: 25, press Enter to use default)"
if ([string]::IsNullOrWhiteSpace($validityYears)) {
    $validityYears = 25
}
$validityDays = [int]$validityYears * 365

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "SUMMARY - Please verify:" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Company Name:      $companyName" -ForegroundColor White
Write-Host "Org Unit:          $orgUnit" -ForegroundColor White
Write-Host "Organization:      $organization" -ForegroundColor White
Write-Host "City:              $city" -ForegroundColor White
Write-Host "State:             $state" -ForegroundColor White
Write-Host "Country:           $country" -ForegroundColor White
Write-Host "Key Alias:         $keyAlias" -ForegroundColor White
Write-Host "Validity:          $validityYears years ($validityDays days)" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Is this information correct? (yes/no)"
if ($confirm -ne "yes" -and $confirm -ne "y") {
    Write-Host "❌ Aborted by user. Please run the script again." -ForegroundColor Red
    exit 1
}

# ============================================
# GENERATE KEYSTORE
# ============================================
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Generating keystore..." -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan

$keystoreFile = "homyens-release-keystore.jks"
$dname = "CN=$companyName, OU=$orgUnit, O=$organization, L=$city, ST=$state, C=$country"

# Remove existing keystore if present
if (Test-Path $keystoreFile) {
    Remove-Item $keystoreFile -Force
}

# Generate keystore using keytool
$keytoolArgs = @(
    "-genkeypair"
    "-v"
    "-keystore", $keystoreFile
    "-alias", $keyAlias
    "-keyalg", "RSA"
    "-keysize", "2048"
    "-validity", $validityDays
    "-storepass", $storePasswordPlain
    "-keypass", $keyPasswordPlain
    "-dname", $dname
)

try {
    & keytool @keytoolArgs 2>&1 | Out-Null
    
    if (Test-Path $keystoreFile) {
        Write-Host "✅ Keystore generated successfully!" -ForegroundColor Green
    } else {
        throw "Keystore file not created"
    }
} catch {
    Write-Host "❌ ERROR generating keystore: $_" -ForegroundColor Red
    exit 1
}

# ============================================
# ENCODE TO BASE64
# ============================================
Write-Host ""
Write-Host "Converting keystore to Base64..." -ForegroundColor Yellow

$keystoreBytes = [System.IO.File]::ReadAllBytes($keystoreFile)
$keystoreBase64 = [System.Convert]::ToBase64String($keystoreBytes)

# Save base64 to file for easy copying
$base64File = "homyens-keystore-base64.txt"
$keystoreBase64 | Out-File -FilePath $base64File -Encoding ASCII -NoNewline

Write-Host "✅ Base64 encoding complete!" -ForegroundColor Green

# ============================================
# OUTPUT INSTRUCTIONS
# ============================================
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "    🎉 KEYSTORE GENERATION COMPLETE!" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Files created:" -ForegroundColor Cyan
Write-Host "  📄 $keystoreFile (Keep this SAFE and PRIVATE!)" -ForegroundColor White
Write-Host "  📄 $base64File (Base64 encoded keystore)" -ForegroundColor White
Write-Host ""
Write-Host "============================================================" -ForegroundColor Yellow
Write-Host "    GITHUB SECRETS SETUP" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Add these secrets to your GitHub repository:" -ForegroundColor Cyan
Write-Host "  Repository > Settings > Secrets and variables > Actions > New repository secret" -ForegroundColor Gray
Write-Host ""
Write-Host ""
Write-Host "  Secret Name                    Value" -ForegroundColor White
Write-Host "  ----------------------------   ------------------------------------" -ForegroundColor Gray
Write-Host "  HOMYENS_KEYSTORE_BASE64        Contents of: $base64File" -ForegroundColor White
Write-Host "  HOMYENS_STORE_PASSWORD         Your keystore password" -ForegroundColor White
Write-Host "  HOMYENS_KEY_PASSWORD           Your key password" -ForegroundColor White
Write-Host "  HOMYENS_KEY_ALIAS              $keyAlias" -ForegroundColor White
Write-Host ""
Write-Host ""
Write-Host "============================================================" -ForegroundColor Red
Write-Host "    ⚠️  IMPORTANT SECURITY NOTES" -ForegroundColor Red
Write-Host "============================================================" -ForegroundColor Red
Write-Host ""
Write-Host "1. NEVER commit the .jks file or base64 file to git!" -ForegroundColor Yellow
Write-Host "2. Store the keystore and passwords in a secure location" -ForegroundColor Yellow
Write-Host "3. If you lose the keystore, you cannot update your app!" -ForegroundColor Yellow
Write-Host "4. Delete the base64 file after copying to GitHub Secrets" -ForegroundColor Yellow
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# Clear sensitive variables from memory
$storePasswordPlain = $null
$keyPasswordPlain = $null
[System.GC]::Collect()

Write-Host "Script completed. Press any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

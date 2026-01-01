#!/bin/bash

# ============================================================
# Keystore Generation Script for Pond Defender (Homyens)
# ============================================================
#
# SECURITY NOTICE:
# - This script does NOT read any system information
# - This script does NOT read any user information  
# - This script does NOT read IP addresses or location data
# - This script does NOT auto-fill any values
# - All inputs must be manually provided by the user
#
# Requirements: Java JDK (keytool must be in PATH)
# ============================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ============================================
# BANNER
# ============================================
clear
echo -e "${CYAN}============================================================${NC}"
echo -e "${CYAN}    KEYSTORE GENERATION SCRIPT - POND DEFENDER (HOMYENS)${NC}"
echo -e "${CYAN}============================================================${NC}"
echo ""
echo -e "${YELLOW}This script will generate a signing keystore for your app.${NC}"
echo ""
echo -e "${RED}[SECURITY NOTICE]${NC}"
echo -e "${GREEN}- No system/user/IP/location data is collected${NC}"
echo -e "${GREEN}- All values must be manually entered${NC}"
echo -e "${GREEN}- Nothing is auto-filled${NC}"
echo ""
echo -e "${CYAN}============================================================${NC}"
echo ""

# ============================================
# CHECK JAVA/KEYTOOL
# ============================================
echo -e "${YELLOW}Checking for Java keytool...${NC}"
if ! command -v keytool &> /dev/null; then
    echo -e "${RED}❌ ERROR: Java keytool not found in PATH${NC}"
    echo -e "${YELLOW}Please install Java JDK and ensure keytool is in your PATH${NC}"
    exit 1
fi
echo -e "${GREEN}✅ keytool found${NC}"
echo ""

# ============================================
# COLLECT COMPANY INFORMATION (MANUAL INPUT ONLY)
# ============================================
echo -e "${CYAN}Please enter your company/organization details:${NC}"
echo -e "(Press Enter after each input)"
echo ""

# Company Name (CN - Common Name)
while true; do
    read -p "1. Company/App Name (e.g., Homyens Studios): " companyName
    if [ -n "$companyName" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Company name cannot be empty${NC}"
done

# Organizational Unit (OU)
while true; do
    read -p "2. Organizational Unit (e.g., Mobile Development): " orgUnit
    if [ -n "$orgUnit" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Organizational unit cannot be empty${NC}"
done

# Organization (O)
while true; do
    read -p "3. Organization Name (e.g., Homyens Inc): " organization
    if [ -n "$organization" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Organization cannot be empty${NC}"
done

# City/Locality (L)
while true; do
    read -p "4. City/Locality (e.g., San Francisco): " city
    if [ -n "$city" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  City cannot be empty${NC}"
done

# State/Province (ST)
while true; do
    read -p "5. State/Province (e.g., California): " state
    if [ -n "$state" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  State cannot be empty${NC}"
done

# Country Code (C)
while true; do
    read -p "6. Country Code - 2 letters (e.g., US, UK, DE): " country
    if [ -n "$country" ] && [ ${#country} -eq 2 ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Country code must be exactly 2 letters${NC}"
done
country=$(echo "$country" | tr '[:lower:]' '[:upper:]')

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}Now enter your keystore credentials:${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# Key Alias
while true; do
    read -p "7. Key Alias (e.g., homyens-release-key): " keyAlias
    if [ -n "$keyAlias" ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Key alias cannot be empty${NC}"
done

# Store Password
echo ""
echo -e "${WHITE}8. Keystore Password (minimum 6 characters)${NC}"
echo -e "${YELLOW}   ⚠️  IMPORTANT: Remember this password! You'll need it for GitHub Secrets${NC}"
while true; do
    read -sp "   Enter Keystore Password: " storePassword
    echo ""
    if [ ${#storePassword} -ge 6 ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Password must be at least 6 characters${NC}"
done

# Key Password
echo ""
echo -e "${WHITE}9. Key Password (minimum 6 characters)${NC}"
echo "   TIP: Can be the same as keystore password"
while true; do
    read -sp "   Enter Key Password: " keyPassword
    echo ""
    if [ ${#keyPassword} -ge 6 ]; then break; fi
    echo -e "${YELLOW}   ⚠️  Password must be at least 6 characters${NC}"
done

# Validity (years)
echo ""
read -p "10. Validity in years (default: 25, press Enter to use default): " validityYears
if [ -z "$validityYears" ]; then
    validityYears=25
fi
validityDays=$((validityYears * 365))

echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}SUMMARY - Please verify:${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""
echo -e "${WHITE}Company Name:      $companyName${NC}"
echo -e "${WHITE}Org Unit:          $orgUnit${NC}"
echo -e "${WHITE}Organization:      $organization${NC}"
echo -e "${WHITE}City:              $city${NC}"
echo -e "${WHITE}State:             $state${NC}"
echo -e "${WHITE}Country:           $country${NC}"
echo -e "${WHITE}Key Alias:         $keyAlias${NC}"
echo -e "${WHITE}Validity:          $validityYears years ($validityDays days)${NC}"
echo ""

read -p "Is this information correct? (yes/no): " confirm
if [ "$confirm" != "yes" ] && [ "$confirm" != "y" ]; then
    echo -e "${RED}❌ Aborted by user. Please run the script again.${NC}"
    exit 1
fi

# ============================================
# GENERATE KEYSTORE
# ============================================
echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${YELLOW}Generating keystore...${NC}"
echo -e "${CYAN}============================================${NC}"

keystoreFile="homyens-release-keystore.jks"
dname="CN=$companyName, OU=$orgUnit, O=$organization, L=$city, ST=$state, C=$country"

# Remove existing keystore if present
rm -f "$keystoreFile"

# Generate keystore using keytool
keytool -genkeypair -v \
    -keystore "$keystoreFile" \
    -alias "$keyAlias" \
    -keyalg RSA \
    -keysize 2048 \
    -validity "$validityDays" \
    -storepass "$storePassword" \
    -keypass "$keyPassword" \
    -dname "$dname" 2>/dev/null

if [ -f "$keystoreFile" ]; then
    echo -e "${GREEN}✅ Keystore generated successfully!${NC}"
else
    echo -e "${RED}❌ ERROR generating keystore${NC}"
    exit 1
fi

# ============================================
# ENCODE TO BASE64
# ============================================
echo ""
echo -e "${YELLOW}Converting keystore to Base64...${NC}"

base64File="homyens-keystore-base64.txt"
base64 -i "$keystoreFile" > "$base64File"

echo -e "${GREEN}✅ Base64 encoding complete!${NC}"

# ============================================
# OUTPUT INSTRUCTIONS
# ============================================
echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}    🎉 KEYSTORE GENERATION COMPLETE!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "${CYAN}Files created:${NC}"
echo -e "${WHITE}  📄 $keystoreFile (Keep this SAFE and PRIVATE!)${NC}"
echo -e "${WHITE}  📄 $base64File (Base64 encoded keystore)${NC}"
echo ""
echo -e "${YELLOW}============================================================${NC}"
echo -e "${YELLOW}    GITHUB SECRETS SETUP${NC}"
echo -e "${YELLOW}============================================================${NC}"
echo ""
echo -e "${CYAN}Add these secrets to your GitHub repository:${NC}"
echo "  Repository > Settings > Secrets and variables > Actions > New repository secret"
echo ""
echo "┌─────────────────────────────┬────────────────────────────────────┐"
echo "│ Secret Name                 │ Value                              │"
echo "├─────────────────────────────┼────────────────────────────────────┤"
echo "│ HOMYENS_KEYSTORE_BASE64     │ (Contents of $base64File) │"
echo "│ HOMYENS_STORE_PASSWORD      │ (Your keystore password)           │"
echo "│ HOMYENS_KEY_PASSWORD        │ (Your key password)                │"
echo "│ HOMYENS_KEY_ALIAS           │ $keyAlias"
echo "└─────────────────────────────┴────────────────────────────────────┘"
echo ""
echo -e "${RED}============================================================${NC}"
echo -e "${RED}    ⚠️  IMPORTANT SECURITY NOTES${NC}"
echo -e "${RED}============================================================${NC}"
echo ""
echo -e "${YELLOW}1. NEVER commit the .jks file or base64 file to git!${NC}"
echo -e "${YELLOW}2. Store the keystore and passwords in a secure location${NC}"
echo -e "${YELLOW}3. If you lose the keystore, you cannot update your app!${NC}"
echo -e "${YELLOW}4. Delete the base64 file after copying to GitHub Secrets${NC}"
echo ""
echo -e "${CYAN}============================================================${NC}"
echo ""

# Clear sensitive variables from memory
unset storePassword
unset keyPassword

echo "Script completed."

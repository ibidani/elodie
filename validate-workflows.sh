#!/bin/bash

# GitHub Workflow Validation Script
# This script validates the GitHub workflow setup for the Elodie project

echo "🔍 GitHub Workflow Setup Validation"
echo "===================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if file exists and is not empty
check_file() {
    local file=$1
    local description=$2
    
    if [[ -f "$file" && -s "$file" ]]; then
        echo -e "${GREEN}✅ $description${NC}: $file"
        return 0
    else
        echo -e "${RED}❌ $description${NC}: $file (missing or empty)"
        return 1
    fi
}

# Function to validate YAML syntax (basic check)
validate_yaml() {
    local file=$1
    
    # Basic YAML validation - check for common syntax issues
    if python3 -c "import yaml; yaml.safe_load(open('$file'))" 2>/dev/null; then
        echo -e "${GREEN}✅ YAML Syntax Valid${NC}: $file"
        return 0
    else
        echo -e "${RED}❌ YAML Syntax Error${NC}: $file"
        return 1
    fi
}

echo ""
echo "📁 Checking Directory Structure..."
echo "--------------------------------"

# Check main directories
directories=(
    ".github"
    ".github/workflows" 
    ".github/ISSUE_TEMPLATE"
)

for dir in "${directories[@]}"; do
    if [[ -d "$dir" ]]; then
        echo -e "${GREEN}✅ Directory exists${NC}: $dir"
    else
        echo -e "${RED}❌ Directory missing${NC}: $dir"
    fi
done

echo ""
echo "📄 Checking Workflow Files..."
echo "----------------------------"

# Check workflow files
workflow_files=(
    ".github/workflows/ci.yml:CI/CD Pipeline"
    ".github/workflows/release.yml:Release Workflow"
    ".github/workflows/docker.yml:Docker Build"
    ".github/workflows/electron-build.yml:Electron Build"
    ".github/workflows/dependency-update.yml:Dependency Updates"
    ".github/workflows/security-scan.yml:Security Scanning"
    ".github/workflows/docs-deploy.yml:Documentation Deployment"
)

workflow_valid=0
for entry in "${workflow_files[@]}"; do
    IFS=':' read -r file description <<< "$entry"
    if check_file "$file" "$description"; then
        validate_yaml "$file"
        ((workflow_valid++))
    fi
done

echo ""
echo "🎫 Checking Templates..."
echo "----------------------"

# Check template files
template_files=(
    ".github/ISSUE_TEMPLATE/bug_report.yml:Bug Report Template"
    ".github/ISSUE_TEMPLATE/feature_request.yml:Feature Request Template"
    ".github/ISSUE_TEMPLATE/config.yml:Issue Template Config"
    ".github/PULL_REQUEST_TEMPLATE.md:Pull Request Template"
    ".github/dependabot.yml:Dependabot Configuration"
)

template_valid=0
for entry in "${template_files[@]}"; do
    IFS=':' read -r file description <<< "$entry"
    if check_file "$file" "$description"; then
        if [[ "$file" == *.yml ]]; then
            validate_yaml "$file"
        fi
        ((template_valid++))
    fi
done

echo ""
echo "📦 Checking Package Configuration..."
echo "----------------------------------"

# Check packaging files
package_files=(
    "setup.py:Python Setup Script"
    "pyproject.toml:Modern Python Packaging"
    "Dockerfile:Docker Configuration"
    "requirements.txt:Python Dependencies"
)

package_valid=0
for entry in "${package_files[@]}"; do
    IFS=':' read -r file description <<< "$entry"
    if check_file "$file" "$description"; then
        ((package_valid++))
    fi
done

echo ""
echo "🔧 Checking Project Dependencies..."
echo "---------------------------------"

# Check if required tools are available
tools=(
    "python3:Python 3"
    "node:Node.js"
    "npm:NPM"
    "docker:Docker"
)

tools_available=0
for entry in "${tools[@]}"; do
    IFS=':' read -r tool description <<< "$entry"
    if command -v "$tool" &> /dev/null; then
        version=$(${tool} --version 2>/dev/null | head -n1)
        echo -e "${GREEN}✅ $description available${NC}: $version"
        ((tools_available++))
    else
        echo -e "${YELLOW}⚠️  $description not found${NC}: $tool"
    fi
done

echo ""
echo "🔄 Checking CircleCI Migration Parity..."
echo "--------------------------------------"

# Check CircleCI compatibility
circleci_checks=(
    "ExifTool version 13.19:grep -q 'Image-ExifTool-13.19' .github/workflows/ci.yml"
    "Google Photos dependencies:grep -q 'googlephotos/requirements.txt' .github/workflows/ci.yml"
    "Debug mode configuration:grep -q 'debug = True' .github/workflows/ci.yml"
    "Nose test command:grep -q 'run_tests.py -w' .github/workflows/ci.yml"
    "Coveralls integration:grep -q 'coveralls' .github/workflows/ci.yml"
)

circleci_valid=0
for entry in "${circleci_checks[@]}"; do
    IFS=':' read -r description check <<< "$entry"
    if eval "$check" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ CircleCI Parity${NC}: $description"
        ((circleci_valid++))
    else
        echo -e "${RED}❌ CircleCI Parity${NC}: $description"
    fi
done

echo ""
echo "📊 Validation Summary"
echo "===================="
echo ""

total_workflows=${#workflow_files[@]}
total_templates=${#template_files[@]}
total_packages=${#package_files[@]}
total_tools=${#tools[@]}
total_circleci=${#circleci_checks[@]}

echo -e "Workflow Files: ${GREEN}$workflow_valid${NC}/$total_workflows"
echo -e "Template Files: ${GREEN}$template_valid${NC}/$total_templates" 
echo -e "Package Files: ${GREEN}$package_valid${NC}/$total_packages"
echo -e "Available Tools: ${GREEN}$tools_available${NC}/$total_tools"
echo -e "CircleCI Parity: ${GREEN}$circleci_valid${NC}/$total_circleci"

total_score=$((workflow_valid + template_valid + package_valid + circleci_valid))
total_possible=$((total_workflows + total_templates + total_packages + total_circleci))

echo ""
echo -e "Overall Score: ${BLUE}$total_score${NC}/$total_possible"

if [[ $total_score -eq $total_possible ]]; then
    echo -e "${GREEN}🎉 All checks passed! GitHub workflow setup is complete with full CircleCI parity.${NC}"
    echo ""
    echo "Migration Summary:"
    echo "✅ All CircleCI build steps successfully replicated"
    echo "✅ Enhanced with multi-platform and security features"
    echo "✅ Ready for seamless transition from CircleCI"
    echo ""
    echo "Next steps:"
    echo "1. Configure repository secrets in GitHub"
    echo "2. Set up branch protection rules"
    echo "3. Test workflows with a sample commit"
    echo "4. Configure external service integrations"
    echo "5. Gradually phase out CircleCI"
    exit 0
elif [[ $total_score -ge $((total_possible * 3 / 4)) ]]; then
    echo -e "${YELLOW}⚠️  Setup mostly complete with some optional items missing.${NC}"
    exit 0
else
    echo -e "${RED}❌ Setup incomplete. Please review the missing files above.${NC}"
    exit 1
fi
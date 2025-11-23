#!/bin/bash

# Update formula with SHA256 hashes from GitHub release
# Usage: ./update-formula.sh VERSION
# Example: ./update-formula.sh v3.0.1

if [ $# -eq 0 ]; then
    echo "Usage: $0 VERSION"
    echo "Example: $0 v3.0.1"
    exit 1
fi

VERSION=$1
BASE_URL="https://github.com/fstark/macflim/releases/download/${VERSION}"

echo "Downloading release artifacts for ${VERSION}..."

# Create temp directory
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

# Download both tarballs
echo "Downloading ARM64 tarball..."
curl -sL "${BASE_URL}/flimmaker-arm64-macos.tar.gz" -o flimmaker-arm64-macos.tar.gz

echo "Downloading x86_64 tarball..."
curl -sL "${BASE_URL}/flimmaker-x86_64-macos.tar.gz" -o flimmaker-x86_64-macos.tar.gz

# Compute SHA256 hashes
echo ""
echo "Computing SHA256 hashes..."
ARM64_SHA=$(shasum -a 256 flimmaker-arm64-macos.tar.gz | awk '{print $1}')
X86_64_SHA=$(shasum -a 256 flimmaker-x86_64-macos.tar.gz | awk '{print $1}')

echo ""
echo "ARM64 SHA256:  $ARM64_SHA"
echo "x86_64 SHA256: $X86_64_SHA"

# Cleanup
cd - > /dev/null
rm -rf "$TMPDIR"

echo ""
echo "Updating Formula/flimmaker.rb..."

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FORMULA_PATH="${SCRIPT_DIR}/Formula/flimmaker.rb"

# Update the formula using sed
sed -i.bak \
    -e "s|download/v[0-9.]\+/flimmaker-arm64-macos.tar.gz|download/${VERSION}/flimmaker-arm64-macos.tar.gz|g" \
    -e "s|download/v[0-9.]\+/flimmaker-x86_64-macos.tar.gz|download/${VERSION}/flimmaker-x86_64-macos.tar.gz|g" \
    -e "/Hardware::CPU.arm?/,/sha256/ s/sha256 \"[^\"]*\"/sha256 \"${ARM64_SHA}\"/" \
    -e "/Hardware::CPU.intel?/,/sha256/ s/sha256 \"[^\"]*\"/sha256 \"${X86_64_SHA}\"/" \
    "$FORMULA_PATH"

rm "${FORMULA_PATH}.bak"

echo "Formula updated!"
echo ""
echo "Review the changes:"
git diff Formula/flimmaker.rb
echo ""
echo "If everything looks good, commit and push:"
echo "  git add Formula/flimmaker.rb"
echo "  git commit -m 'Update to ${VERSION}'"
echo "  git push"

#!/bin/bash

# Update formula with SHA256 hash from GitHub source tarball
# Usage: ./update-formula.sh VERSION
# Example: ./update-formula.sh v2.0.11

if [ $# -eq 0 ]; then
    echo "Usage: $0 VERSION"
    echo "Example: $0 v2.0.11"
    exit 1
fi

VERSION=$1
SOURCE_URL="https://github.com/fstark/macflim/archive/refs/tags/${VERSION}.tar.gz"

echo "Downloading source tarball for ${VERSION}..."

# Create temp directory
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

# Download source tarball
echo "Downloading from ${SOURCE_URL}..."
curl -sL "${SOURCE_URL}" -o source.tar.gz

if [ ! -f source.tar.gz ]; then
    echo "Error: Failed to download source tarball"
    cd - > /dev/null
    rm -rf "$TMPDIR"
    exit 1
fi

# Compute SHA256 hash
echo ""
echo "Computing SHA256 hash..."
SHA256=$(shasum -a 256 source.tar.gz | awk '{print $1}')

echo ""
echo "Version: $VERSION"
echo "SHA256:  $SHA256"

# Cleanup
cd - > /dev/null
rm -rf "$TMPDIR"

echo ""
echo "Updating Formula/flimmaker.rb..."

# Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FORMULA_PATH="${SCRIPT_DIR}/Formula/flimmaker.rb"

# Update the formula - update URL and SHA256
sed -i.bak \
    -e "s|archive/refs/tags/v[0-9.]\+\.tar\.gz|archive/refs/tags/${VERSION}.tar.gz|g" \
    -e "s/sha256 \"[^\"]*\"/sha256 \"${SHA256}\"/" \
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

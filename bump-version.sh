#!/bin/bash
# Version bumping script untuk semantic versioning

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./bump-version.sh [major|minor|patch]"
    echo ""
    echo "Examples:"
    echo "  ./bump-version.sh major  # 1.0.0 → 2.0.0"
    echo "  ./bump-version.sh minor  # 1.0.0 → 1.1.0"
    echo "  ./bump-version.sh patch  # 1.0.0 → 1.0.1"
    exit 1
fi

BUMP_TYPE=$1

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}' | cut -d'+' -f1)
CURRENT_BUILD=$(grep "^version:" pubspec.yaml | awk -F'+' '{print $2}')

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

echo "📊 Current version: $CURRENT_VERSION (build: $CURRENT_BUILD)"

# Bump version
case $BUMP_TYPE in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
  *)
    echo "❌ Invalid bump type: $BUMP_TYPE"
    echo "Use: major, minor, or patch"
    exit 1
    ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_BUILD=$((CURRENT_BUILD + 1))

echo "✨ New version: $NEW_VERSION (build: $NEW_BUILD)"

# Update pubspec.yaml
sed -i.bak "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" pubspec.yaml
rm -f pubspec.yaml.bak

echo "✅ Updated pubspec.yaml"

# Create git tag
git add pubspec.yaml
git commit -m "chore: bump version to $NEW_VERSION"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo "📝 Git changes staged"
echo ""
echo "🚀 Ready to push!"
echo ""
echo "Commands to execute:"
echo "  git push origin main"
echo "  git push origin v$NEW_VERSION"
echo ""
echo "⚠️  This will trigger the CI/CD pipeline automatically!"

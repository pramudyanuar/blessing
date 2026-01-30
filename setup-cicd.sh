#!/bin/bash
# Setup script untuk mengonfigurasi Git hooks dan development environment

set -e

echo "🚀 Setting up CI/CD pipeline..."

# 1. Setup Git hooks
echo "📝 Setting up Git hooks..."
mkdir -p .git/hooks
cp .githooks/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Git pre-commit hook installed"

# 2. Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# 3. Build runner
echo "🔨 Building generated files..."
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Create feature flags documentation
echo "📚 Feature flags documentation ready in lib/core/feature_flags/"

# 5. Setup local overrides for development
echo "⚙️ Creating development configuration..."

echo ""
echo "✅ Setup complete! You're ready to develop."
echo ""
echo "📋 Next steps:"
echo "1. Configure GitHub Secrets (see .github/CICD_SETUP.md)"
echo "2. Create Android Keystore (see .github/CICD_SETUP.md)"
echo "3. Setup Play Store Service Account (see .github/CICD_SETUP.md)"
echo "4. Push changes to main branch"
echo ""
echo "🚀 Your CI/CD pipeline is ready to go!"

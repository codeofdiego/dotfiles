#!/bin/bash
set -e

echo "==> Setting up Android SDK..."

ANDROID_HOME="$HOME/Library/Android/sdk"

# sdkmanager location varies by Android Studio version
if [ -f "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" ]; then
  SDKMANAGER="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
elif [ -f "$ANDROID_HOME/tools/bin/sdkmanager" ]; then
  SDKMANAGER="$ANDROID_HOME/tools/bin/sdkmanager"
else
  echo "    ERROR: sdkmanager not found under $ANDROID_HOME"
  echo ""
  echo "    To fix this, open Android Studio and install the Command-line Tools:"
  echo "    Settings > Languages & Frameworks > Android SDK"
  echo "    > SDK Tools tab > check 'Android SDK Command-line Tools (latest)' > Apply"
  echo ""
  echo "    Then re-run: bash ~/dotfiles/scripts/android.sh"
  exit 1
fi

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

echo "    Installing SDK components..."
yes | "$SDKMANAGER" \
  "platforms;android-35" \
  "build-tools;35.0.1" \
  "system-images;android-35;google_apis;arm64-v8a" \
  "emulator"

echo "    Accepting licenses..."
yes | "$SDKMANAGER" --licenses

echo "==> Android SDK setup complete."

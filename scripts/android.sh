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
  echo "    Make sure Android Studio is installed and you have launched it at least once"
  echo "    to complete the initial SDK setup, then re-run this script."
  exit 1
fi

echo "    Installing SDK components..."
yes | "$SDKMANAGER" \
  "platforms;android-35" \
  "build-tools;35.0.1" \
  "system-images;android-35;google_apis;arm64-v8a" \
  "emulator"

echo "    Accepting licenses..."
yes | "$SDKMANAGER" --licenses

echo "==> Android SDK setup complete."

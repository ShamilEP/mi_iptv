#!/usr/bin/env bash
# Regenerate QA-029 Design System golden PNGs on Linux (CI parity).
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq curl git unzip xz-utils clang cmake ninja-build \
  pkg-config libgtk-3-dev liblzma-dev >/tmp/apt-goldens.log

if [[ ! -x /flutter/bin/flutter ]]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git /flutter
fi

export PATH="/flutter/bin:${PATH}"
flutter --version
flutter config --no-analytics
flutter precache --linux
flutter pub get
flutter test --update-goldens test/qa/visual_regression_design_system_test.dart
ls -la test/qa/goldens/

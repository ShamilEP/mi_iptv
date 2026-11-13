#!/usr/bin/env bash
# Verify QA-029 goldens on Linux (same path as CI).
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq curl git unzip xz-utils clang cmake ninja-build \
  pkg-config libgtk-3-dev liblzma-dev >/tmp/apt-goldens.log

if [[ ! -x /flutter/bin/flutter ]]; then
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git /flutter
fi

export PATH="/flutter/bin:${PATH}"
flutter config --no-analytics >/dev/null
flutter pub get
flutter test test/qa/visual_regression_design_system_test.dart \
  test/docs/qa_029_visual_regression_doc_test.dart

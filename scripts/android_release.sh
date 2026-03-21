#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KEYSTORE_PROPERTIES="$ROOT_DIR/keystore.properties"
KEYSTORE_DEFAULT_PATH="android/app/studymate-release.keystore"
KEY_ALIAS_DEFAULT="studymate"

usage() {
  cat <<'EOF'
StudyMate Android release helper

Usage:
  scripts/android_release.sh create-keystore
  scripts/android_release.sh validate
  scripts/android_release.sh build-appbundle
  scripts/android_release.sh build-apk

Commands:
  create-keystore  Create a release keystore and print SHA fingerprints
  validate         Check keystore.properties and signing file paths
  build-appbundle  Build the signed Android App Bundle for Play Store upload
  build-apk        Build the signed Android APK for manual validation
EOF
}

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: $command_name" >&2
    exit 1
  fi
}

load_keystore_properties() {
  if [[ ! -f "$KEYSTORE_PROPERTIES" ]]; then
    echo "Missing $KEYSTORE_PROPERTIES" >&2
    echo "Copy keystore.properties.example to keystore.properties first." >&2
    exit 1
  fi

  # shellcheck disable=SC1090
  source "$KEYSTORE_PROPERTIES"
}

create_keystore() {
  require_command keytool

  local keystore_path
  local key_alias
  local store_password
  local key_password

  read -r -p "Keystore path [$KEYSTORE_DEFAULT_PATH]: " keystore_path
  keystore_path="${keystore_path:-$KEYSTORE_DEFAULT_PATH}"

  read -r -p "Key alias [$KEY_ALIAS_DEFAULT]: " key_alias
  key_alias="${key_alias:-$KEY_ALIAS_DEFAULT}"

  read -r -s -p "Store password: " store_password
  echo
  read -r -s -p "Key password (press Enter to reuse store password): " key_password
  echo
  key_password="${key_password:-$store_password}"

  mkdir -p "$(dirname "$ROOT_DIR/$keystore_path")"

  keytool -genkeypair \
    -v \
    -keystore "$ROOT_DIR/$keystore_path" \
    -alias "$key_alias" \
    -keyalg RSA \
    -keysize 4096 \
    -validity 10000 \
    -storepass "$store_password" \
    -keypass "$key_password" \
    -dname "CN=AFM SEAR StudyMate, OU=AFM SEAR, O=Apostolic Faith Mission Southern and Eastern Africa, L=Harare, ST=Harare, C=ZW"

  cat <<EOF

Keystore created at:
  $keystore_path

Now create or update $KEYSTORE_PROPERTIES with:

storeFile=$keystore_path
storePassword=YOUR_STORE_PASSWORD
keyAlias=$key_alias
keyPassword=YOUR_KEY_PASSWORD

SHA fingerprints for Google Sign-In / Play setup:
EOF

  keytool -list -v \
    -keystore "$ROOT_DIR/$keystore_path" \
    -alias "$key_alias" \
    -storepass "$store_password"
}

validate_release_signing() {
  load_keystore_properties

  local failures=0

  if [[ -z "${storeFile:-}" ]]; then
    echo "storeFile is missing in keystore.properties" >&2
    failures=1
  elif [[ ! -f "$ROOT_DIR/$storeFile" ]]; then
    echo "Keystore file not found: $ROOT_DIR/$storeFile" >&2
    failures=1
  fi

  for required_key in storePassword keyAlias keyPassword; do
    if [[ -z "${!required_key:-}" ]]; then
      echo "$required_key is missing in keystore.properties" >&2
      failures=1
    elif [[ "${!required_key}" == "CHANGE_ME" ]]; then
      echo "$required_key still uses CHANGE_ME in keystore.properties" >&2
      failures=1
    fi
  done

  if [[ "$failures" -ne 0 ]]; then
    exit 1
  fi

  echo "Android signing config looks ready."
  echo "Keystore: $storeFile"
  echo "Alias: $keyAlias"
}

build_appbundle() {
  validate_release_signing
  (
    cd "$ROOT_DIR"
    flutter build appbundle --release --dart-define=USE_FIREBASE=false
  )
  echo "Output: build/app/outputs/bundle/release/app-release.aab"
}

build_apk() {
  validate_release_signing
  (
    cd "$ROOT_DIR"
    flutter build apk --release --dart-define=USE_FIREBASE=false
  )
  echo "Output: build/app/outputs/flutter-apk/app-release.apk"
}

main() {
  local command="${1:-}"

  case "$command" in
    create-keystore)
      create_keystore
      ;;
    validate)
      validate_release_signing
      ;;
    build-appbundle)
      build_appbundle
      ;;
    build-apk)
      build_apk
      ;;
    *)
      usage
      exit 1
      ;;
  esac
}

main "$@"

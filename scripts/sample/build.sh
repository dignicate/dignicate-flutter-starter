#!/bin/bash

set -euo pipefail

alias flutter="fvm flutter"
alias dart="fvm dart"
# Ensure aliases are expanded in this non-interactive script
shopt -s expand_aliases

# Support a non-interactive mode for only running code generation
CODEGEN_ONLY=0
if [[ "${1:-}" == "--codegen-only" || "${1:-}" == "-c" ]]; then
  CODEGEN_ONLY=1
fi

flutter --version

echo "=== CONPUS development environment ==="

# 前回選択した環境を読み込む
LAST_ENV_FILE="/tmp/build_last_env.txt"
LAST_ENV=""
if [ -f "$LAST_ENV_FILE" ]; then
    LAST_ENV=$(cat "$LAST_ENV_FILE")
fi

# === 環境（ENV/FLAVOR）選択 ===
echo
echo "Select environment:"
echo "  1 -> Product"
echo "  2 -> Staging"
echo "  3 -> Dev"
echo "  4 -> Debug"
echo
read -rp "ENV: " env_input

case "$env_input" in
  1)
    ENV="CONPUS"
    FLAVOR="product"
    ICON_PATH="config/icons/prod"
    IOS_ENV_DIR="prod"
    ;;
  2)
    ENV="TestCONPUS"
    FLAVOR="staging"
    ICON_PATH="config/icons/staging"
    IOS_ENV_DIR="staging"
    ;;
  3)
    ENV="DevCONPUS"
    FLAVOR="dev"
    ICON_PATH="config/icons/dev"
    IOS_ENV_DIR="dev"
    ;;
  4)
    ENV="DebugCONPUS"
    FLAVOR="debugConpus"
    ICON_PATH="config/icons/debug"
    IOS_ENV_DIR="debug"
    ;;
  *)
    echo "Cancel"
    exit 1
    ;;
esac

# 今回選択した環境を保存
echo "$FLAVOR" > "$LAST_ENV_FILE"

# google-services.json の存在チェックとコピー
GOOGLE_SERVICES_JSON="config/google-services.json"
if [ ! -f "$GOOGLE_SERVICES_JSON" ]; then
    echo "===================================================================="
    echo "ERROR: Firebase configuration file not found."
    echo "File does not exist: $GOOGLE_SERVICES_JSON"
    echo "Please add the file and try again."
    echo "===================================================================="
    exit 1
fi
cp "$GOOGLE_SERVICES_JSON" android/app/.
echo "Copied $GOOGLE_SERVICES_JSON to android/app/."

# GoogleService-Info.plist の存在チェックとコピー
IOS_GOOGLE_SERVICES_PLIST="config/ios/$IOS_ENV_DIR/GoogleService-Info.plist"
IOS_DEST_PATH="ios/Runner/GoogleService-Info.plist"

if [ "$IOS_ENV_DIR" == "debug" ]; then
    if [ ! -f "$IOS_GOOGLE_SERVICES_PLIST" ]; then
        echo "===================================================================="
        echo "ERROR: iOS Firebase configuration file for debug not found."
        echo "File does not exist: $IOS_GOOGLE_SERVICES_PLIST"
        echo "Please add the file and try again."
        echo "===================================================================="
        exit 1
    fi
    cp "$IOS_GOOGLE_SERVICES_PLIST" "$IOS_DEST_PATH"
    echo "Copied $IOS_GOOGLE_SERVICES_PLIST to $IOS_DEST_PATH."
else
    if [ -f "$IOS_GOOGLE_SERVICES_PLIST" ]; then
        cp "$IOS_GOOGLE_SERVICES_PLIST" "$IOS_DEST_PATH"
        echo "Copied $IOS_GOOGLE_SERVICES_PLIST to $IOS_DEST_PATH."
    else
        if [ -f "$IOS_DEST_PATH" ]; then
            rm "$IOS_DEST_PATH"
            echo "Removed $IOS_DEST_PATH as no config was found for the '$IOS_ENV_DIR' environment."
        fi
    fi
fi


echo
# For interactive mode ask whether to clean
if [ "$CODEGEN_ONLY" -eq 0 ]; then
  if [ "$LAST_ENV" != "$FLAVOR" ]; then
      echo "Environment changed ($LAST_ENV -> $FLAVOR). Forcing clean."
      input="y"
  else
      read -rp "Clean? (y/N) [N]: " input
  fi
else
  # In codegen-only mode, we want to run codegen, so set input to 'y'
  input="y"
fi

# Helper: run build_runner in the given directory if pubspec contains codegen deps
run_build_runner_for_dir() {
  dir="$1"
  [ -f "$dir/pubspec.yaml" ] || return 0
  if grep -E -q "build_runner|json_serializable|json_annotation|chopper_generator|freezed" "$dir/pubspec.yaml"; then
    echo "Running build_runner in: $dir"
    pushd "$dir" > /dev/null
    if grep -q "^flutter:" pubspec.yaml; then
      flutter pub get
      flutter pub run build_runner build --delete-conflicting-outputs || { echo "build_runner failed in $dir"; popd > /dev/null; return 1; }
    else
      dart pub get
      dart run build_runner build --delete-conflicting-outputs || { echo "build_runner failed in $dir"; popd > /dev/null; return 1; }
    fi
    popd > /dev/null
  else
    echo "Skipping $dir (no codegen deps)"
  fi
}

if [ "$input" = "y" ]; then
  # Clean & get deps at root
  flutter clean && flutter pub get

  # Run build_runner at repo root if needed
  run_build_runner_for_dir "$(pwd)"

  # Run build_runner for each package under packages/* if needed
  if [ -d "packages" ]; then
    for pkg in packages/*; do
      [ -d "$pkg" ] || continue
      run_build_runner_for_dir "$pkg" || { echo "Code generation failed in $pkg"; exit 1; }
    done
  fi

  echo "Build success."
  cp -f "$ICON_PATH"/*.png assets/icons/.
  # Deprecated syntax flutter_launcher_icons:main removed; use new invocation
  if ! flutter pub run flutter_launcher_icons; then
    echo "Launcher icon generation failed."
    exit 1
  fi
fi

# If running only code generation, exit early now
if [ "$CODEGEN_ONLY" -eq 1 ]; then
  echo "Code generation completed (codegen-only). Exiting."
  exit 0
fi

# === ビルド種別選択 ===
echo
echo "Select build type:"
echo "  1 -> Android (aab)"
echo "  2 -> Android (apk)"
echo "  3 -> iOS (App Store/TestFlight)"
echo "  4 -> iOS (ad-hoc/enterprise)"
echo "  else -> Run on device/emulator"
echo
read -rp "Build: " build_input

# iOS用にFLAVORの先頭を大文字にする関数
to_ios_flavor() {
  local flavor="$1"
  echo "$(printf '%s' "$flavor" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')"
}

case "$build_input" in
  1)
    echo "Android (aab)"
    if [ "$ENV" != "CONPUS" ]; then
      flutter build appbundle --flavor "$FLAVOR" --dart-define=ENV=$ENV --debug
    else
      flutter build appbundle --flavor "$FLAVOR" --dart-define=ENV=$ENV
    fi
    open build/app/outputs/bundle
    ;;
  2)
    echo "Android (apk)"
    if [ "$ENV" != "CONPUS" ]; then
      flutter build apk --flavor "$FLAVOR" --dart-define=ENV=$ENV --debug
    else
      flutter build apk --flavor "$FLAVOR" --dart-define=ENV=$ENV
    fi
    open build/app/outputs/flutter-apk
    ;;
  3)
    echo "iOS (App Store/TestFlight)"
    IOS_FLAVOR=$(to_ios_flavor "$FLAVOR")
    flutter build ipa --flavor "$IOS_FLAVOR" --dart-define=ENV=$ENV
    open build/ios/ipa
    ;;
  4)
    echo "iOS (ad-hoc/enterprise)"
    IOS_FLAVOR=$(to_ios_flavor "$FLAVOR")
    flutter build ipa --flavor "$IOS_FLAVOR" --export-method=ad-hoc --dart-define=ENV=$ENV
    open build/ios/ipa
    ;;
  *)
    echo "Run on device or emulator:"

    CACHE_FILE="/tmp/flutter_devices_cache.txt"
    CACHE_DURATION_S=900

    flutter_devices_output=""
    should_fetch_devices=true

    # Check if a recent cache exists.
    if [ -f "$CACHE_FILE" ]; then
      # `stat` is used for checking file modification time. It's common on macOS/Linux.
      if command -v stat &> /dev/null; then
        cache_time=0
        # macOS `stat` uses -f %m, Linux `stat` uses -c %Y
        if [[ "$(uname)" == "Darwin" ]]; then
          cache_time=$(stat -f %m "$CACHE_FILE")
        else
          cache_time=$(stat -c %Y "$CACHE_FILE")
        fi
        current_time=$(date +%s)

        if [ $((current_time - cache_time)) -lt $CACHE_DURATION_S ]; then
          # Cache is recent. Ask user if they want to refresh.
          read -rp "Refresh device list? (y/N) [N]: " refresh_input
          if [[ ! "${refresh_input:-n}" =~ ^[Yy]$ ]]; then
            should_fetch_devices=false
          fi
        fi
      fi
    fi

    if [ "$should_fetch_devices" = true ]; then
      echo "Fetching device list..."
      flutter_devices_output=$(flutter devices 2>/dev/null || true)
      # Cache the new output
      echo "$flutter_devices_output" > "$CACHE_FILE"
    else
      echo "Using cached device list."
      flutter_devices_output=$(cat "$CACHE_FILE")
    fi

    # Collect raw device lines from `flutter devices` output
    devices_raw=$(echo "$flutter_devices_output" | grep -E 'android|ios' || true)

    if [ -z "$devices_raw" ]; then
      echo "No devices found."
      exit 1
    fi

    # Parse devices into entries of the form: device_id|info_text|platform
    device_entries=()
    while IFS= read -r line; do
      # skip empty lines
      [ -z "$line" ] && continue

      # Typical `flutter devices` line uses ' • ' as separator: "Name • id • platform • osVersion"
      device_id=$(echo "$line" | awk -F' • ' '{print $2}' | xargs)
      device_name=$(echo "$line" | awk -F' • ' '{print $1}' | xargs)
      platform=$(echo "$line" | awk -F' • ' '{print $3}' | xargs)
      os_info=$(echo "$line" | awk -F' • ' '{print $4}' | xargs)

      # Fallback: sometimes os info may be in the 3rd field
      if [ -z "$os_info" ]; then
        os_info=$(echo "$line" | awk -F' • ' '{print $3}' | xargs)
      fi

      # Build a readable info string like "iOS 17.0, iPhone 15 Pro"
      info_parts=()
      [ -n "$os_info" ] && info_parts+=("$os_info")
      [ -n "$device_name" ] && info_parts+=("$device_name")
      # Join with a comma + space reliably (avoid IFS first-char joining which can omit the space)
      info=""
      if [ ${#info_parts[@]} -gt 0 ]; then
        info="${info_parts[0]}"
        for ((j=1; j<${#info_parts[@]}; j++)); do
          info="$info, ${info_parts[j]}"
        done
      fi

      device_entries+=("$device_id|$info|$platform")
    done <<< "$devices_raw"

    # Print enumerated commands with the extra info
    for i in "${!device_entries[@]}"; do
      IFS='|' read -r id info platform <<< "${device_entries[$i]}"

      # コマンドの基本部分を定義
      base_args=("flutter" "run" "-d" "$id" "--dart-define=ENV=$ENV")

      # iOSかつproductでない場合のみflavorを追加
      if ! [[ "$platform" == *"ios"* && "$FLAVOR" == "product" ]]; then
        base_args+=("--flavor" "$FLAVOR")
      fi

      # 表示用のコマンド文字列を生成
      display_command=$(printf '%q ' "${base_args[@]}")

      if [ -n "$info" ]; then
        echo "$((i+1)). ${display_command% }, $info"
      else
        echo "$((i+1)). ${display_command% }"
      fi
    done

    read -rp "Select device by number: " device_number
    if [[ $device_number -gt 0 && $device_number -le ${#device_entries[@]} ]]; then
      IFS='|' read -r selected_device _ selected_platform <<< "${device_entries[$((device_number-1))]}"

      # コマンドを配列として一度だけ定義 (これが信頼できる情報源)
      run_args=("flutter" "run" "-d" "$selected_device" "--dart-define=ENV=$ENV")

      # iOSかつproductでない場合のみflavorを追加
      if ! [[ "$selected_platform" == *"ios"* && "$FLAVOR" == "product" ]]; then
        run_args+=("--flavor" "$FLAVOR")
      fi

      # 実行用の配列から、表示/コピー用の文字列を生成する
      # printf %q は引数をシェルが再解釈できる形式に安全にエスケープする
      command_str=$(printf '%q ' "${run_args[@]}")
      # 末尾の余分なスペースを削除
      command_str=${command_str% }

      read -rp "Run directly or copy to clipboard? [c/r] (default: r): " action
      action=${action:-r}

      if [ "$action" = "c" ]; then
        # コマンド文字列を安全にクリップボードへ
        printf '%s' "$command_str" | pbcopy
        echo "Command copied to clipboard."
      else
        # 配列でコマンド実行
        "${run_args[@]}"
      fi
    else
      echo "Invalid device number."
      exit 1
    fi
    exit
    ;;
esac

#!/bin/bash

set -euo pipefail

# === 1. 環境チェックとツールセットアップ ===
echo "=== Environment Check ==="

# fvm のチェックと自動インストール
FLUTTER_CMD="flutter"
if command -v fvm &> /dev/null; then
  FLUTTER_CMD="fvm flutter"
  echo "[✓] fvm is detected. Using 'fvm flutter'."
else
  echo "[!] fvm is not installed."
  read -rp "Would you like to install fvm (Flutter Version Management)? (y/N): " install_fvm
  if [[ "$install_fvm" =~ ^[Yy]$ ]]; then
    if command -v brew &> /dev/null; then
      echo "Installing fvm via Homebrew..."
      brew tap leoafarias/fvm
      brew install fvm
      FLUTTER_CMD="fvm flutter"
      echo "[✓] fvm installed successfully."
    else
      echo "[!] Homebrew not found. Please install fvm manually: https://fvm.app/docs/getting_started/installation"
      read -rp "Continue with standard 'flutter' command? (y/N): " continue_std
      if [[ ! "$continue_std" =~ ^[Yy]$ ]]; then
        exit 1
      fi
    fi
  else
    echo "Using standard 'flutter' command."
  fi
fi

# Support a non-interactive mode
CODEGEN_ONLY=0
if [[ "${1:-}" == "--codegen-only" || "${1:-}" == "-c" ]]; then
  CODEGEN_ONLY=1
fi

$FLUTTER_CMD --version

echo
echo "=== Flutter Project Build Script ==="

# === 2. 環境（ENV/FLAVOR）選択 ===
echo
echo "Select environment:"
echo "  1 -> Production"
echo "  2 -> Staging"
echo "  3 -> Development"
echo
read -rp "Select (1-3): " env_input

case "$env_input" in
  1)
    ENV="prod"
    FLAVOR="prod"
    ;;
  2)
    ENV="stg"
    FLAVOR="stg"
    ;;
  3)
    ENV="dev"
    FLAVOR="dev"
    ;;
  *)
    echo "Cancelled."
    exit 1
    ;;
esac

# === 3. 設定ファイルの同期 ===
copy_config_if_exists() {
  local src="$1"
  local dest="$2"
  if [ -f "$src" ]; then
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "[✓] Config synced: $src -> $dest"
  fi
}

echo
echo "--- Syncing Configuration Files ---"
# アイコンの同期
# 現状の構成に合わせて ic_demo_icon.png を参照するように修正
copy_config_if_exists "config/icons/$ENV/ic_demo_icon.png" "assets/icons/app_icon_ios.png"

# === 4. コード生成 (build_runner) ===
echo
if [ "$CODEGEN_ONLY" -eq 0 ]; then
  read -rp "Run 'flutter clean' and code generation? (y/N) [N]: " run_codegen
else
  run_codegen="y"
fi

run_build_runner_for_dir() {
  local dir="$1"
  [ -f "$dir/pubspec.yaml" ] || return 0
  if grep -E -q "build_runner|json_serializable|freezed|go_router_builder" "$dir/pubspec.yaml"; then
    echo "Running build_runner in: $dir"
    (cd "$dir" && $FLUTTER_CMD pub get && $FLUTTER_CMD pub run build_runner build --delete-conflicting-outputs)
  fi
}

if [[ "$run_codegen" =~ ^[Yy]$ ]]; then
  $FLUTTER_CMD clean
  $FLUTTER_CMD pub get

  # ネイティブアイコンの生成
  echo "Generating native icons..."
  $FLUTTER_CMD pub run flutter_launcher_icons

  run_build_runner_for_dir "."
  if [ -d "packages" ]; then
    for pkg in packages/*; do
      run_build_runner_for_dir "$pkg"
    done
  fi
  echo "Code generation completed."
fi

if [ "$CODEGEN_ONLY" -eq 1 ]; then
  exit 0
fi

# === 5. ビルド / 実行 ===
echo
echo "Select build type:"
echo "  1 -> Android (aab)"
echo "  2 -> Android (apk)"
echo "  3 -> iOS (App Store/TestFlight)"
echo "  else -> Run on Device"
echo
read -rp "Select: " build_input

case "$build_input" in
  1)
    $FLUTTER_CMD build appbundle --flavor "$FLAVOR" --dart-define=ENV="$ENV"
    ;;
  2)
    $FLUTTER_CMD build apk --flavor "$FLAVOR" --dart-define=ENV="$ENV"
    ;;
  3)
    $FLUTTER_CMD build ipa --flavor "$FLAVOR" --dart-define=ENV="$ENV"
    ;;
  *)
    # デバイス選択 (sampleのロジックをベースにリファイン)
    echo "Scanning for available devices..."
    CACHE_FILE="/tmp/flutter_devices_cache.txt"
    CACHE_DURATION_S=900
    should_fetch_devices=true

    if [ -f "$CACHE_FILE" ]; then
      if [[ "$(uname)" == "Darwin" ]]; then
        cache_time=$(stat -f %m "$CACHE_FILE")
      else
        cache_time=$(stat -c %Y "$CACHE_FILE")
      fi
      current_time=$(date +%s)
      if [ $((current_time - cache_time)) -lt $CACHE_DURATION_S ]; then
        read -rp "Refresh device list? (y/N) [N]: " refresh_input
        if [[ ! "${refresh_input:-n}" =~ ^[Yy]$ ]]; then
          should_fetch_devices=false
        fi
      fi
    fi

    if [ "$should_fetch_devices" = true ]; then
      flutter_devices_output=$($FLUTTER_CMD devices 2>/dev/null || true)
      echo "$flutter_devices_output" > "$CACHE_FILE"
    else
      echo "Using cached device list."
      flutter_devices_output=$(cat "$CACHE_FILE")
    fi

    # Android と iOS デバイスのみを抽出
    devices_raw=$(echo "$flutter_devices_output" | grep '•' | grep -Ei 'android|ios' || true)
    if [ -z "$devices_raw" ]; then
      echo "[!] No Android or iOS devices found."
      exit 1
    fi

    device_entries=()
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      id=$(echo "$line" | awk -F' • ' '{print $2}' | xargs)
      name=$(echo "$line" | awk -F' • ' '{print $1}' | xargs)
      platform=$(echo "$line" | awk -F' • ' '{print $3}' | xargs)
      os_info=$(echo "$line" | awk -F' • ' '{print $4}' | xargs || echo "")
      device_entries+=("$id|$name, $os_info|$platform")
    done <<< "$devices_raw"

    echo "Select device to run:"
    for i in "${!device_entries[@]}"; do
      IFS='|' read -r id info platform <<< "${device_entries[$i]}"
      echo "  $((i+1)) -> $info ($id)"
    done
    echo "  q -> Cancel"
    echo
    read -rp "Select (1-${#device_entries[@]}): " device_idx

    if [[ "$device_idx" == "q" ]]; then
      echo "Cancelled."
      exit 0
    fi

    if [[ ! "$device_idx" =~ ^[0-9]+$ ]] || [ "$device_idx" -lt 1 ] || [ "$device_idx" -gt "${#device_entries[@]}" ]; then
      echo "Invalid selection."
      exit 1
    fi

    IFS='|' read -r selected_id _ selected_platform <<< "${device_entries[$((device_idx-1))]}"

    # 実行引数の組み立て
    run_args=("-d" "$selected_id" "--flavor" "$FLAVOR" "--dart-define=ENV=$ENV")
    command_to_run="$FLUTTER_CMD run ${run_args[*]}"

    read -rp "Run directly or copy to clipboard? [c/r] (default: r): " action
    action=${action:-r}

    if [ "$action" = "c" ]; then
      if command -v pbcopy &> /dev/null; then
        printf "%s" "$command_to_run" | pbcopy
        echo "Command copied to clipboard."
      else
        echo "pbcopy not found. Command:"
        echo "$command_to_run"
      fi
    else
      echo "Executing: $command_to_run"
      $FLUTTER_CMD run "${run_args[@]}"
    fi
    ;;
esac

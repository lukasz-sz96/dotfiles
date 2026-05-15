#!/usr/bin/env bash
set -euo pipefail

ID="unknown"
NAME="unknown"
VARIANT_ID=""
ID_LIKE=""
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
fi

echo "OS: ${NAME} (${ID})"
if [[ -n "${VARIANT_ID}" ]]; then
  echo "Variant: ${VARIANT_ID}"
fi

case " ${ID} ${ID_LIKE} ${VARIANT_ID} " in
  *" fedora "*|*" bluefin "*|*" ublue "*)
    echo "Bluefin/Fedora-like OS detected."
    ;;
  *)
    echo "This does not look like a Bluefin/Fedora-like OS."
    ;;
esac

check_command() {
  local name="$1"
  local command_name="$2"

  if command -v "$command_name" >/dev/null 2>&1; then
    echo "ok: $name ($command_name)"
  else
    echo "missing: $name ($command_name)"
  fi
}

check_command "chezmoi" "chezmoi"
check_command "niri" "niri"

if command -v noctalia-shell >/dev/null 2>&1; then
  echo "ok: Noctalia shell (noctalia-shell)"
elif command -v qs >/dev/null 2>&1; then
  echo "ok: Quickshell is present (qs); Noctalia may be launched with qs -c noctalia-shell"
else
  echo "missing: Noctalia shell or Quickshell"
fi

check_command "Homebrew" "brew"
check_command "Flatpak" "flatpak"

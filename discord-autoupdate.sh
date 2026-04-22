#!/usr/bin/env bash
set -euo pipefail

log() { echo "[discord-autoupdate] $*"; }

if command -v dpkg >/dev/null 2>&1 && command -v apt-get >/dev/null 2>&1; then
  # Debian / Ubuntu / derivados: .deb oficial
  URL="https://discord.com/api/download?platform=linux&format=deb"
  TMPDIR="$(mktemp -d)"
  trap 'rm -rf "$TMPDIR"' EXIT

  DEB="$TMPDIR/discord.deb"
  curl -fsSL -o "$DEB" "$URL"

  NEW_VERSION="$(dpkg-deb -f "$DEB" Version)"
  CURRENT_VERSION="$(dpkg-query -W -f='${Version}' discord 2>/dev/null || true)"

  if [ "$NEW_VERSION" = "$CURRENT_VERSION" ]; then
    log "já atualizado ($CURRENT_VERSION)"
    exit 0
  fi

  log "atualizando: ${CURRENT_VERSION:-nenhum} -> $NEW_VERSION"
  DEBIAN_FRONTEND=noninteractive apt-get install -y "$DEB"

elif command -v pacman >/dev/null 2>&1; then
  # Arch / CachyOS / Manjaro / EndeavourOS: pacote oficial do repo extra
  pacman -Sy --noconfirm >/dev/null

  LATEST="$(pacman -Si discord 2>/dev/null | awk -F': ' '/^Version/ {print $2; exit}')"
  if [ -z "$LATEST" ]; then
    log "pacote 'discord' não encontrado nos repos"
    exit 1
  fi

  CURRENT="$(pacman -Qi discord 2>/dev/null | awk -F': ' '/^Version/ {print $2; exit}' || true)"

  if [ "$LATEST" = "$CURRENT" ]; then
    log "já atualizado ($CURRENT)"
    exit 0
  fi

  log "atualizando: ${CURRENT:-nenhum} -> $LATEST"
  pacman -S --noconfirm --needed discord

else
  echo "distro não suportada: precisa de apt/dpkg ou pacman" >&2
  exit 1
fi

# shellcheck shell=bash
REPOSITORY="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_BIN="$HOME/.local/bin"

link() {
  local src="$REPOSITORY/$1" dst="$HOME/$2"
  ln -sfn "$src" "$dst"
  echo "linked:  $dst -> $src"
}

seed_file() {
  local src="$REPOSITORY/$1" dst="$HOME/$2"
  if [ ! -e "$dst" ]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "seeded:  $dst"
  fi
}

install_command() {
  local src="$1" name="$2"
  ln -sfn "$src" "$LOCAL_BIN/$name"
  echo "command: $LOCAL_BIN/$name -> $src"
}

clone_or_pull() {
  local repo="$1" dest="$2" tmp
  if [ -d "$dest/.git" ]; then
    git -C "$dest" pull --ff-only
    echo "updated: $dest"
  elif [ -e "$dest" ] && [ -n "$(ls -A "$dest" 2>/dev/null)" ]; then
    tmp="$(mktemp -d)"
    git clone "$repo" "$tmp/src"
    cp -a "$tmp/src/." "$dest/"
    rm -rf "$tmp"
    echo "merged-clone: $dest"
  else
    mkdir -p "$(dirname "$dest")"
    git clone "$repo" "$dest"
    echo "cloned:  $dest"
  fi
}

register_vault() {
  python3 - "$1" <<'PY'
import json, sys, time, uuid, pathlib
vault = sys.argv[1]
p = pathlib.Path.home() / "Library/Application Support/obsidian/obsidian.json"
p.parent.mkdir(parents=True, exist_ok=True)
data = json.loads(p.read_text()) if p.exists() else {"vaults": {}}
if not any(v.get("path") == vault for v in data.get("vaults", {}).values()):
    data.setdefault("vaults", {})[uuid.uuid4().hex[:16]] = {
        "path": vault, "ts": int(time.time() * 1000), "open": True
    }
    p.write_text(json.dumps(data, indent=2))
    print(f"registered: {vault}")
else:
    print(f"already registered: {vault}")
PY
}

#!/usr/bin/env python3
"""Generate — or, with --check, verify — the plugin manifests and the marketplace catalogue.

One source of truth per pack: `plugins/<dir>/pack.yaml`. From it this script derives
`plugins/<dir>/.claude-plugin/plugin.json`, and from the set of pack directories it derives
`.claude-plugin/marketplace.json`. Nothing in those two files is edited by hand except a
plugin's `version`, which a release bumps in `plugin.json` (and which this script preserves).

Rules it enforces:
  * a plugin's name is its directory name (`meta-discipline-<x>`), and pack.yaml `name:`
    says the same — one name per pack, the repository's;
  * every directory under plugins/ has a catalogue entry, and every entry a directory;
  * description and licence come from pack.yaml; version lives only in plugin.json,
    never in the catalogue entry (Claude Code would silently prefer plugin.json);
  * `renames` in the catalogue is append-only history and is carried over untouched;
  * the CI conformance matrix names exactly the plugin directories.

Usage:
    python3 scripts/sync_manifests.py          # write the files
    python3 scripts/sync_manifests.py --check  # exit 1 if any file would change
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
PLUGINS = ROOT / "plugins"
CATALOGUE = ROOT / ".claude-plugin" / "marketplace.json"

MARKETPLACE_NAME = "meta-agentic"
HOMEPAGE = "https://meta-agentic.ai"
REPOSITORY = "https://github.com/meta-agentic/meta-disciplines"
OWNER = {"name": "meta-agentic", "url": HOMEPAGE}
CATALOGUE_DESCRIPTION = (
    "Discipline packs for Claude: each one a method, a standard of rigor and a checkable "
    "ledger for a field — agents, agile delivery, mathematics, physics, software engineering."
)
INITIAL_VERSION = "1.0.0"
PREFIX = "meta-discipline-"


def dump(obj: dict) -> str:
    return json.dumps(obj, indent=2, ensure_ascii=False) + "\n"


def pack_dirs() -> list[Path]:
    return sorted(p for p in PLUGINS.iterdir() if p.is_dir() and (p / "pack.yaml").is_file())


def plugin_manifest(pack: Path, errors: list[str]) -> dict:
    meta = yaml.safe_load((pack / "pack.yaml").read_text())
    name = pack.name
    if not name.startswith(PREFIX):
        errors.append(f"{name}: plugin directories are named {PREFIX}<discipline>")
    declared = str(meta.get("name", "")).strip()
    if declared != name:
        errors.append(f"{name}: pack.yaml name {declared!r} must equal the directory name")
    current = pack / ".claude-plugin" / "plugin.json"
    version = INITIAL_VERSION
    if current.is_file():
        version = json.loads(current.read_text()).get("version", INITIAL_VERSION)
    discipline = name[len(PREFIX):] if name.startswith(PREFIX) else name
    return {
        "name": name,
        "version": version,
        "description": " ".join(str(meta["description"]).split()),
        "author": OWNER,
        "homepage": HOMEPAGE,
        "repository": REPOSITORY,
        "license": meta.get("license", "MIT"),
        "keywords": ["meta-agentic", "discipline", discipline],
    }


def catalogue(packs: list[Path]) -> dict:
    previous = json.loads(CATALOGUE.read_text()) if CATALOGUE.is_file() else {}
    doc = {
        "name": MARKETPLACE_NAME,
        "description": CATALOGUE_DESCRIPTION,
        "owner": OWNER,
        "plugins": [
            {
                "name": p.name,
                "source": f"./plugins/{p.name}",
                "category": "discipline",
            }
            for p in packs
        ],
    }
    if previous.get("renames"):
        doc["renames"] = previous["renames"]
    return doc


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--check", action="store_true", help="verify only; exit 1 on drift")
    args = ap.parse_args()

    errors: list[str] = []
    packs = pack_dirs()
    wanted: dict[Path, str] = {}
    for pack in packs:
        wanted[pack / ".claude-plugin" / "plugin.json"] = dump(plugin_manifest(pack, errors))
    wanted[CATALOGUE] = dump(catalogue(packs))

    ci = ROOT / ".github" / "workflows" / "ci.yml"
    if ci.is_file():
        matrix = yaml.safe_load(ci.read_text())["jobs"]["conformance"]["strategy"]["matrix"]["pack"]
        expected = [p.name[len(PREFIX):] for p in packs]
        if sorted(matrix) != sorted(expected):
            errors.append(f".github/workflows/ci.yml: conformance matrix {sorted(matrix)} "
                          f"!= plugin directories {sorted(expected)}")

    stray = [p.name for p in PLUGINS.iterdir() if p.is_dir() and p not in packs]
    errors += [f"plugins/{s}: a plugin directory without pack.yaml" for s in stray]

    drift = [path for path, text in wanted.items()
             if not path.is_file() or path.read_text() != text]
    if args.check:
        for path in drift:
            errors.append(f"{path.relative_to(ROOT)}: out of date — run scripts/sync_manifests.py")
    else:
        for path in drift:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(wanted[path])
            print(f"wrote {path.relative_to(ROOT)}")

    for e in errors:
        print(f"✗ {e}", file=sys.stderr)
    if errors:
        return 1
    print(f"✓ {len(packs)} plugin manifests and the catalogue agree with pack.yaml")
    return 0


if __name__ == "__main__":
    sys.exit(main())

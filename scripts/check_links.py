#!/usr/bin/env python3
"""Published Markdown links, it does not wikilink.

A skill is read outside the Obsidian vault it was written in — by Claude as a plugin, by a
reader on GitHub — so `[[target|label]]` is text to them, not a link. This gate rejects any
wikilink under plugins/ and any relative Markdown link whose target does not exist, measured
from the file that carries it. Fenced and inline code are exempt from the link-resolution
check only; a wikilink anywhere fails.

Usage:
    python3 scripts/check_links.py   # exit 1 on any finding
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WIKILINK = re.compile(r"\[\[[^\]]+\]\]")
LINK = re.compile(r"\]\(([^)\s]+)\)")
FENCE = re.compile(r"```.*?```", re.S)
INLINE_CODE = re.compile(r"`[^`\n]*`")
SCHEME = re.compile(r"^[a-z][a-z0-9+.-]*:")


def check(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    rel = path.relative_to(ROOT)
    findings = [f"{rel}: wikilink {m.group(0)} — write a relative Markdown link"
                for m in WIKILINK.finditer(text)]
    prose = INLINE_CODE.sub("", FENCE.sub("", text))
    for m in LINK.finditer(prose):
        target = m.group(1)
        if SCHEME.match(target) or target.startswith("#"):
            continue
        if not (path.parent / target.split("#", 1)[0]).exists():
            findings.append(f"{rel}: broken link ({target})")
    return findings


def main() -> int:
    files = sorted((ROOT / "plugins").rglob("*.md")) + [ROOT / "README.md"]
    findings = [f for path in files if path.is_file() for f in check(path)]
    for f in findings:
        print(f"✗ {f}", file=sys.stderr)
    if findings:
        return 1
    print(f"✓ {len(files)} Markdown files: no wikilinks, every relative link resolves")
    return 0


if __name__ == "__main__":
    sys.exit(main())

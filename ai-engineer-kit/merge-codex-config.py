#!/usr/bin/env python3
"""Add the kit's optional Codex memory settings."""

from __future__ import annotations

import argparse
import difflib
import re
import shutil
import tomllib
from datetime import datetime, timezone
from pathlib import Path


BEGIN = "# BEGIN AI ENGINEER KIT"
END = "# END AI ENGINEER KIT"
BASE_BLOCK = f"""
{BEGIN}
[memories]
generate_memories = true
use_memories = true
disable_on_external_context = true
min_rate_limit_remaining_percent = 20
{END}
"""

def enable_memories_feature(text: str) -> str:
    section = re.search(r"(?m)^\[features\]\s*$", text)
    if section:
        end = re.search(r"(?m)^\[", text[section.end() :])
        section_end = section.end() + (end.start() if end else len(text[section.end() :]))
        body = text[section.end() : section_end]
        if re.search(r"(?m)^memories\s*=", body):
            return text
        return text[:section_end] + "memories = true\n" + text[section_end:]
    return text.rstrip() + "\n\n[features]\nmemories = true\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--config", type=Path, default=Path.home() / ".codex/config.toml")
    args = parser.parse_args()

    original = args.config.read_text() if args.config.exists() else ""
    has_begin = BEGIN in original
    has_end = END in original
    if has_begin != has_end:
        raise SystemExit("refusing to edit an incomplete AI engineer kit marker block")
    if has_begin:
        # Preserve the block byte-for-byte. Codex and plugins may insert their own
        # tables near the end of config.toml, including between these markers.
        rendered = original
    else:
        for header in ("[memories]",):
            if header in original:
                raise SystemExit(f"refusing to overwrite existing config table: {header}")
        rendered = enable_memories_feature(original).rstrip() + "\n" + BASE_BLOCK
    tomllib.loads(rendered)

    if args.dry_run:
        print("".join(difflib.unified_diff(original.splitlines(True), rendered.splitlines(True), fromfile=str(args.config), tofile=str(args.config))))
        return 0

    args.config.parent.mkdir(parents=True, exist_ok=True)
    if original != rendered:
        if args.config.exists():
            stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
            shutil.copy2(args.config, args.config.with_name(f"{args.config.name}.backup-{stamp}"))
        args.config.write_text(rendered)
        args.config.chmod(0o600)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

#!/usr/bin/env python3
"""Build compressed bundles + manifest for first-run unpack."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
from pathlib import Path


TEXT_EXTENSIONS = {".json"}
BINARY_EXTENSIONS = {".pdf"}
INCLUDE_ROOTS = [
    Path("assets/data"),
    Path("assets/pdfs"),
]


def discover_assets(repo_root: Path) -> list[str]:
    discovered: list[str] = []
    for include_root in INCLUDE_ROOTS:
        absolute_root = repo_root / include_root
        if not absolute_root.exists():
            continue
        for path in absolute_root.rglob("*"):
            if not path.is_file():
                continue
            if path.name.startswith("."):
                continue
            if path.suffix.lower() not in (TEXT_EXTENSIONS | BINARY_EXTENSIONS):
                continue
            discovered.append(path.relative_to(repo_root).as_posix())
    discovered.sort()
    return discovered


def _compressed_name_for(logical_path: str) -> str:
    safe = logical_path.replace("/", "__")
    return f"{safe}.gz"


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def build(version: int, repo_root: Path) -> None:
    out_dir = repo_root / "assets" / "data_packs"
    out_dir.mkdir(parents=True, exist_ok=True)
    for stale in out_dir.glob("*.gz"):
        stale.unlink()

    assets = discover_assets(repo_root)
    bundles: list[dict[str, object]] = []
    for logical in assets:
        source = repo_root / logical
        raw = source.read_bytes()
        compressed = gzip.compress(raw, compresslevel=9)
        compressed_name = _compressed_name_for(logical)
        compressed_rel = f"assets/data_packs/{compressed_name}"
        (repo_root / compressed_rel).write_bytes(compressed)

        bundles.append(
            {
                "logicalAssetPath": logical,
                "compressedAssetPath": compressed_rel,
                "outputRelativePath": logical,
                "sha256": sha256_hex(raw),
                "size": len(raw),
                "compressedSize": len(compressed),
            }
        )

    manifest = {"version": version, "bundles": bundles}
    (out_dir / "manifest.json").write_text(
        json.dumps(manifest, indent=2), encoding="utf-8"
    )
    print(f"Generated {len(bundles)} compressed bundles at {out_dir}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--version",
        type=int,
        default=1,
        help="Manifest version. Bump when data changes.",
    )
    args = parser.parse_args()
    repo_root = Path(__file__).resolve().parents[1]
    build(args.version, repo_root)


if __name__ == "__main__":
    main()

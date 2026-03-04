#!/usr/bin/env python3
"""Build compressed data bundles and manifest for first-run unpack."""

from __future__ import annotations

import argparse
import gzip
import hashlib
import json
from pathlib import Path


ASSETS = [
    "assets/data/beginners_lessons.json",
    "assets/data/primary_pals_lessons.json",
    "assets/data/the_answer_lessons.json",
    "assets/data/search_lessons.json",
    "assets/data/discovery_lessons.json",
    "assets/data/daybreak_lessons.json",
    "assets/data/primary_pals_teacher_guides.json",
    "assets/data/answer_teacher_guides.json",
    "assets/data/discovery_teacher_guides.json",
]


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def build(version: int, repo_root: Path) -> None:
    out_dir = repo_root / "assets" / "data_packs"
    out_dir.mkdir(parents=True, exist_ok=True)

    bundles: list[dict[str, object]] = []
    for logical in ASSETS:
        source = repo_root / logical
        raw = source.read_bytes()
        compressed = gzip.compress(raw, compresslevel=9)
        output_name = source.name
        compressed_name = f"{output_name}.gz"
        compressed_rel = f"assets/data_packs/{compressed_name}"
        (repo_root / compressed_rel).write_bytes(compressed)

        bundles.append(
            {
                "logicalAssetPath": logical,
                "compressedAssetPath": compressed_rel,
                "outputFileName": output_name,
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

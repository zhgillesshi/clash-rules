"""Validate rule providers and render an OpenClash overwrite fragment."""

from __future__ import annotations

import argparse
from pathlib import Path
from typing import Any

import yaml

DEFAULT_PROVIDER = "mine-proxy"
DEFAULT_GROUP = "auto"
PACKAGE_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_RULE_FILE = PACKAGE_ROOT / "rules" / "providers" / f"{DEFAULT_PROVIDER}.yaml"


def load_provider(path: Path) -> list[str]:
    """Load and validate a Mihomo classical rule provider."""
    try:
        document: Any = yaml.safe_load(path.read_text(encoding="utf-8"))
    except OSError as exc:
        raise ValueError(f"cannot read {path}: {exc}") from exc
    except yaml.YAMLError as exc:
        raise ValueError(f"invalid YAML in {path}: {exc}") from exc

    if not isinstance(document, dict) or set(document) != {"payload"}:
        raise ValueError(f"{path}: expected exactly one top-level key: payload")
    payload = document["payload"]
    if not isinstance(payload, list) or not payload:
        raise ValueError(f"{path}: payload must be a non-empty list")
    if not all(isinstance(rule, str) and "," in rule for rule in payload):
        raise ValueError(f"{path}: every payload entry must be a classical rule containing a comma")
    return payload


def render(provider_url: str, provider_name: str, group: str) -> str:
    """Render the fragment consumed by OpenClash Custom Clash Rules (Priority)."""
    fragment = {
        "rule-providers": {
            provider_name: {
                "type": "http",
                "behavior": "classical",
                "format": "yaml",
                "path": f"./{provider_name}.yaml",
                "url": provider_url,
                "interval": 86400,
            }
        },
        "rules": [f"RULE-SET,{provider_name},{group}"],
    }
    return yaml.safe_dump(fragment, allow_unicode=True, sort_keys=False)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    subcommands = parser.add_subparsers(dest="command", required=True)

    validate_parser = subcommands.add_parser("validate", help="validate a local provider file")
    validate_parser.add_argument("--file", type=Path, default=DEFAULT_RULE_FILE)

    render_parser = subcommands.add_parser("render", help="render an OpenClash priority overwrite fragment")
    render_parser.add_argument("--provider-url", required=True)
    render_parser.add_argument("--provider-name", default=DEFAULT_PROVIDER)
    render_parser.add_argument("--group", default=DEFAULT_GROUP)
    render_parser.add_argument("--file", type=Path, default=DEFAULT_RULE_FILE)

    args = parser.parse_args()
    payload = load_provider(args.file)
    if args.command == "validate":
        print(f"OK: {args.file} ({len(payload)} rules)")
        return

    print(render(args.provider_url, args.provider_name, args.group), end="")


if __name__ == "__main__":
    main()

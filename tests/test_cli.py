from pathlib import Path

import pytest
from clash_rules.cli import load_provider, render


def test_load_provider_accepts_classical_payload(tmp_path: Path) -> None:
    provider = tmp_path / "provider.yaml"
    provider.write_text("payload:\n  - DOMAIN-SUFFIX,example.com\n", encoding="utf-8")

    assert load_provider(provider) == ["DOMAIN-SUFFIX,example.com"]


def test_load_provider_rejects_non_classical_payload(tmp_path: Path) -> None:
    provider = tmp_path / "provider.yaml"
    provider.write_text("payload:\n  - example.com\n", encoding="utf-8")

    with pytest.raises(ValueError, match="classical rule"):
        load_provider(provider)


def test_render_targets_selected_group() -> None:
    output = render("https://example.com/rules.yaml", "mine-proxy", "auto")

    assert "url: https://example.com/rules.yaml" in output
    assert "- RULE-SET,mine-proxy,auto" in output

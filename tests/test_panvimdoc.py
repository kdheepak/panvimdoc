from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

import pytest  # pyright: ignore[reportMissingImports]
from pydantic import BaseModel, ConfigDict, TypeAdapter

ROOT = Path(__file__).resolve().parents[1]
TESTS_DIR = Path(__file__).resolve().parent
CASES_PATH = TESTS_DIR / "fixtures" / "render_cases.json"
TEST_DATE = "2026 April 12"


class RenderOptions(BaseModel):
    model_config = ConfigDict(frozen=True)

    toc: bool
    dedup_subheadings: bool
    treesitter: bool
    demojify: bool
    description: str | None
    vimversion: str
    ignore_rawblocks: bool
    shift_heading_level_by: int
    increment_heading_level_by: int
    doc_mapping: bool
    doc_mapping_project_name: bool


class RenderCase(BaseModel):
    model_config = ConfigDict(frozen=True)

    name: str
    input: str
    expected: str
    options: RenderOptions

    @property
    def input_path(self) -> Path:
        return TESTS_DIR / self.input

    @property
    def expected_path(self) -> Path:
        return TESTS_DIR / self.expected


def load_render_cases() -> list[RenderCase]:
    return TypeAdapter(list[RenderCase]).validate_json(
        CASES_PATH.read_text(encoding="utf-8")
    )


def metadata_arg(key: str, value: str | bool | int) -> str:
    rendered = str(value).lower() if isinstance(value, bool) else str(value)
    return f"--metadata={key}:{rendered}"


def normalize_output(text: str) -> str:
    return "\n".join(line.rstrip() for line in text.split("\n"))


def render_markdown(markdown: str, options: RenderOptions) -> str:
    with tempfile.TemporaryDirectory() as tmpdir:
        tmpdir_path = Path(tmpdir)
        input_path = tmpdir_path / "input.md"
        output_path = tmpdir_path / "output.txt"
        input_path.write_text(markdown, encoding="utf-8")

        command = [
            "pandoc",
            "--citeproc",
            f"--shift-heading-level-by={options.shift_heading_level_by}",
            metadata_arg("project", "test"),
            metadata_arg("vimversion", options.vimversion),
            metadata_arg("toc", options.toc),
            metadata_arg("dedupsubheadings", options.dedup_subheadings),
            metadata_arg("treesitter", options.treesitter),
            metadata_arg("ignorerawblocks", options.ignore_rawblocks),
            metadata_arg("incrementheadinglevelby", options.increment_heading_level_by),
            metadata_arg("docmappingproject", options.doc_mapping_project_name),
            metadata_arg("docmapping", options.doc_mapping),
            metadata_arg("date", TEST_DATE),
            f"--lua-filter={ROOT / 'scripts' / 'skip-blocks.lua'}",
            f"--lua-filter={ROOT / 'scripts' / 'include-files.lua'}",
        ]
        if options.description is not None:
            command.append(metadata_arg("description", options.description))
        if options.demojify:
            command.extend(
                [
                    f"--data-dir={ROOT / 'lib'}",
                    f"--lua-filter={ROOT / 'scripts' / 'remove-emojis.lua'}",
                ]
            )
        command.extend(
            [
                "-t",
                str(ROOT / "scripts" / "panvimdoc.lua"),
                str(input_path),
                "-o",
                str(output_path),
            ]
        )

        completed = subprocess.run(
            command,
            cwd=ROOT,
            capture_output=True,
            check=False,
            text=True,
        )
        if completed.returncode != 0:
            raise AssertionError(
                f"pandoc failed for {input_path.name}\nstdout:\n{completed.stdout}\nstderr:\n{completed.stderr}"
            )
        return normalize_output(output_path.read_text(encoding="utf-8"))


RENDER_CASES = load_render_cases()


@pytest.mark.parametrize("case", RENDER_CASES, ids=[case.name for case in RENDER_CASES])
def test_render_cases(case: RenderCase) -> None:
    actual = render_markdown(case.input_path.read_text(encoding="utf-8"), case.options)
    expected = case.expected_path.read_text(encoding="utf-8")
    assert actual == expected


def test_help_usage() -> None:
    completed = subprocess.run(
        [str(ROOT / "panvimdoc.sh"), "-h"],
        cwd=ROOT,
        capture_output=True,
        check=False,
        text=True,
    )
    assert completed.returncode == 0, completed.stderr
    assert "Usage:" in completed.stdout
    assert "Arguments:" in completed.stdout

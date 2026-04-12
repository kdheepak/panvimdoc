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


DEFAULT_RENDER_OPTIONS = RenderOptions(
    toc=True,
    dedup_subheadings=False,
    treesitter=True,
    demojify=False,
    description="Test Description",
    vimversion="NVIM v0.8.0",
    ignore_rawblocks=True,
    shift_heading_level_by=0,
    increment_heading_level_by=0,
    doc_mapping=True,
    doc_mapping_project_name=True,
)


def load_render_cases() -> list[RenderCase]:
    return TypeAdapter(list[RenderCase]).validate_json(
        CASES_PATH.read_text(encoding="utf-8")
    )


def metadata_arg(key: str, value: str | bool | int) -> str:
    rendered = str(value).lower() if isinstance(value, bool) else str(value)
    return f"--metadata={key}:{rendered}"


def normalize_output(text: str) -> str:
    return "\n".join(line.rstrip() for line in text.split("\n"))


def current_neovim_version() -> str:
    completed = subprocess.run(
        ["nvim", "--version"],
        cwd=ROOT,
        capture_output=True,
        check=False,
        text=True,
    )
    if completed.returncode != 0:
        raise AssertionError(f"nvim --version failed:\n{completed.stderr}")
    first_line = completed.stdout.splitlines()[0]
    if "-dev" in first_line:
        return first_line.split("-dev", maxsplit=1)[0]
    return first_line


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


def test_render_uses_current_neovim_version_when_vimversion_is_empty() -> None:
    actual = render_markdown(
        "# panvimdoc\n",
        DEFAULT_RENDER_OPTIONS.model_copy(
            update={"description": None, "vimversion": ""}
        ),
    )
    lines = actual.splitlines()
    assert lines[0] == "*test.txt*"
    assert lines[1].endswith(
        f"For {current_neovim_version()}    Last change: {TEST_DATE}"
    )


def test_panvimdoc_shell_uses_current_neovim_version_when_vimversion_is_omitted() -> (
    None
):
    project_name = "test-current-neovim"
    output_path = ROOT / "doc" / f"{project_name}.txt"

    with tempfile.TemporaryDirectory() as tmpdir:
        input_path = Path(tmpdir) / "input.md"
        input_path.write_text("# panvimdoc\n", encoding="utf-8")

        if output_path.exists():
            output_path.unlink()

        completed = subprocess.run(
            [
                str(ROOT / "panvimdoc.sh"),
                "--project-name",
                project_name,
                "--input-file",
                str(input_path),
                "--toc",
                "true",
                "--description",
                "",
                "--dedup-subheadings",
                "false",
                "--treesitter",
                "true",
                "--ignore-rawblocks",
                "true",
                "--doc-mapping",
                "true",
                "--doc-mapping-project-name",
                "true",
                "--demojify",
                "false",
                "--shift-heading-level-by",
                "0",
                "--increment-heading-level-by",
                "0",
                "--scripts-dir",
                str(ROOT / "scripts"),
            ],
            cwd=ROOT,
            capture_output=True,
            check=False,
            text=True,
        )
        try:
            assert completed.returncode == 0, completed.stderr
            actual = normalize_output(output_path.read_text(encoding="utf-8"))
        finally:
            if output_path.exists():
                output_path.unlink()

    lines = actual.splitlines()
    assert lines[0] == f"*{project_name}.txt*"
    assert f"For {current_neovim_version()}    Last change:" in lines[1]

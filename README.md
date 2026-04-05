# mcp-template

Copier template for scaffolding MCP (Model Context Protocol) server projects in Python.

## Usage

```bash
copier copy gh:obrien-matthew/mcp-template ./mcp-myservice
```

Or from a local clone:

```bash
copier copy ./mcp-template ./mcp-myservice
```

## What you get

- `src/{slug}_mcp/` with stub modules: server, client, auth, formatting, validation
- `tests/` with passing test stubs
- GitHub Actions CI (lint + test) and release (build + publish to PyPI)
- Lefthook pre-commit (ruff, pyright) and pre-push (pytest, version bump check)
- `uv` as the package manager and build backend

## After scaffolding

```bash
cd mcp-myservice
git init
uv sync
uv run pytest tests/ -x -q    # should pass
lefthook install
```

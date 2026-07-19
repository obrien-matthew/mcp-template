# mcp-template

Copier template for scaffolding Python MCP server projects under `obrien-matthew/mcp-*`.

## Conventions for generated servers

These conventions are shared by every server scaffolded from this template (mcp-plex,
mcp-pihole, mcp-spotify, mcp-stashapp, mcp-steam, mcp-garmin, mcp-mealie). When updating
the template, keep the example code and any added scaffolding consistent with them.

### Tool return types: real dicts/lists, not stringified JSON

FastMCP populates the `structuredContent` field of a tool result from the tool's return
value. When a tool is annotated `-> str` and returns `json.dumps(data, indent=2)`,
FastMCP wraps the string as `{"result": "<the json.dumps string>"}` -- clients see an
escape-laden blob (e.g. `"[\n  {\n    \"title\": ...}]"`) instead of structured data.

**Convention:**

- **Data tools** (search, list, get, paginated results): annotate `-> dict` or
  `-> list[dict]` and return the value directly. Do not call `json.dumps()`.
- **Action/status tools** (mark-done, scan, restart, delete-confirmation):
  `-> str` is fine when the result is inherently a human-readable confirmation
  message ("Marked X as watched.", "Job ID: job-1").
- **Errors:** raise the underlying exception. FastMCP catches it and emits a proper
  MCP error response with `isError=true`. Do not wrap tools in
  `try: ... except Exception: return f"Error: {e}"` -- that hides failures inside
  successful responses, defeats the protocol's error channel, and (when combined
  with `json.dumps`) double-encodes them.
- **Empty data:** prefer empty containers (`{}`, `[]`) over sentinel strings like
  `"No data available."` so downstream callers can treat absence-of-data
  uniformly with the typed shape.

### Why this matters

The MCP `structuredContent` field is the canonical typed channel; the `text` content
block is a backwards-compat fallback. When the structured side is "stringified JSON
inside a result wrapper," LLMs and clients can't navigate the data without re-parsing.
Returning real `dict`/`list` makes the structured side actually structured.

### When you must keep `-> str`

Some tools genuinely return a single string (e.g. `resolve_vanity_url` returning a
Steam ID, `get_server_version` returning a semver string). FastMCP wraps these as
`{"result": "value"}` -- still proper JSON, no escaping. That's fine and idiomatic.

## Maintenance

- The example tool in `template/src/{{service_slug}}_mcp/server.py.jinja` is
  intentionally minimal (only `get_server_version`). When extending the template
  with example domain tools, follow the convention above.
- The `formatting.py.jinja` stub is for a per-server response formatter module that
  shapes API responses into LLM-friendly dicts (without calling `json.dumps`).

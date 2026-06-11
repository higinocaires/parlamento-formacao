# Parlamento MCP Server

Simple [MCP](https://modelcontextprotocol.io/) server for the course **Module 3 Nice** requirement.  
Built with [`mcp_dart`](https://pub.dev/packages/mcp_dart) (same package as formação).

Exposes two tools that call the [votoaberto API](https://api.votoaberto.org/api/v1):

| Tool | Description |
|------|-------------|
| `list_deputies` | List deputies (optional `partido`, `limit`) |
| `get_deputy` | Deputy detail by `dep_cad_id` |

This is **separate from the Flutter app** — it runs as a small Dart process for AI hosts (Cursor, etc.).

## Setup

```bash
cd mcp_server
dart pub get
```

## Test in terminal

### A) Same data as the MCP tool (easy demo)

```powershell
cd mcp_server
dart run bin/demo_list.dart
```

Prints 3 deputies + total count from votoaberto.

### B) MCP server only (no tool output)

```powershell
dart run bin/parlamento_mcp.dart
```

Shows `Parlamento MCP server running on stdio` and **waits** — it speaks MCP protocol on stdin/stdout, not human text. **This is normal.**

### C) Test MCP tools with CLI

PowerShell **breaks JSON quotes** in `--json-args`. On Windows use the batch file:

```powershell
cd mcp_server
.\test_inspect.cmd
```

Or from **cmd.exe** (not PowerShell):

```cmd
cd mcp_server
mcp_dart inspect --tool list_deputies --json-args "{\"limit\": 3}" -- dart run bin/parlamento_mcp.dart
```

Or PowerShell via cmd:

```powershell
cmd /c "cd /d C:\Users\Joaoc\parlamento-formacao\mcp_server && mcp_dart inspect --tool list_deputies --json-args \"{\"\"limit\"\": 3}\" -- dart run bin/parlamento_mcp.dart"
```

Note the `-- dart run bin/parlamento_mcp.dart` at the end.

## Connect in Cursor

The project includes `.cursor/mcp.json` with the correct `cwd` (`mcp_server/`).

**Important:** `bin/parlamento_mcp.dart` lives inside `mcp_server/`, not the Flutter project root.  
If `cwd` points to `parlamento-formacao` you get: `Could not find file bin/parlamento_mcp.dart`.

### Option A — use project config (recommended)

1. Open workspace folder: `parlamento-formacao` (not only `mcp_server`)
2. **Cursor Settings → MCP** — enable project MCP or remove duplicate manual entry
3. Restart Cursor

### Option B — manual MCP entry

```json
{
  "mcpServers": {
    "parlamento": {
      "command": "dart",
      "args": ["run", "bin/parlamento_mcp.dart"],
      "cwd": "C:/Users/Joaoc/parlamento-formacao/mcp_server"
    }
  }
}
```

`cwd` **must** be the `mcp_server` folder (where `pubspec.yaml` is).

### Verify in terminal

```powershell
cd C:\Users\Joaoc\parlamento-formacao\mcp_server
dart pub get
dart analyze
```

Then ask Cursor to use `list_deputies` with `{"limit": 3}`.

## Demo tip

Tell the trainer: *"The Flutter app is for users; the MCP server exposes the same Parliament API as tools for AI assistants — list deputies and get deputy detail."*

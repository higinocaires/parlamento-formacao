@echo off
cd /d "%~dp0"
echo Testing MCP tool list_deputies (limit 3)...
mcp_dart inspect --tool list_deputies --json-args "{\"limit\": 3}" -- dart run bin/parlamento_mcp.dart
pause

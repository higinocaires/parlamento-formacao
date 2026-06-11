@echo off
cd /d C:\Users\Joaoc\parlamento-formacao\mcp_server
mcp_dart inspect --tool list_deputies --json-args "{""limit"": 3}" -c dart -a run -a bin/parlamento_mcp.dart

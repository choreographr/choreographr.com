+++
title = "MCP servers"
description = "Dynamic tool groups from Model Context Protocol servers."
weight = 10
+++

Choreographr is an MCP **client**. Configure servers in `mcp_servers.json`
(the daemon's config directory); at startup the daemon spawns each server,
discovers its tools, and registers them as a dynamic group `mcp/<slug>`. Tools
appear as `mcp/<slug>/<tool-name>` and are callable once the group is loaded
with `load_tools` — exactly like built-in tools, but dispatched to the MCP
server over JSON-RPC stdio.

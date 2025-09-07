#!/bin/bash

# OpenCode MCP Server Test Script
echo "=== OpenCode MCP Server Test Suite ==="
echo "Testing all MCP servers configured in .opencode/config.json"
echo ""

# Kill any existing OpenCode instances
echo "1. Stopping existing OpenCode instances..."
pkill -f opencode || true
sleep 2

echo ""
echo "2. Testing individual MCP servers with OpenCode CLI..."
echo ""

# Test 1: Playwright (Browser Automation)
echo "=== TEST: Playwright MCP (Desktop) ==="
opencode run -m openrouter/openai/gpt-5 --agent general "Use the Playwright MCP to navigate to https://example.com and return the page title. Use browser_navigate tool." || echo "FAILED: Playwright Desktop"
echo ""

# Test 2: Filesystem MCP
echo "=== TEST: Filesystem MCP ==="
opencode run -m openrouter/openai/gpt-5 --agent general "Use the Filesystem MCP to list files in the docs directory. Return the count of markdown files." || echo "FAILED: Filesystem"
echo ""

# Test 3: Sequential Thinking MCP
echo "=== TEST: Sequential Thinking MCP ==="
opencode run -m openrouter/openai/gpt-5 --agent general "Use the Sequential Thinking MCP to break down the task 'Implement user authentication' into 5 logical steps." || echo "FAILED: Sequential Thinking"
echo ""

# Test 4: Context7 MCP
echo "=== TEST: Context7 MCP (via Researcher) ==="
opencode run -m openrouter/google/gemini-2.5-pro --agent researcher "Use Context7 to find documentation about Next.js 14 App Router. Return the library ID and snippet count." || echo "FAILED: Context7"
echo ""

# Test 5: Perplexity MCP
echo "=== TEST: Perplexity MCP (via Researcher) ==="
opencode run -m openrouter/google/gemini-2.5-pro --agent researcher "Use Perplexity to research 'Next.js 14 Server Components best practices 2025'. Return top 3 findings." || echo "FAILED: Perplexity"
echo ""

# Test 6: BrightData MCP  
echo "=== TEST: BrightData MCP (via Researcher) ==="
opencode run -m openrouter/google/gemini-2.5-pro --agent researcher "Use BrightData to scrape the title and first paragraph from https://example.com. Do not save to file." || echo "FAILED: BrightData"
echo ""

echo "=== MCP Server Tests Complete ==="
echo ""
echo "3. Starting OpenCode TUI for manual testing..."
echo "In the TUI, you can test:"
echo "  - Tab through agents"
echo "  - Run: @researcher Test all MCP tools"
echo "  - Run: @validator Navigate to example.com and capture screenshot"
echo ""
echo "Starting OpenCode..."
opencode

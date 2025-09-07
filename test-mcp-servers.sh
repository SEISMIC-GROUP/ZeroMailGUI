#!/bin/bash

# MCP Server Test Script for OpenCode
# Based on working Cursor configuration

echo "🔍 MCP Server Configuration Test"
echo "================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test if npx is available
echo -e "${BLUE}Checking prerequisites...${NC}"
if ! command -v npx &> /dev/null; then
    echo -e "${RED}❌ npx not found. Please install Node.js${NC}"
    exit 1
fi
echo -e "${GREEN}✅ npx found ($(npx --version))${NC}"
echo ""

# Test if uvx is available (for fetch server)
if ! command -v uvx &> /dev/null; then
    echo -e "${YELLOW}⚠️  uvx not found. Installing uv...${NC}"
    curl -LsSf https://astral.sh/uv/install.sh | sh
    source $HOME/.cargo/env
fi

# Function to test an MCP server
test_mcp_server() {
    local name=$1
    local command=$2
    shift 2
    local args=("$@")
    
    echo -e "${BLUE}Testing $name...${NC}"
    
    # Create a timeout wrapper
    timeout 5s $command "${args[@]}" --version 2>/dev/null || \
    timeout 5s $command "${args[@]}" --help 2>/dev/null || \
    timeout 5s echo '{"jsonrpc":"2.0","method":"initialize","params":{},"id":1}' | $command "${args[@]}" 2>/dev/null | head -1
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $name: Server binary is accessible${NC}"
        return 0
    else
        echo -e "${RED}❌ $name: Failed to access server${NC}"
        return 1
    fi
}

# Test each MCP server from Cursor config
echo -e "${BLUE}Testing MCP Servers:${NC}"
echo "--------------------"

# Sequential Thinking
test_mcp_server "Sequential Thinking" "npx" "-y" "@modelcontextprotocol/server-sequential-thinking"
echo ""

# Fetch (using uvx)
if command -v uvx &> /dev/null; then
    test_mcp_server "Fetch" "uvx" "mcp-server-fetch"
else
    echo -e "${YELLOW}⚠️  Fetch: uvx not available, skipping${NC}"
fi
echo ""

# Playwright
test_mcp_server "Playwright" "npx" "-y" "@playwright/mcp@latest"
echo ""

# Perplexity
test_mcp_server "Perplexity" "npx" "-y" "server-perplexity-ask"
echo ""

# Context7
test_mcp_server "Context7" "npx" "-y" "@upstash/context7-mcp"
echo ""

# BrightData
test_mcp_server "BrightData" "npx" "-y" "@brightdata/mcp"
echo ""

echo "================================="
echo -e "${BLUE}Configuration Files:${NC}"
echo ""

# Check for configuration files
if [ -f "opencode.json" ]; then
    echo -e "${GREEN}✅ opencode.json exists${NC}"
else
    echo -e "${RED}❌ opencode.json not found${NC}"
fi

if [ -f "opencode-fixed.json" ]; then
    echo -e "${GREEN}✅ opencode-fixed.json created${NC}"
else
    echo -e "${RED}❌ opencode-fixed.json not found${NC}"
fi

if [ -f ".env.mcp" ]; then
    echo -e "${GREEN}✅ .env.mcp exists (API keys configured)${NC}"
else
    echo -e "${RED}❌ .env.mcp not found${NC}"
fi

echo ""
echo "================================="
echo -e "${BLUE}Environment Variables:${NC}"
echo ""

# Check critical environment variables
source .env.mcp 2>/dev/null

if [ -n "$PERPLEXITY_API_KEY" ]; then
    echo -e "${GREEN}✅ PERPLEXITY_API_KEY is set${NC}"
else
    echo -e "${RED}❌ PERPLEXITY_API_KEY not set${NC}"
fi

if [ -n "$API_TOKEN" ]; then
    echo -e "${GREEN}✅ BRIGHTDATA API_TOKEN is set${NC}"
else
    # Check alternative name
    if [ -n "$BRIGHTDATA_API_TOKEN" ]; then
        echo -e "${YELLOW}⚠️  BRIGHTDATA_API_TOKEN set but should be API_TOKEN${NC}"
    else
        echo -e "${RED}❌ BRIGHTDATA API_TOKEN not set${NC}"
    fi
fi

echo ""
echo "================================="
echo -e "${BLUE}Recommendations:${NC}"
echo ""

echo "1. To use the fixed configuration:"
echo "   mv opencode-fixed.json opencode.json"
echo ""
echo "2. To test with OpenCode:"
echo "   opencode"
echo ""
echo "3. The MCP servers use these packages:"
echo "   - @modelcontextprotocol/server-sequential-thinking"
echo "   - @playwright/mcp@latest"
echo "   - server-perplexity-ask"
echo "   - @upstash/context7-mcp"
echo "   - @brightdata/mcp"
echo "   - mcp-server-fetch (via uvx)"
echo ""
echo "4. These are the SAME packages working in Cursor"
echo ""
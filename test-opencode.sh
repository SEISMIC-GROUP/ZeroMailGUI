#!/bin/bash

echo "==================================="
echo "OpenCode Multi-Agent Test Suite"
echo "==================================="
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

# Function to run test
run_test() {
    if eval "$1"; then
        echo "✅ $2"
        ((TESTS_PASSED++))
    else
        echo "❌ $2"
        ((TESTS_FAILED++))
    fi
}

echo "1. DIRECTORY STRUCTURE TESTS"
echo "----------------------------"
run_test "test -d .opencode/agent" "Agent directory exists"
run_test "test -d .opencode/command" "Command directory exists"
echo ""

echo "2. CONFIG FILE VALIDATION"
echo "-------------------------"
run_test "cat .opencode/config.json | python3 -m json.tool > /dev/null 2>&1" "Config JSON is valid"
run_test "grep -q 'playwright' .opencode/config.json" "Playwright MCP configured"
run_test "grep -q 'context7' .opencode/config.json" "Context7 MCP configured"
run_test "grep -q 'perplexity-ask' .opencode/config.json" "Perplexity MCP configured"
run_test "grep -q 'drizzle' .opencode/config.json" "Drizzle MCP configured"
run_test "grep -q 'sequential-thinking' .opencode/config.json" "Sequential Thinking configured"
echo ""

echo "3. AGENT FILES VALIDATION"
echo "-------------------------"
AGENTS=("researcher" "build-gpt5" "build-opus" "context-perk" "planner" "assignment-analyzer" "browser-tester" "database-engineer" "claude-code" "codex")
for agent in "${AGENTS[@]}"; do
    run_test "test -f .opencode/agent/$agent.md" "$agent agent file exists"
done
echo ""

echo "4. COMMAND FILES VALIDATION"
echo "---------------------------"
COMMANDS=("researcher" "context-perk" "browser-tester" "claude-code" "codex")
for cmd in "${COMMANDS[@]}"; do
    run_test "test -f .opencode/command/$cmd.md" "/$cmd command file exists"
done
echo ""

echo "5. HARDCODED SUB-AGENT CALLS (@ mentions)"
echo "-----------------------------------------"
run_test "grep -q '@researcher' .opencode/agent/build-gpt5.md" "build-gpt5 invokes @researcher"
run_test "grep -q '@context-perk' .opencode/agent/build-gpt5.md" "build-gpt5 invokes @context-perk"
run_test "grep -q '@browser-tester' .opencode/agent/build-gpt5.md" "build-gpt5 invokes @browser-tester"
run_test "grep -q '@database-engineer' .opencode/agent/build-gpt5.md" "build-gpt5 invokes @database-engineer"
run_test "grep -q 'Sequential Thinking' .opencode/agent/build-opus.md" "build-opus uses Sequential Thinking"
run_test "grep -q '@researcher' .opencode/agent/planner.md" "planner invokes @researcher"
run_test "grep -q '@context-perk' .opencode/agent/planner.md" "planner invokes @context-perk"
run_test "grep -q '@browser-tester' .opencode/agent/assignment-analyzer.md" "assignment-analyzer invokes @browser-tester"
echo ""

echo "6. PLAYWRIGHT ISOLATION CONFIG"
echo "-------------------------------"
run_test "grep -q '\--isolated' .opencode/config.json" "Playwright --isolated flag set"
run_test "grep -q '\--headless' .opencode/config.json" "Playwright --headless flag set"
echo ""

echo "7. MCP SERVER AVAILABILITY"
echo "--------------------------"
run_test "command -v npx > /dev/null 2>&1" "npx is available"
echo ""

echo "==================================="
echo "TEST SUMMARY"
echo "==================================="
echo "✅ Tests Passed: $TESTS_PASSED"
echo "❌ Tests Failed: $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo "🎉 SUCCESS: All tests passed! OpenCode is properly configured."
    echo ""
    echo "Your multi-agent system is ready with:"
    echo "- Primary agents: build-gpt5, build-opus, planner"
    echo "- Subagents: researcher, context-perk, browser-tester, database-engineer, assignment-analyzer"
    echo "- All agents properly invoke subagents via @ mentions"
    echo "- Playwright configured with isolation for parallel testing"
    echo "- MCP servers configured for all tools"
    exit 0
else
    echo "⚠️ FAILURE: $TESTS_FAILED tests failed. Please fix the issues above."
    exit 1
fi
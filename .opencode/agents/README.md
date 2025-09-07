# OpenCode Agent Catalog & Orchestration Guide

## Agent Overview

OpenCode employs a multi-agent architecture optimized for parallel execution and specialized task handling. Each agent has distinct capabilities and resource allocations.

## Agent Profiles

### Primary Agent (Claude Opus 4.1)
**Model**: `openrouter/anthropic.claude-opus-4-1-20250805`  
**Context Window**: 8,000 tokens  
**Max Tokens**: 200,000

#### Responsibilities
- Architecture decisions and system design
- Complex code generation and refactoring
- Pull request reviews
- Documentation generation
- Critical path operations

#### Best For
- Large-scale refactoring
- New feature architecture
- Complex debugging
- Performance optimization
- Security audits

### Thinking Agent (GPT-5 High Reasoning)
**Model**: `openrouter/openai/gpt-5`  
**Context Window**: 6,000 tokens  
**Max Tokens**: 8,000  
**Reasoning Effort**: High

#### Responsibilities
- Problem decomposition
- Root cause analysis
- Architecture planning
- Validation strategies
- Complex algorithm design

#### Best For
- Debugging complex issues
- Planning multi-step operations
- Analyzing system bottlenecks
- Designing test strategies
- Optimization planning

### Task Agent (GPT-5)
**Model**: `openrouter/openai/gpt-5`  
**Context Window**: 4,000 tokens  
**Max Tokens**: 8,000  
**Reasoning Effort**: High

#### Responsibilities
- Focused implementation
- Unit test creation
- Integration testing
- Bug fixes
- Parallel subtask execution

#### Best For
- Implementing planned features
- Writing test cases
- Fixing identified bugs
- Database migrations
- API integrations

### Fast Agent (Claude Sonnet)
**Model**: `openrouter/anthropic.claude-sonnet-4-20250514-v1:0[1m]`  
**Context Window**: 2,000 tokens  
**Max Tokens**: 1,000,000

#### Responsibilities
- Quick clarifications
- Status checks
- Simple file operations
- Documentation updates
- Configuration changes

#### Best For
- Quick responses
- File listings
- Simple edits
- Status reports
- Configuration tweaks

## Orchestration Patterns

### Sequential Pattern
```
Primary → Thinking → Task → Fast
```
Use when tasks have strict dependencies.

### Parallel Pattern
```
     ┌─→ Task Agent 1 ─┐
     │                 │
Primary ─→ Task Agent 2 ─→ Aggregator
     │                 │
     └─→ Task Agent 3 ─┘
```
Use for independent subtasks.

### Hierarchical Pattern
```
Primary (Architecture)
    ├── Thinking (Analysis)
    │   └── Task (Implementation)
    └── Fast (Documentation)
```
Use for complex multi-level operations.

## Task Assignment Matrix

| Task Type | Primary Agent | Fallback | Parallelizable |
|-----------|---------------|----------|----------------|
| Architecture | Primary | Thinking | No |
| Bug Fix | Task | Primary | Yes |
| Testing | Task | - | Yes |
| Documentation | Fast | Primary | Yes |
| Research | Thinking | Primary | No |
| Refactoring | Primary | Task | Partial |
| Performance | Thinking | Primary | No |
| Security | Primary | - | No |

## Resource Allocation

### Token Budget per Agent
- **Primary**: 8,000 tokens/request
- **Thinking**: 6,000 tokens/request
- **Task**: 4,000 tokens/request
- **Fast**: 2,000 tokens/request

### Memory Limits
- **Per Agent**: 2GB max
- **Total Pool**: 6GB max
- **Browser Sessions**: 500MB each

### Concurrent Execution Limits
- **Max Agents**: 3 simultaneous
- **Browser Instances**: 5 max
- **API Calls**: 10/second

## Communication Protocol

### Task Queue Format
```json
{
  "taskId": "task-001",
  "type": "implementation",
  "agent": "task",
  "priority": 1,
  "dependencies": [],
  "input": {
    "description": "Implement user authentication",
    "context": "ref:context-001"
  },
  "constraints": {
    "timeout": 300000,
    "maxTokens": 4000
  }
}
```

### Context Handoff
```json
{
  "handoffId": "handoff-001",
  "fromAgent": "primary",
  "toAgent": "task",
  "context": {
    "summary": "Architecture decisions",
    "artifacts": ["design.md", "schema.sql"],
    "tokens": 3500
  },
  "timestamp": "2025-01-05T12:00:00Z"
}
```

## Agent Lifecycle

### Initialization
1. Load agent configuration
2. Verify MCP server connections
3. Allocate resources
4. Warm up browser pool
5. Ready for tasks

### Execution
1. Receive task from queue
2. Load context
3. Execute with MCP servers
4. Generate artifacts
5. Update queue status

### Cleanup
1. Save context to store
2. Release browser sessions
3. Archive artifacts
4. Update metrics
5. Release resources

## Performance Optimization

### Agent Selection
- Match task complexity to agent capability
- Consider current load and availability
- Factor in token costs
- Optimize for response time

### Load Balancing
- Round-robin for equal complexity tasks
- Priority queue for critical operations
- Dynamic reallocation on failure
- Health checks every 5 seconds

### Caching Strategy
- Cache Context7 responses (1 hour)
- Memoize thinking patterns
- Reuse browser sessions when safe
- Share static analysis results

## Monitoring & Metrics

### Key Performance Indicators
- Task completion rate
- Average execution time
- Token efficiency
- Error frequency
- Queue depth

### Health Checks
```bash
# Check agent status
opencode agents status

# View queue depth
opencode queue stats

# Monitor token usage
opencode tokens report

# Check browser pool
opencode browsers list
```

### Alerts
- Token usage > 80%
- Memory usage > 90%
- Error rate > 10%
- Queue depth > 50 tasks
- Response time > 30s

## Troubleshooting

### Common Issues

#### Agent Timeout
- Check task complexity
- Verify MCP server health
- Review token budget
- Consider task decomposition

#### Context Overflow
- Enable compression
- Prune old context
- Split into subtasks
- Use Fast agent for simple ops

#### Browser Pool Exhaustion
- Check for session leaks
- Verify cleanup routines
- Reduce concurrent tests
- Enable session recycling

## Best Practices

### Task Design
1. Keep tasks focused and atomic
2. Define clear success criteria
3. Provide sufficient context
4. Set realistic timeouts
5. Include rollback strategy

### Agent Coordination
1. Minimize context transfer
2. Use explicit dependencies
3. Implement proper error handling
4. Monitor resource usage
5. Plan for failure scenarios

### Performance Tips
1. Batch similar operations
2. Reuse browser sessions
3. Cache documentation lookups
4. Parallelize independent tasks
5. Compress large contexts

## Configuration Files

### Agent-Specific Configs
- `primary/config.json` - Primary agent settings
- `thinking/config.json` - Thinking agent settings
- `task/config.json` - Task agent settings
- `fast/config.json` - Fast agent settings

### Shared Configurations
- `orchestrator.json` - Orchestration rules
- `../mcp-config.json` - MCP server settings
- `../context/config.json` - Context management

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2025-01-05 | Initial release |

---

For detailed protocol information, see [OPENCODE.md](../OPENCODE.md)
# 🤖 OpenCode Agent Instructions

## Project Stack Context
All agents must understand and work with:
- **Next.js 14** with App Router (Server Components by default)
- **TanStack Query v5** for server state management  
- **Drizzle ORM** with PostgreSQL database
- **NextAuth v5** for authentication
- **TypeScript** with strict mode enabled
- **Playwright** for E2E testing
- **Tailwind CSS** & **shadcn/ui** for styling

## Agent Hierarchy

### Primary Agents (Orchestrators)
- **build-gpt5**: Main orchestrator using GPT-5
- **build-opus**: Advanced reasoning with Claude Opus 4.1
- **codex**: Code generation with Mistral Codestral

### Subagents (Specialists)
- **@researcher**: Research using Perplexity, Context7, BrightData
- **@context-perk**: Documentation with Context7 MCP
- **@claude-code**: Code review and security analysis
- **@browser-tester**: E2E testing with Playwright
- **@database-engineer**: Database operations with Drizzle
- **@assignment-analyzer**: Requirements analysis

## Mandatory Workflows

### All Primary Agents MUST:
1. Start with `@researcher` for requirements analysis
2. Verify with `@context-perk` for documentation
3. Implement based on research findings
4. Review with `@claude-code` for security
5. Test with `@browser-tester` for validation

### Subagent Invocation
Primary agents invoke subagents using @ mentions:
```
@researcher Analyze the requirements for [feature]
@context-perk Verify Next.js 14 patterns for [implementation]
@claude-code Review this code for security issues
@browser-tester Run E2E tests on desktop and mobile
```

## Development Standards

### Next.js 14 Patterns
- **Server Components first**: Use Client Components only when needed
- **App Router conventions**: Use proper file naming (page.tsx, layout.tsx)
- **Server Actions**: For mutations instead of API routes when possible
- **Streaming**: Use Suspense boundaries for better UX

### TanStack Query v5
- **Query keys**: Use consistent key patterns `['resource', 'action', params]`
- **SSR hydration**: Properly prefetch and dehydrate
- **Cache management**: Set appropriate staleTime and gcTime
- **Optimistic updates**: For better perceived performance

### Drizzle ORM
- **Type safety**: Always use inferred types from schema
- **Migrations**: Create proper migration files
- **Relations**: Define relationships in schema
- **Transactions**: Use for multi-table operations

### TypeScript Requirements
- **No `any` types**: Use proper typing or `unknown`
- **Strict mode**: All code must pass strict checks
- **Interfaces over types**: For object shapes
- **Proper generics**: For reusable components

## MCP Tool Usage

### Tool Assignments by Agent
- **researcher**: perplexity-ask, context7, brightdata
- **context-perk**: context7 (primary tool)
- **browser-tester**: playwright-a (desktop), playwright-b (mobile)
- **database-engineer**: drizzle, database operations
- **assignment-analyzer**: sequential-thinking
- **claude-code**: code analysis tools

### Playwright Isolation
- Two isolated instances prevent conflicts
- Desktop viewport: 1920x1080
- Mobile viewport: 390x844
- Always test both viewports

## Quality Gates

Before any code is considered complete:
- [ ] TypeScript compilation passes (no errors)
- [ ] ESLint passes (no errors or warnings)
- [ ] All tests pass (unit, integration, E2E)
- [ ] Documentation updated via @context-perk
- [ ] Security review by @claude-code
- [ ] Performance benchmarks met
- [ ] Accessibility standards met (WCAG 2.1 AA)

## Parallel Development

For handling 20+ PRs per day:
- Each OpenCode instance runs in separate directory
- Primary agents orchestrate work
- Subagents handle specialized tasks
- Proper git branch management
- Automated testing before merge

## Temperature Guidelines

- **0.1-0.2**: Deterministic tasks (testing, reviewing)
- **0.2-0.3**: Code generation and implementation
- **0.3-0.4**: Planning and architecture
- **0.4-0.5**: Research and exploration

## Context Management

- Primary agents get high-level context
- Subagents receive focused, task-specific context
- Use Context7 as source of truth for dependencies
- Maintain documentation parity with code

## Error Handling

When errors occur:
1. Use sequential-thinking to analyze
2. Research solution with @researcher
3. Verify fix with @browser-tester
4. Document resolution

## Performance Targets

- **Core Web Vitals**: LCP < 2.5s, FID < 100ms, CLS < 0.1
- **Build time**: Under 2 minutes
- **Test execution**: Under 5 minutes
- **Bundle size**: Under 200KB initial

## Security Requirements

- All inputs validated with Zod
- SQL injection prevented via Drizzle
- XSS protection enabled
- CSRF tokens implemented
- Environment variables properly managed
- No secrets in code

---

Remember: **Quality over speed**. Use subagents to ensure comprehensive implementation.
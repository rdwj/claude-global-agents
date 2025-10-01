# Specialized AI Subagents for Claude Code

This directory contains specialized AI subagents for Claude Code. Each subagent is focused on a specific domain with dedicated tools and expertise.

**For complete documentation, installation instructions, and workflow information, see the [main README](../README.md).**

## Available Subagents

### Architecture & Design
- `solution-architect.md` - High-level architectural decisions and technology stack recommendations
- `proposal-writer.md` - Create comprehensive technical proposals
- `architecture-reviewer.md` - Validate proposals against project architecture
- `microservices-architect.md` - Microservices patterns and distributed systems

### Security
- `security-compliance-scanner.md` - Security vulnerability analysis and FIPS compliance
- `security-reviewer.md` - Security review of proposals and implementations

### Development & Implementation
- `story-scaffolder.md` - Create code structure and stubs from user stories
- `scaffold-filler.md` - Implement logic in scaffolded code
- `senior-code-reviewer.md` - Comprehensive code review for quality and compliance
- `claude-worker.md` - General-purpose worker for delegated tasks
- `codebase-master.md` - Prevent duplicate implementations, maintain code awareness

### Testing & Quality
- `test-execution-analyst.md` - Design and analyze testing strategies

### Documentation
- `documentation-architect.md` - Create and improve technical documentation

### Deployment & Operations
- `openshift-deployment-engineer.md` - OpenShift deployment manifests and GitOps
- `gitops-argocd-specialist.md` - ArgoCD configuration and GitOps workflows

### Technology-Specific
- `react-nextjs-architect.md` - React and Next.js application development
- `react-native-ux-designer.md` - React Native mobile UI/UX design
- `streamlit-app-developer.md` - Streamlit data applications
- `langgraph-adversarial-architect.md` - LangGraph workflows with validation
- `mcp-protocol-expert.md` - Model Context Protocol server development
- `neo4j-graphrag-architect.md` - Graph database schemas for RAG systems
- `llama-prompt-engineer.md` - Prompt optimization for Meta Llama models
- `granite-prompt-engineer.md` - Prompt optimization for IBM Granite models

### Specialized Tools
- `dependency-analyzer-python.md` - Python dependency analysis and security audits

## Quick Start

```bash
# Install all subagents (user-level)
cp -R agents/* ~/.claude/agents/

# Or install for specific project
cp -R agents/* .claude/agents/
```

## Usage

Subagents are invoked automatically by Claude Code when needed, or you can request them explicitly:

```
"Use the codebase-master subagent to check if we already have this functionality"
"Ask the security-compliance-scanner to review this for FIPS compliance"
```

## Creating Custom Subagents

Use the `/agents` command in Claude Code for interactive subagent creation, or manually create a Markdown file with YAML frontmatter:

```markdown
---
name: my-custom-agent
description: Brief description of what this agent does
tools:
  - Read
  - Write
  - Bash
---

# Agent system prompt

Your specialized instructions here...
```

## Contributing

See the [main README](../README.md#contributing) for contribution guidelines.

## License

MIT License - See [LICENSE](../LICENSE) for details.

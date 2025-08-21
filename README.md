## AI Agents for Claude Code

A curated collection of role definition documents for specialized AI assistants ("agents"). Each file in `agents/` describes a focused persona with clear responsibilities and constraints to accelerate high‑quality work across architecture, security, GitOps, testing, documentation, and more.

### Use with Claude Code

These agents are designed to be used with Claude Code. To make them available in Claude Code, copy the Markdown files from this repository into your local Claude agents directory.

#### Quick start

```bash
mkdir -p ~/.claude/agents
cp -R agents/* ~/.claude/agents/
```

- Open Claude Code and choose from your available agents. The copied files will appear by their filenames.
- To update an agent, edit the file in this repo and re‑copy it to `~/.claude/agents/`.

#### Sync script (optional)

Use the helper script to sync all agent files automatically. It detects whether the files are at the repo root or inside an `agents/` subdirectory and excludes non‑agent files.

```bash
./sync-agents.sh              # sync to ~/.claude/agents
./sync-agents.sh /custom/dir  # sync to a custom destination
```

### Contents

- `agents/`: Individual agent role specifications as Markdown files (one per specialty)
  - Examples: dependency analysis, GitOps/ArgoCD, security/compliance, LangGraph, React/Next.js, OpenShift deployment, and others

### Contributing

Contributions are welcome:
- Keep files concise and focused; prefer clarity over breadth.
- Use consistent headings and imperative, action‑oriented guidance.
- Avoid duplication across agents; factor shared guidance into a single agent when possible.
- Submit PRs with a short rationale for the changes.

### License

This project is licensed under the MIT License. See `LICENSE` for details.

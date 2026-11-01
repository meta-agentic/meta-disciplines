# Privacy

The meta-discipline plugins in this repository (`meta-discipline-agents`, `meta-discipline-agile`, `meta-discipline-math`, `meta-discipline-physics` and `meta-discipline-swe`) collect, store and send no data.

- **What they are.** Each plugin is a set of skills: Markdown instructions that Claude reads when a task matches them. One skill, `agile-swarm`, also ships a shell script (`scripts/pr-body-check.sh`) that checks a pull request body on your machine before you post it. It makes no network calls.
- **No collection.** The plugins have no servers, MCP connectors, telemetry, analytics or accounts. Meta-Agentic receives nothing when you install or use them.
- **Your conversations.** Whatever you and Claude do with a skill happens inside your own Claude session and is governed by your agreement with Anthropic, not by these plugins.
- **Downloads.** Installing a plugin downloads it from GitHub, under GitHub's own privacy terms.

Terms of use: the plugins are provided under the [MIT licence](LICENSE), as is, without warranty.

Questions: open an issue at <https://github.com/meta-agentic/meta-disciplines/issues>.

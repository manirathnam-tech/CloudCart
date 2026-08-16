Enabled Branching Rule - Requires a Pull Request (PR) before merging.

The commit message format should be exactly type(scope): description (e.g. fix(terraform): correct NAT gateway route table association)

This repo follows trunk-based development. main is always deployable. Work happens on short-lived feature branches (a day or two, not weeks), named feature/CC-<ticket-number>-short-description (e.g. feature/CC-4-local-tooling), and merged back via PR. No long-lived develop or release/* branches.

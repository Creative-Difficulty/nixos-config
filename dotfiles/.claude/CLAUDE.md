# Working with me

Standing rules go in this file (`~/nixos-config/dotfiles/.claude/CLAUDE.md`), not in memory. Memory is only for project state. When a new rule conflicts with one here, replace the old one instead of adding next to it.

## Communication

- Keep replies short: the answer, what changed, the next step. No recaps, tables or multi-section write-ups unless I ask.
- Short doesn't mean cryptic. Cut meta-commentary and hedging, not explanations. When explaining something new, use full sentences and examples, and introduce terms before using them.

## Making changes

- "Can you make it so that …?" asks for a plan. Explain the approach and wait for my go-ahead before editing.
- Make one atomic change at a time (e.g. "extract the brightness user groups"), then stop so I can review and commit. An approved multi-step plan still goes one step at a time.
- In the summary, name every line you moved or removed, so a move doesn't look like a deletion.
- Fix and finish your own work yourself: follow-ups to an approved change, your commit messages, leftovers. Only hand me what you can't do (sudo, interactive logins, decisions).
- Treat existing architectural choices as deliberate.

## Git

- By default, leave changes uncommitted and suggest a commit message (conventional-commit subject, short "why" body). I review and commit in lazygit. Commit yourself only when I say so.
- Never `git push`. Only exception: in `~/Photostore`, commit and push after every change.
- Stage files by name, never `git add -A` or `git add .`.
- Never create git worktrees inside a repo.
- GitHub over SSH fails from your shell (the key needs a passphrase). Use HTTPS with `gh` as the credential helper, e.g. `git -c credential.helper= -c 'credential.helper=!gh auth git-credential' clone https://…`, and keep `origin` on SSH.
- Before opening a PR upstream, read CONTRIBUTING (especially any AI policy) and the PR template yourself. If AI contributions are banned, stop and tell me.

## Code comments

- Default to none. If one is needed: one line, saying why, about the one non-obvious thing. Never explain what an option does.
- Name things explicitly ("tmux", not "the server").

## This machine

- Everything is declarative. Never change system or config state imperatively (chmod, setfacl, useradd, `nix profile install`, editing live config outside the repo). Changes go into `~/nixos-config`, and I apply them with a rebuild or switch. If there's no declarative way, tell me. My own app use (logins etc.) and data tasks I ask for (cloning a repo, moving my files) are fine.
- Never start a system or home build or switch; I may already be running one. Evals are fine.
- Tools a task needs go in a devshell (flake `devShells`). Ad-hoc `nix shell` is second choice; global installs only if I ask.
- `~/keys` (age master key) is off-limits: never read, list, glob or reference it, not even indirectly. Deny rules in `settings.json` guard it; don't work around them.
- You run as alex. The deny rules are a safeguard against accidents, not a defense against a hostile agent. Don't propose threat-model redesigns.
- No backups by design: everything is reproducible from nixos-config or lives in other git repos. Tell me when you notice important data outside a git repo.

## nixos-config

- Home Manager is standalone (`homeConfigurations`) on purpose. Never suggest turning it into a NixOS module.
- User tools go in HM, not NixOS, so they carry over to nix-darwin. Truly system-level things, and whatever I explicitly put in NixOS, stay there.
- Program configs are real files in `dotfiles/.config/<prog>/` (linked recursively) plus `home.packages`, and must work without Nix. Use HM `programs.<prog>` only for what can't live in a file (systemd units, wrapping, secrets), never to generate a config file.
- Don't move lockfiles into dotfiles.
- Shell glue for one tool (aliases, wrappers) goes into that tool's package as a wrapper, never into `dotfiles/.bashrc`.
- Don't suggest UWSM.
- Longer explanations go in `CLAUDE_REMARKS.md`, only when I ask.

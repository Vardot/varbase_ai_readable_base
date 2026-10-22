# AGENTS.md

Guidance for AI coding agents working on the Varbase AI Readable Base recipe.

This is a **private** recipe on GitHub (`Vardot/varbase_ai_readable_base`), not a drupal.org project. Issues,
pull requests and CI all live on GitHub. Never make it public or mirror it.

## Before you start

- **`CHANGELOG.md`**: what changed in each release, newest first, and where it was checked.
- **Pull requests and issues** on [github.com/Vardot/varbase_ai_readable_base](https://github.com/Vardot/varbase_ai_readable_base).
- **`README.md`**: what the recipe adds, the required `settings.php` line for Fast 404, and the known gaps.

## When you make a change

- One issue and one pull request per change. The PR says `Closes #<issue>` and ends with the Checkpoints list from
  `.github/pull_request_template.md`.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- CI must be green before merging: `.github/workflows/ci.yml` applies the recipe twice on a real Varbase 11 site
  (the second apply must change no config), runs the inline drush checks, then checks `/llms.txt` and the Markdown
  output over **real HTTP**, then the functional tests in `tests/features`.
- **Check over HTTP, never only with drush.** Fast 404 blocks `*.txt` before routing, and a drush request does not
  pass through it, so a drush-only check goes green on a site that serves a 404.
- A recipe cannot set `$settings`: the `fast404_exts` line stays a documented step in the README, and CI adds it the
  same way a site owner would.
- Do not install `markdownify_views` until a release contains https://www.drupal.org/i/3590402.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file. The lint job fails on any.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment (`1.0.0`)
  and are never moved once pushed.

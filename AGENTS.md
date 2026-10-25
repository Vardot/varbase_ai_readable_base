# AGENTS.md

Guidance for AI coding agents working on the Varbase AI Readable Base recipe.

This is a drupal.org project: [drupal.org/project/varbase_ai_readable_base](https://www.drupal.org/project/varbase_ai_readable_base).
Issues live in its [issue queue](https://www.drupal.org/project/issues/varbase_ai_readable_base) and merge requests on
[git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_readable_base). Its default branch is `1.0.x`; the
GitHub repository is a mirror and takes no issues or pull requests.

## Before you start

- **Documentation** lives on the Varbase docs site: [docs.varbase.vardot.com](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-readable-base). Keep `README.md` short and link there; add no `docs/` folder.
- **`CHANGELOG.md`**: what changed in each release, newest first, and where it was checked.
- **Issues and merge requests** on [drupal.org](https://www.drupal.org/project/issues/varbase_ai_readable_base).

## When you make a change

- One drupal.org issue and one issue-fork merge request per change, titled `<type>: #<issue> Summary`. The MR
  description ends with the Checkpoints list from `.gitlab/merge_request_templates/default.md`.
- CI must be green before merging: `.gitlab-ci.yml` on git.drupalcode.org validates `composer.json` and lints
  every YAML file.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- **Check over HTTP, never only with drush.** Fast 404 blocks `*.txt` before routing, and a drush request does not
  pass through it, so a drush-only check goes green on a site that serves a 404.
- A recipe cannot set `$settings`: the `fast404_exts` line stays a documented step in the README, and CI adds it the
  same way a site owner would.
- Do not install `markdownify_views` until a release contains https://www.drupal.org/i/3590402.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file. The lint job fails on any.
- All configuration lives in `recipe.yml` and the recipe's own `config/`, never in `config/install` or `config/optional`.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment (`1.0.0`)
  and are never moved once pushed.

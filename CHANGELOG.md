# Changelog

All notable changes to the Varbase AI Readable Base recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- The recipe: `/llms.txt` from the site name, slogan, main and footer menus, and a Markdown version
  of every node and taxonomy term, on llms_txt 1.1 and Markdownify 1.2 (with `markdownify_path` and
  `markdownify_file_attachment`, without `markdownify_views`). Grants the admin permissions to SEO and site admins.
  The README documents the `settings.php` line Fast 404 needs, which a recipe cannot set (#1).
- GitHub Actions CI: lint, then a Varbase 11 site (Varbase Starter) that applies the recipe twice with no config
  change on the second apply, checks it with drush, adds the Fast 404 line, and fails unless `/llms.txt` and the
  Markdown of a page answer 200 `text/markdown` over HTTP; then the functional tests in `tests/features` (#1).

### Checked
- By hand on a Varbase Starter site (Drupal 11.4.9, llms_txt 1.1.1, Markdownify 1.2.0, Fast 404 3.7.0): applied
  twice, identical config export, every request in the README table as listed, no new log errors.
- On a fresh Varbase Starter ~1.0.0 build from the Vardot Workspace (`vardot/varbase` 11.0.0, Drupal 11.4.9): the
  same checks pass, and a Starter blog post's Markdown carries its full body (#1).

### Fixed
- The Markdown of a basic page, book page or announcement is its content only: Markdownify renders the `search_index`
  view mode, since a Canvas content template makes the full view mode the whole layout, sidebar and all (#3).
- The install steps rebuild caches before applying. Applying straight after `composer require` failed with
  `"llms_txt" is not a known module or theme` on a fresh site, because Drupal's module list was still cached (#1).

### Known issues
- On Varbase Starter the Markdown of a post also carries the breadcrumb, a lazy-load placeholder image and the
  Share links, which point at `/markdownify/node/<nid>` (#1).

[Unreleased]: https://github.com/Vardot/varbase_ai_readable_base/commits/1.0.x

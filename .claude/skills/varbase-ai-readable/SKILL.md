---
name: varbase-ai-readable
description: "Apply, repair and verify Varbase AI Readable on a Varbase 11 site: /llms.txt and a Markdown version of every content item and term (Varbase AI Readable Base). Install and apply commands, inputs, config, post-apply steps, browser checks, traps and versions, read from the recipe code. Use when adding, fixing or checking Varbase AI Readable."
---

# Varbase AI Readable

Read from `recipe.yml`, `composer.json`, README, CHANGELOG and `git log` at the latest tag, 28 October 2026. Re-check versions on drupal.org before relying on them. For the full Varbase AI apply order, see the Varbase AI recipes docs page.

## Recipes

| Recipe | Latest | Stability | Require |
|---|---|---|---|
| `varbase_ai_readable_base` | 1.0.0-beta1 | beta | `drupal/varbase_ai_readable_base:~1` |

Docs (the code wins where they differ):
- https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-readable-base

## What it does

- Installs `node`, `taxonomy`, `path`, `file`, `text`, `llms_txt`, `markdownify`, `markdownify_path`, `markdownify_file_attachment`. Configures `llms_txt.settings` (site name, slogan, main and footer menus) and `markdownify.settings`; grants `seo_admin`, `site_admin`.
- Markdown at `<path>.md` or with `Accept: text/markdown`.
- Composer: `llms_txt ~1.1`, `markdownify ~1.2` (both stable). No inputs. Needs no AI provider.

## Apply

All commands in DDEV, from the project root; recipes are applied from the docroot path `../recipes/<name>`. Take a snapshot first: `ddev snapshot --name before-varbase-ai-readable`. Add each recipe to `extra.drupal-recipe-unpack.ignore` in `composer.json` before requiring it (read the list first: `composer config --json` replaces it).

```bash
ddev composer require drupal/varbase_ai_readable_base:~1
ddev drush cr                                   # before the apply, or "not a known module"
ddev drush recipe ../recipes/varbase_ai_readable_base -y
```

Then add to `settings.php` (a recipe cannot), and `ddev drush cr`:

```php
$settings['fast404_exts'] = '/^(?!\/robots)^(?!\/llms\.txt$)^(?!\/system\/files).*\.(txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
```

If the site already sets `fast404_exts`, add `^(?!\/llms\.txt$)` to its pattern instead.

## After the apply

- None beyond the settings.php line.

## Verify

- `curl -sk https://<project>.ddev.site/llms.txt` answers 200 with the site name and menus.
- `curl -sk -H 'Accept: text/markdown' https://<project>.ddev.site/<alias>` returns Markdown; `<alias>.md` too.

Test as a real editor or visitor, not user 1: a superuser bypasses permissions.

## Traps

- Without the `fast404_exts` line, Varbase's fast_404 answers 404 for `/llms.txt`.

## History

Started 22 Oct 2026, 1.0.0-alpha1 24 Oct, 1.0.0-beta1 27 Oct (functional tests #3633138).

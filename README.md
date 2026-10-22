[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Readable Base
[![Varbase AI Readable Base](https://img.shields.io/badge/Varbase%20AI%20Readable%20Base-1.0.x--dev-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_readable_base)

A Drupal recipe that makes a Varbase 11 site readable by AI tools. It serves
[`/llms.txt`](https://llmstxt.org), built from the site name, slogan, main menu and footer menu, and a Markdown
version of every content item and taxonomy term, at `<path>.md` or for a request sent with `Accept: text/markdown`.
The HTML pages are unchanged.

Related upstream projects are
[ai_recipe_llm_optimized_content](https://www.drupal.org/project/ai_recipe_llm_optimized_content) (Drupal AI Initiative) and
[llm_support](https://www.drupal.org/project/llm_support) (Pronovix).

It is built on [llms_txt](https://www.drupal.org/project/llms_txt) and
[Markdownify](https://www.drupal.org/project/markdownify), both **stable and covered by the Drupal security advisory
policy**. There is **no custom PHP and no custom shell code** in the recipe: its checks run inline in CI, so the
repository holds no PHP file at all.

> **Required: one line in `settings.php`.** Varbase ships [Fast 404](https://www.drupal.org/project/fast_404), which
> answers every `*.txt` path with a 404 before Drupal routes it, so `/llms.txt` is a 404 until you add the line below.
> A recipe cannot set `$settings`, so this step is yours. See [The fast_404 step](#the-fast_404-step).

## What it adds

| Part | What it does |
|---|---|
| Modules | Installs `llms_txt`, `markdownify`, `markdownify_path` (Markdown at a path alias plus `.md`) and `markdownify_file_attachment` (text attachments embedded in the Markdown). Not `markdownify_views`: see Known issues. |
| `llms_txt.settings` | The llms.txt content: `# [site:name]`, `[site:slogan]`, then `## Main navigation` with `[llms_txt_markdown_menu:main]` and `## Footer` with `[llms_txt_markdown_menu:footer]`. Each menu link becomes a Markdown link. |
| `markdownify.settings` | Basic pages, book pages and announcements are rendered to Markdown from their `search_index` view mode, the content without the page layout: with a Canvas content template the full view mode is the whole layout. Other bundles keep the full view mode. |
| Permissions | SEO admin: administer the llms.txt content and sections. Site admin: the same, plus the Markdownify settings. |

What a site answers once the recipe is applied and the `settings.php` line is in:

| Request | Answer |
|---|---|
| `/llms.txt` | 200 `text/markdown`, listing the main and footer menu links |
| `/node/<nid>.md`, `/<alias>.md`, or any node or term page with `Accept: text/markdown` | 200 `text/markdown`, with `X-Robots-Tag: noindex` |
| The same page without that header | 200 `text/html`, as before |
| `/robots.txt` | unchanged |
| Any other `*.txt` | still a fast 404 |

## Requirements

- Drupal core `^11.4`, Varbase 11, with its `main` and `footer` menus and the `seo_admin` and `site_admin` roles
- [`drupal/llms_txt`](https://www.drupal.org/project/llms_txt) `~1.1` (1.1.1 when this was written)
- [`drupal/markdownify`](https://www.drupal.org/project/markdownify) `~1.2` (1.2.0 when this was written)
- No AI provider or key: nothing here calls a model

## Install and apply

```bash
# 1. Fetch the recipe.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_readable_base"]'
ddev composer require drupal/varbase_ai_readable_base:1.0.x-dev

# 2. Rebuild caches first, so Drupal sees the modules Composer just added.
ddev drush cr

# 3. Apply it.
ddev drush recipe ../recipes/varbase_ai_readable_base
ddev drush cr
```

Do not skip the first `drush cr`. Drupal caches its list of modules, so applying the recipe straight after
`composer require` stops with `"llms_txt" is not a known module or theme` (and the same for each Markdownify
module), even though the code is on disk. Nothing is changed when that happens: rebuild caches and apply again.

Then add the `settings.php` line below. Re-applying the recipe is safe. The ignore line keeps the recipe a locked
package: without it core's recipe-unpack plugin moves its requirements into the project's `composer.json` and drops
the recipe itself. If the project already ignores other packages, add this one to its list rather than replacing it.

On a project whose locked packages have open security advisories, Composer 2.9 can refuse a plain `require`. Require
this package on its own, as above: it adds only the recipe when `llms_txt` and `markdownify` are already there. Do
not run a full `composer update` to get past it.

### The fast_404 step

Add this to `web/sites/default/settings.php` (or the settings file your hosting includes):

```php
// Fast 404 answers every *.txt path before Drupal routes it, which hides the
// /llms.txt route of the llms_txt module. This is the module's default pattern
// with /llms.txt exempted next to /robots; every other .txt still fast-404s.
$settings['fast404_exts'] = '/^(?!\/robots)^(?!\/llms\.txt$)^(?!\/system\/files).*\.(txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i';
```

Without it `/llms.txt` returns Fast 404's own XHTML 404 page over HTTP. A `drush` request does not go through
Fast 404, so a check from `drush` alone passes and hides the problem: always check with a real HTTP request:

```bash
curl -sI https://your-site.ddev.site/llms.txt | grep -iE '^(HTTP|content-type)'
```

If the site already sets `fast404_exts`, add `^(?!\/llms\.txt$)` to its pattern instead.

No cache clear is needed: Fast 404's 404 is not page-cached. A host that runs OPcache with `validate_timestamps` off
only picks up the changed `settings.php` after PHP restarts, which a deploy does.

## Automated testing

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_readable_base) (`.gitlab-ci.yml`) runs on every merge
request and every push to `1.0.x`, like the other Varbase AI recipes: `composer validate` and a lint of every YAML
file.

The functional tests in `tests/features` (Playwright and Cucumber through
[`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e)) run against a site of your own:
`yarn install`, then `LAUNCH_URL=https://your-site.ddev.site yarn test`.

## Checked

14 October 2026, by hand, on a Varbase 11 site (Varbase Starter, Drupal 11.4.9, `vardot/varbase` ~11.0.0, llms_txt
1.1.1, Markdownify 1.2.0, Fast 404 3.7.0): applied twice with an identical config export after the second apply, and
every request in the table above answered as listed, with no new error in the log.

14 October 2026, again on a fresh Varbase Starter site built in the Vardot Workspace `test` folder
(`cmd-varbase_starter1-0-0-project.sh --install`: Varbase Starter ~1.0.0, `vardot/varbase` 11.0.0, Drupal 11.4.9,
`drupal/cva` 1.0.1, Fast 404 3.7.0), following the steps above exactly:

- Applying without the first `drush cr` failed with `"llms_txt" is not a known module or theme`, which is why that
  step is there. With it, both applies passed and the config export was identical after the second.
- Before the `settings.php` line `/llms.txt` answered Fast 404's 404; after it, 200 `text/markdown` with the main
  menu (About Varbase, Features, Blog, Contact Us) and the footer menu (Terms and Conditions).
- A Starter blog post answered 200 `text/markdown` at `<alias>.md`, at `/node/<nid>.md` and with
  `Accept: text/markdown`, carrying its title, date, image and full body (202 words against 55 KB of HTML). The HTML
  page stayed `text/html`.
- `/nothing.txt` was still a 404, `/robots.txt` unchanged, the home page, Canvas pages and the login page all 200,
  and no new error in the log.

Not yet checked on Educare, Horizon Aid or The Rightup.

## Known issues

- **Canvas pages have no Markdown.** Markdownify covers nodes and taxonomy terms only, so the Varbase 11 Canvas pages
  (`canvas_page` entities: About, Features, Blog, Contact on Varbase Starter) get no `.md` version and are listed in
  `/llms.txt` as links only. `Accept: text/markdown` on a Canvas page answers **406**.
- **Views have no Markdown.** `markdownify_views` 1.2.0 answers HTTP 500 for the Markdown of any View on Drupal 11.4
  ("Typed property ViewPageController::$contextualLinks must not be accessed before initialization"), so the recipe
  does not install it. Fixed on 1.1.x-dev, unreleased: https://www.drupal.org/i/3590402. Until a release, a View with
  `Accept: text/markdown` answers **406**.
- **The Markdown of a Varbase Starter post carries some page chrome.** Markdownify renders the node's full view
  mode, so on Varbase Starter the output also holds the breadcrumb (`1. [Home](/)`), the image twice (once as the
  lazy-load `data:image/svg+xml` placeholder) and the Share links. The share links point at the internal
  `/markdownify/node/<nid>` route rather than the page's own URL. The body itself is complete. A trimmed view mode
  for Markdown is a candidate follow-up; Markdownify 1.2 can pick a view mode per bundle.
- On a site with Twig 3.30, `drupal/cva` 1.0.0 fails every page (including the Markdown ones) with a 500; update it to
  1.0.1. This is not caused by the recipe.

## Related work

- [AI Recipe: LLM Optimized Content](https://www.drupal.org/project/ai_recipe_llm_optimized_content), also built on
  Markdownify. It is a recipe, so it is not covered by the security advisory policy.
- The [LLM Support](https://www.drupal.org/project/llm_support) recipe.

| Recipe | What it does |
|---|---|
| [Varbase AI Search Base](https://www.drupal.org/project/varbase_ai_search_base) | A vector index of the site's content. |
| [Varbase AI Answers Base](https://www.drupal.org/project/varbase_ai_answers_base) | Ask AI: cited answers over that index. |
| [Varbase AI Content Review Base](https://www.drupal.org/project/varbase_ai_content_review_base) | AI review of any content item. |

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).

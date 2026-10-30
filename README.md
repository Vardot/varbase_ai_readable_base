[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Readable Base
[![Varbase AI Readable Base](https://img.shields.io/badge/Varbase%20AI%20Readable%20Base-1.0.0--beta2-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_readable_base)

A Drupal recipe that makes a Varbase 11 site readable by AI tools. It serves
[`/llms.txt`](https://llmstxt.org), built from the site name, slogan, main menu and footer menu, and a Markdown
version of every content item and taxonomy term, at `<path>.md` or for a request sent with `Accept: text/markdown`.
The HTML pages are unchanged.

## Documentation

Read the [Varbase AI Readable Base documentation](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-readable-base) on the Varbase docs site.

## Install and apply

```bash
# 1. Fetch the recipe.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_readable_base"]'
ddev composer require drupal/varbase_ai_readable_base:~1

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

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_readable_base) (`.gitlab-ci.yml`) builds
a Varbase 11 site, applies this recipe twice and runs the Varbase functional testing suite in `tests/` on it. See
[tests/README.md](tests/README.md) to run it against a site of your own.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).

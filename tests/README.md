# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-readable-base-llms-txt.feature` | `/llms.txt` is served as Markdown with the main and footer menus; other `.txt` files still get Fast 404 |
| `01-02-ai-readable-base-markdown.feature` | A page is served as Markdown at its `.md` path or when Markdown is asked for; browsers still get HTML |
| `01-03-ai-readable-base-sections.feature` | A section the SEO admin adds is published in `/llms.txt` |
| `01-04-ai-readable-base-access.feature` | Who configures `/llms.txt` |
| `01-05-ai-readable-base-accessibility.feature` | The llms.txt section form gives every field a label and every link a name |

## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

CI applies Drupal CMS AI before the recipe. It sets up an amazee.ai trial as the default provider, so no key
is needed. The suite makes no AI calls of its own. CI adds the README settings.php line for Fast 404.

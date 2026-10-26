# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-readable-base-llms-txt.feature` | /llms.txt as Markdown with the main and footer menus; other .txt files still get Fast 404 |
| `01-02-ai-readable-base-markdown.feature` | A blog post as Markdown at .md and for Accept: text/markdown, HTML otherwise, and a term as Markdown |
| `01-03-ai-readable-base-sections.feature` | An SEO admin adds a section and visitors see it in /llms.txt |
| `01-04-ai-readable-base-access.feature` | SEO and site admins configure /llms.txt, only site admins Markdownify, editors neither |

## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

The suite needs no AI provider and no key. CI adds the README's `settings.php` line that exempts `/llms.txt`
from Fast 404; without it `/llms.txt` answers Fast 404's own 404 page. The Markdown scenarios read the Varbase
demo blog post `/blog/community-behind-varbase-support-and-collaboration` and the first term.

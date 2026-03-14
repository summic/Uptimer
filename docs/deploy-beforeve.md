# Beforeve Deployment Notes

This fork is preconfigured for the Beforeve status site:

- Public status page: `https://status.beforeve.com`
- Default Cloudflare resource prefix: `beforeve-status`
- Default Worker name: `beforeve-status`
- Default D1 database name: `beforeve-status`

The built-in GitHub Actions workflow remains the deployment path. No external deploy scripts are required.

## 1. GitHub Secrets

Add these repository secrets:

| Name | Required | Notes |
| --- | --- | --- |
| `CLOUDFLARE_API_TOKEN` | Yes | Token with Pages, Workers, D1, and account read permissions |
| `CLOUDFLARE_ACCOUNT_ID` | Recommended | Avoid auto-resolution failures |
| `UPTIMER_ADMIN_TOKEN` | Yes | Admin dashboard bearer token |

Optional:

| Name | Notes |
| --- | --- |
| `VITE_ADMIN_PATH` | Override the default admin path `/admin` |

## 2. GitHub Variables

These are optional because this fork already defaults to `beforeve-status`, but setting them explicitly keeps the configuration visible in GitHub:

| Name | Recommended Value |
| --- | --- |
| `UPTIMER_PREFIX` | `beforeve-status` |
| `UPTIMER_WORKER_NAME` | `beforeve-status` |
| `UPTIMER_PAGES_PROJECT` | `beforeve-status` |
| `UPTIMER_D1_NAME` | `beforeve-status` |

Do not set `UPTIMER_API_BASE` or `UPTIMER_API_ORIGIN` for the first deployment unless you also bind a custom API domain. The workflow can derive the Worker URL automatically and inject it into Pages.

## 3. First Deployment

1. Push to `main`.
2. Run the `Deploy to Cloudflare` workflow if it does not auto-run.
3. Wait for the workflow to finish creating:
   - the Worker
   - the Pages project
   - the D1 database
4. Confirm the generated URLs in the workflow logs.

Expected defaults:

- Pages project: `beforeve-status`
- Worker: `beforeve-status`
- D1: `beforeve-status`

## 4. Bind the Custom Domain

After the first successful deploy, bind the Pages project to:

- `status.beforeve.com`

Recommended Cloudflare DNS setup:

- Create a proxied `CNAME` from `status.beforeve.com` to the Cloudflare Pages target shown in the Pages project

If you later decide to give the API a custom domain as well, use a separate hostname such as:

- `status-api.beforeve.com`

Then set either:

- `UPTIMER_API_ORIGIN=https://status-api.beforeve.com`

or

- `UPTIMER_API_BASE=https://status-api.beforeve.com/api/v1`

Do not point `UPTIMER_API_ORIGIN` at `https://status.beforeve.com`, because Pages is the frontend site, not the Worker API.

## 5. Verification

After deployment:

1. Open `https://status.beforeve.com`
2. Open `https://status.beforeve.com/admin`
3. Log in with `UPTIMER_ADMIN_TOKEN`
4. Create a monitor and confirm:
   - public status updates render correctly
   - admin API writes succeed
   - scheduled checks begin populating data

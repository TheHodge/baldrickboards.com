# Hatchbox Deployment Configuration for Baldrick Boards

## Sitemap Setup Instructions

### 1. Add Cron Jobs in Hatchbox Dashboard

Go to your Hatchbox project → Cron Jobs and add these entries:

#### Daily Sitemap Generation
- **Schedule**: `0 2 * * *`
- **Command**: `bundle exec rake sitemap:ping RAILS_ENV=production`
- **Description**: Generate sitemap and ping search engines

#### Weekly Cleanup
- **Schedule**: `0 3 * * 0`
- **Command**: `bundle exec rake sitemap:clean RAILS_ENV=production`
- **Description**: Clean old sitemap files

### 2. Environment Variables

Make sure these environment variables are set in Hatchbox:

- `RAILS_ENV=production`
- `DATABASE_URL` (your production database URL)
- Any other environment variables your app needs

### 2a. Manual PDF generation (Grover / Chromium)

Board manuals can be downloaded as PDF via Grover (headless Chromium).

On the Hatchbox server, install Chromium (or Google Chrome) and set:

- `GROVER_EXECUTABLE_PATH=/usr/bin/chromium`  
  (or `/usr/bin/chromium-browser` / `/usr/bin/google-chrome` — use `which chromium` on the host)

Local development uses Puppeteer instead:

```bash
npm install
```

Markdown downloads (`/boards/:board/manual.md`) do not need Chromium.

### 2b. Christmas Triage HEIC conversion and xLights uploads

Triage converts iPhone HEIC screenshots to JPEG and accepts zipped xLights show folders up to 100MB (no sequences).

**HEIC packages** (ImageMagick is already installed; HEIC is not). SSH in as `root` and run:

```bash
apt-get update
apt-get install -y libheif1 libheif-plugin-libde265 libheif-plugin-aomdec libheif-examples
apt-get install -y libmagickcore-6.q16-6-extra || apt-get install -y libmagickcore-7.q16-10-extra || true
convert -list format | grep -i HEIC
heif-convert -h
```

If `convert` still has no HEIC delegate, the app falls back to `heif-convert`. Hatchbox **Configure** will keep apt packages updated.

Ubuntu 24.04 ships **libheif 1.17.6**, which rejects many iOS 18 photos (HDR gain-map / `tmap` plus Portrait depth) with `Non-existing depth image referenced`. The app retargets those refs and retries. Optionally upgrade libheif to 1.18.2+ (for example `ppa:ubuntuhandbook1/libheif`) so ImageMagick can read those files natively.

**Caddy upload limit (Hatchbox v2):** in the app Settings → Caddyfile, add this *before* `%{default}`:

```
request_body {
    max_size 110MB
}

%{default}
```

If this is still Hatchbox Classic (nginx), set `client_max_body_size 110m;` in the extra nginx config instead.

Puma `worker_timeout` is 180 seconds in production so a slow 100MB upload is less likely to be killed. If uploads hang and then 504, raise the Caddy reverse_proxy read timeout as well.

Cloudflare Free/Pro also cap uploads at 100MB, which matches this limit. Ask people not to include sequences so the zip stays small.

Active Storage files live in `storage/`, which Hatchbox already persists across deploys.

### 3. Post-Deployment Hook (Optional)

You can add a post-deployment hook in Hatchbox to generate the initial sitemap:

```bash
bundle exec rake sitemap:generate RAILS_ENV=production
```

### 4. File Permissions

Hatchbox will handle file permissions automatically, but ensure the `public/` directory is writable for sitemap generation.

### 5. Monitoring

- Check logs in Hatchbox dashboard for cron job execution
- Monitor `log/sitemap.log` for sitemap generation logs
- Verify sitemap is accessible at `https://www.baldrickboard.com/sitemap.xml`

## Manual Commands

You can also run these commands manually in Hatchbox's console:

```bash
# Generate sitemap
bundle exec rake sitemap:generate RAILS_ENV=production

# Generate and ping search engines
bundle exec rake sitemap:ping RAILS_ENV=production

# Clean old files
bundle exec rake sitemap:clean RAILS_ENV=production
```

## Troubleshooting

- If sitemap generation fails, check the Rails logs in Hatchbox
- Ensure all required gems are installed (`bundle install`)
- Verify database connectivity for dynamic content
- Check file permissions in the `public/` directory

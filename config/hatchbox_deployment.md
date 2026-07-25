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

# Open Graph Tags Implementation Guide

## Overview
This Rails application includes a comprehensive Open Graph (OG) tag system for social media sharing. The system uses a hierarchical I18n structure that automatically provides appropriate OG data based on the current page, with graceful fallbacks.

## How It Works

### 1. Hierarchical I18n Structure
Open Graph values are organized in `config/locales/en.yml` with a hierarchical fallback system:

```yaml
og:
  # Global defaults
  site_name: "Baldrick Boards"
  type: "website"
  locale: "en_GB"
  default_title: "Baldrick Boards - Professional LED Controller Boards"
  default_description: "Professional LED controller boards for holiday lighting displays..."
  default_image: "/og-default.jpg"
  twitter_card: "summary_large_image"
  twitter_site: "@baldrickboards"
  
  # Section-specific data
  pages:
    home:
      title: "Baldrick Boards - Professional LED Controller Boards"
      description: "Professional-grade controller boards for lighting displays..."
      image: "/og-homepage.jpg"
    faq:
      title: "Frequently Asked Questions - Baldrick Boards"
      description: "Find answers to the most commonly asked questions..."
      image: "/og-faq.jpg"
  
  # Board-specific data (now in individual board I18n files)
  # See: config/locales/views/boards/[board_name]/en.yml
```

### 2. Automatic Fallback System
The system automatically tries I18n keys in this order:

1. **Most Specific**: `views.boards.baldrick8.og.faq.title` (for `/boards/baldrick8/faq`)
2. **Less Specific**: `views.boards.baldrick8.og.title` (for `/boards/baldrick8`)
3. **Section Specific**: `og.pages.faq.title` (for `/faq`)
4. **Global Default**: `og.default_title`

### 3. Helper Methods
The `ApplicationHelper` provides methods that use the hierarchical fallback:

- `og_title` - Page title (hierarchical fallback)
- `og_description` - Page description (hierarchical fallback)
- `og_image` - Page image (hierarchical fallback)
- `og_url` - Current page URL
- `og_type` - Content type (defaults to "website")
- `og_site_name` - Site name from I18n
- `og_locale` - Locale from I18n

### 4. Manual Overrides (Optional)
You can still override any value using `set_og_data` in views:

```slim
- set_og_data title: "Custom Page Title", description: "Custom description", image: "/custom-image.jpg"
```

## Usage Examples

### Automatic (Recommended)
Most pages now work automatically without any code:

```slim
# Homepage - automatically uses og.pages.home.*
- content_for :title, "Baldrick Boards - Controllers as Cunning as a Fox"

# FAQ Page - automatically uses og.pages.faq.*
- content_for :title, t('faq.title')

# Board Overview - automatically uses og.boards.baldrick8.*
- content_for :title, "Baldrick8 - Baldrick Board Documentation"

# Board FAQ - automatically uses og.boards.baldrick8.faq.*
- content_for :title, "FAQ - Baldrick8 - Baldrick Board Documentation"
```

### Manual Override (When Needed)
Only use `set_og_data` when you need to override the automatic behavior:

```slim
# Override specific values
- set_og_data title: "Custom Title", description: "Custom description", image: "/custom-image.jpg"

# Override just one field
- set_og_data title: "Special Page Title"
```

## Generated Meta Tags

The system automatically generates these meta tags in the `<head>`:

### Open Graph (Facebook)
```html
<meta property="og:type" content="website">
<meta property="og:url" content="https://baldrickboards.com/current-page">
<meta property="og:title" content="Page Title">
<meta property="og:description" content="Page Description">
<meta property="og:image" content="/og-image.jpg">
<meta property="og:site_name" content="Baldrick Boards">
<meta property="og:locale" content="en_US">
```

### Twitter Cards
```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="https://baldrickboards.com/current-page">
<meta name="twitter:title" content="Page Title">
<meta name="twitter:description" content="Page Description">
<meta name="twitter:image" content="/og-image.jpg">
<meta name="twitter:site" content="@baldrickboards">
```

### SEO Meta Tags
```html
<meta name="description" content="Page Description">
<meta name="keywords" content="LED controllers, holiday lighting, Baldrick Boards...">
```

## Testing

### Facebook Debugger
- URL: https://developers.facebook.com/tools/debug/
- Enter your page URL to see how it will appear on Facebook

### Twitter Card Validator
- URL: https://cards-dev.twitter.com/validator
- Enter your page URL to preview Twitter cards

### LinkedIn Post Inspector
- URL: https://www.linkedin.com/post-inspector/
- Enter your page URL to see LinkedIn preview

## Image Requirements

### Open Graph Images
- **Recommended size**: 1200x630 pixels
- **Minimum size**: 600x315 pixels
- **Format**: JPG, PNG, or GIF
- **File size**: Under 5MB

### Twitter Card Images
- **Summary Card**: 1200x675 pixels
- **Summary Large Image**: 1200x630 pixels
- **Format**: JPG, PNG, or GIF

## Best Practices

1. **Unique Images**: Use different images for different page types
2. **Descriptive Titles**: Make titles specific to the page content
3. **Compelling Descriptions**: Write descriptions that encourage clicks
4. **Test Regularly**: Use social media debuggers to verify tags
5. **Update I18n**: Keep default values current and relevant

## Adding New Pages

### For New Board Pages
1. Add board-specific OG data to `config/locales/views/boards/newboard/en.yml`:
   ```yaml
   en:
     views:
       boards:
         newboard:
           og:
             title: "NewBoard - Description"
             description: "Description of the new board..."
             image: "og-newboard"
             faq:
               title: "NewBoard FAQ - Frequently Asked Questions"
               description: "FAQ description..."
               image: "og-newboard-faq"
   ```
2. Create appropriate OG images (1200x630px) in `app/assets/images/`
3. Test with social media debuggers

### For New General Pages
1. Add page-specific OG data to `config/locales/en.yml`:
   ```yaml
   og:
     pages:
       newpage:
         title: "New Page - Baldrick Boards"
         description: "Description of the new page..."
         image: "/og-newpage.jpg"
   ```
2. Update the helper method in `ApplicationHelper` to recognize the new controller/action
3. Create appropriate OG images (1200x630px)
4. Test with social media debuggers

### For Special Cases
Use `set_og_data` in the view for one-off pages that don't fit the standard patterns.

## File Structure

```
app/
├── assets/
│   └── images/
│       ├── og-default.jpg      # Default OG image
│       ├── og-homepage.jpg     # Homepage OG image
│       ├── og-faq.jpg          # FAQ OG image
│       └── og-baldrick8.jpg    # Board-specific OG images
├── helpers/
│   └── application_helper.rb   # OG helper methods
├── views/
│   └── layouts/
│       └── application.html.slim # OG meta tags
config/
└── locales/
    ├── en.yml                  # Global OG defaults and page-specific data
    └── views/
        └── boards/
            ├── baldrick8/
            │   └── en.yml      # Baldrick8-specific OG data
            ├── baldrick17/
            │   └── en.yml      # Baldrick17-specific OG data
            └── [other boards]/
                └── en.yml      # Board-specific OG data
```

## Asset Pipeline Integration

The system automatically uses Rails' asset pipeline for images:

- **Development**: Images served with fingerprints (e.g., `/assets/og-homepage-e8dc057d.jpg`)
- **Production**: Images served with CDN URLs and proper caching headers
- **Fallback**: If an image doesn't exist, it falls back to the default image
- **Error Handling**: Graceful error handling with logging for missing assets

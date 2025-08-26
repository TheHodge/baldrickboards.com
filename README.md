# Baldrick Board Documentation

A Rails-based documentation site for Baldrick controller boards and accessories.

## Overview

This documentation site provides comprehensive information about Baldrick controller boards, including setup guides, tutorials, technical specifications, and support resources.

## Site Structure

The site follows the navigation structure:

- **Home** (`/`) - Overview and quick access to all sections
- **Boards** (`/boards/`) - Controller board types and specifications
  - Pixel Controllers (`/boards/pixel-controllers/`)
  - Relay Controllers (`/boards/relay-controllers/`)
  - Interactive Controllers (`/boards/interactive-controllers/`)
  - Portable Controllers (`/boards/portable-controllers/`)
  - Power Distribution (`/boards/power-distribution/`)
  - DMX Controllers (`/boards/dmx-controllers/`)
- **About Baldrick** (`/about/`) - Company information and philosophy
- **Baldrick Breakthroughs** (`/breakthroughs/`) - Innovative technologies and ecosystem
  - Turnip Network (`/breakthroughs/turnip-network/`)
  - Kluster (`/breakthroughs/kluster/`)
  - CE/UKCA Certification (`/breakthroughs/ce-ukca-certification/`)
  - Turniput (`/breakthroughs/turniput/`)
  - Hodgical Test Mode (`/breakthroughs/hodgical-test-mode/`)
  - CunningFX (`/breakthroughs/cunningfx/`)
- **Guides** (`/guides/`) - Tutorials and how-to guides
  - Light Show 101 (`/guides/light-show-101/`)
  - Easy FPP Joke Button (`/guides/easy-fpp-joke-button/`)
  - Simple Start Show Button (`/guides/simple-start-show-button/`)
  - Sequence AC Lights in xLights (`/guides/sequence-ac-lights-in-xlights/`)
- **Fun Stuff** (`/resources/`) - Technical resources and downloads
  - Release Notes (`/resources/release-notes/`)
  - STLs and Mounts (`/resources/stls-and-mounts/`)
  - Board Dimensions (`/resources/board-dimensions/`)
  - FAQ (`/resources/faq/`)
  - Problem Solver (`/resources/problem-solver/`)
- **Where to Buy** (`/where-to-buy-baldrick-boards/`) - Purchase information
- **Support** (`/support/`) - Support and help resources

## Adding Content

### Creating New Pages

1. **Add the route** in `config/routes.rb`:
   ```ruby
   get 'your-new-page', to: 'controller#action'
   ```

2. **Add the controller action** in the appropriate controller:
   ```ruby
   def action_name
     # Any logic needed
   end
   ```

3. **Create the view** in `app/views/controller/action_name.html.erb`:
   ```erb
   <% content_for :title, "Page Title - Baldrick Board Documentation" %>
   
   <div class="max-w-4xl mx-auto">
     <!-- Your content here -->
   </div>
   ```

### Content Guidelines

- Use Tailwind CSS classes for styling
- Include breadcrumb navigation for deep pages
- Add proper page titles using `content_for :title`
- Use semantic HTML structure with proper headings
- Include related links at the bottom of pages
- Add difficulty levels and estimated read times for guides

### Page Templates

The site includes several page templates:

- **Home page** - Overview with quick access cards
- **Index pages** - Lists of related content (boards, guides, resources)
- **Detail pages** - Comprehensive information with sections
- **Guide pages** - Step-by-step tutorials with table of contents

## Development

### Prerequisites

- Ruby (version specified in `.ruby-version`)
- Rails 7
- Node.js (for asset compilation)

### Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Start the development server:
   ```bash
   rails server
   ```

3. Visit `http://localhost:3000`

### Styling

The site uses Tailwind CSS for styling. The main stylesheet is located at:
- `app/assets/stylesheets/application.css`

### Layout

The main layout is in `app/views/layouts/application.html.erb` and includes:
- Responsive navigation with dropdown menus
- Mobile-friendly design
- Proper meta tags and SEO elements

## Content Migration

The old documentation (in the `old/` directory) was built with Docusaurus. To migrate content:

1. Copy relevant markdown content from `old/docs/`
2. Convert to ERB templates with proper HTML structure
3. Update internal links to match the new URL structure
4. Add proper styling using Tailwind CSS classes
5. Include images and assets in the appropriate directories

## Deployment

The application is configured for deployment using Kamal. See `config/deploy.yml` for deployment settings.

## Contributing

1. Create a new branch for your changes
2. Add content following the established patterns
3. Test locally to ensure everything works
4. Submit a pull request with your changes

## License

[Add your license information here]

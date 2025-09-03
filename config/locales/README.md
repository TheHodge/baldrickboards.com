# Locale Organization Structure

This directory contains all the internationalization (I18n) files for the Baldrick Boards application.

## Structure

```
config/locales/
├── en.yml                           # Main English locale file
├── views/                           # View-specific locales
│   ├── boards/                      # Board-specific content
│   │   ├── baldrick8/              # Baldrick8 board locales
│   │   │   └── faq.yml             # Baldrick8 FAQ content
│   │   ├── baldrick17/             # Baldrick17 board locales
│   │   ├── baldrickdmx/            # BaldrickDMX board locales
│   │   └── ...                     # Other boards
│   ├── pages/                       # Page-specific locales
│   └── shared/                      # Shared component locales
└── models/                          # Model-specific locales
```

## Benefits of This Structure

1. **Modularity**: Each board has its own locale files
2. **Maintainability**: Easier to find and update specific content
3. **Scalability**: New boards can be added without cluttering the main file
4. **Team Collaboration**: Different team members can work on different board locales
5. **Translation Management**: Easier to manage translations for specific sections

## Usage Examples

### Main FAQ (General)
```ruby
t('faq.title')
t('faq.questions.find_board_ip.question')
```

### Board-Specific FAQ
```ruby
t('views.boards.baldrick8.faq.title')
t('views.boards.baldrick8.faq.content.questions.fpp_api_commands.question')
```

### Adding New Board FAQs

1. Create directory: `config/locales/views/boards/[board_name]/`
2. Create file: `faq.yml`
3. Follow the same structure as `baldrick8/faq.yml`
4. Rails will automatically load all `.yml` files in the locales directory

## File Naming Convention

- Use lowercase with underscores: `faq.yml`, `web_interface.yml`
- Group related content in subdirectories
- Keep file names descriptive but concise

## Best Practices

1. **Consistent Structure**: Use the same key structure across similar files
2. **Image Management**: Use the `images` array and `%{image_1}` placeholders
3. **HTML in YAML**: Include Tailwind CSS classes for consistent styling
4. **Validation**: Always test YAML files with `ruby -e "require 'yaml'; YAML.load_file('file.yml')"`
5. **Testing**: Test I18n calls with `rails runner` before deploying

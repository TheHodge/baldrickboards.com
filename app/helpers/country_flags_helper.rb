# Flag SVGs from https://github.com/lipis/flag-icons (MIT)
module CountryFlagsHelper
  REGION_CODES = {
    'uk' => 'gb'
  }.freeze

  HOME_BUY_REGIONS = [
    { code: 'gb', country: 'United Kingdom' },
    { code: 'us', country: 'United States' },
    { code: 'au', country: 'Australia' },
    { code: 'eu', country: 'Europe' },
    { code: 'ca', country: 'Canada' }
  ].freeze

  def country_flag_code(code)
    normalized = code.to_s.downcase
    REGION_CODES.fetch(normalized, normalized)
  end

  def home_buy_regions
    HOME_BUY_REGIONS
  end

  def country_flag(code, size: :md, **options)
    iso = country_flag_code(code)
    css = ['country-flag', "country-flag--#{size}", options[:class]].compact.join(' ')
    image_tag("flags/#{iso}.svg", class: css, alt: '', aria: { hidden: true })
  end
end

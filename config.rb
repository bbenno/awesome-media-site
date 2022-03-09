# frozen_string_literal: true

DOMAIN = 'm.bbenno.com'
HOST = "https://#{DOMAIN}"

###############################################################################
## Activate and configure extensions

activate :aria_current

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :i18n, mount_at_root: :en

# Generates Web Robots Page
# http://www.robotstxt.org/
activate :robots,
         rules: [{ user_agent: '*', disallow: ['/'] }],
         sitemap: "#{HOST}/sitemap.xml"

activate :sitemap,
         gzip: true,
         hostname: HOST

activate :favicon_maker, :icons => {
  '_favicon_template.png' => [
    { icon: 'apple-touch-icon-180x180-precomposed.png' },
    { icon: 'apple-touch-icon-152x152-precomposed.png' },
    { icon: 'apple-touch-icon-144x144-precomposed.png' },
    { icon: 'apple-touch-icon-120x120-precomposed.png' },
    { icon: 'apple-touch-icon-114x114-precomposed.png' },
    { icon: 'apple-touch-icon-76x76-precomposed.png' },
    { icon: 'apple-touch-icon-72x72-precomposed.png' },
    { icon: 'apple-touch-icon-60x60-precomposed.png' },
    { icon: 'apple-touch-icon-57x57-precomposed.png' },
    { icon: 'apple-touch-icon-precomposed.png', size: '57x57' },
    { icon: 'apple-touch-icon.png', size: '57x57' },
    { icon: 'favicon-196x196.png' },
    { icon: 'favicon-160x160.png' },
    { icon: 'favicon-96x96.png' },
    { icon: 'favicon-32x32.png' },
    { icon: 'favicon-16x16.png' },
    { icon: 'favicon.png', size: '16x16' },
    { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' },
    { icon: 'mstile-70x70.png', size: '70x70' },
    { icon: 'mstile-144x144.png', size: '144x144' },
    { icon: 'mstile-150x150.png', size: '150x150' },
    { icon: 'mstile-310x310.png', size: '310x310' },
    { icon: 'mstile-310x150.png', size: '310x150' }
  ]
}

###############################################################################
## Settings

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

config[:sass_assets_paths] << Bootstrap.stylesheets_path

set :strip_index_file, true

## Custom settings
# `set :a, ...` can be accessed via `config.a` in sources

###############################################################################
## Layouts

## Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

###############################################################################
## External pipeline
## Run multiple subprocesses which output content to

# Get media details from TMDB API
require File.expand_path(File.dirname(__FILE__) + '/lib/get_details.rb')

###############################################################################
## Build-specific configuration

configure :build do
  # Add assets fingerprinting to avoid cache issues
  activate :asset_hash
end

configure :development do
  activate :livereload
  set :debug_assets, true

  ::Slim::Engine.set_options pretty: true
end

configure :production do
  # Minification
  activate :minify_css
  activate :minify_html
  # activate :minify_javascript
end

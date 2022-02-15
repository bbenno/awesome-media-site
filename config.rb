HOST = 'bbenno.github.io'

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
         rules: [{ user_agent: '*', allow: ['/'] }],
         sitemap: "https://#{HOST}/sitemap.xml"

activate :sitemap,
         gzip: true,
         hostname: "https://#{HOST}"

activate :favicon_maker, :icons => {
  '_favicon_template.png' => [
    { icon: 'apple-touch-icon-180x180-precomposed.png' },             # Same as apple-touch-icon-57x57.png, for iPhone 6 Plus with @3× display
    { icon: 'apple-touch-icon-152x152-precomposed.png' },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS7.
    { icon: 'apple-touch-icon-144x144-precomposed.png' },             # Same as apple-touch-icon-57x57.png, for retina iPad with iOS6 or prior.
    { icon: 'apple-touch-icon-120x120-precomposed.png' },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS7.
    { icon: 'apple-touch-icon-114x114-precomposed.png' },             # Same as apple-touch-icon-57x57.png, for retina iPhone with iOS6 or prior.
    { icon: 'apple-touch-icon-76x76-precomposed.png' },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS7.
    { icon: 'apple-touch-icon-72x72-precomposed.png' },               # Same as apple-touch-icon-57x57.png, for non-retina iPad with iOS6 or prior.
    { icon: 'apple-touch-icon-60x60-precomposed.png' },               # Same as apple-touch-icon-57x57.png, for non-retina iPhone with iOS7.
    { icon: 'apple-touch-icon-57x57-precomposed.png' },               # iPhone and iPad users can turn web pages into icons on their home screen. Such link appears as a regular iOS native application. When this happens, the device looks for a specific picture. The 57x57 resolution is convenient for non-retina iPhone with iOS6 or prior. Learn more in Apple docs.
    { icon: 'apple-touch-icon-precomposed.png', size: '57x57' },      # Same as apple-touch-icon.png, expect that is already have rounded corners (but neither drop shadow nor gloss effect).
    { icon: 'apple-touch-icon.png', size: '57x57' },                  # Same as apple-touch-icon-57x57.png, for "default" requests, as some devices may look for this specific file. This picture may save some 404 errors in your HTTP logs. See Apple docs
    { icon: 'favicon-196x196.png' },                                  # For Android Chrome M31+.
    { icon: 'favicon-160x160.png' },                                  # For Opera Speed Dial (up to Opera 12; this icon is deprecated starting from Opera 15), although the optimal icon is not square but rather 256x160. If Opera is a major platform for you, you should create this icon yourself.
    { icon: 'favicon-96x96.png' },                                    # For Google TV.
    { icon: 'favicon-32x32.png' },                                    # For Safari on Mac OS.
    { icon: 'favicon-16x16.png' },                                    # The classic favicon, displayed in the tabs.
    { icon: 'favicon.png', size: '16x16' },                           # The classic favicon, displayed in the tabs.
    { icon: 'favicon.ico', size: '64x64,32x32,24x24,16x16' },         # Used by IE, and also by some other browsers if we are not careful.
    { icon: 'mstile-70x70.png', size: '70x70' },                      # For Windows 8 / IE11.
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

## With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

###############################################################################
## Proxy pages

require File.expand_path(File.dirname(__FILE__) + '/lib/get_details.rb')

###############################################################################
## Helpers
## Methods defined in the helpers block are available in templates

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

###############################################################################
## External pipeline
## Run multiple subprocesses which output content to

# activate :external_pipeline,
#          name: :external_tool,
#          command: build? ? 'command 1' : 'command 2',
#          source: '.tmp/',
#          latency: 1

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
#  activate :minify_css
  activate :minify_html
#  activate :minify_javascript
end

configure :github_pages do
  set :build_dir, 'docs'
  set :http_prefix, '/awesome-media-site'
end

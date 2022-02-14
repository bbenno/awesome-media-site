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

activate :sprockets

###############################################################################
## Settings

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

config[:sass_assets_paths] << Bootstrap.stylesheets_path

set :protect_from_csrf, true
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

activate :external_pipeline, name: :download_images,
                             command: './lib/download_images.rb',
                             source: 'assets/images'

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
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
end

configure :github_pages do
  set :build_dir, 'docs'
  set :http_prefix, '/awesome-media-site'
end

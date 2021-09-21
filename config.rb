## Activate and configure extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :i18n, mount_at_root: :en

## Generates Web Robots Page
## http://www.robotstxt.org/
activate :robots,
         rules: [{ user_agent: '*', allow: ['/'] }],
         sitemap: '/sitemap.xml'

activate :sitemap,
         gzip: true,
         hostname: 'https://bbenno.github.io/awesome-media-site'

##

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'

## Layouts

## Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

## With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

## Proxy pages

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

## Helpers
## Methods defined in the helpers block are available in templates

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

## Build-specific configuration

configure :build do
  # Use relative URLs
  activate :directory_indexes

  # Add assets fingerprinting to avoid cache issues
  activate :asset_hash
end

configure :development do
  activate :livereload
  set :debug_assets, true

  ::Slim::Engine.set_options pretty: true
end

configure :production do
  activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript
end

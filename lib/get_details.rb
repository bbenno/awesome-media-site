#! /usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'json'
require 'uri'
require 'net/http'

def api_key = ENV.fetch('TMDB_API_KEY')
def dir_path = File.join('data', 'details')

Category = Struct.new(:name, :tmdb_key) do
  def content = YAML.load(File.open("data/#{name}.yml"))
end

Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

[ Category.new('movies', 'movie'),
  Category.new('short_films', 'movie'),
  Category.new('series', 'tv')
].each do |category|
  puts "CATEGORY: #{category.name}"

  details_path = File.join(dir_path, category.name)
  Dir.mkdir(details_path) unless Dir.exist?(details_path)
  category.content.shuffle.each do |media|
    abort("missing tmdb id for #{media}") unless (id = media['tmdb'])
    puts "MEDIA: #{media['title']}"

    file_path = File.join(details_path, "#{id}.json")

    next if File.exist?(file_path)

    uri = URI("https://api.themoviedb.org/3/#{category.tmdb_key}/#{id}?api_key=#{api_key}")
    res = Net::HTTP.get_response(uri)

    abort("Failed with #{res.class}") unless res.is_a?(Net::HTTPSuccess)

    File.write(file_path, res.body)

    JSON.parse!(res.body).then do |m|
      img = URI('https://image.tmdb.org/t/p/w342').tap { _1.path += m['poster_path'] }
      path = File.join('source', 'assets', 'images', category.name)
      Dir.mkdir(path) unless Dir.exist?(path)
      year = m['release_date']&.slice(0, 4) || m['first_air_date']&.slice(0, 4) || media['year']
      title = m['title'] || media ['title']
      File.write(File.join(path, [title, year].compact.join('+').gsub!(/[^a-z0-9\-_]+/i, '-')), Net::HTTP.get(img))
    end
    sleep 0.1 # Rate Limit
  end
end

#! /usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'json'
require 'uri'
require 'net/http'

def api_key = ENV.fetch('TMDB_API_KEY')
def dir_path = File.join('data', 'details')

Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

{
  movie: YAML.load(File.open('data/movies.yml')),
  tv: YAML.load(File.open('data/series.yml'))
}.each do |media_type, media_items|
  media_items.each do |media|
    abort unless media['tmdb']

    id = media['tmdb']

    file_path = File.join(dir_path, "#{id}.json")

    next if File.exist?(file_path)

    uri = URI("https://api.themoviedb.org/3/#{media_type}/#{id}?api_key=#{api_key}")
    res = Net::HTTP.get_response(uri)

    abort("Failed with #{res.class}") unless res.is_a?(Net::HTTPSuccess)

    File.write(file_path, res.body)

    JSON.parse!(res.body).then do |m|
      img = URI('https://image.tmdb.org/t/p/w342').tap { _1.path += m['poster_path'] }
      File.write(File.join('source', 'assets', 'images', (m['title'] || m['name']).parameterize), Net::HTTP.get(img))
    end
  end
end

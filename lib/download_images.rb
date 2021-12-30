#! /usr/bin/env ruby

require 'yaml'
require 'json'
require 'uri'
require 'logger'
require 'net/http'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

tmdb_api_url = 'https://api.themoviedb.org/3'
tmdb_api_key = ENV['TMDB_API_KEY']

tmdb_image_base_url = 'http://image.tmdb.org/t/p/'
tmdb_image_file_size = 'w342'

data = Hash.new
data[:tv] = YAML.load(File.open('data/series.yml'))['series']
data[:movie] = YAML.load(File.open('data/movies.yml'))['movies']

data.each do |media_type, media_items|
  media_items.each do |media|
    unless media['tmdb']
      logger.error("TMDB key missing for \"#{media['title']}\"")
      next
    end

    path = File.join('source', 'assets', 'images', "#{media['tmdb']}")

    if Dir.glob("#{path}.*").any?
      logger.info("Skip #{media['title']} (#{media['tmdb']})")
      next
    else
      logger.info("Loading #{media['title']} (#{media['tmdb']})")
    end

    uri = URI("#{tmdb_api_url}/#{media_type}/#{media['tmdb']}/images?api_key=#{tmdb_api_key}")
    res = Net::HTTP.get_response(uri)

    unless res.is_a?(Net::HTTPSuccess)
      logger.error("Failed with #{res.class}")
      next
    end

    root = {tv: 'backdrops', movie: 'posters'}[media_type]
    file_path = JSON.parse(res.body)[root][0]['file_path']

    image_uri = URI("#{tmdb_image_base_url}#{tmdb_image_file_size}#{file_path}")
    ext = File.extname(file_path)
    filename = File.join('source', 'assets', 'images', "poster-#{media['tmdb']}#{ext}")

    File.write(filename, Net::HTTP.get(image_uri))

    logger.info("Created #{filename}")
  end
end

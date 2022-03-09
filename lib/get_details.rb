#! /usr/bin/env ruby

require 'yaml'
require 'uri'
require 'logger'
require 'net/http'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

tmdb_api_url = 'https://api.themoviedb.org/3'
tmdb_api_key = ENV['TMDB_API_KEY']

unless tmdb_api_key
  logger.error("Unable to get media details. The environment variable TMDB_API_KEY is not set.")
  return # Exit nicely
end

data = Hash.new
data[:tv] = YAML.load(File.open('data/series.yml'))
data[:movie] = YAML.load(File.open('data/movies.yml'))

dir_path = File.join('data', 'details')
Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

data.each do |media_type, media_items|
  media_items.each do |media|
    unless media['tmdb']
      logger.error("TMDB key missing for \"#{media['title']}\"")
      next
    end

    file_path = File.join(dir_path, "#{media['tmdb']}.json")

    if File.exist?(file_path)
      logger.info("Skip #{media['title']} (#{media['tmdb']})")
      next
    else
      logger.info("Loading #{media['title']} (#{media['tmdb']})")
    end

    uri = URI("#{tmdb_api_url}/#{media_type}/#{media['tmdb']}?api_key=#{tmdb_api_key}")
    res = Net::HTTP.get_response(uri)

    unless res.is_a?(Net::HTTPSuccess)
      logger.error("Failed with #{res.class}")
      next
    end

    File.write(file_path, res.body)

    logger.info("Created #{File.basename(file_path)}")
  end
end

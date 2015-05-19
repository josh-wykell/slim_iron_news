require 'rubygems'
require 'bundler/setup'
require 'tilt'
require 'webrick'
require 'yaml'

ROOT = File.dirname(__FILE__)

PORT = ENV["PORT"] || 8000

server = WEBrick::HTTPServer.new(:Port => PORT)

server.mount '/assets', WEBrick::HTTPServlet::FileHandler, "#{ROOT}/public"

server.mount_proc '/' do |req, res|
  data = YAML.load_file('slim_iron_news.yml')
  template = Tilt.new("#{ROOT}/index.slim")
  res.body = template.render(self, {:data => data})
end

server.mount_proc '/stylesheets.css' do |req, res|
  res.body = Tilt.new("#{ROOT}/stylesheets.sass").render
end


trap 'INT' do
  server.shutdown
end

server.start
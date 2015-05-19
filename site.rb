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
  data = YAML.load_file('data.yml')
  template = Tilt.new("#{ROOT}/index.slim")
  res.body = template.render(self, {:data => data})
end

trap 'INT' do
  serv.shutdown
end

server.start
require 'rack/lobster'

require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

if File.exists?('/config/content.txt')
  FILE_CONTENT=File.read('/config/content.txt')
else
  FILE_CONTENT=File.read('/etc/os-release')
end

use Rack::Deflater
use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

map '/' do
  health = proc do |env|
    [200, { "Content-Type" => "text/plain" }, [
     "Hello world!\n\nPod: #{ENV['HOSTNAME']}\n\n#{FILE_CONTENT}"
    ]]
  end
  run health
end

map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/plain" }, ["1"]]
  end
  run health
end

map '/lobster' do
  run Rack::Lobster.new
end

map '/headers' do
  headers = proc do |env|
    [200, { "Content-Type" => "text/plain" }, [
      env.select {|key,val| key.start_with? 'HTTP_'}
      .collect {|key, val| [key.sub(/^HTTP_/, ''), val]}
      .collect {|key, val| "#{key}: #{val}"}
      .sort
      .join("\n")
    ]]
  end
  run headers
end

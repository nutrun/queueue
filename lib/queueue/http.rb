require "rubygems"
require "cgi"
require "openssl"
require "base64"
require 'rexml/document'
require "sinatra"

$:.unshift File.dirname(__FILE__) + "/../"
require "queueue"
require "queueue/http/config"
require "queueue/http/responses"
require "queueue/http/user"
require "queueue/http/queue"
require "queueue/http/id_generator"
require "queueue/http/adapter"
require "queueue/http/dispatch"
require "queueue/http/request_validator"

at_exit do
  STDOUT.puts "Queueue listening on #{Queueue::Http::HOST}:#{ Queueue::Http::PORT }, pid: #{$$}" if Sinatra.env == :production
end

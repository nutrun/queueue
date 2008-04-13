$:.unshift File.dirname(__FILE__) + "/../lib/"
require "queueue/http"

Sinatra.application.options.env = :production
Sinatra.application.options.host = Queueue::Http::HOST
Sinatra.application.options.port = Queueue::Http::PORT

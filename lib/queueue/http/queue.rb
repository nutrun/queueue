module Queueue
  class Queue
    # Only available if the Queueue::Http module has been loaded. 
    def url
      "http://#{Queueue::Http::HOST}:#{Queueue::Http::PORT}/#{Queueue::Http::QUEUE_PREFIX}/#{@name}"
    end
  end
end
require 'net/http'
require 'uri'

HOST = 'http://127.0.0.1:2323'
QUEUE_NAME = "foolforyourlovinnomore"
QUEUE_PREFIX = 'A23E9WXPHGOG29'

def add_queue
  path = "#{HOST}/?QueueName=#{QUEUE_NAME}"
  url = URI.parse(path)
  req = Net::HTTP::Post.new(url.path + "?QueueName=#{QUEUE_NAME}")
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req)}
  p res.body
end

def delete_queue
  url = URI.parse("#{HOST}/#{QUEUE_PREFIX}/#{QUEUE_NAME}")
  req = Net::HTTP::Delete.new(url.path)
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req)}
  p res.body
end

def put_message
  url = URI.parse("#{HOST}/#{QUEUE_PREFIX}/#{QUEUE_NAME}/back")
  req = Net::HTTP::Put.new(url.path)
  req.body = '<Message>This is the text of my message.</Message>'
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req)}
  p res.body
end

def set_visibility_timeout
  url = URI.parse("#{HOST}/#{QUEUE_PREFIX}/#{QUEUE_NAME}")
  req = Net::HTTP::Put.new(url.path + '?VisibilityTimeout=5')
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req)}
  p res.body
end

def get_with_head
  url = URI.parse("#{HOST}/#{QUEUE_NAME}")
  req = Net::HTTP::Get.new(url.path, {'Authorization' => 'secretkey'})
  res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req)}
  p res.body
end

#get_with_head
#add_queue
put_message
#delete_queue
#set_visibility_timeout

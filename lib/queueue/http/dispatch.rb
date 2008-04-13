post "/" do
  adapter.create_queue(params[:QueueName])
end

get "/" do
  adapter.list_queues(params[:QueueNamePrefix])
end

get "/:prefix/:queue_name" do
  adapter.get_visibility_timeout(params[:queue_name])
end

get "/:prefix/:queue_name/front" do
  adapter.receive_message(params[:queue_name], number_of_messages, visibility_timeout)
end

get "/:prefix/:queue_name/:message_id" do
  adapter.peek_message(params[:queue_name], message_id)
end

delete "/:prefix/:queue_name" do
  adapter.delete_queue(params[:queue_name])
end

delete "/:prefix/:queue_name/:message_id" do
  adapter.delete_message(params[:queue_name], message_id)
end

put "/:prefix/:queue_name/back" do
  message_body = params.keys.map { |k| k.to_s }.grep(/<Message>.*<\/Message>/)[0]
  message_body =~ /<Message>(.*)<\/Message>/
  adapter.send_message(params[:queue_name], $1)
end

put "/:prefix/:queue_name" do
  adapter.set_visibility_timeout(params[:queue_name], visibility_timeout)
end

before do
  header 'Content-Type' => 'text/xml'
  validator = Queueue::Http::RequestValidator.new(request.env)
  throw :halt, validator.invalid_date unless validator.date_valid?
  throw :halt, validator.auth_failure unless validator.authorized?
end

helpers do  
  def adapter
    Queueue::Http::Adapter
  end
  
  def visibility_timeout
    params[:VisibilityTimeout].nil? ? nil : params[:VisibilityTimeout].to_i
  end
  
  def number_of_messages
    params[:NumberOfMessages].nil? ? nil : params[:NumberOfMessages].to_i
  end
  
  def message_id
    CGI.unescape(params[:message_id]) rescue nil
  end
end

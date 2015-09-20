Orchestrate::Client.send :define_method, 'send_request' do |method, path, options={}|
  puts 'OVERRIDED METHOD' 

  path = ['/v0'].concat(path.map{|s| URI.escape(s.to_s).gsub('/','%2F') }).join('/')
  query_string = options.fetch(:query, {})
  body = options.fetch(:body, '')
  headers = options.fetch(:headers, {})
  headers['User-Agent'] = "ruby/orchestrate/#{Orchestrate::VERSION}"
  headers['Accept'] = 'application/json' if method == :get
  headers['Connection'] = 'close' if method == :head

  http_response = http.send(method) do |request|
    request.url path, query_string
    if [:put, :post].include?(method)
      headers['Content-Type'] = 'application/orchestrate-export+json'
      request.body = body.to_json
    elsif [:patch].include?(method)
      request.body = body.to_json
    end
    headers.each {|header, value| request[header] = value }
  end

  response_class = options.fetch(:response, Orchestrate::API::Response)
  response_class.new(http_response, self)
end

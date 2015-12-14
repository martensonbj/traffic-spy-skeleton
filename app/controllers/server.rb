module TrafficSpy

  class Server < Sinatra::Base

    get '/' do
      erb :index
    end

    post '/sources' do
      rv = RequestValidator.new(params)
      rv.validate_request
      status rv.status
      body   rv.body
    end

    post '/sources/:identifier/data' do
      parser = UserAgentParser::Parser.new
      prp = PayloadRequestProcessor.new(params, parser)
      prp.process_request
      status prp.status
      body   prp.body
    end

    get '/sources/:identifier' do |identifier|
      @application = Application.find_by(identifier: identifier)
      @identifier = identifier
      erb ViewRoute.application(@application)
    end

    get '/sources/:identifier/urls/:path' do |identifier, path|
      @application = Application.find_by(identifier: identifier)
      @url = @application.urls.find_by(url: path)
      erb ViewRoute.url_route(@application, @url)
    end

    get '/sources/:identifier/events' do |identifier|
      @application = Application.find_by(identifier: identifier)
      @identifier = identifier
      erb ViewRoute.event_index_route(@application)
    end

    get '/sources/:identifier/events/:event_name' do |identifier, event_name|
      @event_name = event_name
      @application = Application.find_by(identifier: identifier)
      @event = @application.events.find_by(event: event_name)
      erb ViewRoute.event_route(@application, @event)
    end

    not_found do
      erb :error
    end
  end
end

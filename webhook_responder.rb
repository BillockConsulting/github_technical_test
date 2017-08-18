require 'sinatra'

set :raise_errors, true
post '/webhook' do
#    content_type :json
#    @data = params[:data]
    require 'pry'; binding.pry
    'Hello Webhook'

end
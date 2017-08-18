require 'sinatra'

set :raise_errors, true
post '/webhook' do
    foo = JSON.parse(request.body.read)
end
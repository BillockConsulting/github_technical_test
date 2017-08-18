# spec/spec_helper.rb
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'
ENV['github_access_token'] = '123abc'

require File.expand_path '../../webhook_responder.rb', __FILE__

# Global constants for all specs
require File.expand_path '../spec_constants.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x and 3.x
RSpec.configure { |c| c.include RSpecMixin }

require File.expand_path '../spec_helper.rb', __FILE__

describe "GitHub Webhook Handler" do
  it "should return success when posting to the URL" do
    post '/webhook', SAMPLE_REPO_DELETION_WEBHOOK, {'CONTENT_TYPE' => 'application/json'}
    # Rspec 2.x
    
    expect(last_response).to be_ok
  end
end
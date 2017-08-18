require File.expand_path '../spec_helper.rb', __FILE__

describe "GitHub Webhook Handler" do
  context '/webhook' do
    let(:sample_webhook_json) { SAMPLE_REPO_DELETION_WEBHOOK.to_json }
    let(:webhook_request_headers) do
      {
        'content-type' => 'application/json',
        'Expect' => nil, 
        'User-Agent' => 'GitHub-Hookshot/8c529e0',
        'X-GitHub-Delivery' => 'a6ab34ee-8422-11e7-9e1c-aab9ef556873',
        'X-GitHub-Event' => 'repository'
      } 
    end
    let(:subject) { post '/webhook', sample_webhook_json, webhook_request_headers }

    it "should return success when posting to the URL" do
      subject
      expect(last_response).to be_ok
    end

    it 'should contact github to create an issue in the target repo' do
      expect(false).to be
    end

    it 'should tag me in the issue' do
      expect(false).to be
    end

    it 'should correctly identify the organization' do
      expect(false).to be
    end

    it 'should include the deleted repository name' do
      expect(false).to be
    end

    it 'should include correct headers on the github api request' do
      expect(false).to be
    end
  end

  context 'not_found' do
    it 'returns a 404' do
      expect(false).to be
    end

    it 'returns a generic message' do
      expect(false).to be
    end
  end
end

require File.expand_path '../spec_helper.rb', __FILE__

describe "GitHub Webhook Handler" do
  context '/webhook' do
    let(:sample_webhook_json) { SAMPLE_REPO_DELETION_WEBHOOK.to_json }
    let(:sample_creation_webhook_json) do
      new_webhook = SAMPLE_REPO_DELETION_WEBHOOK.dup
      new_webhook["action"] = 'created'
      new_webhook.to_json
    end

    let(:webhook_request_headers) do
      {
        'content-type' => 'application/json',
        'Expect' => nil, 
        'User-Agent' => 'GitHub-Hookshot/8c529e0',
        'X-GitHub-Delivery' => 'a6ab34ee-8422-11e7-9e1c-aab9ef556873',
        'X-GitHub-Event' => 'repository'
      } 
    end
    let(:ghc_stub) { GithubCommunicator.new }
    let(:subject) { post '/webhook', sample_webhook_json, webhook_request_headers }
    let(:subject_created) { post '/webhook', sample_creation_webhook_json, webhook_request_headers }
 
    it "should attempt to post a new issue when the repo was deleted" do
      expect(ghc_stub).to receive(:create_issue_in_target_repo)
      allow(GithubCommunicator).to receive(:new).and_return(ghc_stub)
      subject
      expect(last_response).to be_ok
    end

    it 'should not attempt to create a new issue when the webhook was not deleted' do
      expect(ghc_stub).to_not receive(:create_issue_in_target_repo)
      allow(GithubCommunicator).to receive(:new).and_return(ghc_stub)
      subject_created
      expect(last_response).to be_ok
    end
    
    it 'should return a 500 error if an exception occurs' do
      expect(ghc_stub).to receive(:create_issue_in_target_repo).and_raise("BROKEN")
      allow(GithubCommunicator).to receive(:new).and_return(ghc_stub)
      subject
      expect(last_response).to_not be_ok
    end
  end

  context 'not_found' do
    it 'returns a 404' do
      post '/nothing_here'
      expect(last_response.status).to eq 404
    end
  end
end

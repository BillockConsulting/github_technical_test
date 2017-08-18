require File.expand_path '../../spec_helper.rb', __FILE__

describe 'GithubCommunicator' do
  pending "It be broke"
  let(:test_target_intance) {GithubCommunicator.new}
  context ".create_issue_in_target_repo" do
    let(:organization) { "BillockConsulting" }
    let(:repo) { "sample_repo" }
    let(:message) { "the repo was baleeted" }
    let(:issue_creation_url) { GithubCommunicator::GITHUB_API_URL }
    let(:subject) { test_target_intance.create_issue_in_target_repo(organization, repo, message) }
    let(:stub_issue_request) { stub_request(:post, /#{issue_creation_url}*/).to_return(body: SAMPLE_ISSUE_CREATION_RESPONSE.to_json) }
    let(:stub_issue_request_user_agent_header) do
      stub_request(:post, /#{issue_creation_url}*/)
        .with(headers: {'User-Agent': GithubCommunicator::GITHUB_USER_AGENT})
        .to_return(body: SAMPLE_ISSUE_CREATION_RESPONSE.to_json) 
    end

    it "sends creates an issue in the target repo" do
      stub = stub_issue_request
      subject
      expect(stub).to have_been_requested
    end
    context 'error handling' do
      it 'logs an error if 400 is received (invalid JSON)' do
        expect(false).to be
      end
    
      it 'logs an error if 422 is received (invalid param value)' do
        expect(false).to be
      end
    end
  
    it 'correctly redirects the request if necessary' do
      expect(false).to be
    end
 
    
    it 'provides the appropriate auth tokens to github' do
      stub_issue_request
      subject
      expect(WebMock).to have_requested(:post, /#{issue_creation_url}*/)
        .with(query: hash_including({'customer_id'=> GithubCommunicator::GITHUB_USER_AGENT}))
    end
  
    it 'includes a user agent header' do
      stub_issue_request
      subject
      expect(WebMock).to have_requested(:post, /#{issue_creation_url}*/)
        .with(headers: {'User-Agent'=> GithubCommunicator::GITHUB_USER_AGENT})
    end
  end

  context ".build_issue_creation_params" do
    let(:repo) { "sample_repo" }
    let(:message) { "the repo was baleeted" }
    let(:assignee) { "evilstickman" }
    let(:params) { {} }
    let(:subject) { test_target_intance.build_issue_creation_params(repo, message, assignee) }

    it 'includes appropriate keys' do
      params = subject
      expect(params.keys).to include(:title, :body, :assignee)
    end

    it 'includes repo name in the title' do
      params = subject
      expect(params[:title]).to match /#{repo}/
    end

    it 'sets the body correctly' do
      params = subject
      expect(params[:body]).to eq message
    end

    it 'sets the assignee correctly' do
      params = subject
      expect(params[:assignee]).to eq assignee
    end
  end
end
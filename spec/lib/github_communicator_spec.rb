require File.expand_path '../../spec_helper.rb', __FILE__

describe 'GithubCommunicator' do
  let(:test_target_intance) {GithubCommunicator.new}
  context ".create_issue_in_target_repo" do
    let(:organization) { "BillockConsulting" }
    let(:repo_for_notification) { "sample_repo" }
    let(:repo_deleted) { "sample_repo" }
    let(:message) { "the repo was baleeted" }
    let(:octokit_class) { Octokit::Client }
    let(:octokit_stub) { Octokit::Client.new }
    let(:subject) { test_target_intance.create_issue_in_target_repo(organization, repo_deleted, repo_for_notification, message) }
    
    it "creates a new octokit instance if necessary" do
      allow(octokit_stub).to receive(:create_issue)
        .with(any_args)
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end

    it "Specifies a personal access key when creating the client" do
      allow(octokit_stub).to receive(:create_issue)
        .with(any_args)
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new)
        .with(hash_including({access_token: instance_of(String)}))
        .and_return(octokit_stub)
      subject
    end

    it "Includes the deleted repo name in the issue title" do
      expect(octokit_stub).to receive(:create_issue)
        .with(anything, a_string_matching(/#{repo_deleted}/), anything, hash_including({assignee: anything}))
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end

    it "Sends the notification to the correct repo" do
      expect(octokit_stub).to receive(:create_issue)
        .with(a_string_matching(/#{repo_for_notification}/), anything, anything, hash_including({assignee: anything}))
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end

    it "Specifies the correct organization" do
      expect(octokit_stub).to receive(:create_issue)
        .with(a_string_matching(/#{organization}/), anything, anything, hash_including({assignee: anything}))
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end

    it "Specifies an assignee" do
      expect(octokit_stub).to receive(:create_issue)
        .with(anything, anything, anything, hash_including({assignee: anything}))
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end

    it 'Includes an @ mention' do
      expect(octokit_stub).to receive(:create_issue)
        .with(anything, anything, a_string_matching(/\@#{GithubCommunicator::GITHUB_ISSUE_ASSIGNMENT_TARGET}/), anything)
        .and_return(SAMPLE_ISSUE_CREATION_RESPONSE)
      expect(octokit_class).to receive(:new).and_return(octokit_stub)
      subject
    end
  end 
end
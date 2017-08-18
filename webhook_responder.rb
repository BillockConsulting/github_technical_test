require 'sinatra'
require './lib/github_communicator'

configure do
  set :organization_issue_target_repo_name, "notification_repo"
end

post '/webhook' do
  webhook_content = JSON.parse(request.body.read)
  if(webhook_content["action"] == 'deleted')
    org_name = webhook_content["organization"]["login"]
    repo_deleted_name = webhook_content["repository"]["name"]
    repo_notification_name = "notification_repo"
    message = "Received from webhook"
    ghc = GithubCommunicator.new
    ghc.create_issue_in_target_repo(org_name, repo_deleted_name, repo_notification_name, message)
    200
  end
end

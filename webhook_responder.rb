require 'sinatra'
require './lib/github_communicator'

configure do
  set :organization_issue_target_repo_name, "notification_repo"
end

post '/webhook' do
  begin
    webhook_content = JSON.parse(request.body.read)
    if(webhook_content["action"] == 'deleted')
      org_name = webhook_content["organization"]["login"]
      repo_deleted_name = webhook_content["repository"]["name"]
      message = "Received a repo deletion request from webhook"
      ghc = GithubCommunicator.new
      ghc.create_issue_in_target_repo(org_name, repo_deleted_name, message)
    end
    200
  rescue StandardError => e
    # In a production app, this would be much more elaborate. For now, just
    # return a 500 error and hide details for security reason (someone trying
    # to hack their way through the webhook endpoint)
    logger.error("An error occurred: " + e.message)
    500
  end
end

not_found do
  404
end

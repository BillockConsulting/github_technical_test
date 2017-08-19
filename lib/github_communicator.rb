require 'octokit'

class GithubCommunicator
  GITHUB_USER_AGENT = "tech_test_for_github"
  GITHUB_ISSUE_TITLE_TEMPLATE = ":repo has been deleted"
  GITHUB_ISSUE_ASSIGNMENT_TARGET = "evilstickman"
  GITHUB_REPO_NAME = ':owner/:repo'
  GITHUB_USER_ACCESS_TOKEN = ENV['github_access_token']
  GITHUB_NOTIFICATION_REPO = 'notification_repo'

  def create_issue_in_target_repo(organization, repo_deleted, message)
    octokit_client.user_agent = GITHUB_USER_AGENT
    repo_path = GITHUB_REPO_NAME.gsub(':owner', organization).gsub(':repo',GITHUB_NOTIFICATION_REPO)
    body_message = '@' + GITHUB_ISSUE_ASSIGNMENT_TARGET + " - " + message
    octokit_client.create_issue(repo_path, 
      GITHUB_ISSUE_TITLE_TEMPLATE.gsub(":repo", repo_deleted),
      body_message,
      {
        assignee: GITHUB_ISSUE_ASSIGNMENT_TARGET
      }
    )
  end

  def octokit_client
    @octokit_client ||= Octokit::Client.new(access_token: GITHUB_USER_ACCESS_TOKEN)
  end
end
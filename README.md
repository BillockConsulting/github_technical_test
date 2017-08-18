# Matt Billock's GitHub Tech Test submission
This is my submission for GitHub's technical test. Below are notes on the application, and instructions on what is necessary to configure webhooks and deploy this webhook response handler for the organization.

## Application structure

The application is a simple Sinatra app. It has a single endpoint - `/webhook` - which handles incoming repository webhooks from GitHub. The `webhook` endpoint examines the type of webhook, and if it is a "deletion" webhook the webhook is converted into an issue on the repository https://github.com/BillockConsulting/notification_repo. This is an empty repo whose sole purpose is to receive issue creations from this webhook service.

It uses Octokit (https://github.com/octokit/octokit.rb) to communicate with GitHub. I opted to do this to provide a more readable way of communicating with the API, and prevent me from needing to deal with the authentication headers, but if you like I can rewrite the code to use 'net/http' instead so that you can see that I have the capability to construct a web request from scratch.

There are 10 unit tests that express the functionality of the webhook responder service. They are written using RSpec - you can run them from the project directory with "bundle exec rspec".

This project uses Bundler to manage gem dependencies. Be sure to run `bundle install` from the project directory prior to running the code.

This project was also developed on windows. Apologies for the line endings, or anything else odd introduced due to this tech choice - I do not own a personal macbook, and did not have the free space to set up a VM to do development on.

## Environment and Responses

The application has one environment variable dependency - `github_access_token`. This needs to be defined prior to running the application. It expects a personal access token from github, which is created on a user account. I do not know if this approach works for your needs, particularly since the personal access token needs to be tied to a user with appropriate permissions to create issues in the repo/org. I am sure you know more about this than I do, though. If this approach doesn't work, let me know and I will rewrite it to use an application ID and secret key instead.

Responses are empty by choice - I think it represents a security risk to provide too much detail on application errors. That being said, if you had another response structure in mind, I am happy to modify the code. The code can respond as follows:

* `webhook` endpoint, repository creation - responds with 200 OK
* `webhook` endpoint, repository deletion - responds with 200 OK and creates an issue in the repository specified by the code
* `webhook` endpoint, when an error occurs - responds with 500 and logs a message using `logger.error`
* any other endpoint results in a 404

I hard-coded the username to assign the issue to, the repo to hold the issue, and the organization. These are available as class constants in file lib/github_communicator.rb. If you like, I can easily rewrite this to use additional environment variables and make this code more flexible.

# Deployment instructions
The following deployment instructions use Heroku as the medium. The app is live, and can be tested at https://github-tech-test.herokuapp.com/ 

To deploy the code, follow these steps:

## Step 1 - Deploy code to Heroku
Using whichever means you prefer, deploy the code to a heroku app. I used the github integration to tie it in with my personal user - I do not know if this will work for your use case as you'll be evaluating this as a collaborator. If you have any issues with getting this access, let me know and I can promote you to an organization admin, which should resolve that problem.

Once you've deployed the code, you'll need to configure a personal access token.

## Step 2 - Obtain a personal access token
From the github account menu (upper right hand corner of the screen), select "settings":

![image](images/settings_menu.jpg)

From the "Settings" menu, select "Personal access tokens"

![image](images/personal_access_token.jpg]

Once on the Personal Access Tokens page, select "Generate new token"

![image](images/personal_access_token_generate.jpg)

Once the token is generated, copy the resulting 40 character string - this is the access token used by the application.

## Step 3 - Add the access token to heroku's environment variables.
Next, log in to the heroku dashboard, and navigate to the "Settings" page for your application, and click "Reveal config vars" to reveal and edit environment variables for your app:

![image](images/heroku_reveal_config.jpg)

Add the new environment variable `github_access_token`, provide the value you copied from Step 2 in the value column, and press "add". The resulting list will look like this:

![image](images/heroku_env_var_completed.jpg)

## Step 4 - Configure webhooks for the organization to point at your heroku app
This final step connects the github webhooks to the heroku instance hosting the Sinatra app we've just created. Start by accessing the organization settings on the "settings" tab of the organization's home page:

![image](images/github_org_settings.jpg)

Navigate to the "Webhooks" section:

![image](images/github_webhook_page.jpg)

Select "Add Webhook", and configure the webhook with the following:

* **Payload URL** - The URL for your heroku app, **including the "/webhook" path**
* **Content type** - application/json
* Under **Which events would you like to trigger this webhook?**, check *only* the box for `Repository`

Then click "Add". Your webhook should now be active. You can test it by creating and deleting a repo in the BillockConsulting organization. The repo deletion will result in a new issue created in the repo https://github.com/BillockConsulting/notification_repo

# Verifying functionality
To test this code in a live environment, follow these steps:

* Create a new repository under "Billock Consulting"
* Delete this new repository after it has been created
* View the issues page for https://github.com/BillockConsulting/notification_repo (https://github.com/BillockConsulting/notification_repo/issues)

# Caveats
* Many things are hard-coded here, as the problem statement I received via email indicated that I was to be working exclusively with repos and organizations under my control. In a true work setting, I would clarify this requirement.
* Error reporting, security, and logging are largely not implemented for this task. The problem statement did not seem to indicate that these were necessary.
* I have several other companies moving very quickly, and I wanted to get this in as soon as possible - as a result, there were a few cases where I didn't devote significant effort (such as the aforementioned hardcoded values, and the error reporting/security/logging, and so forth). If you'd rather I take the additional time to implement these features, I am happy to do so - simply let me know either through email, a quick call, or by opening issues on this repository.
* You can wire this up to any github account by modifying the value on line 6 of `lib/github_communicator.rb`. 
* To adjust the target notification repo, change line 15 of `webhook_communicator.rb` to reflect the target repo to receive notifications. Note that I pull the organization and deleted repo name from the webhook, so the notification repo needs to exist in the organization - if this is not the case, the request will result in a 500 error

I am happy to update this to address any shortcomings or answer any issues. I hope this meets your needs, and I am very interested in working with GitHub. Have a great weekend!

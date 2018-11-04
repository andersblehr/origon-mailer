require 'dotenv/load'

require './controllers/mailer_controller.rb'
require './controllers/oauth_controller.rb'

run Rack::URLMap.new({
  '/oauth' => OAuthController,
  '/mailer' => MailerController
})
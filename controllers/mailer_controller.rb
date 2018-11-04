require 'json'
require 'pony'
require 'sinatra'

require_relative '../middleware/check_env'
require_relative '../middleware/check_jwt'

class MailerController < Sinatra::Base
  
  use CheckEnv
  use CheckJwt
  
  post '' do
    begin
      halt 400 if request.content_type != 'application/json'
      request_body = JSON.parse(request.body.read, :symbolize_names => true)
      halt 400 if !request_body[:from] && !ENV['MAILER_FROM']
      halt 400 if !request_body[:to]
      halt 400 if !request_body[:subject]
      halt 400 if !request_body[:body]

      Pony.mail({
        :to => request_body[:to],
        :from => ENV['MAILER_FROM'],
        :subject => request_body[:subject],
        :body => request_body[:body],
      })
      
      status 201
    rescue JSON::ParserError
      halt 400
    end
  end
end

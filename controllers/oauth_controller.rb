require 'json'
require 'jwt'
require 'sinatra'

require_relative '../middleware/check_env'

class OAuthController < Sinatra::Base
 
  use CheckEnv
  
  post '/token' do
    halt 400 if request.content_type != 'application/x-www-form-urlencoded'
    halt 400 if params.count != 3
    halt 400 if !params[:grant_type]
    halt 400 if !params[:client_id]
    halt 400 if !params[:client_secret]
    halt 403 if invalid_grant_type?(params[:grant_type])
    halt 403 if invalid_credentials?(params[:client_id], params[:client_secret])
    
    content_type :json
    now = Time.now.to_i
    jwt_expires_in = ENV['JWT_EXPIRES_IN'].to_i
    
    jwt_payload = {
      exp: now + jwt_expires_in,
      iat: now,
      iss: ENV['JWT_ISSUER'],
    }
    
    {
      access_token: JWT.encode(jwt_payload, ENV['JWT_SECRET'], 'HS256'),
      expires_in: jwt_expires_in,
    }.to_json
  end
  
  def invalid_grant_type?(grant_type)
    grant_type != 'client_credentials'
  end
  
  def invalid_credentials?(client_id, client_secret)
    client_id != ENV['OAUTH_CLIENT_ID'] || client_secret != ENV['OAUTH_CLIENT_SECRET']
  end
end

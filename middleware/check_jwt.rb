require 'jwt'

class CheckJwt
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    begin
      auth_scheme, jwt_token = env.fetch('HTTP_AUTHORIZATION').split(' ')
      return [403, {}, []] if auth_scheme != 'Bearer'
      
      JWT.decode(jwt_token, ENV['JWT_SECRET'], true, {
        algorithm: 'HS256',
        iss: ENV['JWT_ISSUER'],
      })
    
      @app.call(env)
    rescue JWT::ExpiredSignature
      [401, {}, []]
    rescue JWT::DecodeError, JWT::InvalidIssuerError, JWT::InvalidIatError
      [403, {}, []]
    end
  end
end
 
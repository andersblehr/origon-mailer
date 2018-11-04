class CheckEnv
  
  def initialize(app)
    @app = app
  end
  
  def call(env)
    return [500, {}, []] if !ENV['OAUTH_CLIENT_ID']
    return [500, {}, []] if !ENV['OAUTH_CLIENT_SECRET']
    return [500, {}, []] if !ENV['JWT_ISSUER']
    return [500, {}, []] if !ENV['JWT_SECRET']
    return [500, {}, []] if !ENV['JWT_EXPIRES_IN']
    
    @app.call(env)
  end
end
 
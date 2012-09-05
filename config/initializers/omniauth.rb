Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :developer if Rails.env.
  provider :cas, :host => 'Andy-MBP.local', :port => 3443, :ssl => true
end
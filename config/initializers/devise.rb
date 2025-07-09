require 'devise/orm/active_record'
Devise.setup do |config|
  # ... other config lines

  config.sign_out_via = [:delete, :get]
end

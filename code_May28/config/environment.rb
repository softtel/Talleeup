# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {

     :address => "smtp.gmail.com",
     :port => "587",
     :domain => "mail.google.com",
     :authentication => :login,
     :user_name => "nthit90@gmail.com",
     :password => "26101990hung@"
 }

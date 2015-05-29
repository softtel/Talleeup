ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :authentication => :plain,
    :domain => 'gmail.com',
    :user_name => 'nthit90@gmail.com',
    :password => '26101990hung@',
    :enable_starttls_auto => true
}